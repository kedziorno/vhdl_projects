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
	constant G_BOARD_CLOCK : integer := 5_000_000;
	constant G_BAUD_RATE : integer := 300;
end p_constants;

package body p_constants is
end p_constants;
