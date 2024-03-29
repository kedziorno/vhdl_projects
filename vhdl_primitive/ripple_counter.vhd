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
N : integer := 32;
MAX : integer := 1
);
Port (
i_clock : in std_logic;
i_cpb : in std_logic;
i_mrb : in std_logic;
i_ud : in std_logic;
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

	component FF_D_POSITIVE_EDGE is
	port (S,R,C,D:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
	end component FF_D_POSITIVE_EDGE;

	component GATE_AND is
	generic (
	delay_and : TIME := 1 ns
	);
	port (
	A,B : in STD_LOGIC;
	C : out STD_LOGIC
	);
	end component GATE_AND;

	component GATE_OR is
	generic (
	delay_or : TIME := 1 ns
	);
	port (
	A,B : in STD_LOGIC;
	C : out STD_LOGIC
	);
	end component GATE_OR;

	component GATE_NOT is
	generic (
	delay_not : TIME := 1 ns
	);
	port (
	A : in STD_LOGIC;
	B : out STD_LOGIC
	);
	end component GATE_NOT;

	signal cp,mr : std_logic;
	signal q1,q2 : std_logic_vector(N-1 downto 0);
	signal ping,ping1,ping2 : std_logic;
	signal ffjk_and_u,ffjk_and_d,ffjk_or : std_logic_vector(N-1 downto 0); -- XXX omit last FF JK
	signal ud,udb : std_logic;
	signal gated_clock : std_logic;
	signal a : std_logic_vector(N-1 downto 0) := std_logic_vector(to_unsigned(MAX,N));
	signal b : std_logic_vector(N-1 downto 0) := std_logic_vector(to_unsigned(0,N));

	constant WAIT_AND : time := 0 ps;
	constant WAIT_OR : time := 0 ps;
	constant WAIT_NOT : time := 0 ps;

--	attribute keep : string; -- XXX when unconnected signal in g0_and_d
--	attribute keep of ud : signal is "true";
--	attribute keep of udb : signal is "true";
--	attribute keep of ffjk_and_d : signal is "true";

begin

	ffjk_or(N-1) <= '0';
	gated_clock <= i_clock and cp;
	ud <= i_ud;
	o_q <= q1;
	cp <= i_cpb;
	mr <= '1' when o_q = a or i_mrb = '1' else '0';
	--ping <= '1' when o_q = b else '0';

	inst1 : FF_D_POSITIVE_EDGE
	PORT MAP (
	S => not mr,
	R => not mr,
	D => mr,
	C => gated_clock,
	Q1 => ping1,
	Q2 => ping2
	);
	o_ping <= ping1;

	g0_and_u : for i in 0 to N-1 generate -- XXX omit last FF JK
		g0_and_u_first : if (i=0) generate
			g0_and_u_first : GATE_AND generic map (WAIT_AND) port map (A=>q1(i),B=>ud,C=>ffjk_and_u(i));
		end generate g0_and_u_first;
		g0_and_u_chain : if (i>0) generate
			g0_and_u_chain : GATE_AND generic map (WAIT_AND) port map (A=>q1(i),B=>ffjk_and_u(i-1),C=>ffjk_and_u(i));
		end generate g0_and_u_chain;
	end generate g0_and_u;

	g0_and_d : for i in 0 to N-1 generate -- XXX omit last FF JK
		g0_and_d_first : if (i=0) generate
			g0_and_d_first : GATE_AND generic map (WAIT_AND) port map (A=>q2(i),B=>udb,C=>ffjk_and_d(i)); -- XXX udb make unconnected
			g0_not_clock : GATE_NOT generic map (WAIT_NOT) port map (A=>ud,B=>udb);
		end generate g0_and_d_first;
		g0_and_d_chain : if (i>0) generate
			g0_and_d_chain : GATE_AND generic map (WAIT_AND) port map (A=>q2(i),B=>ffjk_and_d(i-1),C=>ffjk_and_d(i));
		end generate g0_and_d_chain;
	end generate g0_and_d;

	g0_or : for i in 0 to N-1 generate -- XXX omit last FF JK
		g0_or_first : if (i=0) generate
			g0_or_first : GATE_OR generic map (WAIT_OR) port map (A=>ffjk_and_u(i),B=>ffjk_and_d(i),C=>ffjk_or(i));
		end generate g0_or_first;
		g0_or_chain : if (i>0) generate
			g0_or_chain : GATE_OR generic map (WAIT_OR) port map (A=>ffjk_and_u(i),B=>ffjk_and_d(i),C=>ffjk_or(i));
		end generate g0_or_chain;
	end generate g0_or;

	g0 : for i in 0 to N-1 generate
		ffjk_first : if (i=0) generate
			ffjk_first : FF_JK port map (i_r=>mr,J=>cp,K=>cp,C=>gated_clock,Q1=>q1(i),Q2=>q2(i));
		end generate ffjk_first;
		ffjk_chain : if (i>0 and i<N-1) generate
			ffjk_chain : FF_JK port map (i_r=>mr,J=>ffjk_or(i-1),K=>ffjk_or(i-1),C=>gated_clock,Q1=>q1(i),Q2=>q2(i));
		end generate ffjk_chain;
		ffjk_last : if (i=N-1) generate
			ffjk_last : FF_JK port map (i_r=>mr,J=>ffjk_or(i-1),K=>ffjk_or(i-1),C=>gated_clock,Q1=>q1(i),Q2=>q2(i));
		end generate ffjk_last;
	end generate g0;

end Behavioral;
