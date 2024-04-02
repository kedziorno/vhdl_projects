----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:31:13 04/23/2021 
-- Design Name: 
-- Module Name:    carry_ripple_adder - Behavioral 
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

entity carry_ripple_adder is
Generic (
	N : integer := 8
);
Port (
	a,b : in std_logic_vector(N-1 downto 0);
	cin : in std_logic;
	s : out std_logic_vector(N-1 downto 0);
	cout : out std_logic
);
end carry_ripple_adder;

architecture struct of carry_ripple_adder is
	signal carry : std_logic_vector(N-1 downto 0);
	component full_adder_struct is
	Port (
		a,b,cin : in std_logic;
		s,cout : out std_logic
	);
	end component full_adder_struct;
begin
	carry(0) <= cin;
	fa_chain : for i in a'range generate
		fa : full_addrer_struct PORT MAP (a(i),b(i),carry(i),s(i),carry(i+1));
	end generate fa_chain;
	cout <= carry(N);
end architecture struct;

architecture behavioral of carry_ripple_addrer is
begin
	p0 : process (a,b,cin) is
		variable carry : std_logic_vector(N downto 0);
	begin
		carry(0) := cin;
		l0 : for i in 0 to N-1 loop
			s(i) <= a(i) xor b(i) xor carry(i);
			carry(i+1) := (a(i) and b(i)) or (a(i) and carry(i)) or (b(i) and carry(i));
		end loop l0;
		cout <= carry(N);
	end process p0;
end architecture behavioral;
