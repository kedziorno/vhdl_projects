library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.all;

entity FF_SR is
port (S,R:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
end entity FF_SR;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#SR_NOR_latch
architecture Behavioral_NOR of FF_SR is
component GOR is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GOR;
component GN is
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GOR use entity WORK.GATE_OR(GATE_OR_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal a,b,c,d,e,f,g:STD_LOGIC;
begin
g1: GOR port map (S,Q2,g);
g2: GN port map (g,Q1);
g3: GOR port map (R,Q1,e);
g4: GN port map (e,Q2);
end architecture Behavioral_NOR;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#SR_NAND_latch
architecture Behavioral_NAND of FF_SR is
component GAND is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GN is
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal a,b,c,d,e,f,g:STD_LOGIC;
begin
g1: GAND port map (S,Q2,g);
g2: GN port map (g,Q1);
g3: GAND port map (R,Q1,e);
g4: GN port map (e,Q2);
end architecture Behavioral_NAND;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#SR_AND-OR_latch
architecture Behavioral_ANDOR of FF_SR is
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
signal a,b,c,d,e,f,g:STD_LOGIC;
begin
g1: GN port map (R,b);
g2: GOR port map (S,Q1,a);
g3: GAND port map (b,a,Q1);
end architecture Behavioral_ANDOR;

architecture Behavioral_NOT_S_NOT_R of FF_SR is
component GOR is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GOR;
component GN is
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GOR use entity WORK.GATE_OR(GATE_OR_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal a,b,c,d,e,f,g:STD_LOGIC;
begin
g1: GN port map (S,a);
g2: GN port map (R,b);
g3: GOR port map (a,d,Q1);
g4: GN port map (Q1,c);
g5: GOR port map (b,c,Q2);
g6: GN port map (Q2,d);
end architecture Behavioral_NOT_S_NOT_R;
