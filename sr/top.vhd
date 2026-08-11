library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

use WORK.p_constants.ALL;

entity top is
generic (
	constant G_BOARD_CLOCK : integer := G_BOARD_CLOCK; -- input clock from board
	constant G_LCD_CLOCK_DIVIDER : integer := G_LCD_CLOCK_DIVIDER -- divider for lcd
);
port (
	signal i_clock : in std_logic; -- main clock
	signal i_reset : in std_logic; -- main reset
	signal i_push : in std_logic; -- release for run p0 process, before input phases
	signal i_phase1 : in std_logic; -- for first phase
	signal i_phase2 : in std_logic; -- for second phase
	signal o_anode : out std_logic_vector(3 downto 0); -- to lcd, anode
	signal o_segment : out std_logic_vector(6 downto 0) -- to lcd, segment multiplexing
);
end top;

architecture Behavioral of top is

type states is (a,b,c,d,e,f); -- states for process p0, e,f is for bcd convert a-d is for calculate phase
signal state : states;
type LCDHex is array(3 downto 0) of std_logic_vector(3 downto 0); -- for 4x lcd, slv30 is for hexdecimal 0-f
signal LCDChar : LCDHex;
signal counter : integer range 0 to 2**16-1; -- 16bit = FFFF, so we fit in lcd
signal cycles : std_logic_vector(15 downto 0); -- from counter
signal enable,tick1,tick2,lcd_clock,bcd_enable,bcd_busy : std_logic; -- signals for operate
signal bcd_binary : std_logic_vector(G_BCD_BITS-1 downto 0); -- for bcd converter, input
signal bcd_digits : std_logic_vector(G_BCD_DIGITS*4-1 downto 0); -- also for bcd converter, output

-- XXX based on https://forum.digikey.com/t/binary-to-bcd-converter-vhdl/12530
COMPONENT binary_to_bcd IS
  GENERIC(
    bits   : INTEGER := G_BCD_BITS;  --size of the binary input numbers in bits
    digits : INTEGER := G_BCD_DIGITS);  --number of BCD digits to convert to
  PORT(
    clk     : IN    STD_LOGIC;                             --system clock
    reset_n : IN    STD_LOGIC;                             --active low asynchronus reset
    ena     : IN    STD_LOGIC;                             --latches in new binary number and starts conversion
    binary  : IN    STD_LOGIC_VECTOR(bits-1 DOWNTO 0);     --binary number to convert
    busy    : OUT  STD_LOGIC;                              --indicates conversion in progress
    bcd     : OUT  STD_LOGIC_VECTOR(digits*4-1 DOWNTO 0)); --resulting BCD number
END COMPONENT binary_to_bcd;
for all : binary_to_bcd use entity WORK.binary_to_bcd(logic);

begin

-- process for divide clock for lcd, we must slowly the main clock for properly work
plcddiv : process (i_clock,i_reset) is
	constant clock_divider : integer := G_BOARD_CLOCK / 1000 / G_LCD_CLOCK_DIVIDER; -- result for plcddiv process
	variable clock_out : std_logic; -- to output
	variable counter : integer range 0 to clock_divider - 1 := 0; -- main variable plcddiv
begin
	if (i_reset = '1') then -- when main reset, restart all values
		clock_out := '0'; -- when reset, keep disabled lcd clock
		counter := 0; -- reset counting
	elsif (rising_edge(i_clock)) then -- when we have rising edge, use condition below
		if (counter = clock_divider-1) then -- when we have max counting
			clock_out := '1'; -- bring out lcd tick
			counter := 0; -- reset from beginig
		else
			clock_out := '0'; -- keep the disabled lcd
			counter := counter + 1; -- increment counter lcd
		end if;
	end if;
	lcd_clock <= clock_out; -- bring out outside process
end process plcddiv;

plcdanode : process (lcd_clock,i_reset) is
	variable count : integer range 0 to 3 := 0;
begin
	if (i_reset = '1') then
		o_anode <= (others => '1');
		count := 0;
	elsif (rising_edge(lcd_clock)) then
		case count is -- multiplexing 4 anodes, when 0 we pull down the voltage for lcd
			when 0 =>
				o_anode(3 downto 0) <= "0111"; -- first anode lcd
			when 1 =>
				o_anode(3 downto 0) <= "1011"; -- second anode lcd
			when 2 =>
				o_anode(3 downto 0) <= "1101"; -- third anode lcd
			when 3 =>
				o_anode(3 downto 0) <= "1110"; -- quarter anode lcd
			when others =>
				o_anode(3 downto 0) <= "1111"; -- for undefined condition, disable all 4x lcd
		end case;
		if (count = 3) then -- counting for 4 anodes, always increment when we have plcddiv tick
			count := 0;
		else
			count := count + 1;
		end if;
	end if;
end process plcdanode;

plcdsegment : process (lcd_clock,i_reset) is -- very likely above
	variable count : integer range 0 to 3 := 0;
begin
	if (i_reset = '1') then -- when global reseting
		o_segment <= (others => '0'); -- disable all 7 segment
		count := 0;
	elsif (rising_edge(lcd_clock)) then
		case to_integer(unsigned(LCDChar(count))) is -- check the all 4 chars from LCDChar signal and bring out the value to lcd
			when 0 => o_segment <= "1000000"; -- 0
			when 1 => o_segment <= "1111001"; -- 1
			when 2 => o_segment <= "0100100"; -- 2
			when 3 => o_segment <= "0110000"; -- 3
			when 4 => o_segment <= "0011001"; -- 4
			when 5 => o_segment <= "0010010"; -- 5
			when 6 => o_segment <= "0000010"; -- 6
			when 7 => o_segment <= "1111000"; -- 7
			when 8 => o_segment <= "0000000"; -- 8
			when 9 => o_segment <= "0010000"; -- 9
			when 10 => o_segment <= "0001000"; -- a
			when 11 => o_segment <= "0000011"; -- b
			when 12 => o_segment <= "1000110"; -- c
			when 13 => o_segment <= "0100001"; -- d
			when 14 => o_segment <= "0000110"; -- e
			when 15 => o_segment <= "0001110"; -- f
			when others => null;
		end case;
		if (count = 3) then -- multiplexing lcd 1-4
			count := 0;
		else
			count := count + 1;
		end if;
	end if;
end process plcdsegment;

-- helper for bring out rising edge for phase1, when phase1 begin, tick equal one period main clock
pre1 : process (i_clock,i_reset,i_phase1) is
	type states is (a,b,c);
	variable state : states;
begin
	if (i_reset = '1') then -- global reset for all project
		tick1 <= '0'; -- keep low
		state := a; -- return to begin FSM
	elsif (rising_edge(i_clock)) then -- when RE main clock
		case (state) is
			when a => -- check when phase1 have 1, then go to state b, else stay on state a, and go out 1 for tick1 signal
				if (i_phase1 = '1') then
					state := b;
					tick1 <= '1';
				else
					state := a;
					tick1 <= '0';
				end if;
			when b => -- keep the 0 for next global i_reset
				state := b;
				tick1 <= '0';
			when others => -- when other states, this is for recovery FSM when something will go wrong
				state := a;
				tick1 <= '0';
		end case;		
	end if;
end process pre1;

-- helper for phase2, same as for phase1/tick1 signal
pre2 : process (i_clock,i_reset,i_phase2) is
	type states is (a,b,c);
	variable state : states;
begin
	if (i_reset = '1') then
		tick2 <= '0';
		state := a;
	elsif (rising_edge(i_clock)) then
		case (state) is
			when a =>
				if (i_phase2 = '1') then
					state := b;
					tick2 <= '1';
				else
					state := a;
					tick2 <= '0';
				end if;
			when b =>
				state := b;
				tick2 <= '0';
			when others =>
				state := a;
				tick2 <= '0';
		end case;		
	end if;
end process pre2;

-- main counting, when ENABLE comes from main p0 process, then count the cycles between phase1 and phase2
pcnt : process (i_clock,i_reset,enable) is
begin
	if (i_reset = '1') then
		counter <= 0;
	elsif (rising_edge(i_clock)) then
		if (enable = '1') then
			counter <= counter + 1;
		else
			counter <= counter;
		end if;
	end if;
end process pcnt;

-- bring out the converted values to 4x lcd
LCDChar <= (
bcd_digits(3 downto 0),
bcd_digits(7 downto 4),
bcd_digits(11 downto 8),
bcd_digits(15 downto 12)
);

-- main process
p0 : process (i_clock,i_reset,tick1,tick2) is -- sensitive for properly FSM work, must have tick1 and tick2 because we read from this signals
begin
	if (i_reset = '1') then -- when we reset the project, we start from beginig
		state <= a;
		enable <= '0';
		cycles <= (others => '0');
		bcd_enable <= '0';
		bcd_binary <= (others => '0');
	elsif(rising_edge(i_clock)) then -- elsewhere FSM run
		case (state) is
			when a => -- wait for triggering
				if (i_push = '1') then
					state <= b;
				else
					state <= a;
				end if;
			when b => -- check when tick 1 or 2 have one, then go to c state, else stay in b and wait for condition
				if (tick1 = '1' or tick2 = '1') then
					enable <= '1'; -- run the counting pcnt process
					state <= c; -- go to c state
				else -- stay in b state
					enable <= '0';
					state <= b;
				end if;
			when c =>
				if (tick2 = '1' or tick1 = '1') then -- check when tick 1 or 2 is positive, then stop counting pcnt process and go to d for BCD converiosn
					enable <= '0';
					state <= d;
				else -- stay and wait for ending tick1 or tick2
					enable <= '1';
					state <= c;
				end if;
			when d => -- information, for know how much we have ticks between phases
				cycles <= std_logic_vector(to_unsigned(counter,16));
				state <= e;
			when e => -- start conversion from hexdecimals values to human output
				bcd_enable <= '1';
				bcd_binary <= cycles(G_BCD_BITS-1 downto 0);
				state <= f;
			when f => -- wait when bcd conversion ending
				if (bcd_busy = '1') then -- conversion in progress
					state <= f;
					bcd_enable <= '1';
				else -- end conversion, return to IDLE state and wait for next measuring
					state <= a;
					bcd_enable <= '0';
				end if;
		end case;
	end if;
end process p0;

-- component to conversion from digikey
bcd : binary_to_bcd
generic map (bits => G_BCD_BITS, digits => G_BCD_DIGITS)
port map (
clk => i_clock,
reset_n => not i_reset,
ena => bcd_enable, -- start and wait for convert
binary => bcd_binary, -- source values from measurement
busy => bcd_busy, -- flag for waiting in state f
bcd => bcd_digits -- output for LCD
);

end Behavioral;

