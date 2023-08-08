----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:50:20 07/09/2021 
-- Design Name: 
-- Module Name:    ff3_synchronizer - Behavioral 
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

entity ff3_synchronizer is
Port (
	i_clock : in  STD_LOGIC;
	i_reset : in  STD_LOGIC;
	i_input : in  STD_LOGIC;
	o_pulse : out  STD_LOGIC
);
end ff3_synchronizer;

architecture Behavioral of ff3_synchronizer is
	signal d,dd,ddd : std_logic;
begin

	p0 : process (i_clock,i_reset) is
	begin
		if (i_reset = '1') then
			o_pulse <= '0';
			d <= '0';
			dd <= '0';
			ddd <= '0';
		elsif (rising_edge(i_clock)) then
			d <= i_input;
			dd <= d;
			ddd <= dd;
			o_pulse <= dd and not ddd;
		end if;
	end process p0;

end Behavioral;

