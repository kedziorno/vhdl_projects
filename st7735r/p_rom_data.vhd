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

	-- in bytes
	-- 00 - NOP
	-- 01 color -- initialize screen with fill color index
	-- 02 color x a y b - draw [color] box on [x,y] with [a,b] dimension
	constant COUNT_ROM_DATA : integer := 28;
	type ARRAY_ROM_DATA is array(0 to COUNT_ROM_DATA - 1) of BYTE_TYPE;
	constant C_ROM_DATA : ARRAY_ROM_DATA := (
		x"00",
		x"01",x"02",
		x"02",x"04",x"1f",x"1f",x"1f",x"1f",
		x"02",x"04",x"2f",x"2f",x"2f",x"2f",
		x"02",x"04",x"3f",x"3f",x"3f",x"3f",
		x"02",x"04",x"4f",x"4f",x"4f",x"4f",
		x"00"
	);

end p_rom_data;

package body p_rom_data is
end p_rom_data;
