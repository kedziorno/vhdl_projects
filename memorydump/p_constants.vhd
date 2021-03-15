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

package p_constants is
	constant G_BOARD_CLOCK : integer := 50_000_000;
	constant NUMBER_BITS : integer := 8;
	constant G_MemoryAddress : integer := 5;
	constant G_MemoryData : integer := NUMBER_BITS;
	subtype MemoryAddress is std_logic_vector(1 to G_MemoryAddress-1);
	subtype MemoryAddressALL is std_logic_vector(0 to G_MemoryAddress-1);
	subtype MemoryDataByte is std_logic_vector(0 to G_MemoryData-1);
--	constant FIFO_WIDTH : integer := NUMBER_BITS;
--	constant FIFO_HEIGHT : integer := 1;
--	constant G_BAUD_RATE : integer := 115200;
--	constant G_BAUD_RATE : integer := 38400;
--	constant G_BAUD_RATE : integer := 19200;
--	constant G_BAUD_RATE : integer := 9600;
	constant G_BAUD_RATE : integer := 300;
	constant G_BR_OVERSAMPLING : integer := 16;
	constant G_PARITY : integer := 0;
	constant G_PARITY_EO : std_logic := '0'; -- even/odd
end p_constants;

package body p_constants is
end p_constants;
