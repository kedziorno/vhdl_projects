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
	b0 : block
		attribute rloc : string;
		attribute rloc of "gate_nand3_LUT3_D" : label is "X0Y0";
	begin
		gate_nand3_LUT3_D : LUT3_D
		generic map (
			INIT => "01111111")
		port map (
			LO => D,
			O => open,
			I0 => A,
			I1 => B,
			I2 => C
		);
	end block b0;
--	D <= T after DELAY_NAND3;
end architecture GATE_NAND3_LUT;