library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_D_POSITIVE_EDGE is
port (C,D:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
end entity FF_D_POSITIVE_EDGE;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Classical_positive-edge-triggered_D_flip-flop
architecture Behavioral_D_PE of FF_D_POSITIVE_EDGE is
component GAND is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GN is
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal X,Y,Z,V,W,O,sa,sb,sc,sd,se,sf:STD_LOGIC;
begin
g1: GAND port map (D,X,sa); g2: GN port map(sa,Y);
g3: GAND port map (Y,O,sb); g4: GN port map(sb,X);
g5: GAND port map (C,V,sc); g6: GN port map(sc,Z);
g7: GAND port map (Z,Y,sd); g8: GN port map(sd,V);
g9: GAND port map (Z,Q2,se); gA: GN port map(se,Q1);
gB: GAND port map (X,Q1,sf); gC: GN port map(sf,Q2);
gD: GAND port map (C,Z,O);
end architecture Behavioral_D_PE;
