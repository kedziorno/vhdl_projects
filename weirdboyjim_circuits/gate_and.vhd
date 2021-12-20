library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity GATE_AND is
generic (
delay_and : TIME := 0 ps
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
	signal T : std_logic;
begin
-- LUT2: 2-input Look-Up Table with general output
-- Spartan-3
-- Xilinx HDL Libraries Guide, version 14.7
LUT2_inst : LUT2
generic map (
	INIT => "1000")
port map (
	O => T, -- LUT general output
	I0 => A, -- LUT input
	I1 => B -- LUT input
);
-- End of LUT2_inst instantiation
C <= T after delay_and;
end architecture GATE_AND_LUT;
