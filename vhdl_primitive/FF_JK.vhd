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
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : FF_SR_NOR use entity WORK.FF_SR(Behavioral_NOR);
signal sa,sb,sc,sd: STD_LOGIC;
begin
g1: GAND port map (K,C,sa);
g2: GAND port map (sa,Q1,sb);
g3: GAND port map (C,J,sc);
g4: GAND port map (sc,Q2,sd);
g5: FF_SR_NOR port map (sb,sd,Q1,Q2);
end architecture Behavioral_FF_JK;
