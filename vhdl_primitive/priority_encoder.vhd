----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:50:51 04/23/2021 
-- Design Name: 
-- Module Name:    priority_encoder - Behavioral 
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

entity priority_encoder is
Generic (
	N : integer := 7
);
Port (
	x : in std_logic_vector(N downto 1);
	y : out integer range 0 to N
);
end priority_encoder;

architecture Behavioral of priority_encoder is
begin
	p0 : process(x) is
	begin
		l0 : for i in x'range loop
			if (x(i)='1') then
				temp := i;
				exit;
			else
				temp := 0;
			end if;
		end loop l0;
		y <= temp;
	end process p0;
end Behavioral;
