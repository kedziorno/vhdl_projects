library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity GATE_OR2_BAR is
generic (
delay_or2_bar : TIME := 1 ps
);
port (
A,B : in STD_LOGIC;
C : out STD_LOGIC
);
end entity GATE_OR2_BAR;

architecture GATE_OR2_BAR_BEHAVIORAL_1 of GATE_OR2_BAR is
begin
C <= (not A) or (not B) after delay_or2_bar;
end architecture GATE_OR2_BAR_BEHAVIORAL_1;

architecture GATE_OR2_BAR_LUT of GATE_OR2_BAR is
	signal T : std_logic;
begin
LUT2_inst : LUT2
generic map (
	INIT => "1110")
port map (
	O	=> T,
	I0 => not A,
	I1 => not B
);
C <= T after delay_or2_bar;
end architecture GATE_OR2_BAR_LUT;