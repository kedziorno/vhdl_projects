library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

use WORK.p_constants.ALL;

entity top is
generic (
	constant G_BOARD_CLOCK : integer := G_BOARD_CLOCK;
	constant G_LCD_CLOCK_DIVIDER : integer := G_LCD_CLOCK_DIVIDER
);
port (
	signal i_clock : in std_logic;
	signal i_reset : in std_logic;
	signal i_push : in std_logic;
	signal i_phase1 : in std_logic;
	signal i_phase2 : in std_logic;
	signal o_anode : out std_logic_vector(3 downto 0);
	signal o_segment : out std_logic_vector(6 downto 0)
);
end top;

architecture Behavioral of top is

type states is (a,b,c,d,e,f);
signal state : states;
type LCDHex is array(3 downto 0) of std_logic_vector(3 downto 0);
signal LCDChar : LCDHex;
signal counter : integer range 0 to 2**16-1;
signal cycles : std_logic_vector(15 downto 0);
signal enable,tick1,tick2,lcd_clock,bcd_enable,bcd_busy : std_logic;
signal bcd_binary : std_logic_vector(G_BCD_BITS-1 downto 0);
signal bcd_digits : std_logic_vector(G_BCD_DIGITS*4-1 downto 0);

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

plcddiv : process (i_clock,i_reset) is
	constant clock_divider : integer := G_BOARD_CLOCK / 1000 / G_LCD_CLOCK_DIVIDER;
	variable clock_out : std_logic;
	variable counter : integer range 0 to clock_divider - 1 := 0;
begin
	if (i_reset = '1') then
		clock_out := '0';
		counter := 0;
	elsif (rising_edge(i_clock)) then
		if (counter = clock_divider-1) then
			clock_out := '1';
			counter := 0;
		else
			clock_out := '0';
			counter := counter + 1;
		end if;
	end if;
	lcd_clock <= clock_out;
end process plcddiv;

plcdanode : process (lcd_clock) is
	variable count : integer range 0 to 3 := 0;
begin
	if (rising_edge(lcd_clock)) then
		case count is
			when 0 =>
				o_anode(3 downto 0) <= "0111";
			when 1 =>
				o_anode(3 downto 0) <= "1011";
			when 2 =>
				o_anode(3 downto 0) <= "1101";
			when 3 =>
				o_anode(3 downto 0) <= "1110";
			when others =>
				o_anode(3 downto 0) <= "1111";
		end case;
		if (count = 3) then
			count := 0;			
		else
			count := count + 1;
		end if;
	end if;
end process plcdanode;

plcdsegment : process (lcd_clock) is
	variable count : integer range 0 to 3 := 0;
begin
	if (rising_edge(lcd_clock)) then
		case to_integer(unsigned(LCDChar(count))) is
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
		if (count = 3) then
			count := 0;
		else
			count := count + 1;
		end if;
	end if;
end process plcdsegment;

pre1 : process (i_clock,i_reset,i_phase1) is
	type states is (a,b,c);
	variable state : states;
begin
	if (i_reset = '1') then
		tick1 <= '0';
		state := a;
	elsif (rising_edge(i_clock)) then
		case (state) is
			when a =>
				if (i_phase1 = '1') then
					state := b;
					tick1 <= '1';
				else
					state := a;
					tick1 <= '0';
				end if;
			when b =>
				state := b;
				tick1 <= '0';
			when others =>
				state := a;
				tick1 <= '0';
		end case;		
	end if;
end process pre1;

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

LCDChar <= (
'0' & bcd_digits(2 downto 0),
'0' & bcd_digits(6 downto 3),
'0' & bcd_digits(10 downto 7),
x"0"
);

p0 : process (i_clock,i_reset,tick1,tick2) is
begin
	if (i_reset = '1') then
		state <= a;
		enable <= '0';
		cycles <= (others => '0');
		bcd_enable <= '0';
		bcd_binary <= (others => '0');
	elsif(rising_edge(i_clock)) then
		case (state) is
			when a =>
				if (i_push = '1') then
					state <= b;
				else
					state <= a;
				end if;
			when b =>
				if (tick1 = '1' or tick2 = '1') then
					enable <= '1';
					state <= c;
				else
					enable <= '0';
					state <= b;
				end if;
			when c =>
				if (tick2 = '1' or tick1 = '1') then
					enable <= '0';
					state <= d;
				else
					enable <= '1';
					state <= c;
				end if;
			when d =>
				cycles <= std_logic_vector(to_unsigned(counter,16));
				state <= e;
			when e =>
				bcd_enable <= '1';
				bcd_binary <= cycles(G_BCD_BITS-1 downto 0);
				state <= f;
			when f =>
				if (bcd_busy = '1') then
					state <= f;
					bcd_enable <= '1';
				else
					state <= a;
					bcd_enable <= '0';
				end if;
		end case;
	end if;
end process p0;

bcd : binary_to_bcd
generic map (bits => G_BCD_BITS, digits => G_BCD_DIGITS)
port map (
clk => i_clock,
reset_n => not i_reset,
ena => bcd_enable,
binary => bcd_binary,
busy => bcd_busy,
bcd => bcd_digits
);

end Behavioral;

