----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:51:33 06/12/2021 
-- Design Name: 
-- Module Name:    ascount - Behavioral 
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

entity ascount is
generic (CounterSize: integer := 2);
port (
	clk,areset,sreset,enable : in std_logic;
	count : inout std_logic_vector(CounterSize-1 downto 0)
);
end ascount;

--use work.std_math.all;

architecture archascount of ascount is
begin
	p1 : process (areset,clk) is
	begin
		if (areset = '1') then
			count <= (others => '0');
		elsif (rising_edge(clk)) then
			if (sreset = '1') then
				count <= (others => '0');
			elsif (enable = '1') then
				count <= std_logic_vector(to_unsigned(to_integer(unsigned(count)) + 1,CounterSize));
			else
				count <= count;
			end if;
		end if;
	end process p1;
end archascount;
