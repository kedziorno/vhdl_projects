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
	constant ROWS : integer := 16; --128;
	constant ROWS_BITS : integer := 4; --7;
	constant COLS_PIXEL : integer := 16; --32;
	constant COLS_PIXEL_BITS : integer := 4; --5;
	constant COLS_BLOCK : integer := 2;
	constant COLS_BLOCK_BITS : integer := 1;
	constant BYTE_BITS : integer := 8;
	constant WORD_BITS : integer := COLS_BLOCK*BYTE_BITS;
	
	subtype WORD is std_logic_vector(WORD_BITS-1 downto 0);
	type MEMORY is array(ROWS-1 downto 0) of WORD;
	
	type LiveSubArray is array(0 to WORD_BITS-1) of std_logic_vector(2 downto 0);
	type LiveArrayType is array(0 to ROWS-1) of LiveSubArray;
	
	constant memory_content : MEMORY :=
	(
		("1111111111111111"), -- F
		("1001000000001001"),
		("1001000000001001"),
		("1001000110001001"),
		("1000000110000001"),
		("1000000110000001"),
		("1001110110111001"),
		("1011100000011101"), -- 8
		("1000000110000001"), -- 7
		("1000000110000001"),
		("1011000110001101"),
		("1011000110001101"),
		("1000110000110001"),
		("1000110000110001"),
		("1000000000000001"), -- 1
		("1111111111111111")  -- 0
	);
	
--	constant memory_content : MEMORY :=
--	(
--		--3       2       1       0      0
--		--1       3       5       7      0
--		("11111111111100000000000000000000"), -- 127
--		("11000000000100000000000000000000"),
--		("10100000000100000000000000000000"),
--		("10010000000100000000000000000000"),
--		("10001000000100000000000000000000"),
--		("10000100000100000000000000000000"), -- 122
--		("10000010000100000000000000000000"),
--		("10000001000100000000000000000000"),
--		("10000000100100000000000000000000"),
--		("10000000010100000000000000000000"),
--		("10000000001100000000000000000000"), -- 117
--		("11111111111100000000000000000000"),
--		("00000000000010000000000000000000"),
--		("00000000000001000000000000000000"),
--		("00000000000000100000000000000000"),
--		("00000000000000010000000000000000"), -- 112
--		("00000000000000001000000000000000"),
--		("00000000000000000100000000000000"),
--		("00000000000000000010000000000000"),
--		("00000000000000000001000000000000"),
--		("00000000000000000000100000000000"), -- 107
--		("00000000000000000000010000000000"),
--		("00000000000000000000001000000000"),
--		("00000000000000000000000100000000"),
--		("00000000000000000000000010000000"),
--		("00000000000000000000000001000000"), -- 102
--		("00000000000000000000000000100000"),
--		("00000000000000000000000000010000"),
--		("00000000000000000000000000001000"),
--		("00000000000000000000000000000100"),
--		("00000000000000000000000000000010"));		-- 97
--		("00000000000000000000000000000001"),
--		("00000000000000000000000000000010"),
--		("00000000000000000000000000000100"),
--		("00000000000000000000000000001000"),
--		("00000000000000000000000000010000"), -- 92
--		("00000000000000000000000000100000"),
--		("00000000000000000000000001000000"),
--		("00000000000000000000000010000000"),
--		("00000000000000000000000100000000"),
--		("00000000000000000000001000000000"), -- 87
--		("00000000000000000000010000000000"),
--		("00000000000000000000100000000000"),
--		("00000000000000000001000000000000"),
--		("00000000000000000010000000000000"),
--		("00000000000000000100000000000000"), -- 82
--		("00000000000000001000000000000000"),
--		("00000000000000010000000000000000"),
--		("00000000000000100000000000000000"),
--		("00000000000001000000000000000000"),
--		("00000000000010000000000000000000"), -- 77
--		("00000000000100000000000000000000"),
--		("00000000001000000000000000000000"),
--		("00000000010000000000000000000000"),
--		("00000000100000000000000000000000"),
--		("00000001000000000000000000000000"), -- 72
--		("00000010000000000000000000000000"),
--		("00000100000000000000000000000000"),
--		("00001000000000000000000000000000"),
--		("00010000000000000000000000000000"),
--		("00100000000000000000000000000000"), -- 67
--		("01000000000000000000000000000000"),
--		("10000000000000000000000000000000"),
--		("01000000000000000000000000000000"),
--		("00100000000000000000000000000000"),
--		("00010000000000000000000000000000"), -- 62
--		("00001000000000000000000000000000"),
--		("00000100000000000000000000000000"),
--		("00000010000000000000000000000000"),
--		("00000001000000000000000000000000"),
--		("00000000100000000000000000000000"), -- 57
--		("00000000010000000000000000000000"),
--		("00000000001000000000000000000000"),
--		("00000000000100000000000000000000"),
--		("00000000000010000000000000000000"),
--		("00000000000001000000000000000000"), -- 52
--		("00000000000000100000000000000000"),
--		("00000000000000010000000000000000"),
--		("00000000000000001000000000000000"),
--		("00000000000000000100000000000000"),
--		("00000000000000000010000000000000"), -- 47
--		("00000000000000000001000000000000"),
--		("00000000000000000000100000000000"),
--		("00000000000000000000010000000000"),
--		("00000000000000000000001000000000"),
--		("00000000000000000000000100000000"), -- 42
--		("00000000000000000000000010000000"),
--		("00000000000000000000000001000000"),
--		("00000000000000000000000000100000"),
--		("00000000000000000000000000010000"),
--		("00000000000000000000000000001000"), -- 37
--		("00000000000000000000000000000100"),
--		("00000000000000000000000000000010"),
--		("00000000000000000000000000000001"),
--		("00000000000000000000000000000010"),
--		("00000000000000000000000000000100"), -- 32
--		("00000000000000000000000000001000"),
--		("00000000000000000000000000010000"),
--		("00000000000000000000000000100000"),
--		("00000000000000000000000001000000"),
--		("00000000000000000000000010000000"), -- 27
--		("00000000000000000000000100000000"),
--		("00000000000000000000001000000000"),
--		("00000000000000000000010000000000"),
--		("00000000000000000000100000000000"),
--		("00000000000000000001000000000000"), -- 22
--		("00000000000000000010000000000000"),
--		("00000000000000000100000000000000"),
--		("00000000000000001000000000000000"),
--		("00000000000000010000000000000000"),
--		("00000000000000100000000000000000"), -- 17
--		("00000000000001000000000000000000"),
--		("00000000000010000000000000000000"),
--		("00000000000100000000000000000000"),
--		("00000000001000000000000000000000"),
--		("00000000010000000000000000000000"), -- 12
--		("00000000100000000000000000000000"),
--		("00000001000000000000000000000000"),
--		("00000010000000000000000000000000"),
--		("00000100000000000000000000000000"),
--		("00001000000000000000000000000000"), -- 7
--		("00010000000000000000000000000000"),
--		("00100000000000000000000000000000"),
--		("01000000000000000000000000000000"),
--		("10000000000000000000000000000000"),
--		("01000000000000000000000000000000"), -- 2
--		("00100000000000000000000000000000"),
--		("00011111111000000000000000000000")  -- 0
--		--3       2       1       0      0
--		--1       3       5       7      0
--		);

end p_memory_content;

package body p_memory_content is
end p_memory_content;
