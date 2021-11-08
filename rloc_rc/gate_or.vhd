library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity GATE_OR is
generic (
delay_or : TIME := 1 ps
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

architecture GATE_OR_LUT of GATE_OR is
--	signal T : std_logic;
begin
	b0 : block
		attribute rloc : string;
		attribute rloc of "gate_or_LUT2_D" : label is "X0Y0";
		attribute hu_set : string;
		attribute hu_set of "gate_or_LUT2_D" : label is "rc/ffjk/gate";
	begin
		gate_or_LUT2_D : LUT2_D
		generic map (
			INIT => "1110")
		port map (
			O => open,
			LO => C,
			I0 => A,
			I1 => B
		);
	end block b0;
--	C <= T after delay_or;
end architecture GATE_OR_LUT;
