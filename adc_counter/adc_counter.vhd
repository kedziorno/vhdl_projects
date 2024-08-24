----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:47:54 05/07/2021 
-- Design Name: 
-- Module Name:    sar_adc - Behavioral 
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
use WORK.p_globals.ALL;
use WORK.p_lcd_display.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity adc_counter is
Generic (
G_BOARD_CLOCK : integer := G_BOARD_CLOCK;
data_size : integer := 12
);
Port (
i_clock : in std_logic;
i_reset : in std_logic;
i_from_comparator : in std_logic;
io_ladder : out std_logic_vector(data_size-1 downto 0);
o_anode : out std_logic_vector(G_LCDAnode-1 downto 0);
o_segment : out std_logic_vector(G_LCDSegment-1 downto 0);
o_eoc : out std_logic
);
end adc_counter;

architecture Behavioral of adc_counter is

component lcd_display is
Generic (
LCDClockDivider : integer := G_LCDClockDivider -- XXX in ms
);
Port (
i_clock : in std_logic;
i_LCDChar : LCDHex;
o_anode : out std_logic_vector(G_LCDAnode-1 downto 0);
o_segment : out std_logic_vector(G_LCDSegment-1 downto 0)
);
end component lcd_display;

signal divclock : std_logic;
signal LCDChar : LCDHex;

begin

p_clockdivider : process (i_clock,i_reset) is
	constant count_max : integer := G_BOARD_CLOCK/1000;
	variable count : integer range 0 to count_max-1 := 0;
begin
	if (i_reset = '1') then
		count := 0;
		divclock <= '0';
	elsif (rising_edge(i_clock)) then
		if (count = count_max-1) then
			count := 0;
			divclock <= '1';
		else
			count := count + 1;
			divclock <= '0';
		end if;
	end if;
end process p_clockdivider;

p_comparator : process (divclock,i_reset) is
	variable a : std_logic;
	constant ccount : integer := 2**data_size;
	variable count : integer range 0 to ccount-1 := 0;
	variable veoc : std_logic;
	variable vladder : std_logic_vector(data_size-1 downto 0);
begin
	if (i_reset = '1') then
		count := 0;
		a := '0';
		veoc := '0';
		vladder := (others => '0');
	elsif (rising_edge(divclock)) then
--		a := not i_from_comparator; -- XXX maybe with S&H
		a := i_from_comparator;
		case (a) is
			when '0' =>
				if (count = ccount-1) then
					count := ccount-1;
					veoc := '1';
				else
					count := count + 1;
					veoc := '0';
				end if;
				vladder := std_logic_vector(to_unsigned(count,data_size));
			when '1' =>
				if (count = 0) then
					count := 0;
					veoc := '1';
				else
					count := count - 1;
					veoc := '0';
				end if;
				vladder := std_logic_vector(to_unsigned(count,data_size));
			when others =>
				count := 0;
				veoc := '0';
		end case;
		o_eoc <= veoc;
		io_ladder <= vladder;
		LCDChar <= (vladder(3 downto 0),vladder(7 downto 4),vladder(11 downto 8),x"0");
	end if;
end process p_comparator;

lcddisplay_entity : lcd_display
generic map (
LCDClockDivider => 4 -- XXX in ms
)
port map (
i_clock => i_clock,
i_LCDChar => LCDChar,
o_anode => o_anode,
o_segment => o_segment
);

end Behavioral;
