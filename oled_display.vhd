----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:47:49 08/21/2020 
-- Design Name: 
-- Module Name:    test_oled - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity oled_display is
generic
(
GLOBAL_CLK : integer := 50_000_000;
I2C_CLK : integer := 100_000;
WIDTH : integer := 128;
HEIGHT : integer := 32;
W_BITS : integer := 7;
H_BITS : integer := 5;
BYTE_SIZE : integer := 8);
port
(
signal i_clk : in std_logic;
signal i_rst : in std_logic;
signal i_x : in std_logic_vector(W_BITS-1 downto 0);
signal i_y : in std_logic_vector(H_BITS-1 downto 0);
signal i_byte : in std_logic_vector(BYTE_SIZE-1 downto 0);
signal i_all_pixels : in std_logic;
signal o_display_initialize : out std_logic;
signal io_sda,io_scl : inout std_logic);
end oled_display;

architecture Behavioral of oled_display is

constant OLED_PAGES_ALL : integer := WIDTH * HEIGHT;
constant OLED_DATA : integer := to_integer(unsigned'(x"40"));
constant OLED_COMMAND : integer := to_integer(unsigned'(x"00")); -- 00,80

constant NI_INIT : natural := 26;
type A_INIT is array (0 to NI_INIT-1) of std_logic_vector(BYTE_SIZE-1 downto 0);
signal init_display : A_INIT :=
(
 x"AE" -- display off
,x"D5",x"F0"
,x"A8" -- 
,x"1F" -- 00-0f/10-1f - Set Lower Column Start Address for Page Addressing Mode
,x"D3",x"00"
,x"40"
,x"8D",x"14"
,x"20",x"00" -- Set Memory Addressing Mode
,x"A0",x"C0" -- A0/A1,C0/C8 - start from specify four display corner
,x"DA",x"02"
,x"81",x"8F" -- contrast
,x"D9",x"F1",x"DB",x"40",x"A4",x"A6",x"2E"
,x"AF" -- display on
);

constant NI_SET_COORDINATION : natural := 6;
type A_SET_COORDINATION is array (0 to NI_SET_COORDINATION-1) of std_logic_vector(BYTE_SIZE-1 downto 0);
signal set_coordination_00 : A_SET_COORDINATION :=
(x"21",x"00",std_logic_vector(to_unsigned(WIDTH-1,BYTE_SIZE))
,x"22",x"00",std_logic_vector(to_unsigned(HEIGHT-1,BYTE_SIZE)));

COMPONENT i2c IS
GENERIC(
	input_clk : INTEGER; --input clock speed from user logic in Hz
	bus_clk   : INTEGER  --speed the i2c bus (scl) will run at in Hz
);
PORT(
	clk       : IN     STD_LOGIC;                    --system clock
	reset_n   : IN     STD_LOGIC;                    --active low reset
	ena       : IN     STD_LOGIC;                    --latch in command
	addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
	rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
	data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
	busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
	data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
	ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
	sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
	scl       : INOUT  STD_LOGIC);                   --serial clock output of i2c bus
END component i2c;
for all : i2c use entity WORK.i2c_master(logic);

type state is 
(
	start, -- initialize oled
	set_address_1, -- set begin point 0,0
	clear_display_state, -- clear display
	set_address_2, -- set begin point 0,0
	send_character, -- send the some data
	wait1, -- disable i2c and wait between transition coordination
	stop -- when index=counter, i2c disable
);

signal c_state,n_state : state := start;
SIGNAL i2c_ena     : STD_LOGIC;                     --i2c enable signal
SIGNAL i2c_addr    : STD_LOGIC_VECTOR(6 DOWNTO 0);  --i2c address signal
SIGNAL i2c_rw      : STD_LOGIC;                     --i2c read/write command signal
SIGNAL i2c_data_wr : STD_LOGIC_VECTOR(7 DOWNTO 0);  --i2c write data
SIGNAL i2c_busy    : STD_LOGIC;                     --i2c busy signal
SIGNAL i2c_reset   : STD_LOGIC;                     --i2c busy signal
SIGNAL busy_prev   : STD_LOGIC;                     --previous value of i2c busy signal
SIGNAL busy_cnt : INTEGER := 0; -- for i2c, count the clk tick when i2c_busy=1

signal counter : integer := 0;
signal coord_prev_x,coord_prev_y : std_logic_vector(H_BITS-1 downto 0);
begin

c0 : i2c
GENERIC MAP
(
	input_clk => GLOBAL_CLK,
	bus_clk => I2C_CLK
)
PORT MAP
(
	clk => i_clk,
	reset_n => i2c_reset,
	ena => i2c_ena,
	addr => i2c_addr,
	rw => i2c_rw,
	data_wr => i2c_data_wr,
	busy => i2c_busy,
	data_rd => open,
	ack_error => open,
	sda => io_sda,
	scl => io_scl
);

p0 : process (i_clk,i_rst,i_all_pixels) is
begin
	if (rising_edge(i_clk)) then
		if (i_rst = '1') then
			busy_cnt <= 0;
			n_state <= start;
		elsif (i_all_pixels = '1') then
			n_state <= stop;
		else
			c_state <= n_state;
			case c_state is
				when start =>
					busy_prev <= i2c_busy;
					if (busy_prev = '0' and i2c_busy = '1') then
						busy_cnt <= busy_cnt + 1;
					end if;
					case busy_cnt is
						when 0 =>
							i2c_reset <= '1';
							i2c_ena <= '1'; -- we are busy
							i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
							i2c_rw <= '0';
							i2c_data_wr <= std_logic_vector(to_unsigned(OLED_COMMAND,BYTE_SIZE));
						when 1 to NI_INIT =>
							i2c_data_wr <= init_display(busy_cnt-1); -- command
						when NI_INIT+1 =>
							i2c_ena <= '0';
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								n_state <= set_address_1;
							end if;
						when others => null;
					end case;
				when set_address_1 =>
					busy_prev <= i2c_busy;
					if (busy_prev = '0' and i2c_busy = '1') then
						busy_cnt <= busy_cnt + 1;
					end if;
					case busy_cnt is
						when 0 =>
							i2c_ena <= '1'; -- we are busy
							i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
							i2c_rw <= '0';
							i2c_data_wr <= std_logic_vector(to_unsigned(OLED_COMMAND,BYTE_SIZE));
						when 1 to NI_SET_COORDINATION =>
							i2c_data_wr <= set_coordination_00(busy_cnt-1); -- command
						when NI_SET_COORDINATION+1 =>
							i2c_ena <= '0';
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								n_state <= clear_display_state;
							end if;
						when others => null;
					end case;
				when clear_display_state =>
					busy_prev <= i2c_busy;
					if (busy_prev = '0' and i2c_busy = '1') then
						busy_cnt <= busy_cnt + 1;
					end if;
					case busy_cnt is
						when 0 =>
							i2c_ena <= '1'; -- we are busy
							i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
							i2c_rw <= '0';
							i2c_data_wr <= std_logic_vector(to_unsigned(OLED_DATA,BYTE_SIZE));
						when 1 to OLED_PAGES_ALL+1 =>
							i2c_data_wr <= x"00"; -- command - FF/allpixels,00/blank,F0/zebra
						when OLED_PAGES_ALL+2 =>
							i2c_ena <= '0';
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								n_state <= set_address_2;
							end if;
						when others => null;
					end case;
				when set_address_2 =>
					busy_prev <= i2c_busy;
					if (busy_prev = '0' and i2c_busy = '1') then
						busy_cnt <= busy_cnt + 1;
					end if;
					case busy_cnt is
						when 0 =>
							i2c_ena <= '1'; -- we are busy
							i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
							i2c_rw <= '0';
							i2c_data_wr <= std_logic_vector(to_unsigned(OLED_COMMAND,BYTE_SIZE));
						when 1 to NI_SET_COORDINATION =>
							i2c_data_wr <= set_coordination_00(busy_cnt-1); -- command
						when NI_SET_COORDINATION+1 =>
							i2c_ena <= '0';
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								n_state <= wait1;
								o_display_initialize <= '1';
							end if;
						when others => null;
					end case;
				when wait1 =>
					i2c_ena <= '0';
					coord_prev_x <= i_x;
					coord_prev_y <= i_y;
					if ((coord_prev_x /= i_x or coord_prev_y /= i_y) and (i_x /= x"00" or i_y /= x"00")) then
						if (counter < 0) then -- wait between transition coord
							counter <= counter + 1;
							n_state <= wait1;
						else
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								counter <= 0;
								n_state <= send_character;
							end if;
						end if;
					end if;
				when send_character =>
					busy_prev <= i2c_busy;
					if (busy_prev = '0' and i2c_busy = '1') then
						busy_cnt <= busy_cnt + 1;
					end if;
					case busy_cnt is
						when 0 =>
							i2c_ena <= '1'; -- we are busy
							i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
							i2c_rw <= '0';
							i2c_data_wr <= std_logic_vector(to_unsigned(OLED_DATA,BYTE_SIZE));
						when 1 =>
							i2c_data_wr <= i_byte;
						when 2 =>
							i2c_ena <= '0';
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								n_state <= wait1;
							end if;
						when others => null;
					end case;
				when stop =>
					i2c_ena <= '0';
					n_state <= stop;
				when others => null;
			end case;
		end if;
	end if;
end process p0;

end Behavioral;

