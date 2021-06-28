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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity ripple_counter is
Generic (
N : integer := 12;
MAX : integer := 571
);
Port (
i_clock : in std_logic;
i_cpb : in std_logic;
i_mrb : in std_logic;
o_q : inout std_logic_vector(N-1 downto 0);
o_ping : out std_logic
);
end ripple_counter;

architecture Behavioral of ripple_counter is

	component FF_JK is
	port (
	i_r:in STD_LOGIC;
	J,K,C:in STD_LOGIC;
	Q1:inout STD_LOGIC;
	Q2:inout STD_LOGIC
	);
	end component FF_JK;

	signal cp,mr : std_logic;
	signal q : std_logic_vector(N-1 downto 0);
	signal ping : std_logic;

begin

	o_q <= q;
	cp <= i_cpb;
	mr <= '1' when q = std_logic_vector(to_unsigned(MAX,N)) else i_mrb;
	ping <= '1' when q = std_logic_vector(to_unsigned(MAX,N)) else '0';

	FDCPE_inst1 : FDCPE
	generic map (INIT => '0')
	port map (Q=>o_ping,C=>i_clock,CE=>'1',CLR=>'0',D=>'0',PRE=>ping); -- XXX D=ping give ~10mhz,d=0 give ~400mhz

	g0 : for i in N-1 downto 0 generate
		ffjk_first : if (i=0) generate
			ffjk : FF_JK port map (i_r=>mr,J=>cp,K=>cp,C=>i_clock,Q1=>q(0));
		end generate ffjk_first;
		ffjk_chain : if (i>0) generate
			ffjk : FF_JK port map (i_r=>mr,J=>cp,K=>cp,C=>q(i-1),Q1=>q(i));
		end generate ffjk_chain;
	end generate g0;

end Behavioral;
