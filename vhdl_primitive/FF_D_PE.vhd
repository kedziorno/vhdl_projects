library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_D_POSITIVE_EDGE is
port (
S : in std_logic := '0';
R : in std_logic := '0';
C : in std_logic;
D : in STD_LOGIC;
Q1,Q2:inout STD_LOGIC);
end entity FF_D_POSITIVE_EDGE;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Classical_positive-edge-triggered_D_flip-flop
architecture Behavioral_D_PE of FF_D_POSITIVE_EDGE is
component GAND is
generic (delay_and:time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GN is
generic (delay_not:time := 0 ns);
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal X,Y,Z,V,W,O,sa,sb,sc,sd,se,sf:STD_LOGIC;
constant DELAY_AND : time := 1 ps;
constant DELAY_NOT : time := 1 ps;
signal setu,setd,resetu,resetd : std_logic;
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
g1 : Q1 <= not (Q2 and S and setd);
g2 : Q2 <= not (Q1 and setu and R);
g3 : setu <= not (S and setd and resetd);
g4 : setd <= not (setu and C and R);
g5 : resetu <= not (C and resetd and setd);
g6 : resetd <= not (D and R and resetu);

end architecture Behavioral_D_PE;
