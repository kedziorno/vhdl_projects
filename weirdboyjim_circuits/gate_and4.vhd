library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity GATE_AND4 is
generic (
delay_and4 : TIME := 1 ps
);
port (
A,B,C,D : in STD_LOGIC;
E : out STD_LOGIC
);
end entity GATE_AND4;

architecture GATE_AND4_BEHAVIORAL_1 of GATE_AND4 is
begin
E <= A and B and C and D after delay_and4;
end architecture GATE_AND4_BEHAVIORAL_1;

architecture GATE_AND4_LUT of GATE_AND4 is
	signal T : std_logic;
begin
LUT4_inst : LUT4
generic map (
	INIT => "1000000000000000")
port map (
	O	=> E,
	I0 => A,
	I1 => B,
	I2 => C,
	I3 => D
);
--E <= T after delay_and4;
end architecture GATE_AND4_LUT;
