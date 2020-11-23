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
Port(
i_clk : in STD_LOGIC;
i_board_clock : in INTEGER;
i_divider : in INTEGER;
o_clk : out STD_LOGIC
);
end clock_divider;

architecture Behavioral of clock_divider is
begin

p0 : process (i_clk) is
	variable clk_out : std_logic;
	variable a : integer := i_board_clock;
	variable b : integer := i_divider;
begin
	if (rising_edge(i_clk)) then
		if (a <= 0) then
			clk_out := '1';
			a := i_board_clock;
			b := i_divider;
		else
			clk_out := '0';
			a := a - b;
		end if;
	end if;
	o_clk <= clk_out;
end process p0;

end Behavioral;

