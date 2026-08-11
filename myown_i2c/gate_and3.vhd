----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:50:05 09/12/2021 
-- Design Name: 
-- Module Name:    gate_and3 - Behavioral 
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
library UNISIM;
use UNISIM.vcomponents.all;

entity GATE_AND3 is
generic (
delay_and3 : TIME := 0 ns
);
port (
A,B,C : in STD_LOGIC;
D : out STD_LOGIC
);
end entity GATE_AND3;

architecture GATE_AND3_BEHAVIORAL_1 of GATE_AND3 is
begin
D <= (A and B and C) after delay_and3;
end architecture GATE_AND3_BEHAVIORAL_1;

architecture GATE_AND3_LUT of GATE_AND3 is
	signal T : std_logic;
begin
LUT3_inst : LUT3
generic map (
	INIT => "10000000")
port map (
	O => T,
	I0 => A,
	I1 => B,
	I2 => C
);
D <= T after delay_and3;
end architecture GATE_AND3_LUT;
