----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:58:09 06/03/2023 
-- Design Name: 
-- Module Name:    serial_line_code - Behavioral 
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

entity serial_line_code is
port (
signal clock_1 : in bit; -- re 1x
signal clock_2 : in bit; -- fe 2x
signal reset : in bit;
signal B_in : in bit;
signal NRZ_Mealy : out bit;
signal NRZ_Moore : out bit;
signal NRZI_Mealy : out bit;
signal NRZI_Moore : out bit;
signal RZ : out bit;
signal Manchester : out bit
);
end serial_line_code;

architecture Behavioral of serial_line_code is

signal bin : bit;
signal manchaster1,manchaster2,manchaster3,manchaster4 : bit;

begin

p_catch_clock : process (clock_2) is
begin
  if (clock_2'event and clock_2 = '1') then
    bin <= clock_1;
  end if;
end process p_catch_clock;

p_Manchester : process (clock_2) is
begin
  if (clock_2'event and clock_2 = '0') then
    if (reset = '1') then
      Manchester <= '0';
    else
      if (B_in = '0') then
        Manchester <= not bin;
      end if;
      if (B_in = '1') then      
        Manchester <= bin;
      end if;
    end if;
  end if;
end process p_Manchester;

end Behavioral;

