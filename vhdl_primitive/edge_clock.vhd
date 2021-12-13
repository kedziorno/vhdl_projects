----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:03:07 07/03/2021 
-- Design Name: 
-- Module Name:    edge_clock - Behavioral 
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

entity edge_clock is
port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	i_e1 : in std_logic;
	i_e2 : in std_logic;
	o_count : out unsigned(31 downto 0)
);
end edge_clock;

architecture Behavioral of edge_clock is
	signal count1,count2 : unsigned(31 downto 0);
begin

	p0 : process (i_clock,i_reset) is
	begin
		if (i_reset = '1') then
			count1 <= (others => '0');
		elsif (rising_edge(i_clock)) then
--			if (i_e1 = '1') then
				count1 <= count1 + 1;
--			end if;
		end if;
	end process p0;

	p1 : process (i_clock,i_reset) is
	begin
		if (i_reset = '1') then
			count2 <= (others => '0');
		elsif (falling_edge(i_clock)) then
--			if (i_e2 = '1') then
				count2 <= count2 - 1;
--			end if;
		end if;
	end process p1;

	o_count <= count1 when i_clock = '1' else count2 when i_clock = '0';

end Behavioral;

