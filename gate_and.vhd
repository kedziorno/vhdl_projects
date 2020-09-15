library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GATE_AND is
generic (delay:TIME := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end entity GATE_AND;

architecture GATE_AND_BEHAVIORAL_1 of GATE_AND is
begin
C <= transport A and B after delay;
end architecture GATE_AND_BEHAVIORAL_1;
