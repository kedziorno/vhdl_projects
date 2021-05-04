library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_JK is
port (J,K,C:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
end entity FF_JK;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#JK_flip-flop
architecture Behavioral_FF_JK of FF_JK is
component GAND is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component FF_SR_NOR is
port (S,R:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
end component FF_SR_NOR;
--component GNOT is
--generic (delay_not : TIME := 0 ns);
--port (A:in STD_LOGIC;B:out STD_LOGIC);
--end component GNOT;
--for all : GNOT use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
--for all : FF_SR_NOR use entity WORK.FF_SR(Behavioral_NOR);
--for all : FF_SR_NOR use entity WORK.FF_SR(Behavioral_NAND);
--for all : FF_SR_NOR use entity WORK.FF_SR(Behavioral_ANDOR);
for all : FF_SR_NOR use entity WORK.FF_SR(Behavioral_NOT_S_NOT_R);
signal sa,sb,sc,sd: STD_LOGIC;
--signal n1,n2 : STD_LOGIC;
begin
g1: GAND port map (K,C,sa);
g2: GAND port map (sa,Q1,sb);
--gn1 : GNOT port map (sb,n1);
g3: GAND port map (C,J,sc);
g4: GAND port map (sc,Q2,sd);
--gn2 : GNOT port map (sd,n2);
g5: FF_SR_NOR port map (sb,sd,Q1,Q2);
end architecture Behavioral_FF_JK;
