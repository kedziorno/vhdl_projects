library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_D_GATED is
generic (
delay_and : TIME := 0 ns;
delay_or : TIME := 0 ns;
delay_not : TIME := 0 ns
);
port (
D,E : in STD_LOGIC;
Q1,Q2 : out STD_LOGIC
);
end entity FF_D_GATED;
 
-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Gated_D_latch
architecture Behavioral_GATED_D_NAND of FF_D_GATED is
component GAND is
generic (delay_and : TIME := 0 ns);
port (A,B : in STD_LOGIC; C : out STD_LOGIC);
end component GAND;
component GN is
generic (delay_not : TIME := 0 ns);
port (A : in STD_LOGIC; B : out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal sa,sb,sc,sd,se,sf,sg,sh:STD_LOGIC;
signal q1out : std_logic;
signal q2out : std_logic;
begin
Q1 <= q1out;
Q2 <= q2out;
g1: GAND generic map (delay_and) port map (D,E,sa);
g2: GN generic map (delay_not) port map (sa,sb);
g3: GAND generic map (delay_and) port map (E,sb,sc);
g4: GN generic map (delay_not) port map (sc,sd);
g5: GAND generic map (delay_and) port map (sb,q2out,sg);
g6: GN generic map (delay_not) port map (sg,q1out);
g7: GAND generic map (delay_and) port map (sd,q1out,se);
g8: GN generic map (delay_not) port map (se,q2out);

end architecture Behavioral_GATED_D_NAND;

architecture GATED_D_NAND_LUT of FF_D_GATED is

	component GAND is
	generic (delay_and : TIME := 0 ns);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GAND;
	for all : GAND use entity WORK.GATE_AND(GATE_AND_LUT);

	component GN is
	generic (delay_not : TIME := 0 ns);
	port (A : in STD_LOGIC; B : out STD_LOGIC);
	end component GN;
	for all : GN use entity WORK.GATE_NOT(GATE_NOT_LUT);

	signal sa,sb,sc,sd,se,sf,sg,sh:STD_LOGIC;
	signal q1out : std_logic;
	signal q2out : std_logic;

begin

	Q1 <= q1out;
	Q2 <= q2out;

	g1: GAND generic map (delay_and) port map (A => D, B => E, C => sa);
	g2: GN generic map (delay_not) port map (A => sa, B => sb);
	g3: GAND generic map (delay_and) port map (A => E, B => sb, C => sc);
	g4: GN generic map (delay_not) port map (A => sc, B => sd);
	g5: GAND generic map (delay_and) port map (A => sb, B => q2out, C => sg);
	g6: GN generic map (delay_not) port map (A => sg, B => q1out);
	g7: GAND generic map (delay_and) port map (A => sd, B => q1out, C => se);
	g8: GN generic map (delay_not) port map (A => se, B => q2out);

end architecture GATED_D_NAND_LUT;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Gated_D_latch
architecture Behavioral_GATED_D_NOR of FF_D_GATED is
component GAND is
generic (delay_and : TIME := 0 ns);
port (A,B : in STD_LOGIC; C : out STD_LOGIC);
end component GAND;
component GOR is
generic (delay_or : TIME := 0 ns);
port (A,B : in STD_LOGIC; C : out STD_LOGIC);
end component GOR;
component GN is
generic (delay_not : TIME := 0 ns);
port (A : in STD_LOGIC; B : out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : GOR use entity WORK.GATE_OR(GATE_OR_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal sa,sb,sc,sd,se,sf,sg,sh:STD_LOGIC;
signal q1out : std_logic;
signal q2out : std_logic;
begin
Q1 <= q1out;
Q2 <= q2out;
g1: GN generic map (delay_not) port map (D,sa);
g2: GAND generic map (delay_and) port map (sa,E,sb);
g3: GAND generic map (delay_and) port map (D,E,sc);
g4: GOR generic map (delay_or) port map (sb,q2out,sg);
g5: GN generic map (delay_not) port map (sg,q1out);
g6: GOR generic map (delay_or) port map (sc,q1out,se);
g7: GN generic map (delay_not) port map (se,q2out);

end architecture Behavioral_GATED_D_NOR;

architecture GATED_D_NOR_LUT of FF_D_GATED is

	component GAND is
	generic (delay_and : TIME := 0 ns);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GAND;
	for all : GAND use entity WORK.GATE_AND(GATE_AND_LUT);

	component GOR is
	generic (delay_or : TIME := 0 ns);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GOR;
	for all : GOR use entity WORK.GATE_OR(GATE_OR_LUT);

	component GN is
	generic (delay_not : TIME := 0 ns);
	port (A : in STD_LOGIC; B : out STD_LOGIC);
	end component GN;
	for all : GN use entity WORK.GATE_NOT(GATE_NOT_LUT);

	signal sa,sb,sc,sd,se,sf,sg,sh:STD_LOGIC;
	signal q1out : std_logic;
	signal q2out : std_logic;

begin

	Q1 <= q1out;
	Q2 <= q2out;

	g1: GN generic map (delay_not) port map (A => D, B => sa);
	g2: GAND generic map (delay_and) port map (A => sa, B => E, C => sb);
	g3: GAND generic map (delay_and) port map (A => D, B => E, C => sc);
	g4: GOR generic map (delay_or) port map (A => sb, B => q2out, C => sg);
	g5: GN generic map (delay_not) port map (A => sg, B => q1out);
	g6: GOR generic map (delay_or) port map (A => sc, B => q1out, C => se);
	g7: GN generic map (delay_not) port map (A => se, B => q2out);

end architecture GATED_D_NOR_LUT;
