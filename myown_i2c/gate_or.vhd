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
	signal T : std_logic;
begin
-- LUT2: 2-input Look-Up Table with general output
-- Spartan-3
-- Xilinx HDL Libraries Guide, version 14.7
LUT2_inst : LUT2
generic map (
	INIT => "1110")
port map (
	O	=> T, -- LUT general output
	I0 => A, -- LUT input
	I1 => B -- LUT input
);
-- End of LUT2_inst instantiation
C <= T after delay_or;
end architecture GATE_OR_LUT;
