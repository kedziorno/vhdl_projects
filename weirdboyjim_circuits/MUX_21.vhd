library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_21 is
generic (
delay_and : TIME := 0 ns;
delay_or : TIME := 0 ns;
delay_not : TIME := 0 ns
);
port (
S,A,B:in STD_LOGIC;
C:out STD_LOGIC
);
end entity MUX_21;

architecture MUX_21_LUT_1 of MUX_21 is
component GAND is
generic (delay_and : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GOR is
generic (delay_or : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GOR;
component GN is
generic (delay_not : time := 0 ns);
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_LUT);
for all : GOR use entity WORK.GATE_OR(GATE_OR_LUT);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_LUT);
signal sa,sb,sc : STD_LOGIC;
begin
g1: GN generic map (delay_not) port map (S,sa);
g3: GAND generic map (delay_and) port map (A,S,sb);
g4: GAND generic map (delay_and) port map (B,sa,sc);
g5: GOR generic map (delay_or) port map (sb,sc,C);
end architecture MUX_21_LUT_1;
