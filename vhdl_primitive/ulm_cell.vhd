----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:33:12 05/08/2021 
-- Design Name: 
-- Module Name:    ulm_cell - Behavioral 
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

entity ulm_cell is
Port (
a,b,c : in std_logic;
f1,f2 : out std_logic
);
end ulm_cell;

architecture Behavioral of ulm_cell is
	signal s1,s2,s3,s4 : std_logic; -- f=ACb+BC
begin
	s1 <= not c;
	s2 <= s1 nand a;
	s3 <= c nand b;
	s4 <= s2 nand s3;
	f1 <= s4;
	f2 <= s4;
end Behavioral;
