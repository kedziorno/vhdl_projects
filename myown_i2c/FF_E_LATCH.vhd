library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_E_LATCH is
generic (
delay_and : time := 0 ns;
delay_and3 : time := 0 ns;
delay_not : time := 0 ns;
delay_nand2 : time := 0 ns;
delay_nand3 : time := 0 ns
);
port (D,E_H,E_L:in STD_LOGIC;Q:out STD_LOGIC);
end entity FF_E_LATCH;

-- https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Earle_latch
architecture Behavioral_E_LATCH of FF_E_LATCH is
component GAND is
generic (delay_and : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GAND3 is
generic (delay_and3 : time := 0 ns);
port (A,B,C:in STD_LOGIC;D:out STD_LOGIC);
end component GAND3;
component GN is
generic (delay_not : time := 0 ns);
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
for all : GAND3 use entity WORK.GATE_AND3(GATE_AND3_BEHAVIORAL_1);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal sa,sb,sc,sd,se,sf,sg,sh,si:STD_LOGIC;
signal qout : std_logic;
begin
Q <= qout;
g1: GAND generic map (delay_and) port map (A => E_H, B => D, C => sa);
g2: GN generic map (delay_not) port map (A => sa, B => sb);
g3: GAND generic map (delay_and) port map (A => D, B => qout, C => sc);
g4: GN generic map (delay_not) port map (A => sc, B =>sd);
g5: GAND generic map (delay_and) port map (A => qout, B => E_L, C => se);
g6: GN generic map (delay_not) port map (A => se, B => sf);
g7: GAND3 generic map (delay_and3) port map (A => sb, B => sd, C => sf, D => sh);
g8: GN generic map (delay_not) port map (A => sh, B => qout);
end architecture Behavioral_E_LATCH;

architecture LUT_E_LATCH of FF_E_LATCH is
component GAND is
generic (delay_and : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
component GAND3 is
generic (delay_and3 : time := 0 ns);
port (A,B,C:in STD_LOGIC;D:out STD_LOGIC);
end component GAND3;
component GN is
generic (delay_not : time := 0 ns);
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : GAND use entity WORK.GATE_AND(GATE_AND_LUT);
for all : GAND3 use entity WORK.GATE_AND3(GATE_AND3_LUT);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_LUT);
signal sa,sb,sc,sd,se,sf,sg,sh,si:STD_LOGIC;
signal qout : std_logic;
begin
Q <= qout;
g1: GAND generic map (delay_and) port map (A => E_H, B => D, C => sa);
g2: GN generic map (delay_not) port map (A => sa, B => sb);
g3: GAND generic map (delay_and) port map (A => D, B => qout, C => sc);
g4: GN generic map (delay_not) port map (A => sc, B => sd);
g5: GAND generic map (delay_and) port map (A => qout, B => E_L, C => se);
g6: GN generic map (delay_not) port map (A => se, B => sf);
g7: GAND3 generic map (delay_and3) port map (A => sb, B => sd, C => sf, D => sh);
g8: GN generic map (delay_not) port map (A => sh, B => qout);
end architecture LUT_E_LATCH;

architecture LUT_E_LATCH_NAND of FF_E_LATCH is
component GNAND2 is
generic (delay_nand2 : time := 0 ns);
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GNAND2;
component GNAND3 is
generic (delay_nand3 : time := 0 ns);
port (A,B,C:in STD_LOGIC;D:out STD_LOGIC);
end component GNAND3;
for all : GNAND2 use entity WORK.GATE_NAND2(GATE_NAND2_LUT);
for all : GNAND3 use entity WORK.GATE_NAND3(GATE_NAND3_LUT);
signal sb,sd,sf:STD_LOGIC := '0';
signal qout : std_logic;
begin
Q <= qout;
g1: GNAND2 generic map (delay_nand2) port map (A => E_H, B => D, C => sb);
g2: GNAND2 generic map (delay_nand2) port map (A => D, B => qout, C => sd);
g3: GNAND2 generic map (delay_nand2) port map (A => qout, B => E_L, C => sf);
g4: GNAND3 generic map (delay_nand3) port map (A => sb, B => sd, C => sf, D => qout);
end architecture LUT_E_LATCH_NAND;
