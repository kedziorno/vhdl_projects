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

package p_memory_content is
	constant WIDTH : integer := 128;
	constant HEIGHT : integer := 4;
	constant WIDTH_BITS : integer := 7;
	constant HEIGHT_BITS : integer := 2;
	constant BYTE_BITS : integer := 8;
	subtype WORD is std_logic_vector((BYTE_BITS*HEIGHT)-1 downto 0);
	type MEMORY is array(WIDTH-1 downto 0) of WORD;
	constant memory_content : MEMORY :=
	(	("11111111111100000000000000000000"),
		("11000000000100000000000000000000"),
		("10100000000100000000000000000000"),
		("10010000000100000000000000000000"),
		("10001000000100000000000000000000"),
		("10000100000100000000000000000000"),
		("10000010000100000000000000000000"),
		("10000001000100000000000000000000"),
		("10000000100100000000000000000000"),
		("10000000010100000000000000000000"),
		("10000000001100000000000000000000"),
		("11111111111100000000000000000000"),
		("00000000000010000000000000000000"),
		("00000000000001000000000000000000"),
		("00000000000000100000000000000000"),
		("00000000000000010000000000000000"),
		("00000000000000001000000000000000"),
		("00000000000000000100000000000000"),
		("00000000000000000010000000000000"),
		("00000000000000000001000000000000"),
		("00000000000000000000100000000000"),
		("00000000000000000000010000000000"),
		("00000000000000000000001000000000"),
		("00000000000000000000000100000000"),
		("00000000000000000000000010000000"),
		("00000000000000000000000001000000"),
		("00000000000000000000000000100000"),
		("00000000000000000000000000010000"),
		("00000000000000000000000000001000"),
		("00000000000000000000000000000100"),
		("00000000000000000000000000000010"),
		("00000000000000000000000000000001"),
		("00000000000000000000000000000010"),
		("00000000000000000000000000000100"),
		("00000000000000000000000000001000"),
		("00000000000000000000000000010000"),
		("00000000000000000000000000100000"),
		("00000000000000000000000001000000"),
		("00000000000000000000000010000000"),
		("00000000000000000000000100000000"),
		("00000000000000000000001000000000"),
		("00000000000000000000010000000000"),
		("00000000000000000000100000000000"),
		("00000000000000000001000000000000"),
		("00000000000000000010000000000000"),
		("00000000000000000100000000000000"),
		("00000000000000001000000000000000"),
		("00000000000000010000000000000000"),
		("00000000000000100000000000000000"),
		("00000000000001000000000000000000"),
		("00000000000010000000000000000000"),
		("00000000000100000000000000000000"),
		("00000000001000000000000000000000"),
		("00000000010000000000000000000000"),
		("00000000100000000000000000000000"),
		("00000001000000000000000000000000"),
		("00000010000000000000000000000000"),
		("00000100000000000000000000000000"),
		("00001000000000000000000000000000"),
		("00010000000000000000000000000000"),
		("00100000000000000000000000000000"),
		("01000000000000000000000000000000"),
		("10000000000000000000000000000000"),
		("01000000000000000000000000000000"),
		("00100000000000000000000000000000"),
		("00010000000000000000000000000000"),
		("00001000000000000000000000000000"),
		("00000100000000000000000000000000"),
		("00000010000000000000000000000000"),
		("00000001000000000000000000000000"),
		("00000000100000000000000000000000"),
		("00000000010000000000000000000000"),
		("00000000001000000000000000000000"),
		("00000000000100000000000000000000"),
		("00000000000010000000000000000000"),
		("00000000000001000000000000000000"),
		("00000000000000100000000000000000"),
		("00000000000000010000000000000000"),
		("00000000000000001000000000000000"),
		("00000000000000000100000000000000"),
		("00000000000000000010000000000000"),
		("00000000000000000001000000000000"),
		("00000000000000000000100000000000"),
		("00000000000000000000010000000000"),
		("00000000000000000000001000000000"),
		("00000000000000000000000100000000"),
		("00000000000000000000000010000000"),
		("00000000000000000000000001000000"),
		("00000000000000000000000000100000"),
		("00000000000000000000000000010000"),
		("00000000000000000000000000001000"),
		("00000000000000000000000000000100"),
		("00000000000000000000000000000010"),
		("00000000000000000000000000000001"),
		("00000000000000000000000000000010"),
		("00000000000000000000000000000100"),
		("00000000000000000000000000001000"),
		("00000000000000000000000000010000"),
		("00000000000000000000000000100000"),
		("00000000000000000000000001000000"),
		("00000000000000000000000010000000"),
		("00000000000000000000000100000000"),
		("00000000000000000000001000000000"),
		("00000000000000000000010000000000"),
		("00000000000000000000100000000000"),
		("00000000000000000001000000000000"),
		("00000000000000000010000000000000"),
		("00000000000000000100000000000000"),
		("00000000000000001000000000000000"),
		("00000000000000010000000000000000"),
		("00000000000000100000000000000000"),
		("00000000000001000000000000000000"),
		("00000000000010000000000000000000"),
		("00000000000100000000000000000000"),
		("00000000001000000000000000000000"),
		("00000000010000000000000000000000"),
		("00000000100000000000000000000000"),
		("00000001000000000000000000000000"),
		("00000010000000000000000000000000"),
		("00000100000000000000000000000000"),
		("00001000000000000000000000000000"),
		("00010000000000000000000000000000"),
		("00100000000000000000000000000000"),
		("01000000000000000000000000000000"),
		("10000000000000000000000000000000"),
		("01000000000000000000000000000000"),
		("00100000000000000000000000000000"),
		("00011111111000000000000000000000")	);
end p_memory_content;

package body p_memory_content is
end p_memory_content;

--		("00000000000000000000000010000000"),
--		("00000000000000000000001010000000"),
--		("00000000000011000000110000000000"),
--		("00000000000100010000110000000000"),
--		("11000000001000001000110000000000"),
--		("11000000001000101100001010000000"),
--		("00000000001000001000000010000000"),
--		("00000000000100010000000000000000"),
--		("00000000000011000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000")

-- https://www.conwaylife.com/patterns/gosperglidergun.cells
-- !Name: Gosper glider gun
-- !Author: Bill Gosper
-- !The first known gun and the first known finite pattern with unbounded growth.
-- !www.conwaylife.com/wiki/index.php?title=Gosper_glider_gun
-- ........................O
-- ......................O.O
-- ............OO......OO............OO
-- ...........O...O....OO............OO
-- OO........O.....O...OO
-- OO........O...O.OO....O.O
-- ..........O.....O.......O
-- ...........O...O
-- ............OO