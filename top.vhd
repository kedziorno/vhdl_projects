----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:11:54 09/04/2020 
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
port(
signal clk : in std_logic;
signal btn_1 : in std_logic;
signal sda,scl : inout std_logic
);
end top;

architecture Behavioral of top is

constant INPUT_CLOCK : integer := 50_000_000;
constant BUS_CLOCK : integer := 100_000;
constant OLED_WIDTH : integer := 128;
constant OLED_HEIGHT : integer := 32;
constant OLED_W_BITS : integer := 7; -- 128
constant OLED_H_BITS : integer := 5; -- 32

component oled_display is
generic(
GLOBAL_CLK : integer;
I2C_CLK : integer;
WIDTH : integer;
HEIGHT : integer;
W_BITS : integer;
H_BITS : integer);
port(
signal i_clk : in std_logic;
signal i_rst : in std_logic;
signal i_x : in std_logic_vector(OLED_W_BITS-1 downto 0);
signal i_y : in std_logic_vector(OLED_H_BITS-1 downto 0);
signal i_bit : in std_logic_vector(0 downto 0);
signal i_all_pixels : in std_logic;
signal io_sda,io_scl : inout std_logic);
end component oled_display;
for all : oled_display use entity WORK.oled_display(Behavioral);
	
component clock_divider is
Generic(
g_board_clock : integer;
g_divider : integer);
Port(
i_clk : in STD_LOGIC;
o_clk : out STD_LOGIC);
end component clock_divider;
for all : clock_divider use entity WORK.clock_divider(Behavioral);

component memory1 is
Generic (
WIDTH : integer := 128;
HEIGHT : integer := 32;
W_BITS : integer := 7;
H_BITS : integer := 5);
Port (
i_clk : in std_logic;
i_x : in std_logic_vector(W_BITS-1 downto 0);
i_y : in std_logic_vector(H_BITS-1 downto 0);
o_bit : out std_logic_vector(0 downto 0));
end component memory1;
for all : memory1 use entity WORK.memory1(Behavioral);

signal a : std_logic_vector(OLED_W_BITS-1 downto 0) := (others => '0');
signal b : std_logic_vector(OLED_H_BITS-1 downto 0) := (others => '0');
signal rst : std_logic := '0';
signal all_pixels : std_logic := '0';
signal clk_1s : std_logic := '0';

constant NV : integer := 4; -- 10
type t_coord_x is array(0 to NV-1) of std_logic_vector(7 downto 0);
type t_coord_y is array(0 to NV-1) of std_logic_vector(7 downto 0);
--signal x_coord : t_coord_x := (x"79",x"78",x"66",x"55",x"44",x"33",x"22",x"11",x"05",x"00");
--signal y_coord : t_coord_y := (x"01",x"01",x"01",x"01",x"01",x"01",x"01",x"01",x"01",x"01");
--signal x_coord : t_coord_x := (x"00",x"7F",x"00",x"7F");
--signal y_coord : t_coord_y := (x"00",x"00",x"1F",x"1F");
signal display_bit : std_logic_vector(0 downto 0) := "0";

--constant clk_period : time := 20 ns;
--signal clk : std_logic := '0';
--signal btn_1 : std_logic := '0';
--signal sda,scl : std_logic;
signal i : integer range 0 to OLED_WIDTH-1 := 0;
signal j : integer range 0 to OLED_HEIGHT-1 := 0;

begin

--	clk_process :process
--	begin
--		clk <= '0';
--		wait for clk_period/2;
--		clk <= '1';
--		wait for clk_period/2;
--	end process;
--	pp : process
--	begin
--		wait for clk_period;
--		btn_1 <= '0';
--		wait for clk_period;
--		btn_1 <= '1';
--		wait for clk_period;
--		btn_1 <= '0';
--	end process;
	
clk_div : clock_divider
generic map (
	g_board_clock => INPUT_CLOCK,
	g_divider => 64)
port map (
	i_clk => clk,
	o_clk => clk_1s
);

c0 : oled_display
generic map (
	GLOBAL_CLK => INPUT_CLOCK,
	I2C_CLK => BUS_CLOCK,
	WIDTH => OLED_WIDTH,
	HEIGHT => OLED_HEIGHT,
	W_BITS => OLED_W_BITS,
	H_BITS => OLED_H_BITS)
port map (
	i_clk => clk,
	i_rst => btn_1,
	i_x => a,
	i_y => b,
	i_bit => "1",
	i_all_pixels => all_pixels,
	io_sda => sda,
	io_scl => scl
);

m1 : memory1
generic map (
	WIDTH => OLED_WIDTH,
	HEIGHT => OLED_HEIGHT,
	W_BITS => OLED_W_BITS,
	H_BITS => OLED_H_BITS)
port map (
	i_clk => clk,
	i_x => a,
	i_y => b,
	o_bit => display_bit
);

p0 : process (clk_1s) is
begin
	if (rising_edge(clk_1s)) then
		if (btn_1 = '1') then
			all_pixels <= '0';
			a <= (others => '0');
			b <= (others => '0');
			i <= 0;
			j <= 0;
		else
			a <= std_logic_vector(to_unsigned(i,a'length));
			b <= std_logic_vector(to_unsigned(j,b'length));		
			if (i = OLED_WIDTH-1) then
--				if (j = OLED_HEIGHT-1) then
					j <= j + 1;
--				end if;
			end if;
							i <= i + 1;

			if (i = OLED_WIDTH-1 and j = OLED_HEIGHT-1) then
				all_pixels <= '1';
			end if;
		end if;
	end if;
end process p0;

--p0 : process (clk_1s) is
--	variable index : integer range 0 to NV-1 := 0;
--begin
--	if (rising_edge(clk_1s)) then
--		if (btn_1 = '1') then
--			all_pixels <= '0';
--			index := 0;
--			a <= (others => '0');
--			b <= (others => '0');
--		else
--			index := index + 1;
--			a <= x_coord(index)(OLED_W_BITS-1 downto 0);
--			b <= y_coord(index)(OLED_H_BITS-1 downto 0);
--			if (index = NV) then
--				all_pixels <= '1';
--			end if;
--		end if;
--	end if;
--end process p0;
end Behavioral;
