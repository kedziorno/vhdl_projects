----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:37:54 05/08/2021 
-- Design Name: 
-- Module Name:    hurst_gates - Behavioral 
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

entity hurst_gates is
Port (
a,b,c : in std_logic;
y1,y2,y3,y4,y5,y6 : out std_logic
);
end hurst_gates;

architecture Behavioral of hurst_gates is
begin
	y1 <= (a xnor b) and ((not a) or c);
	y2 <= ((b xor c) and (not a)) or (a and b and c);
	y3 <= (b xnor c) and a;
	y4 <= (a xnor b) and (b xnor c);
	y5 <= (a and b) or ((not a) and (not c));
	y6 <= (a and b) xnor c;
end Behavioral;

