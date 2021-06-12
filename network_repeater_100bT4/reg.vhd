----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:47:28 06/12/2021 
-- Design Name: 
-- Module Name:    reg - Behavioral 
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

entity reg is
generic (size : integer := 2);
port (
	clk,reset : in std_logic;
	rst,pst : in std_logic;
	d : in std_logic_vector(size-1 downto 0);
	q : inout std_logic_vector(size-1 downto 0)
);
end reg;

architecture archreg of reg is
begin
	p1 : process (clk) is
	begin
		if (rst = '1') then
			q <= (others => '0');
		elsif (pst = '1') then
			q <= (others => '1');
		elsif (rising_edge(clk)) then
			if (load = '1') then
				q <= d;
			else
				q <= q;
			end if;
		end if;
	end process p1;
end archreg;
