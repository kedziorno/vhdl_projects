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

entity sine_unsigned0to255 is
Generic (
N : integer := 8;
M : integer := 5_000_000
);
Port (
i_clock : in  STD_LOGIC;
i_reset : in  STD_LOGIC;
o_ladder : out  STD_LOGIC_VECTOR(N-1 downto 0)
);
end sine_unsigned0to255;

architecture Behavioral of sine_unsigned0to255 is
	constant PROBES : integer := 256;
	type trom is array (0 to PROBES-1) of integer range 0 to 255;
	constant rom : trom := (
128,145,162,178,193,207,220,231,240,247,252,255,255,253,249,243,234,223,211,197,182,166,149,132,115,98,81,66,51,38,27,17,9,4,0,0,1,5,10,19,29,40,54,69,84,101,118,135,152,169,185,200,213,225,236,244,250,254,255,255,252,246,239,229,218,205,191,175,159,142,124,107,90,74,59,45,33,22,13,6,2,0,0,2,7,14,23,34,46,60,76,92,109,126,143,160,176,192,206,219,230,240,247,252,255,255,254,250,243,235,224,212,199,184,168,151,134,117,99,83,67,53,39,28,18,10,4,1,0,1,4,10,18,28,39,53,67,83,99,117,134,151,168,184,199,212,224,235,243,250,254,255,255,252,247,240,230,219,206,192,176,160,143,126,109,92,76,60,46,34,23,14,7,2,0,0,2,6,13,22,33,45,59,74,90,107,124,142,159,175,191,205,218,229,239,246,252,255,255,254,250,244,236,225,213,200,185,169,152,135,118,101,84,69,54,40,29,19,10,5,1,0,0,4,9,17,27,38,51,66,81,98,115,132,149,166,182,197,211,223,234,243,249,253,255,255,252,247,240,231,220,207,193,178,162,145
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
	begin
		if (i_reset = '1') then
			count := 0;
			o_ladder <= (others => '0');
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
