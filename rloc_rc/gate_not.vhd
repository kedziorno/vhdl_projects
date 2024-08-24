library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity GATE_NOT is
generic (
delay_not : TIME := 1 ps
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

architecture GATE_NOT_LUT of GATE_NOT is
--	signal T : std_logic;
begin
	b0 : block
		attribute rloc : string;
		attribute rloc of gate_not_LUT1_D : label is "X0Y0";
		attribute h_set : string;
		attribute h_set of gate_not_LUT1_D : label is "rc/ffjk/gate_not_LUT1_D";
	begin
		gate_not_LUT1_D : LUT1_D
		generic map (
			INIT => "01")
		port map (
			LO => B,
			O => open,
			I0 => A
		);
	end block b0;
--	B <= T after delay_not;
end architecture GATE_NOT_LUT;
