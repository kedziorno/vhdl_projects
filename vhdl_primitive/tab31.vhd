----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:27:24 06/05/2023 
-- Design Name:    BCD and Ex-3 decode from 0-9
-- Module Name:    tab31 - Behavioral 
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

entity tab31 is
port (
signal Decimal_Digit : in bit_vector (3 downto 0);
signal BCD8421_Codes : out bit_vector (3 downto 0);
signal Excess3_Codes : out bit_vector (3 downto 0)
);
end tab31;

architecture Behavioral of tab31 is

begin

p0 : process (Decimal_Digit) is
begin
  case (Decimal_Digit) is
    when "0000" =>
      BCD8421_Codes <= "0000";
      Excess3_Codes <= "0011";
    when "0001" =>
      BCD8421_Codes <= "0001";
      Excess3_Codes <= "0100";
    when "0010" =>
      BCD8421_Codes <= "0010";
      Excess3_Codes <= "0101";
    when "0011" =>
      BCD8421_Codes <= "0011";
      Excess3_Codes <= "0110";
    when "0100" =>
      BCD8421_Codes <= "0100";
      Excess3_Codes <= "0111";
    when "0101" =>
      BCD8421_Codes <= "0101";
      Excess3_Codes <= "1000";
    when "0110" =>
      BCD8421_Codes <= "0110";
      Excess3_Codes <= "1001";
    when "0111" =>
      BCD8421_Codes <= "0111";
      Excess3_Codes <= "1010";
    when "1000" =>
      BCD8421_Codes <= "1000";
      Excess3_Codes <= "1011";
    when "1001" =>
      BCD8421_Codes <= "1001";
      Excess3_Codes <= "1100";
    when others =>
      BCD8421_Codes <= "0000";
      Excess3_Codes <= "0000";
  end case;
end process p0;

end Behavioral;

