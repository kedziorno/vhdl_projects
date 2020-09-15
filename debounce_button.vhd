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
Port
(
i_button : in  STD_LOGIC;
i_clk : in  STD_LOGIC;
o_stable : out  STD_LOGIC
);
end debounce_button;

architecture Behavioral of debounce_button is

COMPONENT FF_D_GATED_NAND
PORT(
D : IN  std_logic;
E : IN  std_logic;
Q1 : INOUT  std_logic;
Q2 : INOUT  std_logic
);
END COMPONENT;
for all : FF_D_GATED_NAND use entity WORK.FF_D_GATED(Behavioral_GATED_D_NOR);

component GAND is
port (A,B:in STD_LOGIC;C:out STD_LOGIC);
end component GAND;
for all : GAND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);

signal sa,sb,sc,sd,se,sf,sg,sh : std_logic;

begin

uut1: FF_D_GATED_NAND PORT MAP (
D => i_button,
E => i_clk,
Q1 => sa,
Q2 => open
);

uut2: FF_D_GATED_NAND PORT MAP (
D => sa,
E => i_clk,
Q1 => sb,
Q2 => open
);

uut3: FF_D_GATED_NAND PORT MAP (
D => sb,
E => i_clk,
Q1 => open,
Q2 => sc
);

g1: GAND port map (sa,sb,sd);
g2: GAND port map (sd,sc,o_stable);

end Behavioral;

