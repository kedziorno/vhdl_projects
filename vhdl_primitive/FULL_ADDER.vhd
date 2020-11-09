library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FULL_ADDER is
port (A,B,Cin:in STD_LOGIC;S,Cout:out STD_LOGIC);
end entity FULL_ADDER;

architecture FULL_ADDER_BEHAVIORAL_1 of FULL_ADDER is
component HA is
port (A,B:in STD_LOGIC;S,C:out STD_LOGIC);
end component HA;
component GOR is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GOR;
for all : HA use entity WORK.HALF_ADDER(HALF_ADDER_BEHAVIORAL_1);
for all : GOR use entity WORK.GATE_OR(GATE_OR_BEHAVIORAL_1);
signal sa,sb,sc: STD_LOGIC;
begin
g1 : HA port map (A,B,sa,sb);
g2 : HA port map (sa,Cin,S,sc);
g3 : GOR port map (sb,sc,Cout);
end architecture FULL_ADDER_BEHAVIORAL_1;
