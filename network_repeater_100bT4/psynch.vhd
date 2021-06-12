----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:00:51 06/12/2021 
-- Design Name: 
-- Module Name:    psynch - Behavioral 
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

entity psynch is
port (
	clk,reset : in std_logic;
	d : in std_logic;
	q : out std_logic
);
end psynch;

architecture archpsynch of psynch is
	signal temp : std_logic;
begin
	p1 : process (preset,clk) is
	begin
		if (preset = '1') then
			q <= '1';
		elsif (rising_edge(clk)) then
			temp <= d;
			q <= temp;
		end if;
	end process p1;
end archpsynch;
