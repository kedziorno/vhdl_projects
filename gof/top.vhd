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
INPUT_CLOCK : integer := G_BOARD_CLOCK;
BUS_CLOCK : integer := G_BUS_CLOCK; -- increase for speed i2c
DIVIDER_CLOCK : integer := G_ClockDivider;
g_lcd_clock_divider : integer := G_LCDClockDivider
);
port(
signal clk : in std_logic;
signal btn_1 : in std_logic;
signal btn_2 : in std_logic;
signal btn_3 : in std_logic;
signal sda,scl : inout std_logic;
signal io_MemOE : inout std_logic;
signal io_MemWR : inout std_logic;
signal io_RamAdv : inout std_logic;
signal io_RamCS : inout std_logic;
signal io_RamCRE : inout std_logic;
signal io_RamLB : inout std_logic;
signal io_RamUB : inout std_logic;
signal io_RamWait : inout std_logic;
signal io_MemAdr : inout std_logic_vector(G_MemoryAddress-1 downto 0);
signal io_MemDB : inout std_logic_vector(G_MemoryData-1 downto 0);
signal seg : inout std_logic_vector(6 downto 0);
signal an : inout std_logic_vector(3 downto 0)
);
end top;

architecture Behavioral of top is

component lcd_display is
Generic (
	LCDClockDivider : integer := g_lcd_clock_divider
);
Port (
	i_clock : in std_logic;
	i_LCDChar : LCDHex;
	o_anode : out std_logic_vector(G_LCDAnode-1 downto 0);
	o_segment : out std_logic_vector(G_LCDSegment-1 downto 0)
);
end component lcd_display;
for all : lcd_display use entity WORK.lcd_display(Behavioral);

component oled_display is
generic(
GLOBAL_CLK : integer;
I2C_CLK : integer;
WIDTH_O : integer;
HEIGHT_O : integer;
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
signal o_busy : out std_logic;
signal o_display_initialize : inout std_logic;
signal io_sda,io_scl : inout std_logic);
end component oled_display;
for all : oled_display use entity WORK.oled_display(Behavioral);
	
component clock_divider is
Port(
i_clk : in STD_LOGIC;
i_board_clock : in INTEGER;
i_divider : in INTEGER;
o_clk : out STD_LOGIC
);
end component clock_divider;
for all : clock_divider use entity WORK.clock_divider(Behavioral);

--component memory1 is
--Port (
--i_clk : in std_logic;
--i_enable_byte : in std_logic;
--i_enable_bit : in std_logic;
--i_write_byte : in std_logic;
--i_write_bit : in std_logic;
--i_row : in std_logic_vector(ROWS_BITS-1 downto 0);
--i_col_pixel : in std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
--i_col_block : in std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
--i_byte : in std_logic_vector(BYTE_BITS-1 downto 0);
--i_bit : in std_logic;
--o_byte : out std_logic_vector(BYTE_BITS-1 downto 0);
--o_bit : out std_logic);
--end component memory1;
--for all : memory1 use entity WORK.memory1(Behavioral);

component memorymodule is
Port (
i_clock : in std_logic;
i_enable : in std_logic;
i_write : in std_logic;
i_read : in std_logic;
o_busy : out std_logic;
i_MemAdr : in std_logic_vector(G_MemoryAddress-1 downto 0);
i_MemDB : in std_logic_vector(G_MemoryData-1 downto 0);
o_MemDB : out std_logic_vector(G_MemoryData-1 downto 0);
io_MemOE : out std_logic;
io_MemWR : out std_logic;
io_RamAdv : out std_logic;
io_RamCS : out std_logic;
io_RamLB : out std_logic;
io_RamUB : out std_logic;
io_RamCRE : out std_logic;
io_MemAdr : out std_logic_vector(G_MemoryAddress-1 downto 0);
io_MemDB : inout std_logic_vector(G_MemoryData-1 downto 0)
);
end component memorymodule;
for all : memorymodule use entity WORK.memorymodule(Behavioral);

signal row : std_logic_vector(ROWS_BITS-1 downto 0) := (others => '0');
signal col_pixel : std_logic_vector(COLS_PIXEL_BITS-1 downto 0) := (others => '0');
signal col_block : std_logic_vector(COLS_BLOCK_BITS-1 downto 0) := (others => '0');
signal rst : std_logic;
signal all_pixels : std_logic;
signal clk_1s : std_logic;
signal display_byte : std_logic_vector(BYTE_BITS-1 downto 0);
signal display_initialize : std_logic;
signal o_bit : std_logic;
signal i_reset : std_logic;

signal i_mem_e_byte : std_logic;
signal i_mem_e_bit : std_logic;
signal i_mem_write_bit : std_logic;
signal i_bit : std_logic;

type state is (
set_cd_memorycopy,enable_memory_module,enable_write_fh,copy_first_halfword,disable_write_fh,memory_wait_fh,enable_write_sh,copy_second_halfword,disable_write_sh,memory_wait_sh,disable_memory_module,check_ranges_write,

idle,
display_is_initialize,

enable_memory_module_read_fh,enable_read_memory_fh,read_fh,store_fh,disable_read_memory_fh,disable_memory_module_read_fh,
send_fh1,send_fh1_waitdisplay,send_fh2,send_fh2_waitdisplay,
enable_memory_module_read_sh,enable_read_memory_sh,read_sh,store_sh,disable_read_memory_sh,disable_memory_module_read_sh,
send_sh1,send_sh1_waitdisplay,send_sh2,send_sh2_waitdisplay,
wait_two_reads,
check_ranges_read,

memory_enable_byte,
waitone,
update_row,
update_col,
set_cd_calculate,
memory_disable_byte,
reset_counters_1,
check_coordinations,
reset_count_alive,
memory_enable_bit,
set_c1,c1,set_c2,c2,set_c3,c3,set_c4,c4,set_c5,c5,set_c6,c6,set_c7,c7,set_c8,c8,
waitfor,
memory_disable_bit,
store_count_alive,
update_row1,
update_col1,
reset_counters1,
memory_enable_bit1,
get_alive,
get_alive1,
enable_write_to_memory,
set_coords_to_write,
write_count_alive,
disable_write_to_memory,
update_row2,
update_col2,
disable_memory,
stop
);
signal cstate : state;

signal i_enable : std_logic;
signal i_write : std_logic;
signal i_read : std_logic;
signal o_membusy : std_logic;
signal o_disbusy : std_logic;
signal i_MemAdr : std_logic_vector(G_MemoryAddress-1 downto 0);
signal i_MemDB : std_logic_vector(G_MemoryData-1 downto 0);
signal o_MemDB : std_logic_vector(G_MemoryData-1 downto 0);
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
signal CellAlive : std_logic;
--signal LiveArray : LiveArrayType;
signal CD : integer := DIVIDER_CLOCK; -- XXX
signal CD_DISPLAY : integer := DIVIDER_CLOCK; -- XXX
signal CD_CALCULATE : integer := DIVIDER_CLOCK; -- XXX
signal CD_COPYMEMORY : integer := G_BOARD_CLOCK; -- XXX

function To_Std_Logic(x_vot : BOOLEAN) return std_ulogic is
begin
	if x_vot then
		return('1');
	else
		return('0');
	end if;
end function To_Std_Logic;

signal LCDChar : LCDHex;

begin

i_reset <= btn_1;
LCDChar <= (o_MemDB(3 downto 0),o_MemDB(7 downto 4),o_MemDB(11 downto 8),o_MemDB(15 downto 12));

c_lcd_display : lcd_display
Port Map (
	i_clock => clk,
	i_LCDChar => LCDChar,
	o_anode => an,
	o_segment => seg
);

clk_div : clock_divider
port map (
	i_clk => clk,
	i_board_clock => INPUT_CLOCK,
	i_divider => CD,
	o_clk => clk_1s
);

c0 : oled_display
generic map (
	GLOBAL_CLK => INPUT_CLOCK,
	I2C_CLK => BUS_CLOCK,
	WIDTH_O => ROWS,
	HEIGHT_O => COLS_BLOCK,
	W_BITS => ROWS_BITS,
	H_BITS => COLS_BLOCK_BITS,
	BYTE_SIZE => BYTE_BITS)
port map (
	i_clk => clk_1s,
	i_rst => btn_1,
	i_clear => btn_2,
	i_draw => btn_3,
	i_x => row,
	i_y => col_block,
	i_byte => display_byte,
	i_all_pixels => all_pixels,
	o_busy => o_disbusy,
	o_display_initialize => display_initialize,
	io_sda => sda,
	io_scl => scl
);

mm : memorymodule PORT MAP (
	i_clock => clk_1s,
	i_enable => i_enable,
	i_write => i_write,
	i_read => i_read,
	o_busy => o_membusy,
	i_MemAdr => i_MemAdr,
	i_MemDB => i_MemDB,
	o_MemDB => o_MemDB,
	io_MemOE => io_MemOE,
	io_MemWR => io_MemWR,
	io_RamAdv => io_RamAdv,
	io_RamCS => io_RamCS,
	io_RamLB => io_RamLB,
	io_RamUB => io_RamUB,
	io_RamCRE => io_RamCRE,
	io_MemAdr => io_MemAdr,
	io_MemDB => io_MemDB
);

gof_logic : process (clk_1s,i_reset) is
	constant W : integer := 10;
	variable waiting : integer range W downto 0 := W;
	variable vppX : natural range 0 to ROWS-1;
	variable vppYb : natural range 0 to COLS_BLOCK-1;
	variable vppYp : natural range 0 to COLS_PIXEL-1;
	variable vppXm1 : integer range -1 to ROWS-1;
	variable vppXp1 : integer range 0 to ROWS;
	variable vppYm1 : integer range -1 to COLS_PIXEL-1;
	variable vppYp1 : integer range 0 to COLS_PIXEL;
	variable vcountAlive : integer;
	variable vCellAlive : boolean;
	variable m1 : MEMORY := memory_content;
	variable startAddress : integer := 0;
	variable copyWords : integer := (ROWS*(COLS_PIXEL/G_MemoryData));
	variable copyWordsIndex : integer := copyWords - 1;
	variable rowIndex : integer range ROWS downto 0 := ROWS-1;
	variable o_Mem1 : MemoryDataByte;
	variable o_Mem2 : MemoryDataByte;
begin
	if (i_reset = '1') then
		all_pixels <= '0';
		vppX := 0;
		vppYb := 0;
		vppYp := 0;
		cstate <= set_cd_memorycopy;
	elsif (rising_edge(clk_1s)) then
		if (waiting > 0) then
			waiting := waiting - 1;
		end if;
		case cstate is
			-- copy memory content
			when set_cd_memorycopy =>
				cstate <= enable_memory_module;
				CD <= CD_CALCULATE;
			when enable_memory_module =>
				cstate <= enable_write_fh;
				i_enable <= '1';
			when enable_write_fh =>
				cstate <= copy_first_halfword;
				i_write <= '1';
			when copy_first_halfword =>
				cstate <= disable_write_fh;
				i_MemAdr <= std_logic_vector(to_unsigned(startAddress + 0,G_MemoryAddress));
				i_MemDB <= m1(rowIndex)(31 downto 16);
			when disable_write_fh =>
				cstate <= memory_wait_fh;
				i_write <= '0';
			when memory_wait_fh =>
				if (o_membusy = '1') then
					cstate <= memory_wait_fh;
				else
					cstate <= enable_write_sh;
				end if;
			when enable_write_sh =>
				cstate <= copy_second_halfword;
				i_write <= '1';
			when copy_second_halfword =>
				cstate <= disable_write_sh;
				i_MemAdr <= std_logic_vector(to_unsigned(startAddress + 1,G_MemoryAddress));
				i_MemDB <= m1(rowIndex)(15 downto 0);
			when disable_write_sh =>
				cstate <= memory_wait_sh;
				i_write <= '0';
			when memory_wait_sh =>
				if (o_membusy = '1') then
					cstate <= memory_wait_sh;
				else
					cstate <= disable_memory_module;
				end if;
			when disable_memory_module =>
				cstate <= check_ranges_write;
				i_enable <= '0';
			when check_ranges_write =>
				if (copyWordsIndex > 0) then
					startAddress := startAddress + 2;
					copyWordsIndex := copyWordsIndex - 1;
					if (rowIndex > 0) then
						rowIndex := rowIndex - 1;
					end if;
					cstate <= enable_memory_module;
				else
					cstate <= idle;
				end if;
			-- draw
			when idle =>
				if (display_initialize = '1') then
					cstate <= display_is_initialize;
				else
					cstate <= idle;
				end if;
			when display_is_initialize =>
				cstate <= enable_memory_module_read_fh;
				vppX := 0;
				vppYb := 0;
				vppYp := 0;
				all_pixels <= '0';
				startAddress := 0;
				rowIndex := ROWS-1;
				copyWordsIndex := copyWords - 1;
				CD <= CD_DISPLAY;
				
			when enable_memory_module_read_fh =>
				cstate <= enable_read_memory_fh;
				i_enable <= '1';
			when enable_read_memory_fh =>
				cstate <= read_fh;
				i_read <= '1';
			when read_fh =>
				cstate <= store_fh;
				i_MemAdr <= std_logic_vector(to_unsigned(startAddress + 0,G_MemoryAddress));
			when store_fh =>
				cstate <= disable_read_memory_fh;
				o_Mem1 := o_MemDB;
			when disable_read_memory_fh =>
				cstate <= disable_memory_module_read_fh;
				i_read <= '0';
			when disable_memory_module_read_fh =>
				cstate <= wait_two_reads;
				i_enable <= '0';
				waiting := W;
			when wait_two_reads =>
				if (waiting = 0) then
					cstate <= enable_memory_module_read_sh;
				else
					cstate <= wait_two_reads;
				end if;
			when enable_memory_module_read_sh =>
				cstate <= enable_read_memory_sh;
				i_enable <= '1';
			when enable_read_memory_sh =>
				cstate <= read_sh;
				i_read <= '1';
			when read_sh =>
				cstate <= store_sh;
				i_MemAdr <= std_logic_vector(to_unsigned(startAddress + 1,G_MemoryAddress));
			when store_sh =>
				cstate <= disable_read_memory_sh;
				o_Mem2 := o_MemDB;
			when disable_read_memory_sh =>
				cstate <= disable_memory_module_read_sh;
				i_read <= '0';
			when disable_memory_module_read_sh =>
				cstate <= send_fh1;
				i_enable <= '0';
				
			when send_fh1 =>
				cstate <= send_fh1_waitdisplay;
				row <= std_logic_vector(to_unsigned(rowIndex,ROWS_BITS));
				col_block <= std_logic_vector(to_unsigned(0,COLS_BLOCK_BITS));
				display_byte <= o_Mem1(15 downto 8);
			when send_fh1_waitdisplay =>
				if (o_disbusy = '1') then
					cstate <= send_fh1_waitdisplay;
				else
					cstate <= send_fh2;
				end if;
			when send_fh2 =>
				cstate <= send_fh2_waitdisplay;
				row <= std_logic_vector(to_unsigned(rowIndex,ROWS_BITS));
				col_block <= std_logic_vector(to_unsigned(1,COLS_BLOCK_BITS));
				display_byte <= o_Mem1(7 downto 0);
			when send_fh2_waitdisplay =>
				if (o_disbusy = '1') then
					cstate <= send_fh2_waitdisplay;
				else
					cstate <= send_sh1;
				end if;
			when send_sh1 =>
				cstate <= send_sh1_waitdisplay;
				row <= std_logic_vector(to_unsigned(rowIndex,ROWS_BITS));
				col_block <= std_logic_vector(to_unsigned(2,COLS_BLOCK_BITS));
				display_byte <= o_Mem2(15 downto 8);
			when send_sh1_waitdisplay =>
				if (o_disbusy = '1') then
					cstate <= send_sh1_waitdisplay;
				else
					cstate <= send_sh2;
				end if;
			when send_sh2 =>
				cstate <= send_sh2_waitdisplay;
				row <= std_logic_vector(to_unsigned(rowIndex,ROWS_BITS));
				col_block <= std_logic_vector(to_unsigned(3,COLS_BLOCK_BITS));
				display_byte <= o_Mem2(7 downto 0);
			when send_sh2_waitdisplay =>
				if (o_disbusy = '1') then
					cstate <= send_sh2_waitdisplay;
				else
					cstate <= check_ranges_read;
				end if;
				
			when check_ranges_read =>
				if (copyWordsIndex > 0) then
					startAddress := startAddress + 2;
					copyWordsIndex := copyWordsIndex - 1;
					if (rowIndex > 0) then
						rowIndex := rowIndex - 1;
					end if;
					cstate <= enable_memory_module_read_fh;
				else
					cstate <= memory_enable_byte;
				end if;
			when others => null;
		end case;		
	end if;
	CellAlive <= To_Std_Logic(vCellAlive);
	ppX <= std_logic_vector(to_unsigned(vppX,ROWS_BITS));
	ppYp <= std_logic_vector(to_unsigned(vppYp,COLS_PIXEL_BITS));
	ppYb <= std_logic_vector(to_unsigned(vppYb,COLS_BLOCK_BITS));
	ppXm1 <= std_logic_vector(to_unsigned(vppXm1,ROWS_BITS));
	ppXp1 <= std_logic_vector(to_unsigned(vppXp1,ROWS_BITS));
	ppYm1 <= std_logic_vector(to_unsigned(vppYm1,COLS_PIXEL_BITS));
	ppYp1 <= std_logic_vector(to_unsigned(vppYp1,COLS_PIXEL_BITS));
end process gof_logic;

end Behavioral;
