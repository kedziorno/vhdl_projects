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

entity test_oled_fsm is
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
end test_oled_fsm;

architecture Behavioral of test_oled_fsm is

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

signal current_character : std_logic_vector(7 downto 0);
signal byte_sended : std_logic;

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
o_byte_sended : out std_logic;
o_sda : out std_logic;
o_scl : out std_logic
);
end component my_i2c_fsm;

type state is 
(
	idle, -- reset i2c
	start, -- initialize oled
	set_address_1, -- set begin point 0,0
	set_address_2, -- set begin point 0,0
	send_character, -- send the some data/text array
	check_character_index, -- check have char
	stop -- when index=counter, i2c disable
);
signal c_state_test_oled_fsm,n_state_test_oled_fsm : state;

signal glcdfont_character : std_logic_vector(7 downto 0);
signal glcdfont_index : std_logic_vector(10 downto 0);

component ripple_counter is
Generic (
N : integer := 32;
MAX : integer := 1
);
Port (
i_clock : in std_logic;
i_cpb : in std_logic;
i_mrb : in std_logic;
i_ud : in std_logic;
o_q : inout std_logic_vector(N-1 downto 0);
o_ping : out std_logic
);
end component ripple_counter;
constant RC0_N : integer := 5;
constant RC0_MAX : integer := BYTES_SEQUENCE_LENGTH;
signal rc0_cpb,rc0_mrb : std_logic;
signal rc0_q : std_logic_vector(RC0_N-1 downto 0);
signal rc0_ping : std_logic;
constant RC1_N : integer := 4;
constant RC1_MAX : integer := 7;
signal rc1_cpb,rc1_mrb : std_logic;
signal rc1_q : std_logic_vector(RC1_N-1 downto 0);
signal rc1_ping : std_logic;
constant RC2_N : integer := 5;
constant RC2_MAX : integer := 16;
signal rc2_cpb,rc2_mrb : std_logic;
signal rc2_q : std_logic_vector(RC2_N-1 downto 0);
signal rc2_ping : std_logic;

signal character_sended : std_logic;

begin

i2c_addr <= "0111100"; -- 3C
--i2c_addr <= "1111111"; -- 3C
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
	o_byte_sended => byte_sended,
	o_sda => io_sda,
	o_scl => io_scl
);

test_oled_fsm_entity_rc0 : ripple_counter
Generic map (N => RC0_N, MAX => RC0_MAX+2)
Port map (
i_clock => byte_sended,
i_cpb => rc0_cpb,
i_mrb => rc0_mrb,
i_ud => '1',
o_q => rc0_q,
o_ping => rc0_ping
);

test_oled_fsm_entity_rc1 : ripple_counter
Generic map (N => RC1_N, MAX => RC1_MAX)
Port map (
i_clock => byte_sended,
i_cpb => rc1_cpb,
i_mrb => rc1_mrb,
i_ud => '1',
o_q => rc1_q,
o_ping => rc1_ping
);

test_oled_fsm_entity_rc2 : ripple_counter
Generic map (N => RC2_N, MAX => RC2_MAX)
Port map (
i_clock => character_sended,
i_cpb => rc2_cpb,
i_mrb => rc2_mrb,
i_ud => '1',
o_q => rc2_q,
o_ping => rc2_ping
);

test_oled_fsm_p1 : process (i_clk,i_rst) is
begin
	if (i_rst = '1') then
		c_state_test_oled_fsm <= idle;
	elsif (rising_edge(i_clk)) then
		c_state_test_oled_fsm <= n_state_test_oled_fsm;
	end if;
end process test_oled_fsm_p1;

test_oled_fsm_p0 : process (c_state_test_oled_fsm,i2c_busy,glcdfont_character,busy_prev) is
	variable index : integer range 0 to 6;
begin
	n_state_test_oled_fsm <= c_state_test_oled_fsm;
	case c_state_test_oled_fsm is
		when idle =>
			n_state_test_oled_fsm <= start;
			i2c_reset <= '1';
			busy_prev <= '0';
			i2c_ena <= '0';
			i2c_data_wr <= (others => '0');
			current_character <= (others => '0');
			glcdfont_index <= (others => '0');
			rc0_mrb <= '1';
			rc0_cpb <= '0';
			rc1_mrb <= '1';
			rc1_cpb <= '0';
			rc2_mrb <= '1';
			rc2_cpb <= '0';
			index := 0;
			character_sended <= '0';
		when start =>
			index := 0;
			character_sended <= '0';
			i2c_reset <= '0';
			busy_prev <= i2c_busy;
			rc0_mrb <= '0';
			rc1_mrb <= '0';
			rc1_cpb <= '0';
			rc2_cpb <= '0';
--			rc0_cpb <= '0';
			rc2_mrb <= '0';
			if (busy_prev = '0' and i2c_busy = '1') then
				rc0_cpb <= '0';
			else
				rc0_cpb <= '1';
			end if;
			case to_integer(unsigned(rc0_q)) is
				when 0 =>
					i2c_ena <= '1'; -- we are busy
					i2c_data_wr <= (others => '0');
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
				when 1 to BYTES_SEQUENCE_LENGTH =>
					i2c_ena <= '1';
					i2c_data_wr <= sequence(to_integer(unsigned(rc0_q))-1); -- command
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
				when BYTES_SEQUENCE_LENGTH+1 =>
					i2c_ena <= '0';
					i2c_data_wr <= (others => '0');
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
					if (i2c_busy = '0') then
						rc0_mrb <= '1';
						n_state_test_oled_fsm <= set_address_1;
					end if;
				when others =>
					i2c_ena <= '0';
					i2c_data_wr <= (others => '0');
					glcdfont_index <= (others => '0');
					current_character <= (others => '0');
			end case;
		when set_address_1 =>
			index := 0;
			character_sended <= '0';
			busy_prev <= i2c_busy;
			rc0_mrb <= '0';
			rc1_cpb <= '0';
--			rc0_cpb <= '0';
			rc2_mrb <= '0';
			rc1_mrb <= '0';
			rc2_cpb <= '0';
			i2c_reset <= '0';
			if (busy_prev = '0' and i2c_busy = '1') then
				rc0_cpb <= '0';
			else
				rc0_cpb <= '1';
			end if;
			case to_integer(unsigned(rc0_q)) is
				when 0 =>
					i2c_ena <= '1'; -- we are busy
					i2c_data_wr <= (others => '0');
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
				when 1 to NI_SET_COORDINATION =>
					i2c_ena <= '1';
					i2c_data_wr <= set_coordination(to_integer(unsigned(rc0_q))-1); -- command
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
				when NI_SET_COORDINATION+1 =>
					i2c_ena <= '0';
					i2c_data_wr <= (others => '0');
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
					if (i2c_busy = '0') then
						rc0_mrb <= '1';
						n_state_test_oled_fsm <= set_address_2; --clear_display_state_1;
					end if;
				when others =>
					i2c_ena <= '0';
					i2c_data_wr <= (others => '0');
					glcdfont_index <= (others => '0');
					current_character <= (others => '0');
			end case;
		when set_address_2 =>
			index := 0;
			character_sended <= '0';
			i2c_reset <= '0';
			current_character <= (others => '0');
			glcdfont_index <= (others => '0');
			busy_prev <= i2c_busy;
			rc0_mrb <= '0';
			rc1_cpb <= '0';
			rc2_cpb <= '0';
--			rc0_cpb <= '0';
			rc2_mrb <= '0';
			rc1_mrb <= '0';
			if (busy_prev = '0' and i2c_busy = '1') then
				rc0_cpb <= '0';
			else
				rc0_cpb <= '1';
			end if;
			case to_integer(unsigned(rc0_q)) is
				when 0 =>
					i2c_ena <= '1'; -- we are busy
					i2c_data_wr <= (others => '0');
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
				when 1 to NI_SET_COORDINATION =>
					i2c_ena <= '1';
					i2c_data_wr <= set_coordination(to_integer(unsigned(rc0_q))-1); -- command
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
				when NI_SET_COORDINATION+1 =>
					i2c_ena <= '0';
					i2c_data_wr <= (others => '0');
					current_character <= (others => '0');
					glcdfont_index <= (others => '0');
					if (i2c_busy = '0') then
						rc0_mrb <= '1';
						n_state_test_oled_fsm <= send_character;
						character_sended <= '1';
					end if;
				when others =>
					i2c_ena <= '0';
					i2c_data_wr <= (others => '0');
					glcdfont_index <= (others => '0');
					current_character <= (others => '0');
			end case;
		when send_character =>
			index := to_integer(unsigned(rc2_q));
			character_sended <= '0';
			i2c_reset <= '0';
			busy_prev <= i2c_busy;
			glcdfont_index <= (others => '0');
			rc0_mrb <= '1';
			rc1_mrb <= '0';
--			rc1_cpb <= '0';
			rc2_mrb <= '0';
			rc2_cpb <= '1';
			rc0_cpb <= '0';
			character_sended <= '0';
			if (busy_prev = '0' and i2c_busy = '1') then
				rc1_cpb <= '0';
			else
				rc1_cpb <= '1';
			end if;
			case to_integer(unsigned(rc1_q)) is
				when 0 =>
					i2c_ena <= '1'; -- we are busy
					current_character <= (others => '0');
					i2c_data_wr <= (others => '0');
					glcdfont_index <= (others => '0');
				when 1 =>
					i2c_ena <= '1';
					current_character <= i_char(index);
					glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+0,glcdfont_index'length));
					i2c_data_wr <= glcdfont_character;
				when 2 =>
					i2c_ena <= '1';
					current_character <= i_char(index);
					glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+1,glcdfont_index'length));
					i2c_data_wr <= glcdfont_character;
				when 3 =>
					i2c_ena <= '1';
					current_character <= i_char(index);
					glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+2,glcdfont_index'length));
					i2c_data_wr <= glcdfont_character;
				when 4 =>
					i2c_ena <= '1';
					current_character <= i_char(index);
					glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+3,glcdfont_index'length));
					i2c_data_wr <= glcdfont_character;
				when 5 =>
					i2c_ena <= '1';
					current_character <= i_char(index);
					glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+4,glcdfont_index'length));
					i2c_data_wr <= glcdfont_character;
				when 6 =>
					i2c_ena <= '0';
					current_character <= (others => '0');
					i2c_data_wr <= (others => '0');
					glcdfont_index <= (others => '0');
					if (i2c_busy = '0') then
--						rc2_mrb <= '1';
						n_state_test_oled_fsm <= check_character_index;
					end if;
				when others =>
					i2c_ena <= '0';
					i2c_data_wr <= (others => '0');
					glcdfont_index <= (others => '0');
					current_character <= (others => '0');
			end case;
		when check_character_index =>
			index := 0;
			rc0_mrb <= '1';
			rc2_cpb <= '1';
			rc1_cpb <= '0';
			rc0_cpb <= '0';
			rc2_mrb <= '0';
--			rc1_mrb <= '0';
			busy_prev <= '0';
			i2c_ena <= '0';
			i2c_reset <= '0';
			i2c_data_wr <= (others => '0');
			current_character <= (others => '0');
			glcdfont_index <= (others => '0');
			character_sended <= '1';
			if (to_integer(unsigned(rc2_q)) = i_char'length - 1) then
				n_state_test_oled_fsm <= stop;
				rc1_mrb <= '0';
			else
				n_state_test_oled_fsm <= send_character;
				rc1_mrb <= '1';
			end if;
		when stop =>
			index := 0;
--			n_state_test_oled_fsm <= idle;
			rc2_cpb <= '0';
			rc0_cpb <= '0';
			rc0_mrb <= '0';
			rc1_cpb <= '0';
			rc2_mrb <= '0';
			rc1_mrb <= '0';
			character_sended <= '0';
			busy_prev <= '0';
			i2c_ena <= '0';
			i2c_reset <= '0';
			i2c_data_wr <= (others => '0');
			current_character <= (others => '0');
			glcdfont_index <= (others => '0');
	end case;
end process test_oled_fsm_p0;

end Behavioral;

