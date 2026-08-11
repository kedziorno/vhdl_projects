----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:15:22 01/08/2022 
-- Design Name: 
-- Module Name:    gate_nor3 - Behavioral 
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

entity GATE_NOR3 is
generic (
	delay_nor3 : TIME := 0 ns
);
port (
	A,B,C : in STD_LOGIC;
	D : out STD_LOGIC
);
end entity GATE_NOR3;

architecture GATE_NOR3_BEHAVIORAL_1 of GATE_NOR3 is
begin
--D <= not (A or B or C) after delay_nor3;
D <= ((A nor B) nor C) after delay_nor3;
end architecture GATE_NOR3_BEHAVIORAL_1;

architecture GATE_NOR3_LUT of GATE_NOR3 is
	signal T : std_logic;
begin
	LUT3_inst : LUT3
	generic map (
		INIT => "00000001")
	port map (
		O => T,
		I0 => A,
		I1 => B,
		I2 => C
	);
	D <= T after delay_nor3;
end architecture GATE_NOR3_LUT;
