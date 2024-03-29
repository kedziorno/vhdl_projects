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
N : integer := 4;
MAX : integer := 16
);
Port (
i_clock : in std_logic;
i_cpb : in std_logic;
i_mrb : in std_logic;
i_ud : in std_logic;
o_q : inout std_logic_vector(N-1 downto 0)
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
	for all : FF_JK use entity WORK.FF_JK(LUT);

	component GATE_AND is
	generic (
	delay_and : TIME := 1 ns
	);
	port (
	A,B : in STD_LOGIC;
	C : out STD_LOGIC
	);
	end component GATE_AND;
	for all : GATE_AND use entity WORK.GATE_AND(GATE_AND_LUT);

	component GATE_OR is
	generic (
	delay_or : TIME := 1 ns
	);
	port (
	A,B : in STD_LOGIC;
	C : out STD_LOGIC
	);
	end component GATE_OR;
	for all : GATE_OR use entity WORK.GATE_OR(GATE_OR_LUT);

	component GATE_NOT is
	generic (
	delay_not : TIME := 1 ns
	);
	port (
	A : in STD_LOGIC;
	B : out STD_LOGIC
	);
	end component GATE_NOT;
	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);

	signal cp,mr : std_logic;
	signal q1,q2 : std_logic_vector(N-1 downto 0);
	signal ping,ping1,ping2 : std_logic;
	signal ffjk_and_u,ffjk_and_d,ffjk_or : std_logic_vector(N-1 downto 0); -- XXX omit last FF JK
	signal ud,udb : std_logic;
	signal gated_clock : std_logic := '0';
	constant a : std_logic_vector(N-1 downto 0) := std_logic_vector(to_unsigned(MAX,N));
	constant b : std_logic_vector(N-1 downto 0) := std_logic_vector(to_unsigned(0,N));

	constant WAIT_AND : time := 0 ps;
	constant WAIT_OR : time := 0 ps;
	constant WAIT_NOT : time := 0 ps;

begin

	ffjk_or(N-1) <= '0';
	gated_clock_gand_lut2 : GATE_AND generic map (WAIT_AND) port map (A=>i_clock,B=>i_cpb,C=>gated_clock); -- XXX ~20mhz
	o_q <= q1;
	mr_block : mr <= '1' when q1 = a or i_mrb = '1' else '0';

	g0_not_clock : GATE_NOT generic map (WAIT_NOT) port map (A=>i_ud,B=>udb);

	g0_and_u : for i in 0 to N-1 generate -- XXX omit last FF JK
		g0_and_u_first : if (i=0) generate
			g0_and_u_first : GATE_AND generic map (WAIT_AND) port map (A=>q1(i),B=>i_ud,C=>ffjk_and_u(i));
		end generate g0_and_u_first;
		g0_and_u_chain : if (i>0) generate
			g0_and_u_chain : GATE_AND generic map (WAIT_AND) port map (A=>q1(i),B=>ffjk_and_u(i-1),C=>ffjk_and_u(i));
		end generate g0_and_u_chain;
	end generate g0_and_u;

	g0_and_d : for i in 0 to N-1 generate -- XXX omit last FF JK
		g0_and_d_first : if (i=0) generate
			g0_and_d_first : GATE_AND generic map (WAIT_AND) port map (A=>q2(i),B=>udb,C=>ffjk_and_d(i)); -- XXX udb make unconnected
		end generate g0_and_d_first;
		g0_and_d_chain : if (i>0) generate
			g0_and_d_chain : GATE_AND generic map (WAIT_AND) port map (A=>q2(i),B=>ffjk_and_d(i-1),C=>ffjk_and_d(i));
		end generate g0_and_d_chain;
	end generate g0_and_d;

	g0_or : for i in 0 to N-1 generate -- XXX omit last FF JK
		g0_or_chain : GATE_OR generic map (WAIT_OR) port map (A=>ffjk_and_u(i),B=>ffjk_and_d(i),C=>ffjk_or(i));
	end generate g0_or;

	g0 : for i in 0 to N-1 generate
		ffjk_first : if (i=0) generate
			b0 : block
				attribute rloc : string;
				attribute rloc of ffjk_first_1 : label is "X0Y8";
				attribute h_set : string;
				attribute h_set of ffjk_first_1 : label is "rc";
			begin
				ffjk_first_1 : FF_JK port map (i_r=>mr,J=>i_cpb,K=>i_cpb,C=>gated_clock,Q1=>q1(i),Q2=>q2(i));
			end block b0;
		end generate ffjk_first;
		ffjk_chain : if (i>0) generate
			b1 : block
				-- XXX UG625 p231
				constant row1 : natural := i * 20;
				constant rloc_str : string := ""
				& "" & "X" & natural'image(row1) & "Y" & "8";
				attribute rloc : string;
				attribute rloc of ffjk_chain_1 : label is rloc_str;
				attribute h_set : string;
				attribute h_set of ffjk_chain_1 : label is "rc";
			begin
				ffjk_chain_1 : FF_JK port map (i_r=>mr,J=>ffjk_or(i-1),K=>ffjk_or(i-1),C=>gated_clock,Q1=>q1(i),Q2=>q2(i));
			end block b1;
		end generate ffjk_chain;
	end generate g0;

end Behavioral;
