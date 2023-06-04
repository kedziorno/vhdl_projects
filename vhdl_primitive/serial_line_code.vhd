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
signal pnrzi : bit;

signal pbin1,pbin2 : bit;
signal nrzime : bit;
signal nrzimo : bit;
signal regrz : bit;

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
      pbin1 <= '0';
      pbin2 <= '0';
    else
      pbin1 <= B_in;
      pbin2 <= pbin1;
    end if;
   end if;
end process p_catch_1;

p_NRZI_Mealy : process (clock_1) is
begin
  if (clock_1'event and clock_1 = '0') then
    if (reset = '1') then
      nrzime <= '0';
    else
      if (((B_in = '1' and pbin2 = '1') or (B_in = '1' and pbin2 = '0'))) then
        nrzime <= not nrzime;
      else
        nrzime <= nrzime;
      end if;
    end if;
  end if;
end process p_NRZI_Mealy;
NRZI_Mealy <= nrzime;

p_NRZI_Moore : process (clock_1) is
begin
  if (clock_1'event and clock_1 = '1') then
    if (reset = '1') then
      nrzimo <= '0';
    else
      nrzimo <= nrzime;
    end if;
  end if;
end process p_NRZI_Moore;
NRZI_Moore <= nrzimo;

p_RZ : process (clock_2) is
begin
  if (clock_2'event and clock_2 = '0') then
    if (reset = '1') then
      regrz <= '0';
    else
      if (nrzime /= nrzimo) then
        regrz <= '0';
      else
        regrz <= '1';
      end if;
    end if;
  end if;
end process p_RZ;
RZ <= '0' when ((nrzime = '0' and nrzimo = '0') or (nrzime = '1' and nrzimo = '1')) else regrz;

end Behavioral;
