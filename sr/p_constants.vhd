library IEEE;
use IEEE.STD_LOGIC_1164.all;

package p_constants is
	constant G_BOARD_CLOCK : integer := 1_000_000_000; -- 1 GHZ , 1 ns
--	constant G_BOARD_CLOCK : integer := 50_000_000; -- nexys 2
--	constant G_BOARD_CLOCK : integer := 8_000_000; -- basys 2
	constant G_LCD_CLOCK_DIVIDER : integer := 200;
	constant G_BCD_BITS : integer := 16;
	constant G_BCD_DIGITS : integer := 4;
end p_constants;

package body p_constants is
end p_constants;
