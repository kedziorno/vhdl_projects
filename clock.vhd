----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:41:31 08/08/2020 
-- Design Name: 
-- Module Name:    clock - Behavioral 
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

entity clock is
port (clock_out: out STD_LOGIC);
end clock;

architecture Behavioral of clock is
component FF_SR_NOR is
port (S,R:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
end component FF_SR_NOR;
component GN is
port (A:in STD_LOGIC;B:out STD_LOGIC);
end component GN;
for all : FF_SR_NOR use entity WORK.FF_SR(Behavioral_NOR);
for all : GN use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
signal sCLOCK: STD_LOGIC;
begin
sCLOCK <= '0';
p0 : process (sCLOCK) is
begin
g1: FF_SR_NOR port map (sCLOCK,open,Q1,open);
g2: GN port map (Q1,sCLOCK);
wait for 20 ns;
end process p0;
end Behavioral;

