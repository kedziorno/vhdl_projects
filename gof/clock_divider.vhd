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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_divider is
Generic(
g_board_clock : REAL;
g_divider : REAL);
Port(
i_clk : in  STD_LOGIC;
i_divider : in REAL;
o_clk : out  STD_LOGIC
);
end clock_divider;

architecture Behavioral of clock_divider is
	constant clk_div : REAL := g_board_clock / i_divider;
	signal scd : std_logic_vector(31 downto 0);
begin

p0 : process (i_clk) is
	variable clk_out : std_logic;
	variable counter : REAL := 1.0e0;
begin
	if (rising_edge(i_clk)) then
		if (counter = clk_div-1.0e0) then
			clk_out := '1';
			counter := 1.0e0;
		else
			clk_out := '0';
			counter := counter + 1.0e0;
		end if;
	end if;
	o_clk <= clk_out;
	--scd <= std_logic_vector(to_unsigned(INTEGER(counter * 1.0),32));
end process p0;

end Behavioral;

