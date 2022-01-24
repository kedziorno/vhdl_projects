library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity GATE_OR is
generic (
<<<<<<< HEAD
delay_or : TIME := 1 ps
=======
delay_or : TIME := 0 ns
>>>>>>> myown_i2c
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
<<<<<<< HEAD
--	signal T : std_logic;
=======
	signal T : std_logic;
>>>>>>> myown_i2c
begin
-- LUT2: 2-input Look-Up Table with general output
-- Spartan-3
-- Xilinx HDL Libraries Guide, version 14.7
<<<<<<< HEAD
gate_or_LUT2_L : LUT2
generic map (
	INIT => "1110")
port map (
	O	=> C, -- LUT local output
=======
LUT2_inst : LUT2
generic map (
	INIT => "1110")
port map (
	O => T, -- LUT general output
>>>>>>> myown_i2c
	I0 => A, -- LUT input
	I1 => B -- LUT input
);
-- End of LUT2_inst instantiation
<<<<<<< HEAD
--C <= T after delay_or;
=======
C <= T after delay_or;
>>>>>>> myown_i2c
end architecture GATE_OR_LUT;
