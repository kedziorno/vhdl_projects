----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:37:18 04/23/2021 
-- Design Name: 
-- Module Name:    big_full_adder - Behavioral 
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

entity big_full_adder is
port (
	a,b : in std_logic_vector(31 downto 0);
	cin : in std_logic;
	sum : out std_logic_vector(31 downto 0);
	cout : out std_logic
);
end big_full_adder;

architecture Behavioral of big_full_adder is
	component carry_lookahead_adder is
	Port (
		a,b : in std_logic_vector(3 downto 0);
		cin : in std_logic;
		sum : out std_logic_vector(3 downto 0);
		cout : out std_logic
	);
	end component carry_lookahead_adder;
	signal carry : std_logic_vector(8 downto 0);
begin
	carry(0) <= cin;
	chain : for i in 1 to 8 generate
		adder : carry_lookahead_adder port map (
			a(4*i-1 downto 4*i-4),
			b(4*i-1 downto 4*i-4),
			carry(i-1),
			sum(4*i-1 downto 4*i-4),
			carry(i)
		);
	end generate chain;
	cout <= carry(8);
end Behavioral;
