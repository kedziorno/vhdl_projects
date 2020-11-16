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
use WORK.p_memory_content.ALL;

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
signal btn_2 : in std_logic;
signal btn_3 : in std_logic;
signal sda,scl : inout std_logic
);
end top;

architecture Behavioral of top is

constant INPUT_CLOCK : integer := 50_000_000;
constant BUS_CLOCK : integer := 400_000; -- increase for speed i2c
constant DIVIDER_CLOCK : integer := 1000; -- increase for speed simulate and i2c

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
signal i_clear : in std_logic;
signal i_draw : in std_logic;
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
Port (
i_clk : in std_logic;
i_enable : in std_logic;
i_write_byte : in std_logic;
i_write_bit : in std_logic;
i_row : in std_logic_vector(ROWS_BITS-1 downto 0);
i_col_pixel : in std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
i_col_block : in std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
i_byte : in std_logic_vector(BYTE_BITS-1 downto 0);
i_bit : in std_logic;
o_byte : out std_logic_vector(BYTE_BITS-1 downto 0);
o_bit : out std_logic);
end component memory1;
for all : memory1 use entity WORK.memory1(Behavioral);

signal row : std_logic_vector(ROWS_BITS-1 downto 0) := (others => '0');
signal col_pixel : std_logic_vector(COLS_PIXEL_BITS-1 downto 0) := (others => '0');
signal col_block : std_logic_vector(COLS_BLOCK_BITS-1 downto 0) := (others => '0');
signal rst : std_logic := '0';
signal all_pixels : std_logic := '0';
signal clk_1s : std_logic := '0';
signal display_byte : std_logic_vector(BYTE_BITS-1 downto 0) := (others => '0');
signal display_initialize : std_logic;

signal i : integer range 0 to ROWS-1 := 0;
signal j : integer range 0 to COLS_BLOCK-1 := 0;

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
	WIDTH => ROWS,
	HEIGHT => COLS_BLOCK,
	W_BITS => ROWS_BITS,
	H_BITS => COLS_BLOCK_BITS,
	BYTE_SIZE => BYTE_BITS)
port map (
	i_clk => clk,
	i_rst => btn_1,
	i_clear => btn_2,
	i_draw => btn_3,
	i_x => row,
	i_y => col_block,
	i_byte => display_byte,
	i_all_pixels => all_pixels,
	o_display_initialize => display_initialize,
	io_sda => sda,
	io_scl => scl
);

m1 : memory1
port map (
	i_clk => clk,
	i_enable => '1',
	i_write_byte => '0',
	i_write_bit => '0',
	i_row => row,
	i_col_pixel => col_pixel,
	i_col_block => col_block,
	i_byte => (others => 'X'),
	i_bit => 'X',
	o_byte => display_byte,
	o_bit => open
);

p0 : process (clk_1s) is
begin
	if (btn_1 = '1') then
		all_pixels <= '0';
		i <= 0;
		j <= 0;
	elsif (rising_edge(clk_1s)) then
		if (display_initialize = '1') then
			if (j < COLS_BLOCK) then
				if (i < ROWS-1) then
					i <= i + 1;
				else
					j <= j + 1;
					i <= 0;
				end if;
			else
				all_pixels <= '1';
			end if;
		end if;
	end if;
end process p0;

row <= std_logic_vector(to_unsigned(i,row'length));
col_block <= std_logic_vector(to_unsigned(j,col_block'length));

end Behavioral;
