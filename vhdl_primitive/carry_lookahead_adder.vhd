----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:25:46 04/23/2021 
-- Design Name: 
-- Module Name:    carry_lookahead_adder - Behavioral 
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

entity carry_lookahead_adder is
Port (
	a,b : in std_logic_vector(3 downto 0);
	cin : in std_logic;
	sum : out std_logic_vector(3 downto 0);
	cout : out std_logic
);
end carry_lookahead_adder;

architecture Behavioral of carry_lookahead_adder is
	signal G,P,c : std_logic_vector(3 downto 0);
begin
	G <= a and b;
	P <= a xor b;
	c(0) <= cin;
	c(1) <= g(0) or (p(0) and cin);
	c(2) <= g(1) or (p(1) and g(0)) or (p(1) and p(0) and cin);
	c(3) <= g(2) or (p(2) and g(1)) or (p(2) and p(1) and g(0)) or (p(2) and p(1) and p(0) and cin);
	cout <= g(3) or (p(3) and g(2)) or (p(3) and p(2) and g(1)) or (p(3) and p(2) and p(1) and g(0)) or (p(3) and p(2) and p(1) and p(0) and cin);
	sum <= P xor c;
end Behavioral;
