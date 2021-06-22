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
	o_cs : inout std_logic;
	o_do : inout std_logic;
	o_ck : inout std_logic;
	o_reset : inout std_logic;
	o_rs : inout std_logic
);
end top;

architecture Behavioral of top is

	component initialize is
	port (
		i_clock : in std_logic;
		i_reset : in std_logic;
		i_run : in std_logic;
		i_color : in COLOR_TYPE;
		o_initialized : inout std_logic;
		o_cs : inout std_logic;
		o_do : inout std_logic;
		o_ck : inout std_logic;
		o_reset : inout std_logic;
		o_rs : inout std_logic
	);
	end component initialize;
	signal initialize_run,initialize_initialized,initialize_cs,initialize_do,initialize_ck,initialize_reset,initialize_rs : std_logic;
	signal initialize_color : COLOR_TYPE;

	type states is (idle,start,get_instruction,execute_instruction,get_color,screen_initialize,screen_initialize_finish,stop);
	signal state_current,state_next : states;

	signal index0 : integer range 0 to COUNT_ROM_DATA - 1;
	signal byte_instruciton : BYTE_TYPE;

begin

	o_cs <= initialize_cs when initialize_run = '1' else '1';
	o_do <= initialize_do when initialize_run = '1' else '0';
	o_ck <= initialize_ck when initialize_run = '1' else '0';
	o_reset <= initialize_reset when initialize_run = '1' else '0';
	o_rs <= initialize_rs when initialize_run = '1' else '0';

	c0 : initialize
	port map (
		i_clock => i_clock,
		i_reset => i_reset,
		i_run => initialize_run,
		i_color => initialize_color,
		o_initialized => initialize_initialized,
		o_cs => initialize_cs,
		o_do => initialize_do,
		o_ck => initialize_ck,
		o_reset => initialize_reset,
		o_rs => initialize_rs
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

	p_control : process (i_clock,i_reset) is
	begin
		if (i_reset = '1') then
			state_current <= idle;
		elsif (rising_edge(i_clock)) then
			state_current <= state_next;
		end if;
	end process p_control;

	pa : process (state_current,initialize_run) is
	begin
--		case (state_current) is
--			when idle =>
--				byte_instruciton <= (others => '0');
--				initialize_run <= '0';
--				index0 <= 0;
--			when get_instruction =>
--				index0 <= index0 + 1;
--			when get_color =>
--				initialize_run <= '1';
--			when others =>
--				byte_instruciton <= C_ROM_DATA(index0);
--			index0 <= index0;
--			initialize_run <= initialize_run;
--		end case;

--		initialize_run <= initialize_run;
--		index0 <= index0;
		if (state_current = idle) then
			byte_instruciton <= (others => '0');
			initialize_run <= '0';
			index0 <= 0;
		elsif (state_current = get_color) then
			initialize_run <= '1';
		elsif (state_current = get_instruction) then
			index0 <= index0 + 1;
		else
			byte_instruciton <= C_ROM_DATA(index0);
			initialize_run <= initialize_run;
			index0 <= index0;
		end if;
	end process pa;

	p_data : process (state_current,byte_instruciton,initialize_initialized) is
	begin
		state_next <= state_current;
		case (state_current) is
			when idle =>
				state_next <= start;
			when start =>
				state_next <= get_instruction;
			when get_instruction =>
				state_next <= execute_instruction;
			when execute_instruction =>
				case (byte_instruciton) is
					when x"00" =>
						state_next <= get_instruction;
					when x"01" =>
						state_next <= get_color;
					when others => null;
				end case;
			when get_color =>
				state_next <= screen_initialize;
			when screen_initialize =>
				if (initialize_initialized = '1') then
					state_next <= screen_initialize_finish;
				else
					state_next <= screen_initialize;
				end if;
			when screen_initialize_finish =>
				state_next <= stop;
			when stop =>
				state_next <= stop;
			when others =>
				state_next <= idle;
		end case;
	end process p_data;

end Behavioral;

