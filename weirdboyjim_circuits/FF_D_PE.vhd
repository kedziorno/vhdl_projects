library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_D_POSITIVE_EDGE is
generic (
delay_not : time := 0 ns;
delay_and : time := 0 ns;
delay_nor2 : time := 0 ns;
delay_nand2 : time := 0 ns;
delay_nand3 : time := 0 ns
);
port (
S : in std_logic;
R : in std_logic;
C : in std_logic;
D : in STD_LOGIC;
Q1,Q2:out STD_LOGIC
);
end entity FF_D_POSITIVE_EDGE;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Classical_positive-edge-triggered_D_flip-flop
architecture Behavioral_D_PE of FF_D_POSITIVE_EDGE is

--component GAND is
--generic (delay_and:time := 0 ns);
--port (A,B:in STD_LOGIC;C:out STD_LOGIC);
--end component GAND;
--component GN is
--generic (delay_not:time := 0 ns);
--port (A:in STD_LOGIC;B:out STD_LOGIC);
--end component GN;
--for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
--for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
--signal X,Y,Z,V,W,O,sa,sb,sc,sd,se,sf:STD_LOGIC;
--constant DELAY_AND : time := 1 ps;
--constant DELAY_NOT : time := 1 ps;

constant WAIT_NAND3 : time := 0 ps;
signal setu,setd,resetu,resetd : std_logic;
signal q1out,q2out : std_logic;

begin

--rst1 <= D when i_reset = '0' else '0';
--g1: GAND generic map (DELAY_AND) port map (rst1,X,sa);
--g2: GN generic map (DELAY_NOT) port map(sa,Y);
--g3: GAND generic map (DELAY_AND) port map (Y,O,sb);
--g4: GN generic map (DELAY_NOT) port map(sb,X);
--rst2 <= C when i_reset = '0' else '0';
--g5: GAND generic map (DELAY_AND) port map (rst2,V,sc);
--g6: GN generic map (DELAY_NOT) port map(sc,Z);
--g7: GAND generic map (DELAY_AND) port map (Z,Y,sd);
--g8: GN generic map (DELAY_NOT) port map(sd,V);
--rst3 <= Q2 when i_reset = '0' else '0';
--g9: GAND generic map (DELAY_AND) port map (Z,rst3,se);
--gA: GN generic map (DELAY_NOT) port map(se,Q1);
--gB: GAND generic map (DELAY_AND) port map (X,Q1,sf);
--gC: GN generic map (DELAY_NOT) port map(sf,Q2);
--gD: GAND generic map (DELAY_AND) port map (C,Z,O);

-- https://en.wikipedia.org/wiki/Flip-flop_%28electronics%29#/media/File:Edge_triggered_D_flip_flop_with_set_and_reset.svg
Q1 <= q1out;
Q2 <= q2out;
g1 : q1out <= not (S and setd and q2out) after delay_nand3;
g2 : q2out <= not (q1out and resetu and R) after delay_nand3;
g3 : setu <= not (S and resetd and setd) after delay_nand3;
g4 : setd <= not (setu and C and R) after delay_nand3;
g5 : resetu <= not (setd and C and resetd) after delay_nand3;
g6 : resetd <= not (resetu and D and R) after delay_nand3;

end architecture Behavioral_D_PE;

architecture D_PE_LUT_1 of FF_D_POSITIVE_EDGE is

	component GATE_NAND2 is
	generic (
		delay_nand2 : TIME := 0 ns
	);
	port (
		A,B : in STD_LOGIC;
		C : out STD_LOGIC
	);
	end component GATE_NAND2;
	for all : GATE_NAND2 use entity WORK.GATE_NAND2(GATE_NAND2_LUT);

	component GATE_NAND3 is
	generic (
		delay_nand3 : TIME := 0 ns
	);
	port (
		A,B,C : in STD_LOGIC;
		D : out STD_LOGIC
	);
	end component GATE_NAND3;
	for all : GATE_NAND3 use entity WORK.GATE_NAND3(GATE_NAND3_LUT);

	component GATE_NOT is
	generic (
		delay_not : TIME := 0 ns
	);
	port (
		A : in STD_LOGIC;
		B : out STD_LOGIC
	);
	end component GATE_NOT;
	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);

	signal D_not,R_latch,S_latch : std_logic;
	signal q1out,q2out : std_logic;

begin

	q1 <= q1out;
	q2 <= q2out;

	g0 : GATE_NOT generic map (delay_not) port map (A => D, B => D_not);

	g1 : GATE_NAND2 generic map (delay_nand2) port map (A => D, B => C, C => R_latch);
	g2 : GATE_NAND2 generic map (delay_nand2) port map (A => D_not, B => C, C => S_latch);

	g3 : GATE_NAND3 generic map (delay_nand3) port map (A => '0', B => S_latch, C => q2out, D => q1out);
	g4 : GATE_NAND3 generic map (delay_nand3) port map (A => '0', B => R_latch, C => q1out, D => q2out);

end architecture D_PE_LUT_1;

architecture D_PE_LUT_2 of FF_D_POSITIVE_EDGE is

	component GATE_AND is
	generic (
		delay_and : TIME := 0 ns
	);
	port (
		A,B : in STD_LOGIC;
		C : out STD_LOGIC
	);
	end component GATE_AND;
	for all : GATE_AND use entity WORK.GATE_AND(GATE_AND_LUT);

	component GATE_NOR2 is
	generic (
		delay_nor2 : TIME := 0 ns
	);
	port (
		A,B : in STD_LOGIC;
		C : out STD_LOGIC
	);
	end component GATE_NOR2;
	for all : GATE_NOR2 use entity WORK.GATE_NOR2(GATE_NOR2_LUT);

	component GATE_NOT is
	generic (
		delay_not : TIME := 0 ns
	);
	port (
		A : in STD_LOGIC;
		B : out STD_LOGIC
	);
	end component GATE_NOT;
	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);

	signal D_not,R_latch,R_latch1,S_latch,S_latch1 : std_logic := '0';
	signal q1out : std_logic := '1';
	signal q2out : std_logic := '0';

begin

	q1 <= q1out;
	q2 <= q2out;

--	g5 : GATE_NOT generic map (delay_not) port map (A => S_latch1, B => S_latch);
--	g6 : GATE_NOT generic map (delay_not) port map (A => R_latch1, B => R_latch);

	g0 : GATE_NOT generic map (delay_not) port map (A => D, B => D_not);

	g1 : GATE_AND generic map (delay_and) port map (A => D, B => C, C => S_latch1);
	g2 : GATE_AND generic map (delay_and) port map (A => D_not, B => C, C => R_latch1);

	g3 : GATE_NOR2 generic map (delay_nor2) port map (A => S_latch1, B => q2out, C => q1out);
	g4 : GATE_NOR2 generic map (delay_nor2) port map (A => R_latch1, B => q1out, C => q2out);

end architecture D_PE_LUT_2;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#/media/File:Edge_triggered_D_flip_flop_with_set_and_reset.svg
architecture D_PE_LUT_3 of FF_D_POSITIVE_EDGE is

	component GATE_NAND3 is
	generic (
		delay_nand3 : TIME := 0 ns
	);
	port (
		A,B,C : in STD_LOGIC;
		D : out STD_LOGIC
	);
	end component GATE_NAND3;
	for all : GATE_NAND3 use entity WORK.GATE_NAND3(GATE_NAND3_LUT);

	signal E,F,G,H : std_logic;
	signal q1out,q2out : std_logic;

begin

	Q1 <= q1out;
	Q2 <= q2out;

	g0 : GATE_NAND3 generic map (delay_nand3) port map (A => S, B => H, C => F, D => E);
	g1 : GATE_NAND3 generic map (delay_nand3) port map (A => E, B => C, C => R, D => F);
	g2 : GATE_NAND3 generic map (delay_nand3) port map (A => F, B => C, C => H, D => G);
	g3 : GATE_NAND3 generic map (delay_nand3) port map (A => G, B => D, C => R, D => H);
	g4 : GATE_NAND3 generic map (delay_nand3) port map (A => S, B => F, C => q2out, D => q1out);
	g5 : GATE_NAND3 generic map (delay_nand3) port map (A => q1out, B => G, C => R, D => q2out);

end architecture D_PE_LUT_3;
