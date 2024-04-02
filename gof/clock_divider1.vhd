----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:42:10 09/18/2020 
-- Design Name: 
-- Module Name:    clock_divider - Behavioral 
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
use WORK.p_memory_content.ALL;
use WORK.p_constants1.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_divider1 is
Generic (
	g_board_clock : integer := G_BOARD_CLOCK;
	g_divider : integer := 1
);
Port (
	i_clock : in STD_LOGIC;
	o_clock : out STD_LOGIC
);
end clock_divider1;

architecture Behavioral of clock_divider1 is
begin

p0 : process (i_clock) is
	variable clock_out : std_logic;
	variable counter : integer := 0;
begin
	if (rising_edge(i_clock)) then
		if (counter = (g_board_clock / g_divider) - 1) then
			clock_out := '1';
			counter := 0;
		else
			clock_out := '0';
			counter := counter + 1;
		end if;
	end if;
	o_clock <= clock_out;
end process p0;

end Behavioral;
