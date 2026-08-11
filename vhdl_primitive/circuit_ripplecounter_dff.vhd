----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:45:02 07/05/2021 
-- Design Name: 
-- Module Name:    circuit_ripplecounter_dff - Behavioral 
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

entity circuit_ripplecounter_dff is
port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	i_input : in std_logic;
	o_output : out std_logic
);
end circuit_ripplecounter_dff;

architecture Behavioral of circuit_ripplecounter_dff is

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
S : in std_logic;
R : in std_logic;
C : in std_logic;
D : in STD_LOGIC;
Q1,Q2:inout STD_LOGIC);
end component FF_D_POSITIVE_EDGE;

component GATE_NOT is
generic (
delay_not : TIME := 1 ns
);
port (
A : in STD_LOGIC;
B : out STD_LOGIC
);
end component GATE_NOT;

constant RC_N : integer := 6;
constant RC_MAX : integer := 32;
signal rc_q : std_logic_vector(RC_N-1 downto 0) := (others => '0');
signal rc_ping,rc_mrb : std_logic;
signal ffd_d,ffd_q1,ffd_q2 : std_logic;
signal not1,not2 : std_logic;

begin

ffd_d <= i_input;
rc_mrb <= not2 xnor i_input;
o_output <= not1;

u0 : ripple_counter
Generic map (
N => RC_N,
MAX => RC_MAX
)
Port map (
i_clock => i_clock,
i_cpb => '1',
i_mrb => rc_mrb,
i_ud => '1',
o_q => rc_q,
o_ping => rc_ping
);

u1 : FF_D_POSITIVE_EDGE
port map (
S => i_reset,
R => '1',
C => rc_q(RC_N-1),
D => ffd_d,
Q1 => ffd_q1,
Q2 => ffd_q2
);

u2 : GATE_NOT
generic map (delay_not => 1 ps)
port map (
A => ffd_q1,
B => not1
);

u3 : GATE_NOT
generic map (delay_not => 1 ps)
port map (
A => not1,
B => not2
);

end Behavioral;
