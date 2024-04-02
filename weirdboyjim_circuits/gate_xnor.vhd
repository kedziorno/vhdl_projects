library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GATE_XNOR is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end entity GATE_XNOR;

architecture GATE_XNOR_BEHAVIORAL_1 of GATE_XNOR is
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
signal sa,sb,sc,sd,se,sf,sg: STD_LOGIC;
begin
g1: GN port map (A,sa);
g2: GN port map (B,sb);
g3: GAND port map (A,B,sc);
g4: GAND port map (sa,sb,sd);
g5: GOR port map (sc,sd,C);
end architecture GATE_XNOR_BEHAVIORAL_1;

architecture GATE_XNOR_LUT of GATE_XNOR is
component GAND is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GOR is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GOR;
component GN is
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_LUT);
for all : GOR use entity WORK.GATE_OR(GATE_OR_LUT);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_LUT);
signal sa,sb,sc,sd,se,sf,sg: STD_LOGIC;
begin
g1: GN port map (A,sa);
g2: GN port map (B,sb);
g3: GAND port map (A,B,sc);
g4: GAND port map (sa,sb,sd);
g5: GOR port map (sc,sd,C);
end architecture GATE_XNOR_LUT;
