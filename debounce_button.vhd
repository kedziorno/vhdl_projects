----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:13:46 09/15/2020 
-- Design Name: 
-- Module Name:    debounce_button - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce_button is
generic (g_board_clock : integer);
Port
(
i_button : in  STD_LOGIC;
i_clk : in  STD_LOGIC;
o_stable : out  STD_LOGIC
);
end debounce_button;

architecture Behavioral of debounce_button is

component clock_divider is
Generic(g_board_clock : integer);
Port(
i_clk : in  STD_LOGIC;
o_clk_25khz : out  STD_LOGIC;
o_clk_50khz : out  STD_LOGIC
);
end component clock_divider;
for all : clock_divider use entity WORK.clock_divider(Behavioral);

COMPONENT FF_D_GATED_NAND
GENERIC(
DELAY_AND : TIME;
DELAY_OR : TIME;
DELAY_NOT : TIME
);
PORT(
D : IN  std_logic;
E : IN  std_logic;
Q1 : INOUT  std_logic;
Q2 : INOUT  std_logic
);
END COMPONENT;
for all : FF_D_GATED_NAND use entity WORK.FF_D_GATED(Behavioral_GATED_D_NAND);

component GAND is
GENERIC (
DELAY_AND : TIME
);
port (
A,B : in STD_LOGIC;
C : out STD_LOGIC
);
end component GAND;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);

signal sa,sb,sc,sd,se,sf,sg,sh : std_logic := '0';

signal clk_25khz : std_logic;
signal clk_50khz : std_logic;

constant delay_and : TIME := 0 ns;
constant delay_or : TIME := 0 ns;
constant delay_not : TIME := 0 ns;

begin

clk_div : clock_divider
generic map (
g_board_clock => g_board_clock
)
port map
(
i_clk => i_clk,
o_clk_25khz => clk_25khz,
o_clk_50khz => clk_50khz
);

uut1: FF_D_GATED_NAND
GENERIC MAP (DELAY_AND => delay_and,DELAY_OR => delay_or,DELAY_NOT => delay_not)
PORT MAP (D => i_button,E => i_clk,Q1 => sa,Q2 => open);

uut2: FF_D_GATED_NAND
GENERIC MAP (DELAY_AND => delay_and,DELAY_OR => delay_or,DELAY_NOT => delay_not)
PORT MAP (D => sa,E => i_clk,Q1 => sb,Q2 => open);

uut3: FF_D_GATED_NAND
GENERIC MAP (DELAY_AND => delay_and,DELAY_OR => delay_or,DELAY_NOT => delay_not)
PORT MAP (D => sb,E => i_clk,Q1 => open,Q2 => sc);

g1: GAND GENERIC MAP (DELAY_AND => delay_and) port map (sa,sb,sd);
g2: GAND GENERIC MAP (DELAY_AND => delay_and) port map (sd,sc,o_stable);

end Behavioral;

