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
constant BUS_CLOCK : integer := 400_000; -- increase for speed i2c
constant OLED_WIDTH : integer := 128;
constant OLED_HEIGHT : integer := 4; -- 32 = <0;3> * 8-bit row
constant OLED_W_BITS : integer := 8; -- 128
constant OLED_H_BITS : integer := 8; -- 4
constant BYTE_SIZE : integer := 8;
constant DIVIDER_CLOCK : integer := 512; -- increase for speed simulate and i2c

component oled_display is
generic(
GLOBAL_CLK : integer;
I2C_CLK : integer;
WIDTH : integer;
HEIGHT : integer;
W_BITS : integer;
H_BITS : integer;
BYTE_SIZE : integer);
port(
signal i_clk : in std_logic;
signal i_rst : in std_logic;
signal i_x : in std_logic_vector(W_BITS-1 downto 0);
signal i_y : in std_logic_vector(H_BITS-1 downto 0);
signal i_byte : in std_logic_vector(BYTE_SIZE-1 downto 0);
signal i_all_pixels : in std_logic;
signal o_display_initialize : out std_logic;
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
WIDTH : integer;
HEIGHT : integer;
W_BITS : integer;
H_BITS : integer;
BYTE_SIZE : integer);
Port (
i_clk : in std_logic;
i_x : in std_logic_vector(W_BITS-1 downto 0);
i_y : in std_logic_vector(H_BITS-1 downto 0);
o_byte : out std_logic_vector(BYTE_SIZE-1 downto 0));
end component memory1;
for all : memory1 use entity WORK.memory1(Behavioral);

signal a : std_logic_vector(OLED_W_BITS-1 downto 0) := (others => '0');
signal b : std_logic_vector(OLED_H_BITS-1 downto 0) := (others => '0');
signal rst : std_logic := '0';
signal all_pixels : std_logic := '0';
signal clk_1s : std_logic := '0';
signal display_bit : std_logic_vector(BYTE_SIZE-1 downto 0) := (others => '0');
signal display_initialize : std_logic;

signal i : integer range 0 to OLED_WIDTH-1 := 0;
signal j : integer range 0 to OLED_HEIGHT-1 := OLED_HEIGHT-1;

begin
	
clk_div : clock_divider
generic map (
	g_board_clock => INPUT_CLOCK,
	g_divider => DIVIDER_CLOCK)
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
	H_BITS => OLED_H_BITS,
	BYTE_SIZE => BYTE_SIZE)
port map (
	i_clk => clk,
	i_rst => btn_1,
	i_x => a,
	i_y => b,
	i_byte => display_bit,
--	i_byte => x"FF",
	i_all_pixels => all_pixels,
	o_display_initialize => display_initialize,
	io_sda => sda,
	io_scl => scl
);

m1 : memory1
generic map (
	WIDTH => OLED_WIDTH,
	HEIGHT => OLED_HEIGHT,
	W_BITS => OLED_W_BITS,
	H_BITS => OLED_H_BITS,
	BYTE_SIZE => BYTE_SIZE)
port map (
	i_clk => clk,
	i_x => a,
	i_y => b,
	o_byte => display_bit
);

p0 : process (clk_1s) is
begin
	if (btn_1 = '1') then
		all_pixels <= '0';
		i <= 0;
		j <= OLED_HEIGHT-1;
	elsif (rising_edge(clk_1s)) then
		if (display_initialize = '1') then
			if (j >= 0) then
				if (i < OLED_WIDTH-1) then
					i <= i + 1;
				else
					j <= j - 1;
					i <= 0;
				end if;
			else
				all_pixels <= '1';
			end if;
		end if;
	end if;
end process p0;

a <= std_logic_vector(to_unsigned(i,a'length));
b <= std_logic_vector(to_unsigned(j,b'length));

end Behavioral;

