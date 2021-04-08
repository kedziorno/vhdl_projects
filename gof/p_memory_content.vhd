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
	constant G_MemoryAddress : integer := 3;
	constant G_MemoryData : integer := 16;
	subtype MemoryAddress is std_logic_vector(0 to G_MemoryAddress-1);
	subtype MemoryAddressALL is std_logic_vector(0 to G_MemoryAddress-1);
	subtype MemoryDataByte is std_logic_vector(0 to G_MemoryData-1);
	constant G_HalfHex : integer := 4;
	constant G_FullHex : integer := G_HalfHex*2;
	constant ROWS : integer := (2**G_MemoryAddress);
	constant ROWS_BITS : integer := G_MemoryAddress;
	constant COLS_PIXEL : integer := 32;
	constant COLS_PIXEL_BITS : integer := 5;
	constant COLS_BLOCK : integer := 4;
	constant COLS_BLOCK_BITS : integer := 2;
	constant BYTE_BITS : integer := 8;
	constant WORD_BITS : integer := COLS_BLOCK*BYTE_BITS;
	constant G_LCDSegment : integer := 7;
	constant G_LCDAnode : integer := 4;
	constant G_LCDClockDivider : integer := 200;
	constant G_Button : integer := 4;
	constant G_Led : integer := 8;
	type LCDHex is array(G_LCDAnode-1 downto 0) of std_logic_vector(G_HalfHex-1 downto 0);
	subtype WORD is std_logic_vector(0 to WORD_BITS-1);
	type MEMORY is array(0 to ROWS-1) of WORD;
	type LiveSubArray is array(WORD_BITS-1 downto 0) of std_logic_vector(2 downto 0);
	type LiveArrayType is array(ROWS-1 downto 0) of LiveSubArray;

	constant memory_content : MEMORY :=
	( --  f              0f              0
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000000"),
		("00000000000000000000000000000001")
	);
	
--constant memory_content : MEMORY :=
--	( -- f              0f              0
--		("11111111111111111111111111111111"), -- F
--		("10010000000010011001000000001001"),
--		("10010000000010011001000000001001"),
--		("10010001100010011001000110001001"),
--		("10000001100000011000000110000001"),
--		("10000001100000011000000110000001"),
--		("10011101101110011001110110111001"),
--		("10111000000111011011100000011101"), -- 8
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000"),
--		("00000000000000000000000000000000")
--	);
end p_memory_content;

package body p_memory_content is
end p_memory_content;
