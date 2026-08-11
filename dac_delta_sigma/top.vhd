----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:13:38 03/03/2021 
-- Design Name: 
-- Module Name:    top - Behavioral 
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

entity top is
Port (
clk : in  STD_LOGIC;
led : out  STD_LOGIC_VECTOR (7 downto 0)
);
end top;

architecture Behavioral of top is

component clock_divider1 is
Generic (
	g_board_clock : integer;
	g_divider : integer
);
Port (
	i_clock : in STD_LOGIC;
	o_clock : out STD_LOGIC
);
end component clock_divider1;

component dac_delta_sigma is
Port (
clk : in  STD_LOGIC;
data : in  STD_LOGIC_VECTOR (7 downto 0);
PulseStream : out  STD_LOGIC
);
end component dac_delta_sigma;

signal data : std_logic_vector(7 downto 0);
signal o_ps : std_logic;

signal o_clk : std_logic;

signal direction : std_logic := '0';

begin

c0 : dac_delta_sigma
port map (
clk => o_clk,
data => data,
PulseStream => o_ps
);

c1 : clock_divider1
Generic map (g_board_clock => 50_000_000, g_divider => 100)
Port map(i_clock => clk, o_clock => o_clk);

p0 : process (o_clk,direction) is
	variable index : integer range 0 to 255 := 0;
	variable v_data : std_logic_vector(7 downto 0);
begin
	if (o_clk = '0') then
		if (direction = '0') then
			if (index = 255) then
				direction <= '1';
				index := 255;
			else
				v_data := std_logic_vector(to_unsigned(index,8));
				index := index + 1;
			end if;
		end if;
		if (direction = '1') then
			if (index = 0) then
				direction <= '0';
				index := 0;
			else
				v_data := std_logic_vector(to_unsigned(index,8));
				index := index - 1;
			end if;
		end if;
	end if;
	data <= v_data;
end process p0;

led(0) <= o_ps;
led(1) <= o_ps;
led(2) <= o_ps;
led(3) <= o_ps;
led(4) <= o_ps;
led(5) <= o_ps;
led(6) <= o_ps;
led(7) <= o_ps;

end Behavioral;
