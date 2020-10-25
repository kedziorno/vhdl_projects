----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:56:44 09/07/2020 
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
use WORK.p_pkg1.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port(
clk : in STD_LOGIC;
rst : in STD_LOGIC;
sda : out STD_LOGIC;
sck : out STD_LOGIC
);
end top;

architecture Behavioral of top is

constant INPUT_CLOCK : integer := 50_000_000;
constant BUS_CLOCK : integer := 100_000;
constant OLED_WIDTH : integer := 128;
constant OLED_HEIGHT : integer := 32;

component oled_display is
generic(
GLOBAL_CLK : integer;
I2C_CLK : integer;
WIDTH : integer;
HEIGHT : integer);
port(
signal i_clk : in std_logic;
signal i_rst : in std_logic;
signal i_x : in integer;
signal i_y : in integer;
signal i_data : in std_logic;
signal io_sda,io_scl : inout std_logic);
end component oled_display;
for all : oled_display use entity WORK.oled_display(Behavioral);

component clock_divider is
Generic(g_board_clock : integer);
Port(
i_clk : in  STD_LOGIC;
o_clk_25khz : out  STD_LOGIC;
o_clk_50khz : out  STD_LOGIC;
o_clk_14sec : out  STD_LOGIC;
o_clk_1second : out  STD_LOGIC
);
end component clock_divider;
for all : clock_divider use entity WORK.clock_divider(Behavioral);

signal a,b : integer := 0;
signal rst : std_logic := '0';
signal clk_1s : std_logic := '0';

type t_coord is array(0 to 3) of integer;
signal x_coord : t_coord := (0,127,0,127);
signal y_coord : t_coord := (0,0,31,31);

begin

clk_div : clock_divider
generic map(g_board_clock => INPUT_CLOCK)
port map(
i_clk => clk,
o_clk_25khz => open,
o_clk_50khz => open,
o_clk_14sec => open,
o_clk_1second => clk_1s);

c0 : oled_display
generic map(
	GLOBAL_CLK => INPUT_CLOCK,
	I2C_CLK => BUS_CLOCK,
	WIDTH => OLED_WIDTH,
	HEIGHT => OLED_HEIGHT)
port map(
	i_clk => clk,
	i_rst => btn_1,
	i_x => a,
	i_y => b,
	i_data => '1',
	io_sda => sda,
	io_scl => scl
);

p0 : process (clk_1s) is
	variable index : integer range 0 to 4 := 0;
begin
	if (btn_1 = '1') then
		index := 0;
		a <= 0;
		b <= 0;
	elsif (rising_edge(clk_1s)) then
		a <= x_coord(index);
		b <= y_coord(index);
		index := index + 1;
	end if;
end process p0;

end Behavioral;

