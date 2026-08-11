----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:04:58 12/04/2024 
-- Design Name: 
-- Module Name:    counter_test1 - Behavioral 
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

entity counter_test1 is
port (
i_clock : in std_logic;
i_reset : in std_logic;
y_inc : out signed (31 downto 0);
y_dec : out signed (31 downto 0)
);
end counter_test1;

architecture Behavioral of counter_test1 is
  signal y1 : signed (31 downto 0);
  signal y2 : signed (31 downto 0);
begin
  p0 : process (i_clock, i_reset) is
  begin
    if (i_reset = '1') then
      y1 <= (others => '0');
    elsif (rising_edge (i_clock)) then
      y1 <= - (not y1);
    end if;
  end process p0;
  p1 : process (i_clock, i_reset) is
  begin
    if (i_reset = '1') then
      y2 <= (others => '1');
    elsif (rising_edge (i_clock)) then
      y2 <= not (- y2);
    end if;
  end process p1;
  y_inc <= y1;
  y_dec <= y2;
end Behavioral;
