library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_21 is
generic (
delay_and : TIME := 0 ns;
delay_or : TIME := 0 ns;
delay_not : TIME := 0 ns
);
port (
S,A,B:in STD_LOGIC;
C:out STD_LOGIC
);
end entity MUX_21;

architecture MUX_21_LUT_1 of MUX_21 is
component GATE_AND is
generic (delay_and : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GATE_AND;
component GATE_OR is
generic (delay_or : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GATE_OR;
component GATE_NOT is
generic (delay_not : time := 0 ns);
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GATE_NOT;
--for all : GATE_AND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : GATE_AND use entity WORK.GATE_AND(GATE_AND_LUT);
--for all : GATE_OR use entity WORK.GATE_OR(GATE_OR_BEHAVIORAL_1);
for all : GATE_OR use entity WORK.GATE_OR(GATE_OR_LUT);
--for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);
signal sa,sb,sc : STD_LOGIC;
begin
g1: GATE_NOT generic map (delay_not) port map (S,sa);
g3: GATE_AND generic map (delay_and) port map (B,S,sb);
g4: GATE_AND generic map (delay_and) port map (A,sa,sc);
g5: GATE_OR  generic map (delay_or)  port map (sb,sc,C);
end architecture MUX_21_LUT_1;
