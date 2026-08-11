----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:36:59 01/18/2022 
-- Design Name: 
-- Module Name:    MUX_41 - Behavioral 
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

entity MUX_41 is
generic (
delay_and : TIME := 0 ns;
delay_or : TIME := 0 ns;
delay_not : TIME := 0 ns
);
port (
S1,S2,A,B,C,D:in STD_LOGIC;
E:out STD_LOGIC
);
end MUX_41;

architecture Behavioral of MUX_41 is

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

	signal m1_out,m2_out : std_logic;

begin

	m1 : MUX_21
	generic map (delay_and => delay_and, delay_or => delay_or, delay_not => delay_not)
	port map (S => S1, A => A, B => B, C => m1_out);

	m2 : MUX_21
	generic map (delay_and => delay_and, delay_or => delay_or, delay_not => delay_not)
	port map (S => S1, A => C, B => D, C => m2_out);

	mout : MUX_21
	generic map (delay_and => delay_and, delay_or => delay_or, delay_not => delay_not)
	port map (S => S2, A => m1_out, B => m2_out, C => E);

end Behavioral;

