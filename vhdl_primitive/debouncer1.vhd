----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:58:26 04/23/2021 
-- Design Name: 
-- Module Name:    debouncer1 - Behavioral 
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

entity debouncer1 is
generic (
	fclk : integer := 1;
	twindow : integer := 10
);
port (
	x : in std_logic;
	clk : in std_logic;
	y : out std_logic
);
end debouncer1;

--architecture Behavioral of debouncer1 is
--	constant max : integer := fclk*twindow;
--begin
--	p0 : process (clk) is
--		variable count : integer range 0 to max;
--	begin
--		if (rising_edge(clk)) then
--			if (y /= x) then
--				count := count + 1;
--				if (count=max) then
--					count := 0;
--					y <= x;
--				end if;
--			else
--				count := 0;
--			end if;
--		end if;
--	end process p0;
--end Behavioral;

architecture struct of debouncer1 is
	component FF_D_GATED is
	generic (
		delay_and : TIME := 0 ns;
		delay_or : TIME := 0 ns;
		delay_not : TIME := 0 ns
	);
	port (
		D,E : in STD_LOGIC;
		Q1,Q2 : inout STD_LOGIC
	);
	end component FF_D_GATED;
	for all : FF_D_GATED use entity WORK.FF_D_GATED(Behavioral_GATED_D_NAND);
--	for all : FF_D_GATED use entity WORK.FF_D_GATED(Behavioral_GATED_D_NOR);
	component counter_ping is
	generic (
		max : integer := 1
	);
	port (
		i_clock : in std_logic;
		i_reset : in std_logic;
		o_ping : out std_logic
	);
	end component counter_ping;
	signal ping : std_logic;
	signal clearb : std_logic;
	signal d,q : std_logic;
	constant max : integer := fclk*twindow;
begin
	cp_entity : counter_ping generic map (max => max) port map (i_clock=>clk,i_reset=>not clearb,o_ping=>ping);
	FF_D_GATED_entity : FF_D_GATED port map (D=>d,E=>clk,Q1=>q,Q2=>open);
	p1 : process (x,q,ping) is
	begin
		clearb <= x xor q;
		d <= ping xor q;
		y <= q;	
	end process p1;
end architecture struct;
