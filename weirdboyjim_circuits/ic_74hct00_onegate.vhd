----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:41:21 11/28/2021 
-- Design Name: 
-- Module Name:    ic_74hct32_onegate - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity ic_74hct00_onegate is
port (
	signal i_A,i_B : in std_logic;
	signal o_Y : out std_logic
);
end ic_74hct00_onegate;

-- https://assets.nexperia.com/documents/data-sheet/74HC_HCT00.pdf
architecture Behavioral of ic_74hct00_onegate is

	component GATE_NOR2 is
		generic (
			delay_nor2 : TIME := 1 ps
		);
		port (
			A,B : in STD_LOGIC;
			C : out STD_LOGIC
		);
	end component GATE_NOR2;
	for all : GATE_NOR2 use entity WORK.GATE_NOR2(GATE_NOR2_LUT);

	component GATE_NOT is
		generic (
			delay_not : TIME := 1 ps
		);
		port (
			A : in STD_LOGIC;
			B : out STD_LOGIC
		);
	end component GATE_NOT;
	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);

	signal not1a,not1b,nor2out,not2,not3 : std_logic;

begin

	inst_not1a : GATE_NOT port map (A => i_A, B => not1a);
	inst_not1b : GATE_NOT port map (A => i_B, B => not1b);
	inst_nand2 : GATE_NOR2 port map (A => not1a, B => not1b, C => nor2out);
	inst_not2 : GATE_NOT port map (A => nor2out, B => not2);
	o_Y <= not2;

end Behavioral;
