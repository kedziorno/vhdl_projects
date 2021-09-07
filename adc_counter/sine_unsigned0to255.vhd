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
N : integer := 12;
M : integer := 5_000_000
);
Port (
i_clock : in  STD_LOGIC;
i_reset : in  STD_LOGIC;
io_ladder : out  STD_LOGIC_VECTOR(N-1 downto 0)
);
end sine_unsigned0to255;

architecture Behavioral of sine_unsigned0to255 is
	constant PROBES : integer := 255;
	type trom is array (0 to PROBES-1) of integer range 0 to 4095;
	constant rom : trom := (
2047,2097,2147,2197,2248,2298,2347,2397,2447,2496,2545,2594,2642,2690,2737,2785,2831,2878,2923,2969,3013,3057,3101,3144,3186,3227,3268,3308,3347,3386,3423,3460,3496,3531,3565,3599,3631,3662,3693,3722,3751,3778,3804,3830,3854,3877,3899,3920,3939,3958,3975,3992,4007,4021,4033,4045,4055,4064,4072,4079,4084,4088,4091,4093,4093,4093,4091,4087,4083,4077,4070,4062,4053,4042,4030,4017,4003,3988,3971,3954,3935,3915,3894,3871,3848,3823,3798,3771,3744,3715,3685,3655,3623,3591,3557,3523,3487,3451,3414,3376,3337,3298,3258,3217,3175,3133,3090,3046,3002,2957,2912,2866,2820,2773,2726,2678,2630,2581,2533,2484,2434,2385,2335,2285,2235,2185,2135,2084,2034,1984,1933,1883,1833,1783,1733,1683,1634,1585,1536,1487,1439,1391,1344,1297,1250,1204,1158,1113,1069,1025,982,939,897,856,815,775,736,698,660,624,588,553,519,486,454,423,393,364,335,308,282,257,233,210,189,168,149,130,113,97,83,69,57,45,35,27,19,13,8,4,1,0,0,1,3,7,11,17,25,33,43,54,66,79,94,109,126,144,163,184,205,227,251,276,302,328,356,385,415,446,478,511,545,579,615,651,688,726,765,805,845,886,928,971,1014,1058,1102,1147,1193,1239,1285,1332,1379,1427,1475,1524,1573,1622,1671,1721,1770,1820,1871,1921,1971
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
			io_ladder <= (others => '0');
		elsif (rising_edge(clock_divider)) then
			io_ladder <= std_logic_vector(to_unsigned(rom(count),N));
			if (count = PROBES-1) then
				count := 0;
			else
				count := count + 1;
			end if;
		end if;
	end process p1;
end Behavioral;
