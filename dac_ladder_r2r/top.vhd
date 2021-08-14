----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:43:44 08/13/2021 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Generic (
N : integer := 8;
M : integer := 500_000
);
Port (
i_clock : in  STD_LOGIC;
i_reset : in  STD_LOGIC;
o_ladder : out  STD_LOGIC_VECTOR(N-1 downto 0)
);
end top;

architecture Behavioral of top is
	constant PROBES : integer := 255;
	type trom is array (0 to PROBES-1) of integer range -128 to 127;
	constant rom : trom := (
17,34,50,65,79,92,103,112,119,124,127,127,125,121,115,106,95,83,69,54,38,21,4,-13,-30,-47,-62,-77,-90,-101,-111,-119,-124,-128,-128,-127,-123,-118,-109,-99,-88,-74,-59,-44,-27,-10,7,24,41,57,72,85,97,108,116,122,126,127,127,124,118,111,101,90,77,63,47,31,14,-4,-21,-38,-54,-69,-83,-95,-106,-115,-122,-126,-128,-128,-126,-121,-114,-105,-94,-82,-68,-52,-36,-19,-2,15,32,48,64,78,91,102,112,119,124,127,127,126,122,115,107,96,84,71,56,40,23,6,-11,-29,-45,-61,-75,-89,-100,-110,-118,-124,-127,-128,-127,-124,-118,-110,-100,-89,-75,-61,-45,-29,-11,6,23,40,56,71,84,96,107,115,122,126,127,127,124,119,112,102,91,78,64,48,32,15,-2,-19,-36,-52,-68,-82,-94,-105,-114,-121,-126,-128,-128,-126,-122,-115,-106,-95,-83,-69,-54,-38,-21,-4,14,31,47,63,77,90,101,111,118,124,127,127,126,122,116,108,97,85,72,57,41,24,7,-10,-27,-44,-59,-74,-88,-99,-109,-118,-123,-127,-128,-128,-124,-119,-111,-101,-90,-77,-62,-47,-30,-13,4,21,38,54,69,83,95,106,115,121,125,127,127,124,119,112,103,92,79,65,50,34,17
	);
	signal clock_divider : std_logic;
begin
	p0 : process (i_clock,i_reset) is
		constant ccount : integer := M;
		variable count : integer range 0 to ccount-1;
	begin
		if (i_reset = '1') then
			count := 0;
			clock_divider <= '0';
		elsif (rising_edge(i_clock)) then
			if (count = ccount-1) then
				clock_divider <= '1';
				count := 0;
			else
				clock_divider <= '0';
				count := count + 1;
			end if;
		end if;
	end process p0;
	p1 : process (clock_divider,i_reset) is
		variable count : integer range 0 to PROBES-1;
		variable item : signed(7 downto 0);
	begin
		if (i_reset = '1') then
			count := 0;
			o_ladder <= (others => '0');
			item := (others => '0');
		elsif (rising_edge(clock_divider)) then
			o_ladder <= std_logic_vector(to_signed(rom(count),8));
--			o_ladder <= std_logic_vector(to_unsigned(count,8));
			if (count = PROBES-1) then
				count := 0;
			else
				count := count + 1;
			end if;
		end if;
	end process p1;
end Behavioral;
