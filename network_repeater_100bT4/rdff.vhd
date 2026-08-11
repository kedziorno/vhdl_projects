----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:37:13 06/12/2021 
-- Design Name: 
-- Module Name:    rdff - Behavioral 
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

entity rdff is
generic (size : integer := 2);
port (
	clk,reset : in std_logic;
	d : in std_logic_vector(size-1 downto 0);
	q : out std_logic_vector(size-1 downto 0)
);
end rdff;

architecture archrdff of rdff is
begin
	p1 : process (reset,clk) is
	begin
		if (reset = '1') then
			q <= (others => '0');
		elsif(rising_edge(clk)) then
			q <= d;
		end if;
	end process p1;
end archrdff;
