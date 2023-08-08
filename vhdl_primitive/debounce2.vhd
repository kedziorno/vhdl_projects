----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:44:39 03/09/2021 
-- Design Name: 
-- Module Name:    debounce - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce2 is
Generic (
	G_BOARD_CLOCK : integer := 50_000_000;
	G_SIZE : integer := 8
);
Port (
	i_clk : in  STD_LOGIC;
	i_reset : in  STD_LOGIC;
	i_btn : in  STD_LOGIC;
	o_db_btn : out  STD_LOGIC
);
end debounce;

architecture Behavioral of debounce2 is

	COMPONENT clock_divider_cnt IS
	Generic (
		g_board_clock : integer;
		g_divider : integer
	);
	Port (
		i_reset : in STD_LOGIC;
		i_clock : in STD_LOGIC;
		o_clock : out STD_LOGIC
	);
	END COMPONENT clock_divider_cnt;

	signal d_clk : std_logic;
	signal q : std_logic_vector(G_SIZE-1 downto 0);
	signal qn : std_logic_vector(G_SIZE-1 downto 0);

begin

	clk_div_cnt : clock_divider_cnt
	GENERIC MAP (
		g_board_clock => G_BOARD_CLOCK,
		g_divider => G_BOARD_CLOCK/2/1250
	)
	PORT MAP (
		i_reset => i_reset,
		i_clock => i_clk,
		o_clock => d_clk
	);
	
	p0 : process (i_clk,i_reset) is
	begin
		if (i_reset = '1') then
			q <= (others => '0');
			qn <= (others => '1');
			o_db_btn <= '0';
		elsif (rising_edge(i_clk)) then
			q(G_SIZE-1 downto 0) <= q(G_SIZE-2 downto 0) & i_btn;
			if (q(G_SIZE-1 downto 0) = qn(G_SIZE-1 downto 0)) then
				o_db_btn <= '1';
				q <= (others => '0');
			else
				o_db_btn <= '0';
			end if;
		end if;
	end process p0;

end Behavioral;
