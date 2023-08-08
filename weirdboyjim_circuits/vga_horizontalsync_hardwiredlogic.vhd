----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:08:42 04/26/2023 
-- Design Name: 
-- Module Name:    vga_horizontalsync_hardwiredlogic - Behavioral 
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

entity vga_horizontalsync_hardwiredlogic is
port (
  signal i_bit0,i_bit1,i_bit2,i_bit3,i_bit4,i_bit5 : in std_logic;
  signal o_sync,o_blank,o_reset : out std_logic
);
end vga_horizontalsync_hardwiredlogic;

architecture Behavioral of vga_horizontalsync_hardwiredlogic is
  signal a,b,c,d,e,f,g,h : std_logic;
begin
  a <= i_bit0 and i_bit1 and i_bit2;
  b <= i_bit0 or i_bit1 or i_bit2;
  c <= i_bit3 and i_bit5;
  d <= i_bit4 and i_bit5;
  e <= not (b and c);
  f <= c or d;
  g <= i_bit0 and d;
  h <= a or e;
  o_blank <= f;
  o_reset <= g;
  o_sync <= h;
end Behavioral;

