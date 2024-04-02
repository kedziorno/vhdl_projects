----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:13:46 09/15/2020 
-- Design Name: 
-- Module Name:    debounce_button - Behavioral 
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

entity debounce_button is
generic (g_board_clock : integer);
Port
(
i_button : in  STD_LOGIC;
i_clk : in  STD_LOGIC;
o_stable : out  STD_LOGIC
);
end debounce_button;

architecture Behavioral of debounce_button is

signal slow_clk_en : std_logic;
signal Q0,Q1,Q2,Q2_bar : std_logic := '0';

begin

p0 : process (i_clk) is
	variable aa : integer := 250_000;
	variable counter : integer := 0;
	variable clk : std_logic;
begin
	if (rising_edge(i_clk)) then
		if (counter = aa-1) then
			counter := 0;
			clk := '1';			
		else
			clk := '0';
		end if;
	end if;
	counter := counter + 1;
	slow_clk_en <= clk;
end process p0;

p1a : process (slow_clk_en) is
begin
	if (rising_edge(slow_clk_en)) then
		--if (slow_clk_en = '1') then
			Q0 <= i_button;
		--end if;
	end if;
end process p1a;

p1b : process (slow_clk_en) is
begin
	if (rising_edge(slow_clk_en)) then
		--if (slow_clk_en = '1') then
			Q1 <= Q0;
		--end if;
	end if;
end process p1b;

p1c : process (slow_clk_en) is
begin
	if (rising_edge(slow_clk_en)) then
		--if (slow_clk_en = '1') then
			Q2 <= Q1;
		--end if;
	end if;
end process p1c;

Q2_bar <= not Q2;
o_stable <= Q1 and Q2_bar;

end Behavioral;
