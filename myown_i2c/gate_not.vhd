library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity GATE_NOT is
generic (
<<<<<<< HEAD
delay_not : TIME := 1 ps
=======
delay_not : TIME := 0 ns
>>>>>>> myown_i2c
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
<<<<<<< HEAD
--	signal T : std_logic;
begin
---- LUT2: 2-input Look-Up Table with general output
---- Spartan-3
---- Xilinx HDL Libraries Guide, version 14.7
--LUT2_inst : LUT2_L
--generic map (
--	INIT => "0001")
--port map (
--	LO	=> T, -- LUT local output
--	I0 => A, -- LUT input
--	I1 => A -- LUT input
--);
---- End of LUT2_inst instantiation
-- LUT1_L: 1-input Look-Up Table with local output
-- Spartan-3
-- Xilinx HDL Libraries Guide, version 14.7
gate_not_LUT1_L : LUT1
generic map (
	INIT => "01")
port map (
	O => B, -- LUT local output
	I0 => A -- LUT input
); -- End of LUT1_L_inst instantiation
--B <= T after delay_not;
=======
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
>>>>>>> myown_i2c
end architecture GATE_NOT_LUT;
