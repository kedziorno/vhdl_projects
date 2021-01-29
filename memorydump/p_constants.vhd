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
	constant FIFO_WIDTH : integer := NUMBER_BITS;
	constant FIFO_HEIGHT : integer := 5;
end p_constants;

package body p_constants is
end p_constants;
