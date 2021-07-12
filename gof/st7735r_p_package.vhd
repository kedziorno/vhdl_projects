--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package st7735r_p_package is

	constant BYTE_SIZE : integer := 8;
	subtype BYTE_TYPE is std_logic_vector(BYTE_SIZE - 1 downto 0);
	constant ABOUT_1coma31_MS: integer := 2**16; --XXX ~1.31ms on 50mhz
	constant C_CLOCK_COUNTER_S : integer := 2**16; -- XXX slow
	constant C_CLOCK_COUNTER_F : integer := 2**8; -- XXX fast
	constant C_CLOCK_COUNTER_VF : integer := 2**4; -- XXX very fast
	constant C_CLOCK_COUNTER_EF : integer := 2**3; -- XXX extreme fast
	constant C_CLOCK_COUNTER_MF : integer := 2**2; -- XXX monster fast,not work,this is max in simulation

end st7735r_p_package;

package body st7735r_p_package is
end st7735r_p_package;
