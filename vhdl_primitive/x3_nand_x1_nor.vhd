----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:58:51 04/19/2021 
-- Design Name: 
-- Module Name:    x3_nand_x1_nor - Behavioral 
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

entity x3_nand_x1_nor is
Port (
A : in  STD_LOGIC;
B : in  STD_LOGIC;
Q : out  STD_LOGIC
);
end x3_nand_x1_nor;

architecture Behavioral of x3_nand_x1_nor is
	signal g_nand1,g_nand2,g_nand3,g_nor1 : std_logic; -- XXX 0,1=1
begin
	process (A,B) is
	begin
		g_nand1 <= A nand B;
		g_nand2 <= g_nand1 nand A;
		g_nand3 <= g_nand1 nand B;
		Q <= g_nand2 nor g_nand3;
	end process;
end Behavioral;
