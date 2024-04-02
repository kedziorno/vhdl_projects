----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:31 04/23/2021 
-- Design Name: 
-- Module Name:    leading_zeros - Behavioral 
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

entity leading_zeros is
Generic (
	N : integer := 8
);
Port (
	x : in std_logic_vector(N-1 downto 0);
	y : out integer range 0 to N
);
end leading_zeros;

architecture Behavioral of leading_zeros is
begin
	p0 : process(x) is
		variable temp : integer range 0 to N;
	begin
		temp := 0;
		loop0 : for i in x'range loop
			exit when x(i) = '1';
			temp := temp + 1;
		end loop loop0;
		y <= temp;
	end process p0;
end Behavioral;
