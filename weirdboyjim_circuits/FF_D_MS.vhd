library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_D_MASTER_SLAVE is
port (C,D:in STD_LOGIC;Q1,Q2:out STD_LOGIC);
end entity FF_D_MASTER_SLAVE;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Master%E2%80%93slave_edge-triggered_D_flip-flop
architecture Behavioral_D_MS of FF_D_MASTER_SLAVE is
component GAND is
generic (delay_and : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GN is
generic (delay_not : time := 0 ns);
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal X,Y,Z,U,V,W,O,P,sa,sb,sc,sd,se,sf,sg,sh:STD_LOGIC;
signal q1out,q2out : std_logic;
begin
Q1 <= q1out;
Q2 <= q2out;
g1: GN port map (C,X);
g2: GAND port map (D,X,sa); g3: GN port map(sa,Y);
g4: GN port map (X,U);
g5: GAND port map (X,Y,sb); g6: GN port map(sb,V);
g7: GAND port map (Y,W,sc); g8: GN port map(sc,Z);
g9: GAND port map (V,Z,sd); g10: GN port map(sd,W);
g11: GAND port map (Z,U,se); g12: GN port map(se,O);
g13: GAND port map (O,U,sf); g14: GN port map(sf,P);
g15: GAND port map (O,q2out,sg); g16: GN port map(sg,q1out);
g17: GAND port map (P,q1out,sh); g18: GN port map(sh,q2out);
end architecture Behavioral_D_MS;

architecture D_MS_LUT of FF_D_MASTER_SLAVE is

	component GAND is
		generic (delay_and : time := 0 ns);
		port (A,B:in STD_LOGIC;C:out STD_LOGIC);
	end component GAND;
	for all : GAND use entity WORK.GATE_AND(GATE_AND_LUT);

	component GN is
		generic (delay_not : time := 0 ns);
		port (A:in STD_LOGIC;B:out STD_LOGIC);
	end component GN;
	for all : GN use entity WORK.GATE_NOT(GATE_NOT_LUT);

	signal X,Y,Z,U,V,W,O,P,sa,sb,sc,sd,se,sf,sg,sh:STD_LOGIC;
	signal q1out,q2out : std_logic;

begin

	Q1 <= q1out;
	Q2 <= q2out;

	g1: GN generic map (1 ns) port map (A => C, B => X);
	g2: GAND port map (A => D, B => X, C => sa); g3: GN port map (A => sa, B => Y);
	g4: GN port map (A => X, B => U);
	g5: GAND generic map (1 ns) port map (A => X, B => Y, C => sb); g6: GN port map (A => sb, B => V);
	g7: GAND generic map (3 ns) port map (A => Y, B => W, C => sc); g8: GN port map (A => sc, B => Z);
	g9: GAND generic map (6 ns) port map (A => V, B => Z, C => sd); g10: GN port map (A => sd, B => W);
	g11: GAND port map (A => Z, B => U, C => se); g12: GN port map (A => se, B => O);
	g13: GAND port map (A => O, B => U, C => sf); g14: GN port map (A => sf, B => P);
	g15: GAND port map (A => O, B => q2out, C => sg); g16: GN port map (A => sg, B => q1out);
	g17: GAND port map (A => P, B => q1out, C => sh); g18: GN port map (A => sh, B => q2out);

end architecture D_MS_LUT;
