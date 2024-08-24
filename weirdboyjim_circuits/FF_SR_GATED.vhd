library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_SR_GATED is
generic (
delay_and : time := 0 ns;
delay_or : time := 0 ns;
delay_not : time := 0 ns;
delay_nand2 : time := 0 ns;
delay_nor2 : time := 0 ns
);
port (S,R,E:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
end entity FF_SR_GATED;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Gated_SR_latch
architecture Behavioral_GATED_SR_1 of FF_SR_GATED is
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
signal sa,sb,sc,sd,se,sf,sg:STD_LOGIC;
signal q1out,q2out : std_logic;
begin
Q1 <= q1out;
Q2 <= q2out;
g1: GAND generic map (delay_and) port map (S,E,sa);
g2: GN generic map (delay_not) port map (sa,sb);
g3: GAND generic map (delay_and) port map (R,E,sc);
g4: GN generic map (delay_not) port map (sc,sd);
g5: GAND generic map (delay_and) port map (sb,q2out,sg);
g6: GN generic map (delay_not) port map (sg,q1out);
g7: GAND generic map (delay_and) port map (sd,q1out,se);
g8: GN generic map (delay_not) port map (se,q2out);
end architecture Behavioral_GATED_SR_1;

architecture LUT_GATED_SR_1 of FF_SR_GATED is
component GAND is
generic (delay_and : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GN is
generic (delay_not : time := 0 ns);
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_LUT);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_LUT);
signal sa,sb,sc,sd,se,sf,sg:STD_LOGIC;
signal q1out,q2out : std_logic;
begin
Q1 <= q1out;
Q2 <= q2out;
g1: GAND generic map (delay_and) port map (S,E,sa);
g2: GN generic map (delay_not) port map (sa,sb);
g3: GAND generic map (delay_and) port map (R,E,sc);
g4: GN generic map (delay_not) port map (sc,sd);
g5: GAND generic map (delay_and) port map (sb,q2out,sg);
g6: GN generic map (delay_not) port map (sg,q1out);
g7: GAND generic map (delay_and) port map (sd,q1out,se);
g8: GN generic map (delay_not) port map (se,q2out);
end architecture LUT_GATED_SR_1;

architecture LUT_GATED_SR_1_WON of FF_SR_GATED is
component GNAND2 is
generic (delay_nand2 : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GNAND2;
for all : GNAND2 use entity WORK.GATE_NAND2(GATE_NAND2_LUT);
signal sa,sb,sc,sd,se,sf,sg:STD_LOGIC;
signal q1out,q2out : std_logic;
begin
Q1 <= q1out;
Q2 <= q2out;
g1: GNAND2 generic map (delay_nand2) port map (S,E,sb);
g2: GNAND2 generic map (delay_nand2) port map (R,E,sd);
g3: GNAND2 generic map (delay_nand2) port map (sb,q2out,q1out);
g4: GNAND2 generic map (delay_nand2) port map (sd,q1out,q2out);
end architecture LUT_GATED_SR_1_WON;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Gated_SR_latch
architecture Behavioral_GATED_SR_2 of FF_SR_GATED is
component GAND is
generic (delay_and : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GOR is
generic (delay_or : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GOR;
component GN is
generic (delay_not : time := 0 ns);
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : GOR use entity WORK.GATE_OR(GATE_OR_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal sa,sb,sc,sd,se,sf,sg:STD_LOGIC;
signal q1out,q2out : std_logic;
begin
Q1 <= q1out;
Q2 <= q2out;
g1: GAND generic map (delay_and) port map (S,E,sa);
g2: GAND generic map (delay_and) port map (R,E,sb);
g3: GOR generic map (delay_or) port map (sa,q2out,sg);
g4: GN generic map (delay_not) port map (sg,q1out);
g5: GOR generic map (delay_or) port map (sb,q1out,se);
g6: GN generic map (delay_not) port map (se,q2out);
end architecture Behavioral_GATED_SR_2;

architecture LUT_GATED_SR_2 of FF_SR_GATED is
component GAND is
generic (delay_and : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GOR is
generic (delay_or : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GOR;
component GN is
generic (delay_not : time := 0 ns);
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_LUT);
for all : GOR use entity WORK.GATE_OR(GATE_OR_LUT);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_LUT);
signal sa,sb,sc,sd,se,sf,sg:STD_LOGIC;
signal q1out,q2out : std_logic;
begin
Q1 <= q1out;
Q2 <= q2out;
g1: GAND generic map (delay_and) port map (S,E,sa);
g2: GAND generic map (delay_and) port map (R,E,sb);
g3: GOR generic map (delay_or) port map (sa,q2out,sg);
g4: GN generic map (delay_not) port map (sg,q1out);
g5: GOR generic map (delay_or) port map (sb,q1out,se);
g6: GN generic map (delay_not) port map (se,q2out);
end architecture LUT_GATED_SR_2;

architecture LUT_GATED_SR_2_WON of FF_SR_GATED is
component GAND is
generic (delay_and : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GNOR2 is
generic (delay_nor2 : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GNOR2;
for all : GAND use entity WORK.GATE_AND(GATE_AND_LUT);
for all : GNOR2 use entity WORK.GATE_NOR2(GATE_NOR2_LUT);
signal sa,sb,sc,sd,se,sf,sg:STD_LOGIC;
signal q1out,q2out : std_logic;
begin
Q1 <= q1out;
Q2 <= q2out;
g1: GAND generic map (delay_and) port map (S,E,sa);
g2: GAND generic map (delay_and) port map (R,E,sb);
g3: GNOR2 generic map (delay_nor2) port map (sa,q2out,q1out);
g4: GNOR2 generic map (delay_nor2) port map (sb,q1out,q2out);
end architecture LUT_GATED_SR_2_WON;
