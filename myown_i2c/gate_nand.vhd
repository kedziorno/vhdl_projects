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

entity GATE_NAND is
Generic (
<<<<<<< HEAD
DELAY_NAND : time := 1 ps
=======
DELAY_NAND : time := 0 ps
>>>>>>> myown_i2c
);
Port (
A,B : in  STD_LOGIC;
C : out  STD_LOGIC
);
end GATE_NAND;

architecture GATE_NAND_BEHAVIORAL_1 of GATE_NAND is
	signal T : std_logic;
begin
<<<<<<< HEAD
T <= A nand B;
C <= T after DELAY_NAND;
end GATE_NAND_BEHAVIORAL_1;

architecture GATE_NAND_LUT of GATE_NAND is
--	signal T : std_logic;
=======
C <= A nand B after DELAY_NAND;
end GATE_NAND_BEHAVIORAL_1;

architecture GATE_NAND_LUT of GATE_NAND is
	signal T : std_logic;
>>>>>>> myown_i2c
begin
-- LUT2: 2-input Look-Up Table with general output
-- Spartan-3
-- Xilinx HDL Libraries Guide, version 14.7
gate_nand_LUT2_L : LUT2
generic map (
	INIT => "0111")
port map (
<<<<<<< HEAD
	O	=> C, -- LUT local output
=======
	O => T, -- LUT local output
>>>>>>> myown_i2c
	I0 => A, -- LUT input
	I1 => B -- LUT input
);
-- End of LUT2_inst instantiation
<<<<<<< HEAD
--C <= T after DELAY_NAND;
end architecture GATE_NAND_LUT;
=======
C <= T after DELAY_NAND;
end architecture GATE_NAND_LUT;
>>>>>>> myown_i2c
