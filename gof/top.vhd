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
generic(
INPUT_CLOCK : integer := 50_000_000;
BUS_CLOCK : integer := 100_000; -- increase for speed i2c
DIVIDER_CLOCK : integer := 1_000 -- increase for speed simulate and i2c
);
port(
signal clk : in std_logic;
signal btn_1 : in std_logic;
signal btn_2 : in std_logic;
signal btn_3 : in std_logic;
signal sda,scl : inout std_logic
);
end top;

architecture Behavioral of top is

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
signal o_display_initialize : inout std_logic;
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
	variable i_row : in natural range 0 to ROWS-1;
	variable i_col : in natural range 0 to COLS_PIXEL-1;
	variable o_row : out natural range 0 to ROWS-1;
	variable o_col : out natural range 0 to COLS_PIXEL-1
) is begin
	if (i_row < 0) then
		o_row := 0;
	else
		o_row := i_row;
	end if;
	if (i_col < 0) then
		o_col := 0;
	else
		o_col := i_col;
	end if;
	if (i_row > ROWS-1) then
		o_row := ROWS-1;
	else
		o_row := i_row;
	end if;
	if (i_col > COLS_PIXEL-1) then
		o_col := COLS_PIXEL-1;
	else
		o_col := i_col;
	end if;
end GetCellAt;

signal i_mem_e_byte : std_logic;
signal i_mem_e_bit : std_logic;
signal i_mem_write_bit : std_logic;
signal i_bit : std_logic;

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
c1_before,c1,c1_after,
c2,c3,c4,c5,c6,c7,c8,
memory_disable_bit,
store_count_alive,
check_counters_2,
reset_counters1,
memory_enable_bit1,
enable_write_to_memory,
get_alive,
write_count_alive,
disable_write_to_memory,
stop);
signal cstate : state;

constant W : integer := 1;
signal waiting : integer range W-1 downto 0 := 0;
signal ppX : std_logic_vector(ROWS_BITS-1 downto 0);
signal ppYb : std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
signal ppYp : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
signal ppXm1 : std_logic_vector(ROWS_BITS-1 downto 0);
signal ppXp1 : std_logic_vector(ROWS_BITS-1 downto 0);
signal ppYm1 : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
signal ppYp1 : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
signal oppX : std_logic_vector(ROWS_BITS-1 downto 0);
signal oppY : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
signal countAlive : std_logic_vector(2 downto 0);
signal slivearray : std_logic_vector(2 downto 0);

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
	i_write_bit => i_mem_write_bit,
	i_row => row,
	i_col_pixel => col_pixel,
	i_col_block => col_block,
	i_byte => (others => 'X'),
	i_bit => i_bit,
	o_byte => display_byte,
	o_bit => o_bit
);

gof_logic : process (clk_1s,i_reset) is
constant W : integer := 1;
variable waiting : integer range W-1 downto 0 := 0;
variable vppX : natural range 0 to ROWS-1;
variable vppYb : natural range 0 to COLS_BLOCK-1;
variable vppYp : natural range 0 to COLS_PIXEL-1;
variable vppXm1 : natural range 0 to ROWS-1;
variable vppXp1 : natural range 0 to ROWS-1;
variable vppYm1 : natural range 0 to COLS_PIXEL-1;
variable vppYp1 : natural range 0 to COLS_PIXEL-1;
variable voppX : natural range 0 to ROWS-1;
variable voppY : natural range 0 to COLS_PIXEL-1;
variable vcountAlive : integer := 0;
type LiveArrayType is array(0 to ROWS-1,0 to COLS_PIXEL-1) of integer range 0 to 7;
variable LiveArray : LiveArrayType;
variable CellAlive : boolean;
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
					cstate <= display_is_initialize;
--					cstate <= reset_counters_1;
				else
					cstate <= idle;
				end if;
			when display_is_initialize =>
				cstate <= memory_enable_byte;
				vppX := 0;
				vppYb := 0;
				vppYp := 0;
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
				vppXm1 := vppX-1;
				if (vppXm1 < 0) then
					vppXm1 := 0;
				end if;
				vppXp1 := vppX+1;
				if (vppXp1 > ROWS-1) then
					vppXp1 := ROWS-1;
				end if;
				vppYm1 := vppYp-1;
				if (vppYm1 < 0) then
					vppYm1 := 0;
				end if;
				vppYp1 := vppYp+1;
				if (vppYp1 > COLS_PIXEL-1) then
					vppYp1 := COLS_PIXEL-1;
				end if;
			when c1 =>
				cstate <= c2;
				if (vppYp /= 0) then
					GetCellAt(vppX,vppYm1,voppX,voppY);
					row <= std_logic_vector(to_unsigned(voppX,7));
					col_pixel <= std_logic_vector(to_unsigned(voppY,5));
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				end if;
			when c2 =>
				cstate <= c3;
				if (vppYp /= COLS_PIXEL-1) then
					GetCellAt(vppX,vppYp1,voppX,voppY);
					row <= std_logic_vector(to_unsigned(voppX,7));
					col_pixel <= std_logic_vector(to_unsigned(voppY,5));
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				end if;
			when c3 =>
				cstate <= c4;
				if (vppX /= ROWS-1) then
					GetCellAt(vppXp1,vppYp,voppX,voppY);
					row <= std_logic_vector(to_unsigned(voppX,7));
					col_pixel <= std_logic_vector(to_unsigned(voppY,5));
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				end if;
			when c4 =>
				cstate <= c5;
				if (vppX /= 0) then
					GetCellAt(vppXm1,vppYp,voppX,voppY);
					row <= std_logic_vector(to_unsigned(voppX,7));
					col_pixel <= std_logic_vector(to_unsigned(voppY,5));
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				end if;
			when c5 =>
				cstate <= c6;
				if ((vppX /= 0) and (vppYp /= 0)) then
					GetCellAt(vppXm1,vppYm1,voppX,voppY);
					row <= std_logic_vector(to_unsigned(voppX,7));
					col_pixel <= std_logic_vector(to_unsigned(voppY,5));
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				end if;
			when c6 =>
				cstate <= c7;
				if ((vppX /= ROWS-1) and (vppYp /= 0)) then
					GetCellAt(vppXp1,vppYm1,voppX,voppY);
					row <= std_logic_vector(to_unsigned(voppX,7));
					col_pixel <= std_logic_vector(to_unsigned(voppY,5));
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				end if;
			when c7 =>
				cstate <= c8;
				if ((vppX /= 0) and (vppYp /= COLS_PIXEL-1)) then
					GetCellAt(vppXm1,vppYp1,voppX,voppY);
					row <= std_logic_vector(to_unsigned(voppX,7));
					col_pixel <= std_logic_vector(to_unsigned(voppY,5));
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				end if;
			when c8 =>
				cstate <= memory_disable_bit;
				if ((vppX /= ROWS-1) and (vppYp /= COLS_PIXEL-1)) then
					GetCellAt(vppXp1,vppYp1,voppX,voppY);
					row <= std_logic_vector(to_unsigned(voppX,7));
					col_pixel <= std_logic_vector(to_unsigned(voppY,5));
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				end if;
			when memory_disable_bit =>
				cstate <= store_count_alive;
				i_mem_e_bit <= '0';
			when store_count_alive =>
				cstate <= check_counters_2;
				LiveArray(vppX,vppYp) := vcountAlive;
			when check_counters_2 =>
				if (vppX < ROWS-1) then
					if (vppYp < COLS_PIXEL-1) then
						vppYp := vppYp + 1;
					else
						vppX := vppX + 1;
						vppYp := 0;
					end if;
					cstate <= memory_enable_bit;
					vcountAlive := 0;
				else
					cstate <= reset_counters1;
				end if;
			when reset_counters1 =>
				cstate <= memory_enable_bit1;
				vppX := 0;
				vppYb := 0;
				vppYp := 0;
			when memory_enable_bit1 =>
				cstate <= get_alive;
				i_mem_e_bit <= '1';
			when get_alive =>
				cstate <= enable_write_to_memory;
				row <= std_logic_vector(to_unsigned(vppX,7));
				col_pixel <= std_logic_vector(to_unsigned(vppYp,5));
				if (o_bit = '1') then
					CellAlive := true;
				else
					CellAlive := false;
				end if;
			when enable_write_to_memory =>
				cstate <= write_count_alive;
				i_mem_write_bit <= '1';
			when write_count_alive =>
				slivearray <= std_logic_vector(to_unsigned(LiveArray(vppX,vppYp),3));
				if (vppX < ROWS-1) then
					if (vppYp < COLS_PIXEL-1) then
						vppYp := vppYp + 1;
						row <= std_logic_vector(to_unsigned(vppX,7));
						col_pixel <= std_logic_vector(to_unsigned(vppYp,5));
						if (CellAlive = true) then
							if ((LiveArray(vppX,vppYp) = 2) or (LiveArray(vppX,vppYp) = 3)) then
								i_bit <= '1';
							else
								i_bit <= '0';
							end if;
						else
							if ((LiveArray(vppX,vppYp) = 3)) then
								i_bit <= '1';
							else
								i_bit <= '0';
							end if;
						end if;
					else
						vppX := vppX + 1;
						vppYp := 0;
					end if;
				else
					cstate <= disable_write_to_memory;
				end if;
			when disable_write_to_memory =>
				cstate <= stop;
				i_mem_write_bit <= '0';
			when stop =>
				all_pixels <= '0';
				cstate <= idle;
			when others => null;
		end case;
--		col_pixel <= ppYp;
		row <= ppX;
		col_block <= ppYb;
	end if;
	countAlive <= std_logic_vector(to_unsigned(vcountALive,3));
	ppX <= std_logic_vector(to_unsigned(vppX,ROWS_BITS));
	ppYp <= std_logic_vector(to_unsigned(vppYp,COLS_PIXEL_BITS));
	ppYb <= std_logic_vector(to_unsigned(vppYb,COLS_BLOCK_BITS));
	ppXm1 <= std_logic_vector(to_unsigned(vppXm1,ROWS_BITS));
	ppXp1 <= std_logic_vector(to_unsigned(vppXp1,ROWS_BITS));
	ppYm1 <= std_logic_vector(to_unsigned(vppYm1,COLS_PIXEL_BITS));
	ppYp1 <= std_logic_vector(to_unsigned(vppYp1,COLS_PIXEL_BITS));
	oppX <= std_logic_vector(to_unsigned(voppX,ROWS_BITS));
	oppY <= std_logic_vector(to_unsigned(voppY,COLS_PIXEL_BITS));
end process gof_logic;



end Behavioral;
