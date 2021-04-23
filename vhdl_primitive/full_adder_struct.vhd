----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:28:26 04/23/2021 
-- Design Name: 
-- Module Name:    full_adder_struct - struct 
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

entity full_adder_struct is
Port (
	a,b,cin : in std_logic;
	s,cout : out std_logic
);
end full_adder_struct;

architecture struct of full_adder_struct is
begin
	s <= a xor b xor cin;
	cout <= (a and b) or (a and cin) or (b and cin);
end struct;
