----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:14:20 04/18/2021 
-- Design Name: 
-- Module Name:    OR_N_GATE - Behavioral 
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

entity OR_N_GATE is
Generic (
N : integer := 8
);
Port (
input : in  STD_LOGIC_VECTOR (N-1 downto 0);
output : out  STD_LOGIC
);
end OR_N_GATE;

-- XXX https://stackoverflow.com/q/53161241
architecture Behavioral of OR_N_GATE is

begin
	p0 : process (input)
	begin
		output <= '0';
		for i in N-1 downto 0 loop
			if input(i) = '1' then
				output <= '1';
			end if;
		end loop;
	end process p0;
end Behavioral;

