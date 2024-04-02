----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:11:25 07/06/2021 
-- Design Name: 
-- Module Name:    test_debouncebutton_lcddisplay - Behavioral 
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
use work.p_globals.all;
use work.p_lcd_display.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_debouncebutton_lcddisplay is
port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	i_up : in std_logic;
	i_down : in std_logic;
	o_seg : out std_logic_vector(G_LCDSegment-1 downto 0);
	o_an : out std_logic_vector(G_LCDAnode-1 downto 0)
);
end test_debouncebutton_lcddisplay;

architecture Behavioral of test_debouncebutton_lcddisplay is

	component new_debounce is
	generic ( -- ripplecounter N bits (RC_N=N+1,RC_MAX=2**N)
		G_RC_N : integer := 5;
		G_RC_MAX : integer := 16
	);
	port (
		i_clock : in std_logic;
		i_reset : in std_logic;
		i_b : in std_logic;
		o_db : out std_logic
	);
	end component new_debounce;

	component lcd_display is
	Generic (
		G_BOARD_CLOCK : integer := 1;
		LCDClockDivider : integer := 1
	);
	Port (
		i_clock : in std_logic;
		i_reset : in std_logic;
		i_LCDChar : LCDHex;
		o_anode : out std_logic_vector(G_LCDAnode-1 downto 0);
		o_segment : out std_logic_vector(G_LCDSegment-1 downto 0)
	);
	end component lcd_display;

	constant G_RC_N : integer := G_DEBOUNCE_MS_BITS;
	constant G_RC_MAX : integer := G_DEBOUNCE_MS_COUNT;
	constant BITS : integer := 16;
	signal LCDChar : LCDHex;
	signal db_up,db_down : std_logic;
	signal counter : integer range 0 to 2**BITS-1 := 0;
	signal increment : integer range -1 to 1;
	signal output : std_logic_vector(BITS-1 downto 0);
	signal counter_enable : std_logic;
	signal db_up_reset,db_down_reset : std_logic;

begin

	p0 : process (i_clock,i_reset,db_up,db_down,counter_enable) is
	begin
		if (i_reset = '1') then
			counter <= 0;
			counter_enable <= '0';
			db_up_reset <= '1';
			db_down_reset <= '1';
		elsif (rising_edge(i_clock)) then
			if (db_up = '1') then
				increment <= 1;
				counter_enable <= '1';
				db_up_reset <= '1';
			elsif (db_down = '1') then
				increment <= -1;
				counter_enable <= '1';
				db_down_reset <= '1';
			else
				increment <= 0;
				counter_enable <= '0';
				db_up_reset <= '0';
				db_down_reset <= '0';
			end if;				
			if (counter_enable = '1') then
				if (counter = 2**BITS-1) then
					counter <= 0;
				elsif (counter = -1) then
					counter <= 2**BITS-1;
				end if;
				counter <= counter + increment;
			end if;
		end if;
	end process p0;
	output <= std_logic_vector(to_unsigned(counter,BITS));
	LCDChar <= (output(3 downto 0),output(7 downto 4),output(11 downto 8),output(15 downto 12));

	db_entity_up : new_debounce
	generic map (
		G_RC_N => G_RC_N,
		G_RC_MAX => G_RC_MAX
	)
	port map (
		i_clock => i_clock,
		i_reset => db_up_reset,
		i_b => i_up,
		o_db => db_up
	);

	db_entity_down : new_debounce
	generic map (
		G_RC_N => G_RC_N,
		G_RC_MAX => G_RC_MAX
	)
	port map (
		i_clock => i_clock,
		i_reset => db_down_reset,
		i_b => i_down,
		o_db => db_down
	);

	lcddisplay_entity : lcd_display
	Generic Map (
		G_BOARD_CLOCK => G_BOARD_CLOCK,
		LCDClockDivider => G_LCDClockDivider
	)
	Port Map (
		i_clock => i_clock,
		i_reset => i_reset,
		i_LCDChar => LCDChar,
		o_anode => o_an,
		o_segment => o_seg
	);

end Behavioral;
