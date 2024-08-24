----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:45:09 01/20/2022 
-- Design Name: 
-- Module Name:    MUX_81 - Behavioral 
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

entity MUX_81 is
generic (
delay_and : TIME := 0 ns;
delay_or : TIME := 0 ns;
delay_not : TIME := 0 ns
);
port (
signal in0,in1,in2,in3,in4,in5,in6,in7 : in std_logic;
signal s0,s1,s2 : in std_logic;
signal o : out std_logic
);
end MUX_81;

architecture Behavioral of MUX_81 is

	component MUX_21 is
	generic (
		delay_and : TIME := 0 ns;
		delay_or : TIME := 0 ns;
		delay_not : TIME := 0 ns
	);
	port (
		S,A,B:in STD_LOGIC;
		C:out STD_LOGIC
	);
	end component MUX_21;
	for all : MUX_21 use entity WORK.MUX_21(MUX_21_LUT_1);

	component MUX_41 is
	generic (
		delay_and : TIME := 0 ns;
		delay_or : TIME := 0 ns;
		delay_not : TIME := 0 ns
	);
	port (
		S1,S2,A,B,C,D:in STD_LOGIC;
		E:out STD_LOGIC
	);
	end component MUX_41;
	for all : MUX_41 use entity WORK.MUX_41(Behavioral);

	signal m1out,m2out : std_logic;

begin

	m1 : MUX_41
	generic map (delay_and => delay_and, delay_or => delay_or, delay_not => delay_not)
	port map (S1 => s0, S2 => s1, A => in0, B => in1, C => in2, D => in3, E => m1out);

	m2 : MUX_41
	generic map (delay_and => delay_and, delay_or => delay_or, delay_not => delay_not)
	port map (S1 => s0, S2 => s1, A => in4, B => in5, C => in6, D => in7, E => m2out);

	mout : MUX_21
	generic map (delay_and => delay_and, delay_or => delay_or, delay_not => delay_not)
	port map (S => s2, A => m1out, B => m2out, C => o);

end Behavioral;

