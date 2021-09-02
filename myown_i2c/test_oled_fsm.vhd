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
use WORK.p_constants1.ALL;

entity test_oled is
generic (
g_board_clock : integer := 50_000_000;
g_bus_clock : integer := 100_000
);
port
(
signal i_clk : in std_logic;
signal i_rst : in std_logic;
signal i_refresh : in std_logic;
signal io_sda,io_scl : inout std_logic
);
end test_oled;

architecture Behavioral of test_oled is

constant i_char : array1(0 to 5) := (x"30",x"31",x"32",x"33",x"34",x"35");

constant GCLK : integer := g_board_clock;
constant BCLK : integer := g_bus_clock;

constant OLED_WIDTH : integer := 128;
constant OLED_HEIGHT : integer := 32;
constant OLED_PAGES_ALL : integer := OLED_WIDTH * ((OLED_HEIGHT + 7) / 8);
constant OLED_DATA : integer := to_integer(unsigned'(x"40"));
constant OLED_COMMAND : integer := to_integer(unsigned'(x"00")); -- 00,80

constant NI_SET_COORDINATION : natural := 6;
type A_SET_COORDINATION is array (0 to NI_SET_COORDINATION-1) of std_logic_vector(7 downto 0);
constant set_coordination : A_SET_COORDINATION := (x"21",x"00",std_logic_vector(to_unsigned(OLED_WIDTH-1,8)),x"22",x"00",std_logic_vector(to_unsigned(OLED_HEIGHT-1,8)));

SIGNAL i2c_ena     : STD_LOGIC;                     --i2c enable signal
SIGNAL i2c_addr    : STD_LOGIC_VECTOR(6 DOWNTO 0);  --i2c address signal
SIGNAL i2c_data_wr : STD_LOGIC_VECTOR(0 to G_BYTE_SIZE-1);  --i2c write data
SIGNAL i2c_busy    : STD_LOGIC;                     --i2c busy signal
SIGNAL i2c_reset   : STD_LOGIC;                     --i2c busy signal
SIGNAL busy_prev   : STD_LOGIC;                     --previous value of i2c busy signal

signal busy_cnt_sequence : INTEGER range 0 to BYTES_SEQUENCE_LENGTH + 1;
signal busy_cnt_coord : INTEGER range 0 to NI_SET_COORDINATION + 1;
signal busy_cnt_clear : INTEGER range 0 to OLED_PAGES_ALL + 3;
signal busy_cnt_send_char : INTEGER range 0 to 6;
signal index_character : INTEGER range 0 to 5;
signal current_character : std_logic_vector(7 downto 0);

component glcdfont is
port(
	i_clk : in std_logic;
	i_reset : in std_logic;
	i_index : in std_logic_vector(10 downto 0);
	o_character : out std_logic_vector(7 downto 0)
);
end component glcdfont;
for all : glcdfont use entity WORK.glcdfont(behavioral_glcdfont);

component my_i2c_fsm is
generic(
BOARD_CLOCK : INTEGER := G_BOARD_CLOCK;
BUS_CLOCK : INTEGER := G_BUS_CLOCK
);
port(
i_clock : in std_logic;
i_reset : in std_logic;
i_slave_address : in std_logic_vector(0 to G_SLAVE_ADDRESS_SIZE-1);
i_bytes_to_send : in std_logic_vector(0 to G_BYTE_SIZE-1);
i_enable : in std_logic;
o_busy : out std_logic;
o_sda : out std_logic;
o_scl : out std_logic
);
end component my_i2c_fsm;

type state is 
(
	idle, -- reset i2c
	start, -- initialize oled
	set_address_1, -- set begin point 0,0
--	clear_display_state_1, -- clear display and power on
	set_address_2, -- set begin point 0,0
	send_character, -- send the some data/text array
	check_character_index, -- check have char
	stop -- when index=counter, i2c disable
);
signal c_state,n_state : state;

signal glcdfont_character : std_logic_vector(7 downto 0);
signal glcdfont_index : std_logic_vector(10 downto 0);

begin

i2c_addr <= "1111111"; -- 3C
--i2c_addr <= "0000000"; -- 3C

c0 : glcdfont
port map
(
	i_clk => i_clk,
	i_reset => i_rst,
	i_index => glcdfont_index,
	o_character => glcdfont_character
);

c1 : my_i2c_fsm
GENERIC MAP
(
	BOARD_CLOCK => GCLK,
	BUS_CLOCK => BCLK
)
PORT MAP
(
	i_clock => i_clk,
	i_reset => i2c_reset,
	i_enable => i2c_ena,
	i_slave_address => i2c_addr,
	i_bytes_to_send => i2c_data_wr,
	o_busy => i2c_busy,
	o_sda => io_sda,
	o_scl => io_scl
);

p1 : process (i_clk,i_rst) is
begin
	if (i_rst = '1') then
		c_state <= idle;
	elsif (rising_edge(i_clk)) then
		c_state <= n_state;
	end if;
end process p1;


p0 : process (c_state,i2c_busy,glcdfont_character,busy_prev) is
begin
	n_state <= c_state;
	case c_state is
		when idle =>
			n_state <= start;
			i2c_reset <= '1';
			busy_cnt_sequence <= 0;
			busy_cnt_coord <= 0;
			busy_cnt_clear <= 0;
			busy_cnt_send_char <= 0;
			busy_prev <= '0';
			i2c_ena <= '0';
			i2c_data_wr <= (others => '0');
			current_character <= (others => '0');
			index_character <= 0;
			glcdfont_index <= (others => '0');
		when start =>
			i2c_reset <= '0';
			current_character <= (others => '0');
			index_character <= 0;
			glcdfont_index <= (others => '0');
			busy_prev <= i2c_busy;
			busy_cnt_coord <= 0;
			busy_cnt_clear <= 0;
			busy_cnt_send_char <= 0;
			if (busy_prev = '0' and i2c_busy = '1') then
				busy_cnt_sequence <= busy_cnt_sequence + 1;
			end if;
			case busy_cnt_sequence is
				when 0 =>
					i2c_ena <= '1'; -- we are busy
					i2c_data_wr <= (others => '0');
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
					index_character <= 0;
				when 1 to BYTES_SEQUENCE_LENGTH =>
					i2c_ena <= '0';
					i2c_data_wr <= sequence(busy_cnt_sequence-1); -- command
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
					index_character <= 0;
				when BYTES_SEQUENCE_LENGTH+1 =>
					i2c_ena <= '0';
					i2c_data_wr <= (others => '0');
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
					index_character <= 0;
					if (i2c_busy = '0') then
						busy_cnt_sequence <= 0;
						n_state <= set_address_1;
					end if;
			end case;
		when set_address_1 =>
			i2c_reset <= '0';
			busy_cnt_sequence <= 0;
			busy_cnt_clear <= 0;
			busy_cnt_send_char <= 0;
			current_character <= (others => '0');
			index_character <= 0;
			glcdfont_index <= (others => '0');
			busy_prev <= i2c_busy;
			if (busy_prev = '0' and i2c_busy = '1') then
				busy_cnt_coord <= busy_cnt_coord + 1;
			end if;
			case busy_cnt_coord is
				when 0 =>
					i2c_ena <= '1'; -- we are busy
					i2c_data_wr <= (others => '0');
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
					index_character <= 0;
				when 1 to NI_SET_COORDINATION =>
					i2c_ena <= '1';
					i2c_data_wr <= set_coordination(busy_cnt_coord-1); -- command
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
					index_character <= 0;
				when NI_SET_COORDINATION+1 =>
					i2c_ena <= '0';
					i2c_data_wr <= (others => '0');
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
					index_character <= 0;
					if (i2c_busy = '0') then
						busy_cnt_coord <= 0;
						n_state <= set_address_2; --clear_display_state_1;
					end if;
			end case;
--		when clear_display_state_1 =>
--			busy_prev <= '0';
--			i2c_reset <= '0';
--			current_character <= (others => '0');
--			index_character <= 0;
--			glcdfont_index <= (others => '0');
--			busy_prev <= i2c_busy;
--			if (busy_prev = '0' and i2c_busy = '1') then
--				busy_cnt <= busy_cnt + 1;
--			end if;
--			case busy_cnt is
--				when 0 =>
--					i2c_ena <= '1'; -- we are busy
--				when 1 to OLED_PAGES_ALL =>
--					i2c_ena <= '1';
--					i2c_data_wr <= x"00"; -- command - FF/allpixels,00/blank,F0/zebra
--				when OLED_PAGES_ALL+1 =>
--					i2c_ena <= '0';
--					if (i2c_busy = '0') then
--						busy_cnt <= 0;
--						n_state <= set_address_2;
--					end if;
--				when others =>
--					i2c_ena <= '1';
--			end case;
		when set_address_2 =>
			i2c_reset <= '0';
			busy_cnt_sequence <= 0;
			busy_cnt_clear <= 0;
			busy_cnt_send_char <= 0;
			current_character <= (others => '0');
			index_character <= 0;
			glcdfont_index <= (others => '0');
			busy_prev <= i2c_busy;
			if (busy_prev = '0' and i2c_busy = '1') then
				busy_cnt_coord <= busy_cnt_coord + 1;
			end if;
			case busy_cnt_coord is
				when 0 =>
					i2c_ena <= '1'; -- we are busy
					i2c_data_wr <= (others => '0');
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
					index_character <= 0;
				when 1 to NI_SET_COORDINATION =>
					i2c_ena <= '1';
					i2c_data_wr <= set_coordination(busy_cnt_coord-1); -- command
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
					index_character <= 0;
				when NI_SET_COORDINATION+1 =>
					i2c_ena <= '0';
					i2c_data_wr <= (others => '0');
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
					index_character <= 0;
					if (i2c_busy = '0') then
						busy_cnt_coord <= 0;
						n_state <= send_character;
					end if;
			end case;
		when send_character =>
			i2c_reset <= '0';
			busy_cnt_sequence <= 0;
			busy_cnt_coord <= 0;
			busy_cnt_clear <= 0;
			busy_prev <= i2c_busy;
			glcdfont_index <= (others => '0');
			if (busy_prev = '0' and i2c_busy = '1') then
				busy_cnt_send_char <= busy_cnt_send_char + 1;
			end if;
			case busy_cnt_send_char is
				when 0 =>
					i2c_ena <= '1'; -- we are busy
					current_character <= (others => '0');
					i2c_data_wr <= (others => '0');
					glcdfont_index <= (others => '0');
				when 1 =>
					i2c_ena <= '1';
					current_character <= i_char(index_character);
					glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+0,glcdfont_index'length));
					i2c_data_wr <= glcdfont_character;
				when 2 =>
					i2c_ena <= '1';
					current_character <= i_char(index_character);
					glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+1,glcdfont_index'length));
					i2c_data_wr <= glcdfont_character;
				when 3 =>
					i2c_ena <= '1';
					current_character <= i_char(index_character);
					glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+2,glcdfont_index'length));
					i2c_data_wr <= glcdfont_character;
				when 4 =>
					i2c_ena <= '1';
					current_character <= i_char(index_character);
					glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+3,glcdfont_index'length));
					i2c_data_wr <= glcdfont_character;
				when 5 =>
					i2c_ena <= '1';
					current_character <= i_char(index_character);
					glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+4,glcdfont_index'length));
					i2c_data_wr <= glcdfont_character;
				when 6 =>
					i2c_ena <= '0';
					current_character <= (others => '0');
					i2c_data_wr <= (others => '0');
					glcdfont_index <= (others => '0');
					if (i2c_busy = '0') then
						busy_cnt_send_char <= 0;
						n_state <= check_character_index;
					end if;
			end case;
		when check_character_index =>
			busy_prev <= '0';
			busy_cnt_sequence <= 0;
			busy_cnt_coord <= 0;
			busy_cnt_clear <= 0;
			busy_cnt_send_char <= 0;
			i2c_ena <= '0';
			i2c_reset <= '0';
			i2c_data_wr <= (others => '0');
			current_character <= (others => '0');
			glcdfont_index <= (others => '0');
			if (index_character < i_char'length - 1) then
				n_state <= send_character;
				index_character <= index_character + 1;
			else
				n_state <= stop;
				index_character <= 0;
			end if;
		when stop =>
--			n_state <= idle;
			busy_prev <= '0';
			busy_cnt_sequence <= 0;
			busy_cnt_coord <= 0;
			busy_cnt_clear <= 0;
			busy_cnt_send_char <= 0;
			i2c_ena <= '0';
			i2c_reset <= '0';
			i2c_data_wr <= (others => '0');
			current_character <= (others => '0');
			index_character <= 0;
			glcdfont_index <= (others => '0');
			i2c_ena <= '0';
	end case;
end process p0;

end Behavioral;

