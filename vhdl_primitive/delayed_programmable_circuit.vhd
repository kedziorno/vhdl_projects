----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:35:29 08/22/2021 
-- Design Name: 
-- Module Name:    delayed_programmable_circuit - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity delayed_programmable_circuit is
port (
i_reg1 : in std_logic;
i_reg2 : in std_logic;
i_reg3 : in std_logic;
i_reg4 : in std_logic;
i_reg5 : in std_logic;
i_reg6 : in std_logic;
i_reg7 : in std_logic;
i_input : in std_logic;
o_output : out std_logic
);
end delayed_programmable_circuit;

architecture Behavioral of delayed_programmable_circuit is

component MUX_21 is
port (S,A,B:in STD_LOGIC;C:out STD_LOGIC);
end component MUX_21;

component GATE_NOT is
generic (
delay_not : time := 1 ns
);
port (
A : in STD_LOGIC;
B : out STD_LOGIC
);
end component GATE_NOT;
for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);

component DEMUX_12 is
port (S,A:in STD_LOGIC;B,C:out STD_LOGIC);
end component DEMUX_12;

signal mux_out : std_logic_vector(8 downto 1);
signal normal_line : std_logic_vector(8 downto 1);

signal nots1 : std_logic_vector(2**1 downto 0);
signal nots2 : std_logic_vector(2**2 downto 0);
signal nots3 : std_logic_vector(2**3 downto 0);
signal nots4 : std_logic_vector(2**4 downto 0);
signal nots5 : std_logic_vector(2**5 downto 0);
signal nots6 : std_logic_vector(2**6 downto 0);
signal nots7 : std_logic_vector(2**7 downto 0);

begin

dmx1 : DEMUX_12 port map (
S => i_reg1, A => i_input,
B => normal_line(1), C => nots1(0)
);
gnots1 : for i in 1 to 2**1 generate
	gn : GATE_NOT port map (A => nots1(i-1), B => nots1(i));
end generate gnots1;
mux1 : MUX_21 port map (
S => i_reg1,
A => normal_line(1), B => nots1(2**1),
C => mux_out(1)
);

dmx2 : DEMUX_12 port map (
S => i_reg2, A => mux_out(1),
B => normal_line(2), C => nots2(0)
);
gnots2 : for i in 1 to 2**2 generate
	gn : GATE_NOT port map (A => nots2(i-1), B => nots2(i));
end generate gnots2;
mux2 : MUX_21 port map (
S => i_reg2,
A => normal_line(2), B => nots2(2**2),
C => mux_out(2)
);

dmx3 : DEMUX_12 port map (
S => i_reg3, A => mux_out(2),
B => normal_line(3), C => nots3(0)
);
gnots3 : for i in 1 to 2**3 generate
	gn : GATE_NOT port map (A => nots3(i-1), B => nots3(i));
end generate gnots3;
mux3 : MUX_21 port map (
S => i_reg3,
A => normal_line(3), B => nots3(2**3),
C => mux_out(3)
);

dmx4 : DEMUX_12 port map (
S => i_reg4, A => mux_out(3),
B => normal_line(4), C => nots4(0)
);
gnots4 : for i in 1 to 2**4 generate
	gn : GATE_NOT port map (A => nots4(i-1), B => nots4(i));
end generate gnots4;
mux4 : MUX_21 port map (
S => i_reg4,
A => normal_line(4), B => nots4(2**4),
C => mux_out(4)
);

dmx5 : DEMUX_12 port map (
S => i_reg5, A => mux_out(4),
B => normal_line(5), C => nots5(0)
);
gnots5 : for i in 1 to 2**5 generate
	gn : GATE_NOT port map (A => nots5(i-1), B => nots5(i));
end generate gnots5;
mux5 : MUX_21 port map (
S => i_reg5,
A => normal_line(5), B => nots5(2**5),
C => mux_out(5)
);

dmx6 : DEMUX_12 port map (
S => i_reg6, A => mux_out(5),
B => normal_line(6), C => nots6(0)
);
gnots6 : for i in 1 to 2**6 generate
	gn : GATE_NOT port map (A => nots6(i-1), B => nots6(i));
end generate gnots6;
mux6 : MUX_21 port map (
S => i_reg6,
A => normal_line(6), B => nots6(2**6),
C => mux_out(6)
);

dmx7 : DEMUX_12 port map (
S => i_reg7, A => mux_out(6),
B => normal_line(7), C => nots7(0)
);
gnots7 : for i in 1 to 2**7 generate
	gn : GATE_NOT port map (A => nots7(i-1), B => nots7(i));
end generate gnots7;
mux7 : MUX_21 port map (
S => i_reg7,
A => normal_line(7), B => nots7(2**7),
C => mux_out(7)
);

o_output <= mux_out(7);

end Behavioral;
