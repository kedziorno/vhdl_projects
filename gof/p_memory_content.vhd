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
	constant ROWS : integer := 128; --16; --128;
--	constant ROWS_BITS : integer := 7; --7;
	constant COLS_PIXEL : integer := 160; --32; --160;
--	constant COLS_PIXEL_BITS : integer := 9; --5;
--	constant COLS_BLOCK : integer := 4;
--	constant COLS_BLOCK_BITS : integer := 2;
	constant BYTE_BITS : integer := 8;
--	constant WORD_BITS : integer := COLS_BLOCK*BYTE_BITS;
--	constant PARITY_BITS : integer := 4;
--	constant BRAM_ADDRESS_BITS : integer := 9;
	constant G_MemoryAddress : integer := 24;
	constant G_MemoryData : integer := 16;
	subtype MemoryAddress is std_logic_vector(G_MemoryAddress-1 downto 1);
	subtype MemoryDataByte is std_logic_vector(G_MemoryData-1 downto 0);

	subtype WORD is std_logic_vector(COLS_PIXEL-1 downto 0);
	type MEMORY is array(ROWS-1 downto 0) of WORD;

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

--	constant memory_content : MEMORY :=
--	(
--		("11111111111111111111111111111111"), -- XXX 1 pattern is in LA
--		("10000000000000000000000000000001"), -- XXX a.a.
--		("10000000000000000000000010000001"),
--		("10000000000000000000001010000001"),
--		("10000000000011000000110000000001"),
--		("10000000000100010000110000000001"),
--		("11000000001000001000110000000001"),
--		("11000000001000101100001010000001"),
--		("10000000001000001000000010000001"),
--		("10000000000100010000000000000001"),
--		("10000000000011000000000000000001"),
--		("10000000000000000000000000000001"),
--		("10000000000000000000000000000001"),
--		("10000000000000000000000000000001"),
--		("10000000000000000000000000000001"),
--		("11111111111111111111111111111111")
--	);

	constant memory_content : MEMORY :=
	(
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111"), -- XXX 1 pattern is in LA
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111"), -- XXX a.a.
		("0000000000000000000000001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000000000000"),
		("0000000000000000000000101000000000000000000000000000001010000000000000000000000000000010100000000000000000000000000000101000000000000000000000000000000000000000"),
		("0000000000001100000011000000000000000000000011000000110000000000000000000000110000001100000000000000000000001100000011000000000000000000000000000000000000000000"),
		("0000000000010001000011000000000000000000000100010000110000000000000000000001000100001100000000000000000000010001000011000000000000000000000000000000000000000000"),
		("1100000000100000100011000000000011000000001000001000110000000000110000000010000010001100000000001100000000100000100011000000000000000000000000000000000000000000"),
		("1100000000100010110000101000000011000000001000101100001010000000110000000010001011000010100000001100000000100010110000101000000000000000000000000000000000000000"),
		("0000000000100000100000001000000000000000001000001000000010000000000000000010000010000000100000000000000000100000100000001000000000000000000000000000000000000000"),
		("0000000000010001000000000000000000000000000100010000000000000000000000000001000100000000000000000000000000010001000000000000000000000000000000000000000000000000"),
		("0000000000001100000000000000000000000000000011000000000000000000000000000000110000000000000000000000000000001100000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000000000000"),
		("0000000000000000000000101000000000000000000000000000001010000000000000000000000000000010100000000000000000000000000000101000000000000000000000000000000000000000"),
		("0000000000001100000011000000000000000000000011000000110000000000000000000000110000001100000000000000000000001100000011000000000000000000000000000000000000000000"),
		("0000000000010001000011000000000000000000000100010000110000000000000000000001000100001100000000000000000000010001000011000000000000000000000000000000000000000000"),
		("1100000000100000100011000000000011000000001000001000110000000000110000000010000010001100000000001100000000100000100011000000000000000000000000000000000000000000"),
		("1100000000100010110000101000000011000000001000101100001010000000110000000010001011000010100000001100000000100010110000101000000000000000000000000000000000000000"),
		("0000000000100000100000001000000000000000001000001000000010000000000000000010000010000000100000000000000000100000100000001000000000000000000000000000000000000000"),
		("0000000000010001000000000000000000000000000100010000000000000000000000000001000100000000000000000000000000010001000000000000000000000000000000000000000000000000"),
		("0000000000001100000000000000000000000000000011000000000000000000000000000000110000000000000000000000000000001100000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000000000000"),
		("0000000000000000000000101000000000000000000000000000001010000000000000000000000000000010100000000000000000000000000000101000000000000000000000000000000000000000"),
		("0000000000001100000011000000000000000000000011000000110000000000000000000000110000001100000000000000000000001100000011000000000000000000000000000000000000000000"),
		("0000000000010001000011000000000000000000000100010000110000000000000000000001000100001100000000000000000000010001000011000000000000000000000000000000000000000000"),
		("1100000000100000100011000000000011000000001000001000110000000000110000000010000010001100000000001100000000100000100011000000000000000000000000000000000000000000"),
		("1100000000100010110000101000000011000000001000101100001010000000110000000010001011000010100000001100000000100010110000101000000000000000000000000000000000000000"),
		("0000000000100000100000001000000000000000001000001000000010000000000000000010000010000000100000000000000000100000100000001000000000000000000000000000000000000000"),
		("0000000000010001000000000000000000000000000100010000000000000000000000000001000100000000000000000000000000010001000000000000000000000000000000000000000000000000"),
		("0000000000001100000000000000000000000000000011000000000000000000000000000000110000000000000000000000000000001100000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000000000000"),
		("0000000000000000000000101000000000000000000000000000001010000000000000000000000000000010100000000000000000000000000000101000000000000000000000000000000000000000"),
		("0000000000001100000011000000000000000000000011000000110000000000000000000000110000001100000000000000000000001100000011000000000000000000000000000000000000000000"),
		("0000000000010001000011000000000000000000000100010000110000000000000000000001000100001100000000000000000000010001000011000000000000000000000000000000000000000000"),
		("1100000000100000100011000000000011000000001000001000110000000000110000000010000010001100000000001100000000100000100011000000000000000000000000000000000000000000"),
		("1100000000100010110000101000000011000000001000101100001010000000110000000010001011000010100000001100000000100010110000101000000000000000000000000000000000000000"),
		("0000000000100000100000001000000000000000001000001000000010000000000000000010000010000000100000000000000000100000100000001000000000000000000000000000000000000000"),
		("0000000000010001000000000000000000000000000100010000000000000000000000000001000100000000000000000000000000010001000000000000000000000000000000000000000000000000"),
		("0000000000001100000000000000000000000000000011000000000000000000000000000000110000000000000000000000000000001100000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000000000000"),
		("0000000000000000000000101000000000000000000000000000001010000000000000000000000000000010100000000000000000000000000000101000000000000000000000000000000000000000"),
		("0000000000001100000011000000000000000000000011000000110000000000000000000000110000001100000000000000000000001100000011000000000000000000000000000000000000000000"),
		("0000000000010001000011000000000000000000000100010000110000000000000000000001000100001100000000000000000000010001000011000000000000000000000000000000000000000000"),
		("1100000000100000100011000000000011000000001000001000110000000000110000000010000010001100000000001100000000100000100011000000000000000000000000000000000000000000"),
		("1100000000100010110000101000000011000000001000101100001010000000110000000010001011000010100000001100000000100010110000101000000000000000000000000000000000000000"),
		("0000000000100000100000001000000000000000001000001000000010000000000000000010000010000000100000000000000000100000100000001000000000000000000000000000000000000000"),
		("0000000000010001000000000000000000000000000100010000000000000000000000000001000100000000000000000000000000010001000000000000000000000000000000000000000000000000"),
		("0000000000001100000000000000000000000000000011000000000000000000000000000000110000000000000000000000000000001100000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000000000000"),
		("0000000000000000000000101000000000000000000000000000001010000000000000000000000000000010100000000000000000000000000000101000000000000000000000000000000000000000"),
		("0000000000001100000011000000000000000000000011000000110000000000000000000000110000001100000000000000000000001100000011000000000000000000000000000000000000000000"),
		("0000000000010001000011000000000000000000000100010000110000000000000000000001000100001100000000000000000000010001000011000000000000000000000000000000000000000000"),
		("1100000000100000100011000000000011000000001000001000110000000000110000000010000010001100000000001100000000100000100011000000000000000000000000000000000000000000"),
		("1100000000100010110000101000000011000000001000101100001010000000110000000010001011000010100000001100000000100010110000101000000000000000000000000000000000000000"),
		("0000000000100000100000001000000000000000001000001000000010000000000000000010000010000000100000000000000000100000100000001000000000000000000000000000000000000000"),
		("0000000000010001000000000000000000000000000100010000000000000000000000000001000100000000000000000000000000010001000000000000000000000000000000000000000000000000"),
		("0000000000001100000000000000000000000000000011000000000000000000000000000000110000000000000000000000000000001100000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000000000000"),
		("0000000000000000000000101000000000000000000000000000001010000000000000000000000000000010100000000000000000000000000000101000000000000000000000000000000000000000"),
		("0000000000001100000011000000000000000000000011000000110000000000000000000000110000001100000000000000000000001100000011000000000000000000000000000000000000000000"),
		("0000000000010001000011000000000000000000000100010000110000000000000000000001000100001100000000000000000000010001000011000000000000000000000000000000000000000000"),
		("1100000000100000100011000000000011000000001000001000110000000000110000000010000010001100000000001100000000100000100011000000000000000000000000000000000000000000"),
		("1100000000100010110000101000000011000000001000101100001010000000110000000010001011000010100000001100000000100010110000101000000000000000000000000000000000000000"),
		("0000000000100000100000001000000000000000001000001000000010000000000000000010000010000000100000000000000000100000100000001000000000000000000000000000000000000000"),
		("0000000000010001000000000000000000000000000100010000000000000000000000000001000100000000000000000000000000010001000000000000000000000000000000000000000000000000"),
		("0000000000001100000000000000000000000000000011000000000000000000000000000000110000000000000000000000000000001100000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000000000000"),
		("0000000000000000000000101000000000000000000000000000001010000000000000000000000000000010100000000000000000000000000000101000000000000000000000000000000000000000"),
		("0000000000001100000011000000000000000000000011000000110000000000000000000000110000001100000000000000000000001100000011000000000000000000000000000000000000000000"),
		("0000000000010001000011000000000000000000000100010000110000000000000000000001000100001100000000000000000000010001000011000000000000000000000000000000000000000000"),
		("1100000000100000100011000000000011000000001000001000110000000000110000000010000010001100000000001100000000100000100011000000000000000000000000000000000000000000"),
		("1100000000100010110000101000000011000000001000101100001010000000110000000010001011000010100000001100000000100010110000101000000000000000000000000000000000000000"),
		("0000000000100000100000001000000000000000001000001000000010000000000000000010000010000000100000000000000000100000100000001000000000000000000000000000000000000000"),
		("0000000000010001000000000000000000000000000100010000000000000000000000000001000100000000000000000000000000010001000000000000000000000000000000000000000000000000"),
		("0000000000001100000000000000000000000000000011000000000000000000000000000000110000000000000000000000000000001100000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
		("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
	);

end p_memory_content;

package body p_memory_content is
end p_memory_content;
