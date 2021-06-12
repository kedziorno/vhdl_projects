----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:40:31 06/12/2021 
-- Design Name: 
-- Module Name:    rreg1 - Behavioral 
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

entity rreg1 is
port (
	clk,reset,load : in std_logic;
	d : in std_logic;
	q : inout std_logic
);
end rreg1;

architecture archrreg1 of rreg1 is
begin
	p1 : process (reset,clk) is
	begin
		if (reset = '1') then
			q <= '0';
		elsif (rising_edge(clk)) then
			if (load = '1') then
				q <= d;
			else
				q <= q;
			end if;
		end if;
	end process p1;
end archrreg1;
