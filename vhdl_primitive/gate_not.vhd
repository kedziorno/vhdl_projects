library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GATE_NOT is
generic (
delay_not : TIME := 0 ns
);
port (
A : in STD_LOGIC;
B : out STD_LOGIC
);
end entity GATE_NOT;

architecture GATE_NOT_BEHAVIORAL_1 of GATE_NOT is
begin
B <= not A after delay_not;
end architecture GATE_NOT_BEHAVIORAL_1;
