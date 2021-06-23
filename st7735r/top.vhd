----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:59:41 06/21/2021 
-- Design Name: 
-- Module Name:    top - Behavioral 
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
use WORK.p_package.ALL;
use WORK.p_screen.ALL;
use WORK.p_rom_data.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	o_cs : out std_logic;
	o_do : out std_logic;
	o_ck : out std_logic;
	o_reset : out std_logic;
	o_rs : out std_logic
);
end top;

architecture Behavioral of top is

	component my_spi is
	port (
		i_clock : in std_logic;
		i_reset : in std_logic;
		i_enable : in std_logic;
		i_data_byte : in std_logic_vector(0 to BYTE_SIZE-1);
		o_cs : out std_logic;
		o_do : out std_logic;
		o_ck : out std_logic;
		o_sended : out std_logic
	);
	end component my_spi;
	signal spi_enable,spi_cs,spi_do,spi_ck,spi_sended : std_logic;
	signal spi_data_byte : std_logic_vector(0 to BYTE_SIZE-1);

	component initialize is
	port (
		i_clock : in std_logic;
		i_reset : in std_logic;
		i_run : in std_logic;
		i_color : in COLOR_TYPE;
		i_sended : in std_logic;
		o_initialized : out std_logic;
		o_enable : out std_logic;
		o_reset : out std_logic;
		o_rs : out std_logic;
		o_cs : out std_logic;
		o_data_byte : out std_logic_vector(0 to BYTE_SIZE-1)
	);
	end component initialize;
	signal initialize_run,initialize_sended : std_logic;
	signal initialize_initialized,initialize_enable,initialize_reset,initialize_rs,initialize_cs : std_logic;
	signal initialize_color : COLOR_TYPE;
	signal initialize_data_byte : std_logic_vector(0 to BYTE_SIZE-1);

	type states is (idle,start,get_instruction,execute_instruction,get_color,screen_initialize,screen_initialize_finish,stop);
	signal state : states;

	signal index0 : integer range 0 to COUNT_ROM_DATA - 1;
	signal byte_instruciton : BYTE_TYPE;

begin

	o_cs <= spi_cs; -- TODO use initialize_cs mux
	o_do <= spi_do;
	o_ck <= spi_ck;
	o_reset <= initialize_reset;
	o_rs <= initialize_rs;

	spi_data_byte <= initialize_data_byte;
	spi_enable <= initialize_enable;
	initialize_sended <= spi_sended;

	c0 : my_spi
	port map (
		i_clock => i_clock,
		i_reset => i_reset,
		i_enable => spi_enable,
		i_data_byte => spi_data_byte,
		o_cs => spi_cs,
		o_do => spi_do,
		o_ck => spi_ck,
		o_sended => spi_sended
	);

	c1 : initialize
	port map (
		i_clock => i_clock,
		i_reset => i_reset,
		i_run => initialize_run,
		i_color => initialize_color,
		i_sended => initialize_sended,
		o_initialized => initialize_initialized,
		o_cs => initialize_cs,
		o_reset => initialize_reset,
		o_rs => initialize_rs,
		o_enable => initialize_enable,
		o_data_byte => initialize_data_byte
	);

	p1 : process (byte_instruciton) is
	begin
		case (byte_instruciton) is
			when x"00" =>
				initialize_color <= SCREEN_BLACK;
			when x"01" =>
				initialize_color <= SCREEN_BLUE;
			when x"02" =>
				initialize_color <= SCREEN_RED;
			when x"03" =>
				initialize_color <= SCREEN_GREEN;
			when x"04" =>
				initialize_color <= SCREEN_CYAN;
			when x"05" =>
				initialize_color <= SCREEN_MAGENTA;
			when x"06" =>
				initialize_color <= SCREEN_YELLOW;
			when x"07" =>
				initialize_color <= SCREEN_WHITE;
			when x"08" =>
				initialize_color <= SCREEN_ORANGE;
			when x"09" =>
				initialize_color <= SCREEN_LIGHTGREEN;
			when x"0a" =>
				initialize_color <= SCREEN_LIGHTGREY;
			when others =>
				initialize_color <= SCREEN_BLACK;
		end case;	
	end process p1;

	p_control : process (i_clock,i_reset,initialize_initialized) is
	begin
		if (i_reset = '1') then
			state <= idle;
		elsif (rising_edge(i_clock)) then
			case (state) is
				when idle =>
					state <= start;
					byte_instruciton <= (others => '0');
					initialize_run <= '0';
					index0 <= 0;
				when start =>
					state <= get_instruction;
				when get_instruction =>
					state <= execute_instruction;
					byte_instruciton <= C_ROM_DATA(index0);
					index0 <= index0 + 1;
				when execute_instruction =>
					case (byte_instruciton) is
						when x"00" =>
							state <= get_instruction;
						when x"01" =>
							state <= get_color;
						when others => null;
					end case;
				when get_color =>
					state <= screen_initialize;
					byte_instruciton <= C_ROM_DATA(index0);
					initialize_run <= '1';
				when screen_initialize =>
					if (initialize_initialized = '1') then
						state <= screen_initialize_finish;
					else
						state <= screen_initialize;
					end if;
				when screen_initialize_finish =>
					state <= stop;
				when stop =>
					state <= stop;
				when others =>
					state <= idle;
			end case;
		end if;
	end process p_control;

end Behavioral;

