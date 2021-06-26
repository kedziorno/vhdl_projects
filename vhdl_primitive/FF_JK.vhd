library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_JK is
port (J,K,C:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
end entity FF_JK;

---- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#JK_flip-flop
---- XXX strange operation
--architecture Behavioral_FF_JK of FF_JK is
--component GAND is
--port (A,B:in STD_LOGIC;C:out STD_LOGIC);
--end component GAND;
--component FF_SR_NOR is
--port (S,R:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
--end component FF_SR_NOR;
----component GNOT is
----generic (delay_not : TIME := 0 ns);
----port (A:in STD_LOGIC;B:out STD_LOGIC);
----end component GNOT;
----for all : GNOT use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
--for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
--for all : FF_SR_NOR use entity WORK.FF_SR(Behavioral_NOR);
----for all : FF_SR_NOR use entity WORK.FF_SR(Behavioral_NAND);
----for all : FF_SR_NOR use entity WORK.FF_SR(Behavioral_ANDOR);
----for all : FF_SR_NOR use entity WORK.FF_SR(Behavioral_NOT_S_NOT_R);
--signal sa,sb,sc,sd: STD_LOGIC;
----signal n1,n2 : STD_LOGIC;
--begin
--g1: GAND port map (K,C,sa);
--g2: GAND port map (sa,Q1,sb);
----gn1 : GNOT port map (sb,n1);
--g3: GAND port map (C,J,sc);
--g4: GAND port map (sc,Q2,sd);
----gn2 : GNOT port map (sd,n2);
--g5: FF_SR_NOR port map (sb,sd,Q1,Q2);
--end architecture Behavioral_FF_JK;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#JK_flip-flop
--architecture Structural of FF_JK is
--component GAND is port (A,B:in STD_LOGIC;C:out STD_LOGIC); end component GAND;
--component GOR is port (A,B:in STD_LOGIC;C:out STD_LOGIC); end component GOR;
--component GNOT is port (A:in STD_LOGIC;B:out STD_LOGIC); end component GNOT;
--for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
--for all : GOR use entity WORK.GATE_OR(GATE_OR_BEHAVIORAL_1);
--for all : GNOT use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
--signal sa,sb,sc,sd,se,sf,sg,sh,si,sj : std_logic;
--begin
--g1 : GAND port map (J,C,sa);
--g2 : GAND port map (K,C,sb);
--
--g3 : GAND port map (sa,Q2,sc);
--
--g4 : GNOT port map (sb,sd);
--g5 : GAND port map (sd,Q1,se);
--
--g6 : GOR port map (sc,se,sf);
--g7 : GNOT port map (sf,sg);
--Q1 <= sf;
--Q2 <= sg;
--end architecture Structural;

--architecture Structural of FF_JK is
----component GAND is port (A,B:in STD_LOGIC;C:out STD_LOGIC); end component GAND;
----component GOR is port (A,B:in STD_LOGIC;C:out STD_LOGIC); end component GOR;
----component GNOT is port (A:in STD_LOGIC;B:out STD_LOGIC); end component GNOT;
----for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
----for all : GOR use entity WORK.GATE_OR(GATE_OR_BEHAVIORAL_1);
----for all : GNOT use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
--signal sa,sb,sc,sd,se,sf,sg,sh,si,sj : std_logic := '0';
--constant clock_period : time := 1 ns;
--begin
--g1 : sa <= J and C;
--sb <= sa and Q2 after clock_period;
--
--g2 : sc <= K and C;
--sd <= sc and Q1 after clock_period;
--
--g3 : se <= sb nor Q2 after clock_period;
--
--g4 : sf <= sd nor Q1 after clock_period;
--
--Q1 <= se;
--Q2 <= sf;
--end architecture Structural;

architecture structural of FF_JK is
	constant W_NOT : time := 1 ns;
begin
	p0 : process (C,j,k,q1,q2) is
		variable sa,sb,sc,sd : std_logic;
		variable se,sf,sg : std_logic;
		variable sh,si,sj : std_logic;
		variable sk,sn : std_logic;
		variable so,sp : std_logic := '0';
		variable sr,ss : std_logic := '0';
		variable st,su : std_logic;
		variable sw,sx : std_logic;
		variable sy,sz : std_logic;
	begin
	sa := C;
	sb := not C;
	sc := j;
	sd := k;
	
	-- nand3 1u
	se := sa and sc;
	sf := se and q2;
	sg := not sf;
	
	-- nand3 1d
	sh := sa and sd;
	si := sh and q1;
	sj := not si;
	
	-- nand2 1u
	sk := sg and sp;
	sn := not sk;
	
	-- nand2 1d
	so := sj and sn;
	sp := not so;

	-- nand2 1u
	sr := sn and sb;
	ss := not sr;

	-- nand2 1d
	st := sp and sb;
	su := not st;
	
	-- nand2 q1
	sw := ss and q2;
	sx := not sw;
	
	-- nand2 q2
	sy := su and q1;
	sz := not sy;
		
	q1 <= sx;
	q2 <= sy;
	end process p0;
	
end architecture Structural;
