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
signal NRZI_Mealy : buffer bit;
signal NRZI_Moore : out bit;
signal RZ : out bit;
signal Manchester : out bit
);
end serial_line_code;

architecture Behavioral of serial_line_code is

signal bin : bit;
signal pnrzi : bit;
signal toggle : bit;

signal reg1,reg2 : bit;
signal prev : bit;

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

p_NRZ_Mealy : process (clock_1) is
begin
  if (clock_1'event and clock_1 = '0') then
    NRZ_Mealy <= B_in;
  end if;
end process p_NRZ_Mealy;

p_NRZ_Moore : process (clock_1) is
begin
  if (clock_1'event and clock_1 = '1') then
    NRZ_Moore <= B_in;
  end if;
end process p_NRZ_Moore;

p_catch_1 : process (clock_1) is
begin
  if (clock_1'event and clock_1 = '0') then
    if (reset = '1') then
      reg1 <= '0';
      reg2 <= '0';
    else
      reg1 <= B_in;
      reg2 <= reg1;
    end if;
   end if;
end process p_catch_1;

p_NRZI_Mealy2 : process (clock_1) is
begin
  if (clock_1'event and clock_1 = '0') then
    if (reset = '1') then
      pnrzi <= '0';
      toggle <= '0';
    else
      pnrzi <= B_in;
      if (((B_in = '1' and reg2 = '1') or (B_in = '1' and reg2 = '0'))) then
        toggle <= '1';
      else
        toggle <= '0';
      end if;
    end if;
   end if;
end process p_NRZI_Mealy2;

p_prev : process (clock_1) is
begin
  if (clock_1'event and clock_1 = '0') then
    if (reset = '1') then
      prev <= '0';
    else
      prev <= NRZI_Mealy;
    end if;
  end if;
end process p_prev;

p_NRZI_Mealy1 : process (clock_1) is
begin
  if (clock_1'event and clock_1 = '0') then
    if (reset = '1') then
      NRZI_Mealy <= '0';
    else
      if (((B_in = '1' and reg2 = '1') or (B_in = '1' and reg2 = '0'))) then
        NRZI_Mealy <= not NRZI_Mealy;
      else
        NRZI_Mealy <= NRZI_Mealy;
      end if;
    end if;
  end if;
end process p_NRZI_Mealy1;

end Behavioral;

