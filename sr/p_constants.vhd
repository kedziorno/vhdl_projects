library IEEE;
use IEEE.STD_LOGIC_1164.all;

package p_constants is
	constant G_BOARD_CLOCK : integer := 50_000_000; -- nexys 2
--	constant G_BOARD_CLOCK : integer := 8_000_000; -- basys 2
	constant G_LCD_CLOCK_DIVIDER : integer := 200;
	constant G_BCD_BITS : integer := 10;
	constant G_BCD_DIGITS : integer := 3;
end p_constants;

package body p_constants is
end p_constants;
