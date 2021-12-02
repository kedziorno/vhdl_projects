library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity GATE_AND3 is
generic (
delay_and3 : TIME := 1 ps
);
port (
A,B,C : in STD_LOGIC;
D : out STD_LOGIC
);
end entity GATE_AND3;

architecture GATE_AND3_BEHAVIORAL_1 of GATE_AND3 is
begin
D <= (A and B and C) after delay_and3;
end architecture GATE_AND3_BEHAVIORAL_1;

architecture GATE_AND3_LUT of GATE_AND3 is
	signal T : std_logic;
begin
LUT3_inst : LUT3
generic map (
	INIT => "10000000")
port map (
	O	=> T,
	I0 => A,
	I1 => B,
	I2 => C
);
D <= T after delay_and3;
end architecture GATE_AND3_LUT;
