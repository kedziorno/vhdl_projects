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
	signal T,A_not,B_not : std_logic;
begin
A_not <= not A;
B_not <= not B;
LUT2_inst : LUT2
generic map (
	INIT => "1110")
port map (
	O	=> C,
	I0 => A_not,
	I1 => B_not
);
--C <= T after delay_or2_bar;
end architecture GATE_OR2_BAR_LUT;