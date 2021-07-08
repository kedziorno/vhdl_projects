----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:28:43 05/04/2021 
-- Design Name: 
-- Module Name:    logic_analyser - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity logic_analyser is
Generic (
G_BOARD_CLOCK : integer := G_BOARD_CLOCK;
G_BAUD_RATE : integer := 9_600;
address_size : integer := 4;
data_size : integer := 8;
G_RC_N : integer := G_DEBOUNCE_MS_BITS;
G_RC_MAX : integer := G_DEBOUNCE_MS_COUNT
);
Port (
i_clock : in std_logic;
i_reset : in std_logic;
i_catch : in std_logic;
i_data : in std_logic_vector(data_size-1 downto 0);
o_rs232_tx : out std_logic;
o_sended : out std_logic;
o_seg : out std_logic_vector(G_LCDSegment-1 downto 0);
--o_dp : out std_logic;
o_an : out std_logic_vector(G_LCDAnode-1 downto 0);
o_data : out std_logic_vector(G_Led-1 downto 0)
);
end logic_analyser;

architecture Behavioral of logic_analyser is

component nxp_74hc573 is
generic (
nbit : integer := 8
);
port (
i_le : in std_logic;
i_oeb : in std_logic;
i_d : in std_logic_vector(nbit-1 downto 0);
o_q : out std_logic_vector(nbit-1 downto 0)
);
end component nxp_74hc573;

component sram_62256 is
Generic (
address_size : integer := 8;
data_size : integer := 8
);
Port (
i_ceb : in  STD_LOGIC;
i_web : in  STD_LOGIC;
i_oeb : in  STD_LOGIC;
i_address : in  STD_LOGIC_VECTOR (address_size-1 downto 0);
i_data : in  STD_LOGIC_VECTOR (data_size-1 downto 0);
o_data : out  STD_LOGIC_VECTOR (data_size-1 downto 0)
);
end component sram_62256;

component ripple_counter is
Generic (
N : integer := 32;
MAX : integer := 1
);
Port (
i_clock : in std_logic;
i_cpb : in std_logic;
i_mrb : in std_logic;
o_q : inout std_logic_vector(N-1 downto 0);
i_ud : in std_logic;
o_ping : out std_logic
);
end component ripple_counter;

component rs232 is
Generic (
G_BOARD_CLOCK : integer := G_BOARD_CLOCK;
G_BAUD_RATE : integer := G_BAUD_RATE
);
Port(
clk : in  STD_LOGIC;
rst : in  STD_LOGIC;
enable_tx : in  STD_LOGIC;
--enable_rx : in  STD_LOGIC;
byte_to_send : in  STD_LOGIC_VECTOR (7 downto 0);
--byte_received : out  STD_LOGIC_VECTOR (7 downto 0);
--parity_tx : out  STD_LOGIC;
--parity_rx : out  STD_LOGIC;
busy : out  STD_LOGIC;
ready : out  STD_LOGIC;
--is_byte_received : out STD_LOGIC;
is_byte_sended : out STD_LOGIC;
RsTx : out  STD_LOGIC
--RsRx : in  STD_LOGIC
);
end component rs232;

component GATE_AND is
generic (
delay_and : TIME := 1 ns
);
port (
A,B : in STD_LOGIC;
C : out STD_LOGIC
);
end component GATE_AND;

component GATE_NOT is
generic (
delay_not : TIME := 1 ns
);
port (
A : in STD_LOGIC;
B : out STD_LOGIC
);
end component GATE_NOT;

component FF_D_POSITIVE_EDGE is
port (C,D:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
end component FF_D_POSITIVE_EDGE;

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
i_LCDChar : LCDHex;
o_anode : out std_logic_vector(G_LCDAnode-1 downto 0);
o_segment : out std_logic_vector(G_LCDSegment-1 downto 0)
);
end component lcd_display;

signal latch_le,latch_oeb : std_logic;
signal latch_d,latch_q : std_logic_vector(data_size-1 downto 0);
signal sram_ceb,sram_web,sram_oeb : std_logic;
signal sram_address : std_logic_vector(address_size-1 downto 0);
signal sram_di,sram_do : std_logic_vector(data_size-1 downto 0);
signal rc_clock,rc_cpb,rc_mrb,rc_ud,rc_ping : std_logic;
signal rc_oq : std_logic_vector(address_size downto 0);
signal rs232_etx,rs232_tx,rs232_byte_sended,rs232_busy,rs232_ready : std_logic;
signal rs232_b2s : std_logic_vector(7 downto 0);
signal wr,rd,a,b : std_logic;
signal catch : std_logic;
signal LCDChar : LCDHex;
signal reset_db : std_logic;

constant WAIT_AND : time := 3 ps;
constant WAIT_NOT : time := 2 ps;

type state_type is (
idle,start,start_count,check_catch,check_write,wait0,wait1,
--wait_catch,
read0,
st_enable_tx,st_rs232_waiting,st_disable_tx,
stop
);
signal state_c,state_n : state_type;

begin

p0 : process (i_clock,i_reset) is
begin
	if (i_reset = '1') then
		state_c <= idle;
	elsif (rising_edge(i_clock)) then
		state_c <= state_n;
	end if;
end process p0;

latch_le <= '1' when rc_clock = '0' else '0';
--latch_oeb <= '0' when (i_clock = '0' and wr = '1') else '0';
latch_oeb <= '1' when rd = '1' else '0'; -- XXX todo
sram_web <= '0' when latch_le = '0' else '1';
sram_oeb <= '0' when rd = '1' and state_c = read0 else '1';
rc_clock <= not i_clock when (wr = '1' and catch = '1') or (rd = '1' and rs232_etx = '1' and rs232_byte_sended = '1') else '0';
sram_ceb <= '0' when rc_clock = '1' or rs232_etx = '0' else '1';
--rc_mrb <= '1' when i_reset = '1' else '0';
rc_ping <= '0';

db_entity : new_debounce
generic map (
G_RC_N => G_RC_N,
G_RC_MAX => G_RC_MAX
)
port map (
i_clock => i_clock,
i_reset => reset_db,
i_b => i_catch,
o_db => catch
);

lcddisplay_entity : lcd_display
Generic Map (
	G_BOARD_CLOCK => G_BOARD_CLOCK,
	LCDClockDivider => G_LCDClockDivider
)
Port Map (
	i_clock => i_clock,
	i_LCDChar => LCDChar,
	o_anode => o_an,
	o_segment => o_seg
);

p1 : process (state_c,rs232_etx,rs232_byte_sended,sram_address,catch) is
begin
--	state_n <= state_c;
	reset_db <= '0';
--	o_data <= (others => '0');
--	o_sended <= '0';
--	rd <= '1';
--	wr <= '1';
--	rc_mrb <= '0';
--	rs232_etx <= '0';
--	LCDChar <= (x"0",x"0",x"0",x"0");
	case (state_c) is
		when idle =>
			rs232_etx <= '0';
			reset_db <= '1';
			state_n <= start_count;
			rd <= '0';
			wr <= '0';
			rc_cpb <= '1';
			rc_ud <= '1';
			rc_mrb <= '1';
			rs232_etx <= '0';
			o_sended <= '0';
			LCDChar <= (x"f",x"0",x"1",x"f");
			o_data <= "00000001";
		when start_count =>
			wr <= '0';
			rd <= '0';
			o_sended <= '0';
			rs232_etx <= '0';
			state_n <= start;
			rc_mrb <= '0';
			LCDChar <= (x"0",x"0",x"0",x"0");
			o_data <= "00000010";
		when start =>
			rc_mrb <= '0';
			rd <= '0';
			o_sended <= '0';
			rs232_etx <= '0';
			reset_db <= '1';
			state_n <= check_catch;
			wr <= '1';
			LCDChar <= (x"1",x"0",x"0",x"0");
			o_data <= "00000100";
		when check_catch =>
			rc_mrb <= '0';
			wr <= '1';
			rd <= '0';
			o_sended <= '0';
			rs232_etx <= '0';
			if (catch = '1') then
				state_n <= check_write;
			else
				state_n <= check_catch;
			end if;
			o_data <= "00001000";
			LCDChar <= (x"2",x"2",x"2",x"2");
		when check_write =>
			rc_mrb <= '0';
			wr <= '1';
			rd <= '0';
			o_sended <= '0';
			rs232_etx <= '0';
			reset_db <= '1';
			if (to_integer(unsigned(sram_address)) = 2**address_size-1) then
				state_n <= wait0;
				LCDChar <= (x"2",x"0",x"0",x"0");
			else
--				state_n <= wait_catch;
				state_n <= start;
				LCDChar <= (x"3",x"0",x"0",x"0");
			end if;
			o_data <= "00010000";
--		when wait_catch =>
--			state_n <= start;
--			reset_db <= '1';
		when wait0 =>
			wr <= '0';
			rd <= '0';
			o_sended <= '0';
			state_n <= wait1;
			rs232_etx <= '0';
			rc_mrb <= '1';
			o_data <= (others => '0');
			LCDChar <= (x"0",x"0",x"0",x"0");
		when wait1 =>
			wr <= '0';
			rd <= '0';
			o_sended <= '0';
			state_n <= read0;
			rs232_etx <= '0';
			rc_mrb <= '0';
			o_data <= (others => '0');
			LCDChar <= (x"0",x"0",x"0",x"0");
		when read0 =>
			rc_mrb <= '0';
			wr <= '0';
			o_sended <= '0';
			rd <= '1';
			rs232_etx <= '0';
			if (to_integer(unsigned(sram_address)) = 2**address_size-1) then
				LCDChar <= (x"6",x"0",x"0",x"0");
				state_n <= stop;
			else
				LCDChar <= (x"7",x"0",x"0",x"0");
				state_n <= st_enable_tx;
			end if;
			o_data <= "00100000";
		when st_enable_tx =>
			rc_mrb <= '0';
			wr <= '0';
			rd <= '1';
			o_sended <= '0';
			state_n <= st_rs232_waiting;
			rs232_etx <= '1';
			o_data <= (others => '0');
			LCDChar <= (x"0",x"0",x"0",x"0");
		when st_rs232_waiting =>
			rc_mrb <= '0';
			wr <= '0';
			rd <= '1';
			o_sended <= '0';
			rs232_etx <= '1';
			if (rs232_byte_sended = '1') then
				state_n <= st_disable_tx;
				LCDChar <= (x"8",x"0",x"0",x"0");
			else
				state_n <= st_rs232_waiting;
				LCDChar <= (x"9",x"0",x"0",x"0");
			end if;
			o_data <= "01000000";
		when st_disable_tx =>
			rc_mrb <= '0';
			wr <= '0';
			rd <= '1';
			o_sended <= '0';
			state_n <= read0;
			rs232_etx <= '0';
			o_data <= (others => '0');
			LCDChar <= (x"A",x"0",x"0",x"0");
		when stop =>
			rc_mrb <= '0';
			wr <= '0';
			rd <= '1';
			state_n <= idle;
			o_sended <= '1';
			rs232_etx <= '0';
			LCDChar <= (x"B",x"0",x"0",x"0");
			o_data <= "10000000";
	end case;
end process p1;

latch_d <= i_data;
sram_di <= latch_q;
sram_address <= rc_oq(address_size-1 downto 0);
rs232_b2s <= sram_do;
o_rs232_tx <= rs232_tx;

latch_entity : nxp_74hc573
generic map (nbit=>data_size)
port map (
i_le=>latch_le,
i_oeb=>latch_oeb,
i_d=>latch_d,
o_q=>latch_q
);

sram_entity : sram_62256
Generic map (address_size=>address_size,data_size=>data_size)
Port map (
i_ceb=>sram_ceb,
i_web=>sram_web,
i_oeb=>sram_oeb,
i_address=>sram_address,
i_data=>sram_di,
o_data=>sram_do
);

rc_entity : ripple_counter
Generic map (N=>address_size+1,MAX=>2**address_size)
Port map (
i_clock=>rc_clock,
i_cpb=>rc_cpb,
i_mrb=>rc_mrb,
i_ud=>rc_ud,
o_q=>rc_oq,
o_ping=>rc_ping
);

rs232_entity : rs232
Generic map (G_BOARD_CLOCK=>G_BOARD_CLOCK,G_BAUD_RATE=>G_BAUD_RATE)
Port map (
clk=>i_clock,
rst=>i_reset,
enable_tx=>rs232_etx,
--enable_rx=>'0',
byte_to_send=>rs232_b2s,
--byte_received=>open,
--parity_tx=>open,
--parity_rx=>open,
busy=>rs232_busy,
ready=>rs232_ready,
----is_byte_received=>open,
is_byte_sended=>rs232_byte_sended,
RsTx=>rs232_tx
--RsRx=>rs232_rx
);

end Behavioral;
