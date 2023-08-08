----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:49:51 06/04/2023 
-- Design Name:    CMOS MS DFF
-- Module Name:    fig37 - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity fig37 is
port (
Data : in std_logic;
Clear_bar : in std_logic;
clock : in std_logic;
Q,Qb : out std_logic
);
end fig37;

architecture Behavioral of fig37 is

component transmission_gate is
port (
	io_a : in std_logic;
	io_b : out std_logic;
	i_s : in std_logic
);
end component transmission_gate;
--for all : transmission_gate use entity work.transmission_gate(Behavioral1);
for all : transmission_gate use entity work.transmission_gate(Behavioral2);

component GATE_NOT is
generic (
delay_not : TIME := 1 ps
);
port (
A : in STD_LOGIC;
B : out STD_LOGIC
);
end component GATE_NOT;
for all : GATE_NOT use entity work.GATE_NOT(GATE_NOT_LUT);

signal a,b,b1,c,c1,d,e,e1,f,f1,g,h,h1 : std_logic := '0';
attribute KEEP : string;
attribute KEEP of a : signal is "true";
attribute KEEP of b : signal is "true";
attribute KEEP of b1 : signal is "true";
attribute KEEP of c : signal is "true";
attribute KEEP of c1 : signal is "true";
attribute KEEP of d : signal is "true";
attribute KEEP of e : signal is "true";
attribute KEEP of e1 : signal is "true";
attribute KEEP of f : signal is "true";
attribute KEEP of f1 : signal is "true";
attribute KEEP of g : signal is "true";
attribute KEEP of h : signal is "true";
attribute KEEP of h1 : signal is "true";

begin

inst1 : BUF port map (I=>Data,O=>a);

clock_tg1 : transmission_gate
port map (
io_a => a,
io_b => b,
i_s => not clock
);

c <= b nand Clear_bar after 1 ns;
inst_not1 : GATE_NOT port map (A=>c,B=>d);

clock_tg2 : transmission_gate
port map (
io_a => d,
io_b => b1,
i_s => clock
);

inst2 : BUF port map (I=>c,O=>c1);

clock_tg3 : transmission_gate
port map (
io_a => c1,
io_b => e,
i_s => clock
);

bt1 : BUFT port map (I=>b1,O=>b,T=>not clock);

inst_not2 : GATE_NOT port map (A=>e,B=>f);
g <= f nand Clear_bar;

Qb <= g;
Q <= not g;

clock_tg4 : transmission_gate
port map (
io_a => g,
io_b => e1,
i_s => not clock
);

bt2 : BUFT port map (I=>e1,O=>e,T=>clock);

end Behavioral;

