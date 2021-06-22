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

	constant COUNT_ROM_DATA : integer := 9;
	type ARRAY_ROM_DATA is array(0 to COUNT_ROM_DATA - 1) of BYTE_TYPE;
	constant C_ROM_DATA : ARRAY_ROM_DATA := (
		x"00", -- NOP
		x"01", -- initialize
		x"02", -- color_number
		x"02", -- draw box
		x"f0", -- box x
		x"f0", -- box y
		x"f0", -- box a
		x"f0", -- box b
		x"00"  -- NOP
	);

end p_rom_data;

package body p_rom_data is
end p_rom_data;
