library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HALF_ADDER is
port (A,B:in STD_LOGIC;S,C:out STD_LOGIC);
end entity HALF_ADDER;

architecture HALF_ADDER_BEHAVIORAL_1 of HALF_ADDER is
component GXOR is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GXOR;
component GAND is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
for all : GXOR use entity WORK.GATE_XOR(GATE_XOR_BEHAVIORAL_1);
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
begin
g1 : GXOR port map (A,B,S);
g2 : GAND port map (A,B,C);
end architecture HALF_ADDER_BEHAVIORAL_1;
