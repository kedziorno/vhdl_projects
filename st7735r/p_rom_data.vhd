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
	-- 02 color x1 y1 x2 y2 - draw [color] box on [x1,y1] with [x2,y2] dimension
	constant COUNT_ROM_DATA : integer := 28;
	type ARRAY_ROM_DATA is array(0 to COUNT_ROM_DATA - 1) of BYTE_TYPE;
	constant C_ROM_DATA : ARRAY_ROM_DATA := (
		x"00",
		x"01",x"02",
		x"02",x"04",x"10",x"10",x"1f",x"6f",
		x"02",x"04",x"13",x"13",x"15",x"15",
		x"02",x"04",x"16",x"16",x"18",x"18",
		x"02",x"04",x"1a",x"1a",x"1c",x"1c",
		x"00"
	);

end p_rom_data;

package body p_rom_data is
end p_rom_data;
