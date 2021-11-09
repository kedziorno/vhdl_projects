----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:50:05 09/12/2021 
-- Design Name: 
-- Module Name:    gate_and3 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity GATE_NAND4 is
Generic (
DELAY_NAND4 : time := 1 ps
);
Port (
A,B,C,D : in  STD_LOGIC;
E : out  STD_LOGIC
);
end GATE_NAND4;

architecture GATE_NAND4_BEHAVIORAL_1 of GATE_NAND4 is
	signal T : std_logic;
begin
T <= not (A and B and C and D);
E <= T after DELAY_NAND4;
end GATE_NAND4_BEHAVIORAL_1;

architecture GATE_NAND4_LUT of GATE_NAND4 is
--	signal T : std_logic;
begin
	b0 : block
		attribute rloc : string;
		attribute rloc of "gate_nand4_LUT4_D" : label is "X0Y0";
		attribute h_set : string;
		attribute h_set of "gate_nand4_LUT4_D" : label is "rc/ffjk/gate_nand4_LUT4_D";
	begin
		gate_nand4_LUT4_D : LUT4_D
		generic map (
			INIT => X"7FFF")
		port map (
			LO => E,
			O => open,
			I0 => A,
			I1 => B,
			I2 => C,
			I3 => D
		);
	end block b0;
--	E <= T after DELAY_NAND4;
end architecture GATE_NAND4_LUT;