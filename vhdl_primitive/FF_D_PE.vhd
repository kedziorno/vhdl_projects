library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_D_POSITIVE_EDGE is
port (C,D:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
end entity FF_D_POSITIVE_EDGE;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Classical_positive-edge-triggered_D_flip-flop
architecture Behavioral_D_PE of FF_D_POSITIVE_EDGE is
component GAND is
generic (delay_and:time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GN is
generic (delay_not:time := 0 ns);
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal X,Y,Z,V,W,O,sa,sb,sc,sd,se,sf:STD_LOGIC;
constant DELAY_AND : time := 1 ps;
constant DELAY_NOT : time := 1 ps;
begin
g1: GAND generic map (DELAY_AND) port map (D,X,sa);
g2: GN generic map (DELAY_NOT) port map(sa,Y);
g3: GAND generic map (DELAY_AND) port map (Y,O,sb);
g4: GN generic map (DELAY_NOT) port map(sb,X);
g5: GAND generic map (DELAY_AND) port map (C,V,sc);
g6: GN generic map (DELAY_NOT) port map(sc,Z);
g7: GAND generic map (DELAY_AND) port map (Z,Y,sd);
g8: GN generic map (DELAY_NOT) port map(sd,V);
g9: GAND generic map (DELAY_AND) port map (Z,Q2,se);
gA: GN generic map (DELAY_NOT) port map(se,Q1);
gB: GAND generic map (DELAY_AND) port map (X,Q1,sf);
gC: GN generic map (DELAY_NOT) port map(sf,Q2);
gD: GAND generic map (DELAY_AND) port map (C,Z,O);
end architecture Behavioral_D_PE;
