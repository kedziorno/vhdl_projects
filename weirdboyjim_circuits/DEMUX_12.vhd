library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DEMUX_12 is
port (S,A:in STD_LOGIC;B,C:out STD_LOGIC);
end entity DEMUX_12;

architecture DEMUX_12_BEHAVIORAL_1 of DEMUX_12 is
component GAND is
generic (delay_and : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GOR is
generic (delay_or : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GOR;
component GN is
generic (delay_not : time := 0 ns);
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_LUT);
for all : GOR use entity WORK.GATE_OR(GATE_OR_LUT);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_LUT);
signal sa : STD_LOGIC;
begin
g1: GN port map (S,sa);
g3: GAND port map (A,S,B);
g4: GAND port map (A,sa,C);
end architecture DEMUX_12_BEHAVIORAL_1;
