library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity GATE_NOT is
generic (
delay_not : TIME := 0 ps
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
	signal T : std_logic;
begin
-- LUT2: 2-input Look-Up Table with general output
-- Spartan-3
-- Xilinx HDL Libraries Guide, version 14.7
LUT2_inst : LUT2
generic map (
	INIT => "0001")
port map (
	O => T, -- LUT general output
	I0 => A, -- LUT input
	I1 => A -- LUT input
);
-- End of LUT2_inst instantiation
B <= T after delay_not;
end architecture GATE_NOT_LUT;
