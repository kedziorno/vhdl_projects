----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:26:55 04/28/2021 
-- Design Name: 
-- Module Name:    ones_detector - Behavioral 
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

entity ones_detector is
Generic (
	N : integer := 16
);
Port (
	x : in std_logic_vector(N-1 downto 1);
	y : out std_logic_vector(3 downto 0)
);
end ones_detector;

architecture Behavioral of ones_detector is

	component FULL_ADDER is
	port (A,B,Cin:in STD_LOGIC;S,Cout:out STD_LOGIC);
	end component FULL_ADDER;

signal s0,c0 : std_logic_vector(N-1 downto 0);
signal s1,c1 : std_logic_vector(N-1 downto 0);
signal s2,c2 : std_logic_vector(N-1 downto 0);
begin

g0 : for i in 1 to (N/2)-1 generate
	g00 : if (i=1) generate
		fa : FULL_ADDER port map (
		A=>x(2),
		B=>x(3),
		Cin=>x(1),
		
		S=>s0(1),
		Cout=>c0(1));	
	end generate g00;
	g01 : if (i>1 and i<(N/2)-1) generate
		fa : FULL_ADDER port map (
		A=>x(2*i+0),
		B=>x(2*i+1),
		Cin=>s0(i-1),
		
		S=>s0(i),
		Cout=>c0(i));
	end generate g01;
	g02 : if (i=(N/2)-1) generate
		fa : FULL_ADDER port map (
		A=>x(2*i+0),
		B=>x(2*i+1),
		Cin=>s0(i-1),
		
		S=>y(0),
		Cout=>c0(i));
	end generate g02;
end generate g0;

g1 : for i in 1 to (N/2/2)-1 generate
	g10 : if (i=1) generate
		fa : FULL_ADDER port map (
		A=>c0(2*i),
		B=>c0(2*i+1),
		Cin=>c0(2*i-1),
		
		S=>s1(1), --XXX
		Cout=>c1(1)); --XXX
	end generate g10;
	g11 : if (i>1 and i<(N/2/2)-1) generate
		fa : FULL_ADDER port map (
		A=>c0(2*i),
		B=>c0(2*i+1),
		Cin=>s1(i-1),
		
		S=>s1(i), --XXX
		Cout=>c1(i)); --XXX
	end generate g11;
	g12 : if (i=(N/2/2)-1) generate
		fa : FULL_ADDER port map (
		A=>c0(2*i),
		B=>c0(2*i+1),
		Cin=>s1(i-1),
		
		S=>y(1), --XXX
		Cout=>c1(i)); --XXX
	end generate g12;
end generate g1;

--g2 : for i in 1 to (N/2/2/2)-1 generate
--	g20 : if (i=1) generate
--		fa : FULL_ADDER port map (
--		A=>c1(2*i),
--		B=>c1(2*i+1),
--		Cin=>c1(2*i-1),
--		
--		S=>s2(1), --XXX
--		Cout=>c2(1)); --XXX
--	end generate g20;
--	g21 : if (i>1 and i<(N/2/2/2)-1) generate
--		fa : FULL_ADDER port map (
--		A=>c1(2*i),
--		B=>c1(2*i+1),
--		Cin=>s1(2*i-1),
--		
--		S=>s2(i), --XXX
--		Cout=>c2(i)); --XXX
--	end generate g21;
--	g22 : if (i=(N/2/2/2)-1) generate
--		fa : FULL_ADDER port map (
--		A=>c1(2*i),
--		B=>c1(2*i+1),
--		Cin=>s1(2*i-1),
--		
--		S=>y(2), --XXX
--		Cout=>y(3)); --XXX
--	end generate g22;
--end generate g2;

end Behavioral;
