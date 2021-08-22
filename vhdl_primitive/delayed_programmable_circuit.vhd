----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:35:29 08/22/2021 
-- Design Name: 
-- Module Name:    delayed_programmable_circuit - Behavioral 
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

entity delayed_programmable_circuit is
generic (n : integer := 8);
port (
i_input : in std_logic;
o_output : out std_logic
);
end delayed_programmable_circuit;

architecture Behavioral of delayed_programmable_circuit is

component MUX_21 is
port (S,A,B:in STD_LOGIC;C:out STD_LOGIC);
end component MUX_21;

signal reg : std_logic_vector(n-1 downto 0);
signal nots : std_logic_vector(2**n-1 downto 0);
signal mux_out : std_logic_vector(n-1 downto 0);

begin

mux_out(0) <= i_input;

g0_not : for i in 1 to n-1 generate
	g1_not : for j in 2**(i+0) to 2**(i+1)-1 generate
		nots(j) <= not nots(j-1);
		mux_out : if (j=2**(i+1)-1) generate
			m21 : MUX_21 port map (S => reg(i), A => mux_out(i-1), B => nots(j), C => mux_out(i));
		end generate mux_out;
	end generate g1_not;
end generate g0_not;

o_output <= mux_out(n-1);

end Behavioral;
