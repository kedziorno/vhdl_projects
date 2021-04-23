----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:56:47 04/23/2021 
-- Design Name: 
-- Module Name:    counter_ping - Behavioral 
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

entity counter_ping is
generic (
	max : integer := 1
);
port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	o_ping : out std_logic
);
end counter_ping;

architecture Behavioral of counter_ping is
begin
	p0 : process (i_clock,i_reset) is
		variable count : integer range 0 to max-1;
		variable ping : std_logic;
	begin
		if (i_reset = '1') then
				count := 0;
				ping := '0';
		elsif (rising_edge(i_clock)) then
			if (count = max-1) then
				count := 0;
				ping := '1';
			else
				count := count + 1;
				ping := '0';
			end if;
		end if;
		o_ping <= ping;
	end process p0;
end Behavioral;
