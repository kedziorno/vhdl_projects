library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_21 is
port (S,A,B:in STD_LOGIC;C:out STD_LOGIC);
end entity MUX_21;

architecture MUX_21_BEHAVIORAL_1 of MUX_21 is
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
signal sa,sb,sc,sd: STD_LOGIC;
begin
g1: GN port map (S,sa);
g3: GAND port map (A,S,sc);
g4: GAND port map (B,sa,sd);
g5: GOR port map (sc,sd,C);
end architecture MUX_21_BEHAVIORAL_1;
