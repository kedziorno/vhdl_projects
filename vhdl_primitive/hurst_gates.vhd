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
	y1 <= ((not a) and (not b)) or (a and b and c); --(a xnor b) and ((not a) or c);
	y2 <= (a and b and c) or ((not a) or (not b) or c) or ((not a) or b or (not c)); --((b xor c) and (not a)) or (a and b and c);
	y3 <= a and ((b and c) or ((not b) or (not c))); --(b xnor c) and a;
	y4 <= (a and b and c) or (a and (not b) and (not c)); --(a xnor b) and (b xnor c);
	y5 <= (a and b) or ((not a) and (not c));
	y6 <= (a and b and c) or ((not a) and (not c)) or ((not b) and (not c)); --(a and b) xnor c;
end Behavioral;

