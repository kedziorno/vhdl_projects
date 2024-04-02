----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:08:00 05/07/2021 
-- Design Name: 
-- Module Name:    count - Behavioral 
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity COUNT16 is -- XXX check for more than 32 bit in simulator
port (Clk,Rst,Load: in std_logic;
Data: in std_logic_vector (3 downto 0);
Count: out std_logic_vector (3 downto 0)
);
end COUNT16;

architecture COUNT16_A of COUNT16 is
	signal Q: unsigned (3 downto 0);
	constant MAXCOUNT: unsigned (3 downto 0) := "1111";
begin
	process(Rst,Clk)
	begin
		if Rst = '1' then
			Q <= (others => '0');
		elsif rising_edge(Clk) then
			if Load = '1' then
				Q <= UNSIGNED(Data); -- Type conversion
			elsif Q = MAXCOUNT then
				Q <= (others => '0');
			else
				Q <= Q + 1;
			end if;
		end if;
		Count <= STD_LOGIC_VECTOR(Q); -- Type conversion
	end process;
end COUNT16_A;
