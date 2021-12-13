library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity GATE_NAND3 is
generic (
delay_nand3 : TIME := 1 ps
);
port (
A,B,C : in STD_LOGIC;
D : out STD_LOGIC
);
end entity GATE_NAND3;

architecture GATE_NAND3_BEHAVIORAL_1 of GATE_NAND3 is
begin
--C <= not (A and B and C) after delay_nand3;
D <= (A nand B) nand C after delay_nand3;
end architecture GATE_NAND3_BEHAVIORAL_1;

architecture GATE_NAND3_LUT of GATE_NAND3 is
	signal T : std_logic;
begin
LUT3_inst : LUT3
generic map (
	INIT => "01111111")
port map (
	O => T,
	I0 => A,
	I1 => B,
	I2 => C
);
D <= T after delay_nand3;
end architecture GATE_NAND3_LUT;
