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
Generic(g_board_clock : integer);
Port(
i_clk : in  STD_LOGIC;
o_clk_25khz : out  STD_LOGIC;
o_clk_50khz : out  STD_LOGIC
);
end clock_divider;

architecture Behavioral of clock_divider is
	constant clk25khz_div : integer := g_board_clock / 25_000;
	constant clk50khz_div : integer := g_board_clock / 50_000;
begin

p0 : process (i_clk) is
	variable clk_out25 : std_logic;
	variable clk_out50 : std_logic;
	variable counter1 : integer := 0;
	variable counter2 : integer := 0;
begin
	if (rising_edge(i_clk)) then
		if (counter1 = clk25khz_div-1) then
			clk_out25 := '1';
			counter1 := 0;
		else
			clk_out25 := '0';
			counter1 := counter1 + 1;
		end if;
		if (counter2 = clk50khz_div-1) then
			clk_out50 := '1';
			counter2 := 0;
		else
			clk_out50 := '0';
			counter2 := counter2 + 1;
		end if;
	end if;
	o_clk_25khz <= clk_out25;
	o_clk_50khz <= clk_out50;
end process p0;

end Behavioral;

