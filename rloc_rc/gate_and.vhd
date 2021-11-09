library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity GATE_AND is
generic (
delay_and : TIME := 1 ps
);
port (
A,B : in STD_LOGIC;
C : out STD_LOGIC
);
end entity GATE_AND;

architecture GATE_AND_BEHAVIORAL_1 of GATE_AND is
begin
C <= A and B after delay_and;
end architecture GATE_AND_BEHAVIORAL_1;

architecture GATE_AND_LUT of GATE_AND is
--	signal T : std_logic;
begin
	b0 : block
		attribute rloc : string;
		attribute rloc of "gate_and_LUT2_D" : label is "X0Y0";
		attribute h_set : string;
		attribute h_set of "gate_and_LUT2_D" : label is "rc/ffjk/gate_and_LUT2_D";
	begin
		gate_and_LUT2_D : LUT2_D
		generic map (
			INIT => "1000")
		port map (
			LO => C,
			O	=> open,
			I0 => A,
			I1 => B
		);
	end block b0;
--	C <= T after delay_and;
end architecture GATE_AND_LUT;
