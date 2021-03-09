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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
Generic (
	G_BOARD_CLOCK : integer
);
Port (
	i_clk : in  STD_LOGIC;
	i_btn : in  STD_LOGIC;
	o_db_btn : out  STD_LOGIC
);
end debounce;

architecture Behavioral of debounce is

	COMPONENT clock_divider_cnt IS
	Generic (
		g_board_clock : integer;
		g_divider : integer
	);
	Port (
		i_clock : in STD_LOGIC;
		o_clock : out STD_LOGIC
	);
	END COMPONENT clock_divider_cnt;

	signal d_clk : std_logic;
	signal q0,q1,q2 : std_logic;

begin

	clk_div_cnt : clock_divider_cnt
	GENERIC MAP (
		g_board_clock => G_BOARD_CLOCK,
		g_divider => 33 -- XXX ~30ms
	)
	PORT MAP (
		i_clock => i_clk,
		o_clock => d_clk
	);
	
	p0 : process (d_clk) is
	begin
		if (rising_edge(d_clk)) then
			q2 <= i_btn;
			q1 <= q2;
			q0 <= q1;
		end if;
	end process p0;

	o_db_btn <= (q2 and q1 and not q0);

end Behavioral;
