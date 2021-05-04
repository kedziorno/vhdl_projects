----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:32:30 05/04/2021 
-- Design Name: 
-- Module Name:    ripple_counter - Behavioral 
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

entity ripple_counter is
Generic (
N : integer := 12
);
Port (
i_clock : in std_logic;
i_cpb : in std_logic; -- clock input
i_mrb : in std_logic; -- master reset
o_q : inout std_logic_vector(N-1 downto 0)
);
end ripple_counter;

architecture Behavioral of ripple_counter is

	component FF_JK is port (J,K,C:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
	end component FF_JK;

	signal cp : std_logic;
	signal q : std_logic_vector(N-1 downto 0);

begin

	cp <= not i_cpb;

	g0 : for i in 0 to N-1 generate
		ffjk_first : if (i=0) generate
			ffjk : FF_JK port map (
				J=>cp,K=>cp,C=>i_clock,
				Q1=>o_q(0),Q2=>q(0)
			);
		end generate ffjk_first;
		ffjk_chain : if (i>0) generate
			ffjk : FF_JK port map (
				J=>q(i-1),K=>q(i-1),C=>i_clock,
				Q1=>o_q(i),Q2=>q(i)
			);
		end generate ffjk_chain;
	end generate g0;

end Behavioral;

