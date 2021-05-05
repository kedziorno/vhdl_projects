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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity logic_analyser is
Generic (
G_BOARD_CLOCK : integer := 50_000_000;
G_BAUD_RATE : integer := 9_600;
address_size : integer := 8;
data_size : integer := 8
);
Port (
i_clock : in std_logic;
i_reset : in std_logic;
i_data : in std_logic_vector(data_size-1 downto 0);
o_rs232_tx : out std_logic;
oc0,ain1 : in std_logic
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
N : integer := 8
);
Port (
i_clock : in std_logic;
i_cpb : in std_logic;
i_mrb : in std_logic;
o_q : inout std_logic_vector(N-1 downto 0)
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
RsTx : out  STD_LOGIC;
RsRx : in  STD_LOGIC
);
end component rs232;

signal latch_le,latch_oeb : std_logic;
signal latch_d,latch_q : std_logic_vector(data_size-1 downto 0);
signal sram_ceb,sram_web,sram_oeb : std_logic;
signal sram_address : std_logic_vector(address_size-1 downto 0);
signal sram_di,sram_do : std_logic_vector(data_size-1 downto 0);
signal rc_clock,rc_cpb,rc_mrb : std_logic;
signal rc_oq : std_logic_vector(address_size-1 downto 0);
signal rs232_clock,rs232_reset,rs232_etx,rs232_tx,rs232_rx,rs232_busy : std_logic;
signal rs232_b2s : std_logic_vector(8 downto 0);

signal wr,rd,a,b : std_logic;
--signal oc0,ain1 : std_logic;

type state_type is (
idle,start,stop,check_write,wait1,wait0,wait0_increment,
read0,read_check
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

--p1 : process (state_c,oc0,ain1) is
--constant C_W0 : integer := 10;
--variable w0 : integer range 0 to C_W0-1 := 0;
--begin
--	case (state_c) is
--		when idle =>
--			rd <= '0';
--			wr <= '0';
--			if (ain1 = '1') then
--				state_n <= start;
--				rc_mrb <= '1';
--			else
--				state_n <= idle;
--			end if;
--		when start =>
--			state_n <= check_write;
--			wr <= '0';
--			rc_mrb <= '0';
--			latch_oeb <= '0';
--		when check_write =>
--			wr <= '1';
--			if (sram_address(address_size-1)='1') then
--				state_n <= wait1;
--				wr <= '1';
--			else
--				state_n <= start;
--			end if;
--		when wait1 =>
--			if (oc0 = '1') then
--				state_n <= wait1;
--			elsif (oc0 = '0') then
--				state_n <= wait0;
--				w0 := 0;
--			end if;
--		when wait0 =>
--			latch_oeb <= '1';
--			if (w0 = C_W0-1) then
--				state_n <= read_check;
--			else
--				state_n <= wait0_increment;
--			end if;
--		when wait0_increment =>
--			state_n <= wait0;
--			w0 := w0 + 1;
--		when read_check =>
--			rc_mrb <= '1';
--			if (ain1 = '1') then
--				state_n <= read0;
--			else
--				state_n <= read_check;
--			end if;
--		when read0 =>
--			state_n <= stop;
--			rc_mrb <= '0';
--			wr <= '0';
--			rd <= '1';
--		when stop =>
--			state_n <= stop;
--	end case;
--end process p1;

-- XXX work only write
wr <= '0' when sram_address(address_size-1)='1' else '1';
rc_mrb <= '1' when (i_reset = '1' or ain1 = '1') else '0';
rd <= '1' when wr = '0' else '0';

a <= i_clock and (wr or rd);
b <= ain1 and a;

sram_ceb <= '0';
sram_web <= a when wr='1' else '1'; --not (a and i_clock);
sram_oeb <= a when rd='1' else '1';--ain1; --not b when rd='1' else '1';

rc_clock <= i_clock;
rc_cpb <= '1';

latch_le <= a when wr='1' else '0'; --not (a and i_clock);
latch_oeb <= not a when wr='1' else '1'; -- XXX distinct signal

latch_d <= i_data;
sram_di <= latch_q;
sram_address <= rc_oq;
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
Generic map (N=>address_size)
Port map (
i_clock=>rc_clock,
i_cpb=>rc_cpb,
i_mrb=>rc_mrb,
o_q=>rc_oq
);

rs232_entity : rs232
Generic map (G_BOARD_CLOCK=>G_BOARD_CLOCK,G_BAUD_RATE=>G_BAUD_RATE)
Port map (
clk=>rs232_clock,
rst=>rs232_reset,
enable_tx=>rs232_etx,
enable_rx=>'0',
byte_to_send=>rs232_b2s,
byte_received=>open,
parity_tx=>open,
parity_rx=>open,
busy=>rs232_busy,
ready=>open,
is_byte_received=>open,
RsTx=>rs232_tx,
RsRx=>rs232_rx
);

end Behavioral;
