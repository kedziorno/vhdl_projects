----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:03:18 08/27/2023 
-- Design Name: 
-- Module Name:    test_add4 - Behavioral 
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
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_add4 is
port (
i_clock : in std_logic;
i_reset : in std_logic;
ia : in std_logic_vector (3 downto 0);
io : out std_logic_vector (4 downto 0)
);
end test_add4;

architecture Behavioral of test_add4 is

signal a : std_logic_vector (3 downto 0);
signal o : std_logic_vector (4 downto 0);

attribute keep : string;
attribute keep of a : signal is "true";
attribute keep of o : signal is "true";

begin

a <= ia;

p0 : process (i_clock) is
begin
  if (not i_clock'stable and i_clock = '1') then
    if (i_reset = '1') then
      o <= (others => '0');
    else
      o <= ("0"&a + "00100");
    end if;
  end if;
end process p0;

io <= o;
end Behavioral;

