----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:40:04 04/23/2021 
-- Design Name: 
-- Module Name:    signal_generator - Behavioral 
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

entity signal_generator is
port (
	clk : in bit;
	x : buffer bit;
	y : out bit
);
end signal_generator;

architecture Behavioral of signal_generator is
	type state is (a,b,c);
	signal pr_state1,nx_state1 : state;
	signal pr_state2,nx_state2 : state;
begin
	p0 : process (clk) is
	begin
		if (rising_edge(clk)) then
			pr_state1 <= nx_state1;
		end if;
	end process p0;
	p1 : process (pr_state1,clk) is
	begin
		case pr_state1 is
			when a =>
				x <= '1';
				nx_state1 <= b;
			when b =>
				x <= clk;
				nx_state1 <= c;
			when c =>
				x <= '1';
				nx_state1 <= a;
		end case;
	end process p1;
	p2 : process (clk) is
	begin
		if (rising_edge(clk)) then
			pr_state2 <= nx_state2;
		end if;
	end process p2;
	p3 : process (pr_state1,pr_state2,x) is
	begin
		nx_state2 <= pr_state1;
		case pr_state2 is
			when a =>
				y <= x;
			when b =>
				y <= '1';
			when c =>
				y <= x;
		end case;
	end process p3;
end Behavioral;
