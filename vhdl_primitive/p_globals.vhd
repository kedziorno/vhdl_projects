library IEEE;
use IEEE.STD_LOGIC_1164.all;

package p_globals is

	-- https://stackoverflow.com/a/21784274
	-- Returns number of bits required to represent val in binary vector
	function bits_req(val : natural) return natural;

	constant G_CLOCK1 : integer := 50_000_000; -- XXX main clock
	constant G_OSC1 : integer := 29_952_000; -- XXX osc on socket
	constant G_OSC2 : integer := 23_961_600; -- XXX osc on socket
	constant G_OSC3 : integer := 1_000_000; -- XXX for sim
	constant G_BOARD_CLOCK : integer := G_CLOCK1; -- XXX osc on board
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
	constant G_DEBOUNCE_SPEED_X : integer := 1;
	constant G_DEBOUNCE_MS : integer := 50/G_DEBOUNCE_SPEED_X;
	constant G_DEBOUNCE_DIV : integer := 2*G_DEBOUNCE_SPEED_X;
--	constant G_DEBOUNCE_MS_COUNT : integer := integer(real((G_DEBOUNCE_MS * 1000 * 1000)/(1_000_000_000/G_BOARD_CLOCK)));
--	constant G_DEBOUNCE_MS_COUNT : integer := integer(real((0.001*real(G_DEBOUNCE_MS)))/real(1/G_BOARD_CLOCK));
--	constant G_DEBOUNCE_MS_COUNT : integer := 14976000/G_DEBOUNCE_DIV; -- XXX for 100ms,0.001*50/(1/29952000)
--	constant G_DEBOUNCE_MS_COUNT : integer := 299520/G_DEBOUNCE_DIV; -- XXX for sim 10ms,0.001*10/(1/29952000)
--	constant G_DEBOUNCE_MS_COUNT : integer := 299520/1; -- XXX for syn 10ms,0.001*10/(1/29952000)
	constant G_DEBOUNCE_MS_COUNT : integer := 50000; -- XXX 0.001*50/(1/1000000)
	constant G_DEBOUNCE_MS_BITS : integer := bits_req(G_DEBOUNCE_MS_COUNT);

end p_globals;

package body p_globals is

	-- https://stackoverflow.com/a/21784274
	-- Returns number of bits required to represent val in binary vector
	function bits_req(val : natural) return natural is
		variable res_v    : natural;  -- Result
		variable remain_v : natural;  -- Remainder used in iteration
	begin
		res_v := 0;
		remain_v := val;
		while remain_v > 0 loop  -- Iteration for each bit required
			res_v := res_v + 1;
			remain_v := remain_v / 2;
		end loop;
		return res_v;
	end function;

end p_globals;

