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
--	process (A,B,g_nand1,g_nand2,g_nand3) is
	process (A,B) is
--    variable g_nand1,g_nand2,g_nand3,g_nor1 : std_logic; -- XXX 0,1=1
	begin
--    Q <= ((A nand B) nand A) nor ((A nand B) nand B) after 1 ns;
		g_nand1 <= A nand B after 10 ns;
		g_nand2 <= g_nand1 nand A after 10 ns;
		g_nand3 <= g_nand1 nand B after 10 ns;
    Q <= g_nand2 nor g_nand3 after 10 ns;
	end process;
end Behavioral;
