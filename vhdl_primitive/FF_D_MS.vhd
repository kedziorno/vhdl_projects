library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_D_MASTER_SLAVE is
port (C,D:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
end entity FF_D_MASTER_SLAVE;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Master%E2%80%93slave_edge-triggered_D_flip-flop
architecture Behavioral_D_MS of FF_D_MASTER_SLAVE is
component GAND is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GN is
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal X,Y,Z,U,V,W,O,P,sa,sb,sc,sd,se,sf,sg,sh:STD_LOGIC;
begin
g1: GN port map (C,X);
g2: GAND port map (D,X,sa); g3: GN port map(sa,Y);
g4: GN port map (X,U);
g5: GAND port map (X,Y,sb); g6: GN port map(sb,V);
g7: GAND port map (Y,W,sc); g8: GN port map(sc,Z);
g9: GAND port map (V,Z,sd); g10: GN port map(sd,W);
g11: GAND port map (Z,U,se); g12: GN port map(se,O);
g13: GAND port map (O,U,sf); g14: GN port map(sf,P);
g15: GAND port map (O,Q2,sg); g16: GN port map(sg,Q1);
g17: GAND port map (P,Q1,sh); g18: GN port map(sh,Q2);
end architecture Behavioral_D_MS;
