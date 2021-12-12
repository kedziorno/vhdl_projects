library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity GATE_NAND2 is
generic (
delay_nand2 : TIME := 1 ps
);
port (
A,B : in STD_LOGIC;
C : out STD_LOGIC
);
end entity GATE_NAND2;

architecture GATE_NAND2_BEHAVIORAL_1 of GATE_NAND2 is
begin
--C <= not (A and B) after delay_nand2;
C <= A nand B after delay_nand2;
end architecture GATE_NAND2_BEHAVIORAL_1;

architecture GATE_NAND2_LUT of GATE_NAND2 is
	signal T : std_logic;
begin
-- LUT2: 2-input Look-Up Table with general output
-- Spartan-3
-- Xilinx HDL Libraries Guide, version 14.7
LUT2_inst : LUT2
generic map (
	INIT => "0111")
port map (
	O	=> C, -- LUT general output
	I0 => A, -- LUT input
	I1 => B -- LUT input
);
-- End of LUT2_inst instantiation
--C <= T after delay_nand2;
end architecture GATE_NAND2_LUT;
