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
constant BUS_CLOCK : integer := 100_000; -- increase for speed i2c
constant DIVIDER_CLOCK : integer := 10_000; -- increase for speed simulate and i2c

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
i_reset : in std_logic;
i_enable_byte : in std_logic;
i_enable_bit : in std_logic;
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
signal o_bit : std_logic;
signal i_reset : std_logic;

procedure GetCellAt(
	variable i_row : in integer;
	variable i_col : in integer;
	variable o_row : out integer;
	variable o_col : out integer
) is begin
	--report "getcellat" severity note;
	if (i_row < 0) then
		--report "i_row < MIN : "&integer'image(i_row) severity note;
		o_row := 0;
	else
		o_row := i_row;
	end if;
	if (i_col < 0) then
		--report "i_col < MIN : "&integer'image(i_col) severity note;
		o_col := 0;
	else
		o_col := i_col;
	end if;
	if (i_row >= ROWS) then
		--report "i_row >= MAX-1 : "&integer'image(i_row) severity note;
		o_row := ROWS-1;
	else
		o_row := i_row;
	end if;
	if (i_col >= COLS_PIXEL) then
		--report "i_col >= MAX-1 : "&integer'image(i_col) severity note;
		o_col := COLS_PIXEL-1;
	else
		o_col := i_col;
	end if;
end GetCellAt;

signal i_mem_e_byte : std_logic;
signal i_mem_e_bit : std_logic;

type state is (
idle,
display_is_initialize,
memory_enable_byte,
waitone,
update_row,
update_col,
memory_disable_byte,
reset_counters_1,
memory_enable_bit,
c1,c2,c3,c4,c5,c6,c7,c8,
memory_disable_bit,
check_counters_2,
stop);
signal cstate : state;

constant W : integer := 1;
signal waiting : integer range W-1 downto 0 := 0;
signal ppX : integer range 0 to ROWS-1 := 0;
signal ppYb : integer range 0 to COLS_BLOCK-1 := 0;
signal ppYp : integer range 0 to COLS_PIXEL-1 := 0;
signal ppXm1 : integer range -1 to ROWS := ppX-1;
signal ppXp1 : integer range -1 to ROWS := ppX+1;
signal ppYm1 : integer range -1 to COLS_PIXEL := ppYp-1;
signal ppYp1 : integer range -1 to COLS_PIXEL := ppYp+1;
signal oppX : integer range 0 to ROWS-1;
signal oppY : integer range 0 to COLS_PIXEL-1;
signal countAlive : integer := 0;

begin

i_reset <= btn_1;

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
	i_reset => '0',
	i_enable_byte => i_mem_e_byte,
	i_enable_bit => i_mem_e_bit,
	i_write_byte => '0',
	i_write_bit => '0',
	i_row => row,
	i_col_pixel => col_pixel,
	i_col_block => col_block,
	i_byte => (others => 'X'),
	i_bit => 'X',
	o_byte => display_byte,
	o_bit => o_bit
);

gof_logic : process (clk_1s,i_reset) is
constant W : integer := 1;
variable waiting : integer range W-1 downto 0 := 0;
variable vppX : integer range 0 to ROWS-1 := 0;
variable vppYb : integer range 0 to COLS_BLOCK-1 := 0;
variable vppYp : integer range 0 to COLS_PIXEL-1 := 0;
variable ppXm1 : integer range -1 to ROWS := ppX-1;
variable ppXp1 : integer range -1 to ROWS := ppX+1;
variable ppYm1 : integer range -1 to COLS_PIXEL := ppYp-1;
variable ppYp1 : integer range -1 to COLS_PIXEL := ppYp+1;
variable oppX : integer range 0 to ROWS-1;
variable oppY : integer range 0 to COLS_PIXEL-1;
variable vcountAlive : integer := 0;
begin
	if (i_reset = '1') then
		all_pixels <= '0';
		vppX := 0;
		vppYb := 0;
		vppYp := 0;
		cstate <= idle;
	elsif (rising_edge(clk_1s)) then
		cstate <= cstate;
		case cstate is
			when idle =>
				if (display_initialize = '1') then
--					cstate <= display_is_initialize;
					cstate <= reset_counters_1;
				else
					cstate <= idle;
				end if;
			when display_is_initialize =>
				cstate <= memory_enable_byte;
			when memory_enable_byte =>
				cstate <= waitone;
				i_mem_e_byte <= '1';
				waiting := W-1;
			when waitone =>
				if (waiting = 0) then
					cstate <= update_row;
				else
					waiting := waiting - 1;
				end if;
			when update_row =>
				if (vppX < ROWS-1) then
					vppX := vppX + 1;
					cstate <= waitone;
					waiting := W-1;
				else
					cstate <= update_col;
				end if;
			when update_col =>
				if (vppYb < COLS_BLOCK-1) then
					vppYb := vppYb + 1;
					cstate <= waitone;
					waiting := W-1;
					vppX := 0;
				else
					cstate <= memory_disable_byte;
					vppYb := 0;
				end if;
			when memory_disable_byte =>
				cstate <= reset_counters_1;
				i_mem_e_byte <= '0';
			when reset_counters_1 =>
				cstate <= memory_enable_bit;
				all_pixels <= '1';
				vppX := 0;
				vppYb := 0;
				vppYp := 0;
			when memory_enable_bit =>
				cstate <= c1;
				i_mem_e_bit <= '1';
			when c1 =>
				cstate <= c2;
				if (vppYp /= 0) then
					GetCellAt(vppX,ppYm1,oppX,oppY);
					row <= std_logic_vector(to_unsigned(oppX,7));
					col_pixel <= std_logic_vector(to_unsigned(oppY,5));
	--				report "ppy /= 0 : "&integer'image(ppX)&" , ppy /= 0 : "&integer'image(ppYm1)&" , ppy /= 0 : "&integer'image(oppX)&" , ppy /= 0 : "&integer'image(oppY) severity note;
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					ppX <= oppX;
--					ppYp <= oppY;
				end if;
			when c2 =>
				cstate <= c3;
				if (vppYp /= COLS_PIXEL-1) then
					GetCellAt(vppX,ppYp1,oppX,oppY);
					row <= std_logic_vector(to_unsigned(oppX,7));
					col_pixel <= std_logic_vector(to_unsigned(oppY,5));
	--				report "ppy /= COL_PIXEL-1 : "&integer'image(ppX)&" , ppy /= COL_PIXEL-1 : "&integer'image(ppYp1)&" , ppy /= COL_PIXEL-1 : "&integer'image(oppX)&" , ppy /= COL_PIXEL-1 : "&integer'image(oppY) severity note;
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					ppX <= oppX;
--					ppYp <= oppY;
				end if;
			when c3 =>
				cstate <= c4;
				if (vppX /= ROWS-1) then
					GetCellAt(ppXp1,vppYp,oppX,oppY);
					row <= std_logic_vector(to_unsigned(oppX,7));
					col_pixel <= std_logic_vector(to_unsigned(oppY,5));
	--				report "ppx /= ROWS-1 : "&integer'image(ppXp1)&" , ppx /= ROWS-1 : "&integer'image(ppY)&" , ppx /= ROWS-1 : "&integer'image(oppX)&" , ppx /= ROWS-1 : "&integer'image(oppY) severity note;
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					ppX <= oppX;
--					ppYp <= oppY;
				end if;
			when c4 =>
				cstate <= c5;
				if (vppX /= 0) then
					GetCellAt(ppXm1,vppYp,oppX,oppY);
					row <= std_logic_vector(to_unsigned(oppX,7));
					col_pixel <= std_logic_vector(to_unsigned(oppY,5));
	--				report "ppx /= 0 : "&integer'image(ppXm1)&" , ppx /= 0 : "&integer'image(ppY)&" , ppx /= 0 : "&integer'image(oppX)&" , ppx /= 0 : "&integer'image(oppY) severity note;
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					ppX <= oppX;
--					ppYp <= oppY;
				end if;
			when c5 =>
				cstate <= c6;
				if ((vppX /= 0) and (vppYp /= 0)) then
					GetCellAt(ppXm1,ppYm1,oppX,oppY);
					row <= std_logic_vector(to_unsigned(oppX,7));
					col_pixel <= std_logic_vector(to_unsigned(oppY,5));
	--				report "ppx /= 0 & ppy /= 0 : "&integer'image(ppXm1)&" , ppx /= 0 & ppy /= 0 : "&integer'image(ppYm1)&" , ppx /= 0 & ppy /= 0 : "&integer'image(oppX)&" , ppx /= 0 & ppy /= 0 : "&integer'image(oppY) severity note;
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					ppX <= oppX;
--					ppYp <= oppY;
				end if;
			when c6 =>
				cstate <= c7;
				if ((vppX /= ROWS-1) and (vppYp /= 0)) then
					GetCellAt(ppXp1,ppYm1,oppX,oppY);
					row <= std_logic_vector(to_unsigned(oppX,7));
					col_pixel <= std_logic_vector(to_unsigned(oppY,5));
	--				report "ppx /= ROWS-1 & ppy /= 0 : "&integer'image(ppXp1)&" , ppx /= ROWS-1 & ppy /= 0 : "&integer'image(ppYm1)&" , ppx /= ROWS-1 & ppy /= 0 : "&integer'image(oppX)&" , ppx /= ROWS-1 & ppy /= 0 : "&integer'image(oppY) severity note;
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					ppX <= oppX;
--					ppYp <= oppY;
				end if;
			when c7 =>
				cstate <= c8;
				if ((vppX /= 0) and (vppYp /= COLS_PIXEL-1)) then
					GetCellAt(ppXm1,ppYp1,oppX,oppY);
					row <= std_logic_vector(to_unsigned(oppX,7));
					col_pixel <= std_logic_vector(to_unsigned(oppY,5));
	--				report "ppx /= 0 & ppy /= COLS_PIXEL-1 : "&integer'image(ppXm1)&" , ppx /= 0 & ppy /= COLS_PIXEL-1 : "&integer'image(ppYp1)&" , ppx /= 0 & ppy /= COLS_PIXEL-1 : "&integer'image(oppX)&" , ppx /= 0 & ppy /= COLS_PIXEL-1 : "&integer'image(oppY) severity note;
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					ppX <= oppX;
--					ppYp <= oppY;
				end if;
			when c8 =>
				cstate <= memory_disable_bit;
				if ((vppX /= ROWS-1) and (vppYp /= COLS_PIXEL-1)) then
					GetCellAt(ppXp1,ppYp1,oppX,oppY);
					row <= std_logic_vector(to_unsigned(oppX,7));
					col_pixel <= std_logic_vector(to_unsigned(oppY,5));
	--				report "ppx /= ROWS-1 & ppy /= COLS_PIXEL-1 : "&integer'image(ppXp1)&" , ppx /= ROWS-1 & ppy /= COLS_PIXEL-1 : "&integer'image(ppYp1)&" , ppx /= ROWS-1 & ppy /= COLS_PIXEL-1 : "&integer'image(oppX)&" , ppx /= ROWS-1 & ppy /= COLS_PIXEL-1 : "&integer'image(oppY) severity note;
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					ppX <= oppX;
--					ppYp <= oppY;
				end if;
			when memory_disable_bit =>
				cstate <= check_counters_2;
				i_mem_e_bit <= '0';
				vcountAlive := 0;
			when check_counters_2 =>
				if (vppX < ROWS-1) then
					if (vppYp < COLS_PIXEL-1) then
						vppYp := vppYp + 1;
					else
						vppX := vppX + 1;
						vppYp := 0;
					end if;
					cstate <= memory_enable_bit;
				else
					cstate <= stop;
				end if;
			when stop =>
				cstate <= idle;
			when others => null;
		end case;
	end if;
	countAlive <= vcountALive;
end process gof_logic;

--row <= std_logic_vector(to_unsigned(ppX,row'length));
--col_block <= std_logic_vector(to_unsigned(ppYb,col_block'length));
--col_pixel <= std_logic_vector(to_unsigned(ppYp,col_pixel'length));

end Behavioral;
