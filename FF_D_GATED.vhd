library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_D_GATED is
port (D,E:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
end entity FF_D_GATED;
 
-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Gated_D_latch
architecture Behavioral_GATED_D_NAND of FF_D_GATED is
component GAND is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GN is
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal sa,sb,sc,sd,se,sf,sg:STD_LOGIC;
begin
g1: GAND port map (D,E,sa);
g2: GN port map (sa,sb);
g3: GAND port map (E,sb,sc);
g4: GN port map (sc,sd);
g5: GAND port map (sb,Q2,sg);
g6: GN port map (sg,Q1);
g7: GAND port map (sd,Q1,se);
g8: GN port map (se,Q2);
end architecture Behavioral_GATED_D_NAND;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Gated_D_latch
architecture Behavioral_GATED_D_NOR of FF_D_GATED is
component GAND is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GOR is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GOR;
component GN is
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : GOR use entity WORK.GATE_OR(GATE_OR_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal sa,sb,sc,sd,se,sf,sg:STD_LOGIC;
begin
g1: GN port map (D,sa);
g2: GAND port map (sa,E,sb);
g3: GAND port map (D,E,sc);
g4: GOR port map (sb,Q2,sg);
g5: GN port map (sg,Q1);
g6: GOR port map (sc,Q1,se);
g7: GN port map (se,Q2);
end architecture Behavioral_GATED_D_NOR;
