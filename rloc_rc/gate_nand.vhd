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
DELAY_NAND : time := 1 ps
);
Port (
A,B : in  STD_LOGIC;
C : out  STD_LOGIC
);
end GATE_NAND;

architecture GATE_NAND_BEHAVIORAL_1 of GATE_NAND is
	signal T : std_logic;
begin
T <= A nand B;
C <= T after DELAY_NAND;
end GATE_NAND_BEHAVIORAL_1;

architecture GATE_NAND_LUT of GATE_NAND is
--	signal T : std_logic;
begin
	b0 : block
		attribute rloc : string;
		attribute rloc of "gate_nand_LUT2_D" : label is "X0Y0";
		attribute hu_set : string;
		attribute hu_set of "gate_nand_LUT2_D" : label is "rc/ffjk/gate";
	begin
		gate_nand_LUT2_D : LUT2_D
		generic map (
			INIT => "0111")
		port map (
			LO => C,
			O	=> open,
			I0 => A,
			I1 => B
		);
	end block b0;
--	C <= T after DELAY_NAND;
end architecture GATE_NAND_LUT;