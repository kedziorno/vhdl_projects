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
	constant PROBES : integer := 256;
	type trom is array (0 to PROBES-1) of integer range 0 to 255;
	constant rom : trom := (
	128,131,134,137,140,143,146,149,
	152,156,159,162,165,168,171,174,
	176,179,182,185,188,191,193,196,
	199,201,204,206,209,211,213,216,
	218,220,222,224,226,228,230,232,
	234,235,237,239,240,242,243,244,
	246,247,248,249,250,251,251,252,
	253,253,254,254,254,255,255,255,
	255,255,255,255,254,254,253,253,
	252,252,251,250,249,248,247,246,
	245,244,242,241,239,238,236,235,
	233,231,229,227,225,223,221,219,
	217,215,212,210,207,205,202,200,
	197,195,192,189,186,184,181,178,
	175,172,169,166,163,160,157,154,
	151,148,145,142,138,135,132,129,
	126,123,120,117,113,110,107,104,
	101,98,95,92,89,86,83,80,
	77,74,71,69,66,63,60,58,
	55,53,50,48,45,43,40,38,
	36,34,32,30,28,26,24,22,
	20,19,17,16,14,13,11,10,
	9,8,7,6,5,4,3,3,
	2,2,1,1,0,0,0,0,
	0,0,0,1,1,1,2,2,
	3,4,4,5,6,7,8,9,
	11,12,13,15,16,18,20,21,
	23,25,27,29,31,33,35,37,
	39,42,44,46,49,51,54,56,
	59,62,64,67,70,73,76,79,
	81,84,87,90,93,96,99,103,
	106,109,112,115,118,121,124,128
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
		variable item : unsigned(7 downto 0);
	begin
		if (i_reset = '1') then
			count := 0;
			o_ladder <= (others => '0');
			item := (others => '0');
		elsif (rising_edge(clock_divider)) then
			o_ladder <= std_logic_vector(to_unsigned(rom(count),8));
			if (count = PROBES-1) then
				count := 0;
			else
				count := count + 1;
			end if;
		end if;
	end process p1;
end Behavioral;
