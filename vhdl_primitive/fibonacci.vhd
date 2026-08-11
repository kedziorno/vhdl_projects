----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:04:34 04/23/2021 
-- Design Name: 
-- Module Name:    fibonacci - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fibonacci is
generic (
	N : integer := 16
);
port (
	clk,rst : in bit;
	f : out integer range 0 to 2**N-1
);
end fibonacci;

architecture Behavioral of fibonacci is
	signal a,b,c : integer range 0 to 2**N-1;
begin
	p0 : process (clk,rst) is
	begin
		if (rst = '1') then
			b <= 1;
			c <= 0;
		elsif (rising_edge(clk)) then
			c <= b;
			b <= a;
		end if;
		a <= b + c;
	end process p0;
	f <= c;
end Behavioral;
