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
use WORK.p_package.ALL;

package p_rom_data is

	constant COUNT_ROM_DATA : integer := 3;
	type ARRAY_ROM_DATA is array(0 to COUNT_ROM_DATA - 1) of std_logic_vector(BYTE_SIZE - 1 downto 0);
	constant C_ROM_DATA : ARRAY_ROM_DATA := (
		x"01", -- initialize
		x"01", -- color_number
		x"00"
	);

end p_rom_data;

package body p_rom_data is
end p_rom_data;
