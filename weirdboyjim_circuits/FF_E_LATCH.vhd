library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_E_LATCH is
port (D,E_H,E_L:in STD_LOGIC;Q:inout STD_LOGIC);
end entity FF_E_LATCH;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Earle_latch
architecture Behavioral_E_LATCH of FF_E_LATCH is
component GAND is
generic (delay_and : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GN is
generic (delay_not : time := 1 ns);
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal sa,sb,sc,sd,se,sf,sg,sh,si:STD_LOGIC;
begin
g1: GAND port map (E_H,D,sa);
g2: GN port map (sa,sb);
g3: GAND port map (D,Q,sc);
g4: GN port map (sc,sd);
g5: GAND port map (Q,E_L,se);
g6: GN port map (se,sf);
g7: GAND port map (sb,sd,sg);
g8: GAND port map (sf,sg,sh);
g9: GN port map (sh,Q);
end architecture Behavioral_E_LATCH;
