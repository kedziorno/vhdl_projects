----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:44:15 04/19/2021 
-- Design Name: 
-- Module Name:    counter_n - Behavioral 
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

entity counter_n is
Generic (
N : integer := 8
);
Port (
i_clock : in  STD_LOGIC;
i_reset : in  STD_LOGIC;
o_count : out  STD_LOGIC_VECTOR (N-1 downto 0)
);
end counter_n;

architecture Behavioral of counter_n is
	signal counter : STD_LOGIC_VECTOR (N-1 downto 0);
begin

p0 : process (i_clock,i_reset) is
begin
	o_count <= counter;
	if (i_reset = '1') then
		counter <= (others => '0');
	elsif (rising_edge(i_clock)) then
		counter <= std_logic_vector(to_unsigned(to_integer(unsigned(counter))+1,N));
	end if;
end process p0;

end Behavioral;

