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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity logic_analyser is
Generic (
G_BOARD_CLOCK : integer := 50_000_000;
G_BAUD_RATE : integer := 9_600;
address_size : integer := 4;
data_size : integer := 8
);
Port (
i_clock : in std_logic;
i_reset : in std_logic; -- XXX use for catch data
i_catch : in std_logic;
i_data : in std_logic_vector(data_size-1 downto 0);
o_rs232_tx : out std_logic;
o_sended : out std_logic
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
enable_rx : in  STD_LOGIC;
byte_to_send : in  STD_LOGIC_VECTOR (8 downto 0);
byte_received : out  STD_LOGIC_VECTOR (7 downto 0);
parity_tx : out  STD_LOGIC;
parity_rx : out  STD_LOGIC;
busy : out  STD_LOGIC;
ready : out  STD_LOGIC;
is_byte_received : out STD_LOGIC;
is_byte_sended : out STD_LOGIC;
RsTx : out  STD_LOGIC;
RsRx : in  STD_LOGIC
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

signal latch_le,latch_oeb : std_logic;
signal latch_d,latch_q : std_logic_vector(data_size-1 downto 0);
signal sram_ceb,sram_web,sram_oeb : std_logic;
signal sram_address : std_logic_vector(address_size-1 downto 0);
signal sram_di,sram_do : std_logic_vector(data_size-1 downto 0);
signal rc_clock,rc_cpb,rc_mrb,rc_ud,rc_ping : std_logic;
signal rc_oq : std_logic_vector(address_size downto 0);
signal rs232_clock,rs232_reset,rs232_etx,rs232_tx,rs232_rx,rs232_busy,rs232_ready,rs232_byte_sended : std_logic;
signal rs232_b2s : std_logic_vector(8 downto 0);
signal wr,rd,a,b : std_logic;
signal catch,catch_not,catch_not1,catch_not2,catch_tick : std_logic;
signal clock_mux1,clock_mux2,clock_mux3 : std_logic;

constant WAIT_AND : time := 3 ps;
constant WAIT_NOT : time := 2 ps;

type state_type is (
idle,start,start_count,stop,check_write,wait0,wait0_increment,
read0,
st_enable_tx,st_rs232_waiting,st_disable_tx
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
rc_clock <= not i_clock when (wr = '1' and i_catch = '1') or (rd = '1' and rs232_etx = '1' and rs232_byte_sended = '1') else '0';
sram_ceb <= '0' when rc_clock = '1' or rs232_etx = '0' else '1';
--rc_mrb <= '1' when i_reset = '1' else '0';

--g_catch_and : GATE_AND Generic map (WAIT_AND) Port map (A=>i_catch,B=>catch_not,C=>catch_tick);
--g_catch_not1 : GATE_NOT Generic map (WAIT_NOT) Port map (A=>i_catch,B=>catch_not1);
--g_catch_not2 : GATE_NOT Generic map (WAIT_NOT) Port map (A=>catch_not1,B=>catch_not2);
--g_catch_not3 : GATE_NOT Generic map (WAIT_NOT) Port map (A=>catch_not2,B=>catch_not);

--p2 : process (i_clock,clock_mux1,catch_tick) is
--begin
--	if (i_clock='0' and catch_tick='1') then
--		clock_mux1 <= '1';
--	elsif (i_clock = '1') then
--		clock_mux1 <= '0';
--	end if;
--end process p2;

--ff_d_catch : FF_D_POSITIVE_EDGE
--PORT MAP (
--	D => clock_mux1,
--	C => i_clock,
--	Q1 => catch,
--	Q2 => open
--);

p1 : process (state_c,rs232_etx,rs232_byte_sended,sram_address) is
constant C_W0 : integer := 10;
variable w0 : integer range 0 to C_W0-1 := 0;
begin
	case (state_c) is
		when idle =>
			state_n <= start_count;
			rd <= '0';
			wr <= '0';
			rc_cpb <= '1';
			rc_ud <= '1';
			rc_mrb <= '1';
			rs232_etx <= '0';
			o_sended <= '0';
		when start_count =>
			state_n <= start;
			rc_mrb <= '0';
		when start =>
			state_n <= check_write;
			wr <= '1';
		when check_write =>
			if (to_integer(unsigned(sram_address)) = 2**address_size-1) then
				state_n <= wait0;
				wr <= '0';
			else
				state_n <= start;
			end if;
		when wait0 =>
			if (w0 = C_W0-1) then
				state_n <= read0;
				rc_mrb <= '0';
			else
				state_n <= wait0_increment;
				rc_mrb <= '1';
			end if;
		when wait0_increment =>
			state_n <= wait0;
			w0 := w0 + 1;
		when read0 =>
			rd <= '1';
			if (to_integer(unsigned(sram_address)) = 2**address_size-1) then
				state_n <= stop;
			else
				state_n <= st_enable_tx;
			end if;
		when st_enable_tx =>
			state_n <= st_rs232_waiting;
			rs232_etx <= '1';
		when st_rs232_waiting =>
			if (rs232_byte_sended = '1') then
				state_n <= st_disable_tx;
			else
				state_n <= st_rs232_waiting;
			end if;
		when st_disable_tx =>
			state_n <= read0;
			rs232_etx <= '0';
		when stop =>
			state_n <= stop;
			o_sended <= '1';
	end case;
end process p1;

latch_d <= i_data;
sram_di <= latch_q;
sram_address <= rc_oq(address_size-1 downto 0);
rs232_b2s(7 downto 0) <= sram_do;
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
enable_rx=>'0',
byte_to_send=>rs232_b2s,
byte_received=>open,
parity_tx=>open,
parity_rx=>open,
busy=>rs232_busy,
ready=>rs232_ready,
is_byte_received=>open,
is_byte_sended=>rs232_byte_sended,
RsTx=>rs232_tx,
RsRx=>rs232_rx
);

end Behavioral;
