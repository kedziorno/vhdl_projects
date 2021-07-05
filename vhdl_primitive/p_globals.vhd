library IEEE;
use IEEE.STD_LOGIC_1164.all;

package p_globals is

	constant G_BOARD_CLOCK : integer := 50_000_000; -- XXX osc on board
	constant G_SOCKET_CLOCK : integer := 29_952_000; -- XXX osc on socket
	constant G_LCDSegment : integer := 7;
	constant G_LCDAnode : integer := 4;
	constant G_LCDClockDivider : integer := 400;
	constant G_MemoryAddress : integer := 24;
	constant G_MemoryData : integer := 16;
	constant G_Switch : integer := 8;
	constant G_Button : integer := 4;
	constant G_Led : integer := 8;
	constant G_HalfHex : integer := 4;
	constant G_FullHex : integer := G_HalfHex*2;

end p_globals;

package body p_globals is
end p_globals;

