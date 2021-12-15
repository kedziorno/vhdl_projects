library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_D_DUAL_EDGE_TRIGGERED is
port (D,C:in STD_LOGIC;Q:out STD_LOGIC);
end entity FF_D_DUAL_EDGE_TRIGGERED;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Dual-edge-triggered_D_flip-flop
architecture Behavioral_D_DET of FF_D_DUAL_EDGE_TRIGGERED is
component FF_D_PE is
port (C,D:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
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
begin
g1: GN port map (C,sa);
g2: FF_D_PE port map (sa,D,sb,open);
g3: FF_D_PE port map (C,D,sc,open);
g4: MUX_21 port map (C,sb,sc,Q);
end architecture Behavioral_D_DET;

architecture D_DET_LUT of FF_D_DUAL_EDGE_TRIGGERED is

	component FF_D_PE is
		port (C,D:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
	end component FF_D_PE;
	for all : FF_D_PE use entity WORK.FF_D_POSITIVE_EDGE(D_PE_LUT_2); -- D_PE_LUT_1

	component MUX_21 is
		port (S,A,B:in STD_LOGIC;C:out STD_LOGIC);
	end component MUX_21;
	for all : MUX_21 use entity WORK.MUX_21(MUX_21_BEHAVIORAL_1);

	component GN is
		port (A:in STD_LOGIC;B:out STD_LOGIC);
	end component GN;
	for all : GN use entity WORK.GATE_NOT(GATE_NOT_LUT);

	signal sa,sb,sc: STD_LOGIC;

begin

	g1: GN port map (A => C, B => sa);
	g2: FF_D_PE port map (A => sa, B => D, C => sb, D => open);
	g3: FF_D_PE port map (A => C, B => D, C => sc, D => open);
	g4: MUX_21 port map (A => C, B => sb, C => sc, D => Q);

end architecture FF_D_DUAL_EDGE_TRIGGERED;
