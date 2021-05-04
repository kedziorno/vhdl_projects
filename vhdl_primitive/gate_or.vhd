library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GATE_OR is
generic (
delay_or : TIME := 1 ns
);
port (
A,B : in STD_LOGIC;
C : out STD_LOGIC
);
end entity GATE_OR;

architecture GATE_OR_BEHAVIORAL_1 of GATE_OR is
begin
C <= A or B after delay_or;
end architecture GATE_OR_BEHAVIORAL_1;
