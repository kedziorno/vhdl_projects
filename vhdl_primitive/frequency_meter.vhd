----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:08:20 04/23/2021 
-- Design Name: 
-- Module Name:    frequency_meter - Behavioral 
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

entity frequency_meter is
generic (
	fclk : integer := 5;
	fxmax : integer := 15
);
port (
	clk,x : in bit;
	test : out bit;
	fx : out integer range 0 to fxmax
);
end frequency_meter;

architecture Behavioral of frequency_meter is
	signal twindow : bit;
	signal temp : integer range 0 to fxmax;
begin
	p0 : process (clk) is
		variable count : integer range 0 to fclk;
	begin
		if (rising_edge(clk)) then
			count := count + 1;
			if (count=fclk) then
				twindow <= '1';
			elsif (count=fclk+1) then
				twindow <= '0';
				count := 0;
			end if;
		end if;
	end process p0;
	p1 : process (x,twindow) is
		variable count : integer range 0 to 20;
	begin
		if (twindow='1') then
			count := 0;
		elsif (x'event and x='1') then -- rising_edge(x)
			count := count + 1;
		end if;
		temp <= count;
	end process p1;
	p2 : process (twindow) is
	begin
		if (twindow'event and twindow='1') then -- rising_edge(twindow)
			fx <= temp;
		end if;
	end process p2;
	test <= twindow;
end Behavioral;
