----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:20:48 01/08/2022 
-- Design Name: 
-- Module Name:    gate_nor4 - Behavioral 
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

entity GATE_NOR4 is
generic (
	delay_nor4 : TIME := 0 ns
);
port (
	A,B,C,D : in STD_LOGIC;
	E : out STD_LOGIC
);
end entity GATE_NOR4;

architecture GATE_NOR4_BEHAVIORAL_1 of GATE_NOR4 is
begin
--E <= not (A or B or C or D) after delay_nor4;
E <= (((A nor B) nor C) nor D) after delay_nor4;
end architecture GATE_NOR4_BEHAVIORAL_1;

architecture GATE_NOR4_LUT of GATE_NOR4 is
	signal T : std_logic;
begin
	LUT4_inst : LUT4
	generic map (
		INIT => "0000000000000001")
	port map (
		O => T,
		I0 => A,
		I1 => B,
		I2 => C,
		I3 => D
	);
	E <= T after delay_nor4;
end architecture GATE_NOR4_LUT;
