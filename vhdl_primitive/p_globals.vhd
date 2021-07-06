library IEEE;
use IEEE.STD_LOGIC_1164.all;

package p_globals is

	constant G_CLOCK1 : integer := 50_000_000; -- XXX main clock
	constant G_OSC1 : integer := 29_952_000; -- XXX osc on socket
	constant G_OSC2 : integer := 23_961_600; -- XXX osc on socket
	constant G_BOARD_CLOCK : integer := G_OSC1; -- XXX osc on board
	constant G_LCDSegment : integer := 7;
	constant G_LCDAnode : integer := 4;
	constant G_LCDClockDivider : integer := 200;
	constant G_MemoryAddress : integer := 24;
	constant G_MemoryData : integer := 16;
	constant G_Switch : integer := 8;
	constant G_Button : integer := 4;
	constant G_Led : integer := 8;
	constant G_HalfHex : integer := 4;
	constant G_FullHex : integer := G_HalfHex*2;
	constant G_DEBOUNCE_MS : integer := 50;
	constant G_DEBOUNCE_MS_COUNT : integer := integer(real((G_DEBOUNCE_MS * 1000 * 1000)/(1_000_000_000/G_BOARD_CLOCK)));

end p_globals;

package body p_globals is
end p_globals;

