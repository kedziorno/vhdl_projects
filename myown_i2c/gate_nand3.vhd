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
