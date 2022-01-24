<<<<<<< HEAD
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

entity GATE_NAND3 is
Generic (
DELAY_NAND3 : time := 1 ps
);
Port (
A,B,C : in  STD_LOGIC;
D : out  STD_LOGIC
);
end GATE_NAND3;

architecture GATE_NAND3_BEHAVIORAL_1 of GATE_NAND3 is
	signal T : std_logic;
begin
T <= not (A and B and C);
D <= T after DELAY_NAND3;
end GATE_NAND3_BEHAVIORAL_1;

architecture GATE_NAND3_LUT of GATE_NAND3 is
--	signal T : std_logic;
begin
-- LUT3_D: 3-input Look-Up Table with general and local outputs
-- Spartan-3
-- Xilinx HDL Libraries Guide, version 14.7
gate_nand3_LUT3_L : LUT3
generic map (
	INIT => "01111111")
port map (
	O => D, -- LUT local output
	I0 => A, -- LUT input
	I1 => B, -- LUT input
	I2 => C -- LUT input
);
-- End of LUT3_D_inst instantiation
--D <= T after DELAY_NAND3;
end architecture GATE_NAND3_LUT;
=======
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity GATE_NAND3 is
generic (
delay_nand3 : TIME := 0 ns
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
>>>>>>> myown_i2c
