----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:49:49 06/30/2021 
-- Design Name: 
-- Module Name:    schneider_circuit - Behavioral 
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

entity schneider_circuit is
port (
	x1,x2,x3,x4 : in std_logic;
	y : out std_logic
);
end schneider_circuit;

architecture Behavioral of schneider_circuit is
	signal g1,g2,g3,g4,g5,g6,g7 : std_logic;
begin
	g1 <= x1 nand x3;
	g2 <= x2 nand x3;
	g3 <= x2 nand x4;
	g4 <= g1 nand x2;
	g5 <= x1 nand g2;
	g6 <= x4 nand g2;
	g7 <= g3 nand x3;
	y <= not (g4 and g5 and g6 and g7);
end Behavioral;
