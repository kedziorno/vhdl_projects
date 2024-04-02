----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:23:10 05/08/2021 
-- Design Name: 
-- Module Name:    universal_function - Behavioral 
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

-- generate 12 functions from 2
entity universal_function is
Port (
i_x1,i_x2 : in std_logic;
o_x1b,o_x2b : out std_logic;
o_x1b_or_x2b : out std_logic;
o_x1_and_x2 : out std_logic;
o_x1_or_x2b : out std_logic;
o_x1b_and_x2 : out std_logic;
o_x1_xor_x2 : out std_logic;
o_x1_eq_x2 : out std_logic;
o_x1b_or_x2 : out std_logic;
o_x1_and_x2b : out std_logic;
o_x1_or_x2 : out std_logic;
o_x1b_and_x2b : out std_logic
);
end universal_function;

architecture Behavioral of universal_function is
	signal s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14 : std_logic;
begin
	-- 3x7400
	s1 <= i_x1 nand i_x1;
	s2 <= i_x1;
	s3 <= i_x2 nand i_x2;
	s4 <= i_x2;
	s5 <= s2 nand s4;
	s6 <= s1 nand s4;
	s7 <= s2 nand s3;
	s8 <= s3 nand s1;
	s14 <= s13 nand s13;
	s9 <= s5 nand s5;
	s10 <= s6 nand s6;
	s13 <= s6 nand s7;
	s11 <= s7 nand s7;
	s12 <= s8 nand s8;
	o_x1b <= s1;
	o_x2b <= s3;
	o_x1b_or_x2b <= s5;
	o_x1_and_x2 <= s9;
	o_x1_or_x2b <= s6;
	o_x1b_and_x2 <= s10;
	o_x1_xor_x2 <= s13;
	o_x1_eq_x2 <= s14;
	o_x1b_or_x2 <= s7;
	o_x1_and_x2b <= s11;
	o_x1_or_x2 <= s8;
	o_x1b_and_x2b <= s12;
end Behavioral;
