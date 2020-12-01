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
	constant G_BOARD_CLOCK : integer := 50_000_000;
	constant G_BUS_CLOCK : integer := 100_000;
	constant G_ClockDivider : integer := 1000;
	constant G_MemoryAddress : integer := 24;
	constant G_MemoryData : integer := 16;
	constant G_HalfHex : integer := 4;
	constant G_FullHex : integer := G_HalfHex*2;
	constant ROWS : integer := 32; --128;
	constant ROWS_BITS : integer := 5; --7;
	constant COLS_PIXEL : integer := 32; --32;
	constant COLS_PIXEL_BITS : integer := 5; --5;
	constant COLS_BLOCK : integer := 4;
	constant COLS_BLOCK_BITS : integer := 2;
	constant BYTE_BITS : integer := 8;
	constant WORD_BITS : integer := COLS_BLOCK*BYTE_BITS;
	
	subtype WORD is std_logic_vector(WORD_BITS-1 downto 0);
	type MEMORY is array(ROWS-1 downto 0) of WORD;
	
	type LiveSubArray is array(WORD_BITS-1 downto 0) of std_logic_vector(2 downto 0);
	type LiveArrayType is array(ROWS-1 downto 0) of LiveSubArray;

	-- https://www.conwaylife.com/patterns/gosperglidergun.cells
	-- !Name: Gosper glider gun
	-- !Author: Bill Gosper
	-- !The first known gun and the first known finite pattern with unbounded growth.
	-- !www.conwaylife.com/wiki/index.php?title=Gosper_glider_gun
	-- ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
	-- ........................O...........
	-- ......................O.O...........
	-- ............OO......OO............OO
	-- ...........O...O....OO............OO
	-- OO........O.....O...OO..............
	-- OO........O...O.OO....O.O...........
	-- ..........O.....O.......O...........
	-- ...........O...O....................
	-- ............OO......................
	-- ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

	constant memory_content : MEMORY :=
	(
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000010000000"),
		("00000000000000000000001010000000"),
		("00000000000011000000110000000000"),
		("00000000000100010000110000000000"),
		("11000000001000001000110000000000"),
		("11000000001000101100001010000000"),
		("00000000001000001000000010000000"),
		("00000000000100010000000000000000"),
		("00000000000011000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000")
	);

end p_memory_content;

package body p_memory_content is
end p_memory_content;
