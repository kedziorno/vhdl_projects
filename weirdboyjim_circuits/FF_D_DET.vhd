library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_D_DUAL_EDGE_TRIGGERED is
generic (
delay_not : time := 0 ns;
delay_and : time := 0 ns;
delay_or : time := 0 ns;
delay_nor2 : time := 0 ns;
delay_nand2 : time := 0 ns;
delay_nand3 : time := 0 ns
);
port (S,R,D,C:in STD_LOGIC;Q:out STD_LOGIC);
end entity FF_D_DUAL_EDGE_TRIGGERED;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Dual-edge-triggered_D_flip-flop
architecture Behavioral_D_DET of FF_D_DUAL_EDGE_TRIGGERED is
component FF_D_PE is
generic (
delay_not : time := 0 ns;
delay_and : time := 0 ns;
delay_nor2 : time := 0 ns;
delay_nand2 : time := 0 ns;
delay_nand3 : time := 0 ns
);
port (S,R,C,D:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
end component FF_D_PE;
component MUX_21 is
port (S,A,B:in STD_LOGIC;C:out STD_LOGIC);
end component MUX_21;
component GN is
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : FF_D_PE use entity WORK.FF_D_POSITIVE_EDGE(Behavioral_D_PE);
for all : MUX_21 use entity WORK.MUX_21(MUX_21_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal sa,sb,sc: STD_LOGIC;
signal null_s,null_r : std_logic := '0';
begin
g1: GN port map (C,sa);
g2: FF_D_PE port map (null_s,null_r,sa,D,sb,open);
g3: FF_D_PE port map (null_s,null_r,C,D,sc,open);
g4: MUX_21 port map (C,sb,sc,Q);
end architecture Behavioral_D_DET;

architecture D_DET_LUT of FF_D_DUAL_EDGE_TRIGGERED is

	component FF_D_PE is
	generic (
	delay_not : time := 0 ns;
	delay_and : time := 0 ns;
	delay_nor2 : time := 0 ns;
	delay_nand2 : time := 0 ns;
	delay_nand3 : time := 0 ns
	);
	port (S,R,C,D:in STD_LOGIC;Q1,Q2:out STD_LOGIC);
	end component FF_D_PE;
--	for all : FF_D_PE use entity WORK.FF_D_POSITIVE_EDGE(Behavioral_D_PE);
--	for all : FF_D_PE use entity WORK.FF_D_POSITIVE_EDGE(D_PE_LUT_1);
--	for all : FF_D_PE use entity WORK.FF_D_POSITIVE_EDGE(D_PE_LUT_2);
	for all : FF_D_PE use entity WORK.FF_D_POSITIVE_EDGE(D_PE_LUT_3);

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

	component GN is
	generic (delay_not : time := 0 ns);
	port (A:in STD_LOGIC;B:out STD_LOGIC);
	end component GN;
	for all : GN use entity WORK.GATE_NOT(GATE_NOT_LUT);

	signal sa,sb,sc: STD_LOGIC;
	signal null_s,null_r : std_logic;

begin

	g1: GN generic map (delay_not) port map (A => C, B => sa);
	g2: FF_D_PE
	generic map (
	delay_not => delay_not,
	delay_and => delay_and,
	delay_nor2 => delay_nor2,
	delay_nand2 => delay_nand2,
	delay_nand3 => delay_nand3
	)
	port map (S => S, R => R, C => sa, D => D, Q1 => sb, Q2 => open);
	g3: FF_D_PE
	generic map (
	delay_not => delay_not,
	delay_and => delay_and,
	delay_nor2 => delay_nor2,
	delay_nand2 => delay_nand2,
	delay_nand3 => delay_nand3
	)
	port map (S => S, R => R, C => C, D => D, Q1 => sc, Q2 => open);
	g4: MUX_21
	generic map (
	delay_and => delay_and,
	delay_or => delay_or,
	delay_not => delay_not
	)
	port map (S => C, A => sb, B => sc, C => Q);

end architecture D_DET_LUT;
