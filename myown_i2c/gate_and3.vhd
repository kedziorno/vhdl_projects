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

entity GATE_AND3 is
Generic (
DELAY_AND3 : time := 1 ps
);
Port (
A,B,C : in  STD_LOGIC;
D : out  STD_LOGIC
);
end GATE_AND3;

architecture GATE_AND3_BEHAVIORAL_1 of GATE_AND3 is
	signal T : std_logic;
begin
T <= A and B and C;
D <= T after DELAY_AND3;
end GATE_AND3_BEHAVIORAL_1;

architecture GATE_AND3_LUT of GATE_AND3 is
	signal T : std_logic;
begin
-- LUT3_D: 3-input Look-Up Table with general and local outputs
-- Spartan-3
-- Xilinx HDL Libraries Guide, version 14.7
LUT3_D_inst : LUT3_D
generic map (
	INIT => "10000000")
port map (
	LO => open, -- LUT local output to the same CLB or FCB
	O => T, -- LUT general output
	I0 => A, -- LUT input
	I1 => B, -- LUT input
	I2 => C -- LUT input
);
-- End of LUT3_D_inst instantiation
D <= T after DELAY_AND3;
end architecture GATE_AND3_LUT;