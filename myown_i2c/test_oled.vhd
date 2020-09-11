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
use WORK.p_pkg1.ALL;

entity test_oled is 
port
(
signal i_clk : in std_logic;
signal i_rst : in std_logic;
signal i_refresh : in std_logic;
signal i_char : in array1;
signal io_sda,io_scl : inout std_logic
);
end test_oled;

architecture Behavioral of test_oled is

constant GCLK : integer := 50_000_000;
constant BCLK : integer := 100_000;

constant OLED_WIDTH : integer := 128;
constant OLED_HEIGHT : integer := 32;
constant OLED_PAGES_ALL : integer := OLED_WIDTH * ((OLED_HEIGHT + 7) / 8);
constant OLED_DATA : integer := to_integer(unsigned'(x"40"));
constant OLED_COMMAND : integer := to_integer(unsigned'(x"00")); -- 00,80

constant NI_INIT : natural := 25;
type A_INIT is array (0 to NI_INIT-1) of std_logic_vector(7 downto 0);
signal init_display : A_INIT := (x"AE",x"D5",x"F0",x"A8",x"1F",x"D3",x"00",x"40",x"8D",x"14",x"20",x"00",x"A1",x"C8",x"DA",x"02",x"81",x"8F",x"D9",x"F1",x"DB",x"40",x"A4",x"A6",x"2E");
--signal init_display : A_INIT := (x"AE",x"D5",x"80",x"A8",x"1F",x"D3",x"00",x"40",x"8D",x"14",x"A1",x"C8",x"DA",x"02",x"81",x"8F",x"D9",x"F1",x"DB",x"40",x"A4",x"A6");

constant NI_SET_COORDINATION : natural := 6;
type A_SET_COORDINATION is array (0 to NI_SET_COORDINATION-1) of std_logic_vector(7 downto 0);
signal set_coordination : A_SET_COORDINATION := (x"21",x"00",std_logic_vector(to_unsigned(OLED_WIDTH-1,8)),x"22",x"00",std_logic_vector(to_unsigned(OLED_HEIGHT-1,8)));

SIGNAL i2c_ena     : STD_LOGIC;                     --i2c enable signal
SIGNAL i2c_addr    : STD_LOGIC_VECTOR(6 DOWNTO 0);  --i2c address signal
SIGNAL i2c_rw      : STD_LOGIC;                     --i2c read/write command signal
SIGNAL i2c_data_wr : STD_LOGIC_VECTOR(7 DOWNTO 0);  --i2c write data
SIGNAL i2c_busy    : STD_LOGIC;                     --i2c busy signal
SIGNAL i2c_reset   : STD_LOGIC;                     --i2c busy signal
SIGNAL busy_prev   : STD_LOGIC;                     --previous value of i2c busy signal

signal busy_cnt : INTEGER := 0; -- for i2c, count the clk tick when i2c_busy=1
signal index_character : INTEGER := 0;
signal current_character : std_logic_vector(7 downto 0);

component glcdfont is
port(
	i_clk : in std_logic;
	i_index : in std_logic_vector(11 downto 0);
	o_character : out std_logic_vector(7 downto 0)
);
end component glcdfont;

for all : glcdfont use entity WORK.glcdfont(behavioral_glcdfont);

COMPONENT i2c IS
GENERIC(
	input_clk : INTEGER := GCLK; --input clock speed from user logic in Hz
	bus_clk   : INTEGER := BCLK  --speed the i2c bus (scl) will run at in Hz
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
	check_character_index, -- check have char
	stop -- when index=counter, i2c disable
);
signal c_state,n_state : state := start;

signal glcdfont_character : std_logic_vector(7 downto 0) := (others => '0');
signal glcdfont_index : std_logic_vector(11 downto 0) := (others => '0');

begin

c0 : glcdfont
port map
(
	i_clk => i_clk,
	i_index => glcdfont_index,
	o_character => glcdfont_character
);

c1 : i2c
GENERIC MAP
(
	input_clk => GCLK,
	bus_clk => BCLK
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
	if (rising_edge(i_clk)) then
		if (i_rst = '1') then
			n_state <= start;
			busy_cnt <= 0;
			index_character <= 0;
		elsif (i_refresh = '1') then
			n_state <= set_address_1;
			busy_cnt <= 0;
			index_character <= 0;
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
							i2c_data_wr <= std_logic_vector(to_unsigned(OLED_COMMAND,8));
						when 1 to NI_INIT =>
							i2c_data_wr <= init_display(busy_cnt-1); -- command
						when NI_INIT+1 =>
							i2c_ena <= '0';
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								n_state <= clear_display_state;
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
							i2c_data_wr <= std_logic_vector(to_unsigned(OLED_COMMAND,8));
						when 1 to NI_SET_COORDINATION =>
							i2c_data_wr <= set_coordination(busy_cnt-1); -- command
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
							--i2c_data_wr <= std_logic_vector(to_unsigned(OLED_COMMAND,8));
						when 1 to OLED_PAGES_ALL =>
							i2c_data_wr <= x"00"; -- command - FF/allpixels,00/blank,F0/zebra
						when OLED_PAGES_ALL+1 =>
							i2c_data_wr <= x"AF"; -- display on
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
							i2c_data_wr <= std_logic_vector(to_unsigned(OLED_COMMAND,8));
						when 1 to NI_SET_COORDINATION =>
							i2c_data_wr <= set_coordination(busy_cnt-1); -- command
						when NI_SET_COORDINATION+1 =>
							i2c_ena <= '0';
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								n_state <= send_character;
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
							i2c_data_wr <= std_logic_vector(to_unsigned(OLED_DATA,8));
							current_character <= i_char(index_character);
						when 1 =>
							glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+0,glcdfont_index'length));
							i2c_data_wr <= glcdfont_character;
						when 2 =>
							glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+1,glcdfont_index'length));
							i2c_data_wr <= glcdfont_character;
						when 3 =>
							glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+2,glcdfont_index'length));
							i2c_data_wr <= glcdfont_character;
						when 4 =>
							glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+3,glcdfont_index'length));
							i2c_data_wr <= glcdfont_character;
						when 5 =>
							glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+4,glcdfont_index'length));
							i2c_data_wr <= glcdfont_character;
						when 6 =>
							i2c_data_wr <= x"00"; -- to space between characters / optional
						when 7 =>
							i2c_ena <= '0';
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								n_state <= check_character_index;
							end if;
						when others => null;
					end case;
				when check_character_index =>
					busy_prev <= i2c_busy;
					if (busy_prev = '0' and i2c_busy = '1') then
						busy_cnt <= busy_cnt + 1;
					end if;
					case busy_cnt is
						when 0 =>
							i2c_ena <= '1'; -- we are busy
							if (i2c_busy = '1') then
								index_character <= index_character + 1;
							end if;
						when 1 =>
							i2c_data_wr <= x"00";
							if (i2c_busy = '1') then
								if (index_character > i_char'length-1) then -- we gain end array
									i2c_ena <= '0';
									if (i2c_busy = '0') then
										busy_cnt <= 0;
										n_state <= stop;
									end if;
								end if;
							end if;
						when 3 =>
							i2c_ena <= '0';
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								n_state <= send_character;
							end if;
						when others => null;
					end case;
				when stop =>
					i2c_ena <= '0';
				when others => null;
			end case;
		end if;
	end if;
end process p0;

end Behavioral;

