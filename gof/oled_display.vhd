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
WIDTH_O : integer := 128;
HEIGHT_O : integer := 32;
W_BITS : integer := 7;
H_BITS : integer := 5;
BYTE_SIZE : integer := 8);
port
(
signal i_clk : in std_logic;
signal i_rst : in std_logic;
signal i_clear : in std_logic;
signal i_draw : in std_logic;
signal i_x : in std_logic_vector(W_BITS-1 downto 0);
signal i_y : in std_logic_vector(H_BITS-1 downto 0);
signal i_byte : in std_logic_vector(BYTE_SIZE-1 downto 0);
signal i_all_pixels : in std_logic;
signal o_busy : out std_logic;
signal o_display_initialize : inout std_logic;
signal io_sda,io_scl : inout std_logic);
end oled_display;

architecture Behavioral of oled_display is

constant WIDTH : integer := 128; -- XXX
constant HEIGHT : integer := 4; -- XXX

constant OLED_PAGES_ALL : integer := WIDTH * HEIGHT;
constant OLED_DATA : integer := to_integer(unsigned'(x"40"));
constant OLED_COMMAND : integer := to_integer(unsigned'(x"00")); -- 00,80
constant COUNTER_WAIT1 : integer := 1;

constant NI_INIT : natural := 26;
type A_INIT is array (0 to NI_INIT-1) of std_logic_vector(BYTE_SIZE-1 downto 0);
signal init_display : A_INIT :=
(
 x"AE" -- display off
,x"D5",x"80" -- setdisplayclockdiv
,x"A8",x"1F" -- 00-0f/10-1f - Set Lower Column Start Address for Page Addressing Mode
,x"D3",x"00" -- display offset
,x"40"       -- set start line
,x"8D",x"14" -- chargepump
,x"20",x"00" -- Set Memory Addressing Mode
,x"A1",x"C8" -- A0/A1,C0/C8 - start from specify four display corner - a0|a1 - segremap , c0|c8 - comscandec
,x"DA",x"02" -- setcompins
,x"81",x"8F" -- contrast
,x"D9",x"F1" -- precharge
,x"DB",x"40" -- setvcomdetect
,x"A4"       -- displayon resume
,x"A6"       -- normal display
,x"2E"       -- scroll off
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
	idle,
	start, -- initialize oled
	wait0,
	set_address_1, -- set begin point 0,0
	wait1, -- wait after initialize
	send_character, -- send the some data in loop
	wait2, -- disable i2c and wait between transition coordination
	wait3,
	set_coordinations,
	set_address_2, -- set begin point 0,0
	clear_display_state, -- clear display
	stop -- when index=counter, i2c disable
);

signal c_state : state := start;
SIGNAL i2c_ena     : STD_LOGIC;                     --i2c enable signal
SIGNAL i2c_addr    : STD_LOGIC_VECTOR(6 DOWNTO 0);  --i2c address signal
SIGNAL i2c_rw      : STD_LOGIC;                     --i2c read/write command signal
SIGNAL i2c_data_wr : STD_LOGIC_VECTOR(7 DOWNTO 0);  --i2c write data
SIGNAL i2c_busy    : STD_LOGIC;                     --i2c busy signal
SIGNAL i2c_reset   : STD_LOGIC;                     --i2c busy signal
SIGNAL busy_prev   : STD_LOGIC;                     --previous value of i2c busy signal
SIGNAL busy_cnt : INTEGER := 0; -- for i2c, count the clk tick when i2c_busy=1

signal counter : integer range 0 to COUNTER_WAIT1 := COUNTER_WAIT1;
signal coord_prev_x : std_logic_vector(W_BITS-1 downto 0) := (others => '0');
signal coord_prev_y : std_logic_vector(H_BITS-1 downto 0) := (others => '0');

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

p0 : process (i_clk,i_rst) is
begin
	if (i_rst = '1') then
		c_state <= idle;
	elsif (rising_edge(i_clk)) then
		if (i_all_pixels = '1') then
			c_state <= stop;
		end if;
		if (counter > 0) then
			counter <= counter - 1;
		end if;
		case c_state is
			when idle =>
				busy_cnt <= 0;
				if (i_all_pixels = '1') then
					c_state <= idle;
				else
					if (o_display_initialize = '1') then
						c_state <= wait0;
					else
						c_state <= start;
					end if;
				end if;
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
							c_state <= set_address_2;
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
							c_state <= clear_display_state;
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
					when 1 to OLED_PAGES_ALL => -- XXX
						i2c_data_wr <= x"00"; -- command - FF/allpixels,00/blank,F0/zebra
					when OLED_PAGES_ALL+1 => -- XXX
						i2c_ena <= '0';
						if (i2c_busy = '0') then
						busy_cnt <= 0;
							c_state <= wait0;
						end if;
					when others => null;
				end case;
			when wait0 =>
				c_state <= set_address_1;
			when set_address_1 =>
				coord_prev_x <= std_logic_vector(to_unsigned(0,W_BITS));
				coord_prev_y <= std_logic_vector(to_unsigned(0,H_BITS));
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
							c_state <= wait1;
							o_display_initialize <= '1';
						end if;
					when others => null;
				end case;
			when wait1 =>
				if (i_draw = '1') then
					c_state <= wait2;
				else
					c_state <= wait1;
				end if;
			when wait2 =>
				i2c_ena <= '0';
				o_busy <= '0';
				coord_prev_x <= i_x;
				coord_prev_y <= i_y;
				busy_cnt <= 0;
				if (counter = 0) then
					if (coord_prev_y /= i_y) then
						c_state <= wait3;
					else
						if (coord_prev_x /= i_x) then
							c_state <= send_character;
						end if;
					end if;
				end if;   
			when wait3 =>
				--c_state <= send_character; -- xxx maybe delete send coords
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
						o_busy <= '1';
					when 1 =>
						i2c_data_wr <= x"21";
					when 2 =>
						i2c_data_wr <= std_logic_vector(to_unsigned(0,BYTE_SIZE-W_BITS))&i_x; -- XXX
					when 3 =>
						i2c_data_wr <= std_logic_vector(to_unsigned(WIDTH-1,BYTE_SIZE));
					when 4 =>
						i2c_data_wr <= x"22";
					when 5 =>
					i2c_data_wr <= std_logic_vector(to_unsigned(0,BYTE_SIZE-H_BITS))&i_y; -- XXX
					when 6 =>
						i2c_data_wr <= std_logic_vector(to_unsigned(HEIGHT-1,BYTE_SIZE));
					when 7 =>
						i2c_ena <= '0';
						if (i2c_busy = '0') then
							busy_cnt <= 0;
							counter <= COUNTER_WAIT1-1;
							c_state <= send_character;
							o_busy <= '0';
						end if;
					when others => null;
				end case;
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
						o_busy <= '1';
					when 1 =>
						i2c_data_wr <= i_byte;
					when 2 =>
						i2c_ena <= '0';
						if (i2c_busy = '0') then
							busy_cnt <= 0;
							c_state <= wait1;
							o_busy <= '0';
						end if;
					when others => null;
				end case;
			when stop =>
				i2c_ena <= '0';
				c_state <= idle;
			when others => null;
		end case;
	end if;
end process p0;

end Behavioral;

