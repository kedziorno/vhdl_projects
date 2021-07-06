----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:45:58 07/05/2021 
-- Design Name: 
-- Module Name:    new_debounce - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity new_debounce is
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
end new_debounce;

architecture Behavioral of new_debounce is
-- XXX based on MAX16054 datasheet

component ripple_counter is
Generic (
N : integer := 32;
MAX : integer := 1
);
Port (
i_clock : in std_logic;
i_cpb : in std_logic;
i_mrb : in std_logic;
i_ud : in std_logic;
o_q : inout std_logic_vector(N-1 downto 0);
o_ping : out std_logic
);
end component ripple_counter;

component FF_D_POSITIVE_EDGE is
port (
S,R : in std_logic;
C : in std_logic;
D : in STD_LOGIC;
Q1,Q2:inout STD_LOGIC);
end component FF_D_POSITIVE_EDGE;

component FF_JK is
port (
i_r : in STD_LOGIC;
J,K,C : in STD_LOGIC;
Q1 : inout STD_LOGIC;
Q2 : inout STD_LOGIC
);
end component FF_JK;

component GATE_NOT is
generic (
delay_not : TIME := 1 ns
);
port (
A : in STD_LOGIC;
B : out STD_LOGIC
);
end component GATE_NOT;

constant WAIT_NOT : time := 1 ps;

constant RC_N : integer := G_RC_N;
constant RC_MAX : integer := G_RC_MAX;
signal rc_cpb,rc_mrb,rc_ud,rc_ping : std_logic := '0';
signal rc_q : std_logic_vector(RC_N-1 downto 0) := (others => '0');
signal ffdpe_d,ffdpe_q1,ffdpe_q2 : std_logic := '0';
signal ffjk_reset,ffjk_j,ffjk_k,ffjk_q1,ffjk_q2 : std_logic := '0';

signal a,not1 : std_logic;
signal not2 : std_logic;

begin

ffdpe_d <= i_b;
rc_mrb <= not2 xnor i_b;
ffjk_j <= not1;
ffjk_k <= not1;
rc_ud <= '1';
rc_cpb <= '1';
o_db <= ffjk_q1;

gnot1 : GATE_NOT
GENERIC MAP (WAIT_NOT)
port map (
A => ffdpe_q1,
B => not1
);

gnot2 : GATE_NOT
GENERIC MAP (WAIT_NOT)
port map (
A => not1,
B => not2
);

rc_entity : ripple_counter -- XXX 50ms
Generic map (
N => RC_N,
MAX => RC_MAX
)
Port map (
i_clock => i_clock,
i_cpb => rc_cpb,
i_mrb => rc_mrb,
i_ud => rc_ud,
o_q => rc_q,
o_ping => rc_ping
);

ffdpe_entity : FF_D_POSITIVE_EDGE
port map(
S => not i_reset,
R => not i_reset,
C => rc_q(RC_N-1),
D => ffdpe_d,
Q1 => ffdpe_q1,
Q2 => ffdpe_q2
);

ffjk_entity : FF_JK
port map (
i_r => i_reset,
J => ffjk_j,
K => ffjk_k,
C => not1,
Q1 => ffjk_q1,
Q2 => ffjk_q2
);

end Behavioral;
