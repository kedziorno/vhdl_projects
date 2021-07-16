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
library UNISIM;
use UNISIM.VComponents.all;

-- XXX !!!!!!!!!
-- XXX NEEDS FIX 
-- XXX NEEDS FIX 
-- XXX NEEDS FIX 
-- XXX NEEDS FIX 
-- XXX NEEDS FIX 
-- XXX NEEDS FIX 
-- XXX NEEDS FIX 
-- XXX NEEDS FIX 
-- XXX NEEDS FIX 
-- XXX NEEDS FIX 
-- XXX NEEDS FIX 
-- XXX NEEDS FIX 
-- XXX NEEDS FIX 
-- XXX NEEDS FIX 
-- XXX NEEDS FIX 
-- XXX !!!!!!!!!

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
signal io_RamClk : inout std_logic;
signal io_MemAdr : inout MemoryAddressALL;
signal io_MemDB : inout MemoryDataByte;
signal seg : inout std_logic_vector(6 downto 0);
signal an : inout std_logic_vector(3 downto 0);
signal io_FlashCS : out std_logic
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

component BUFG
port (I : in std_logic;
O : out std_logic); 
end component;

component clock_divider is
Port(
i_clk : in STD_LOGIC;
i_board_clock : in INTEGER;
i_divider : in INTEGER;
o_clk : out STD_LOGIC
);
end component clock_divider;

component memorymodule is
Port (
<<<<<<< HEAD
i_clock : in std_logic;
i_enable : in std_logic;
i_write : in std_logic;
i_read : in std_logic;
o_busy : out std_logic;
i_MemAdr : in MemoryAddressALL;
i_MemDB : in MemoryDataByte;
o_MemDB : out MemoryDataByte;
io_MemOE : out std_logic;
io_MemWR : out std_logic;
io_RamAdv : out std_logic;
io_RamCS : out std_logic;
io_RamLB : out std_logic;
io_RamUB : out std_logic;
io_RamCRE : out std_logic;
io_RamClk : out std_logic;
io_MemAdr : out MemoryAddressALL;
io_MemDB : inout MemoryDataByte
);
end component memorymodule;
for all : memorymodule use entity WORK.memorymodule(Behavioral);
=======
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

component RAMB16_S4
generic (
WRITE_MODE : string := "NO_CHANGE" ; -- WRITE_FIRST(default)/ READ_FIRST/NO_CHANGE
INIT : bit_vector(3 downto 0) := X"0";
SRVAL : bit_vector(3 downto 0) := X"0"
);
port (
DI    : in std_logic_vector (3 downto 0);
ADDR  : in std_logic_vector (11 downto 0);
EN    : in STD_LOGIC;
WE    : in STD_LOGIC;
SSR   : in STD_LOGIC;
CLK   : in STD_LOGIC;
DO    : out std_logic_vector (3 downto 0)
);
end component;
>>>>>>> oled_glidergun_32x32

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
signal draw : std_logic;

signal i_mem_e_byte : std_logic;
signal i_mem_e_bit : std_logic;
signal i_mem_write_bit : std_logic;
signal i_bit : std_logic;

signal CLK_BUFG : std_logic;

signal DATA_IN : std_logic_vector(3 downto 0);
signal ADDRESS : std_logic_vector(11 downto 0);
signal ENABLE : std_logic;
signal WRITE_EN : std_logic;
signal DATA_OUT : std_logic_vector(3 downto 0);

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
asdf,
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
check_cell_alive_wm,
c1_mdr,c2_mdr,c3_mdr,c4_mdr,c5_mdr,c6_mdr,c7_mdr,c8_mdr,
c1_me,c1_mr,c1_md,c2_me,c2_mr,c2_md,c3_me,c3_mr,c3_md,c4_me,c4_mr,c4_md,c5_me,c5_mr,c5_md,c6_me,c6_mr,c6_md,c7_me,c7_mr,c7_md,c8_me,c8_mr,c8_md,
set_c1,c1,set_c2,c2,set_c3,c3,set_c4,c4,set_c5,c5,set_c6,c6,set_c7,c7,set_c8,c8,
waitfor,
memory_disable_bit,
store_count_alive_me,store_count_alive_we,store_count_alive_sa,store_count_alive,store_count_alive_wd,store_count_alive_md,update_row1,
memory_sa1,memory_disable_read1,memory_disable_bit1,get_alive,get_alive1,enable_m2,enable_write_to_memory,check_cell_alive_1,check_cell_alive_1a,check_cell_alive_2,check_cell_alive_3,aa,aaa,aaaa,aaaaa,disable_write_to_memory,vvv,
update_col1,
store_count_alive_wm,memory_disable_read1_wm,vvv_wm,
memory_enable_read1,
reset_counters1,
memory_enable_bit1,
set_coords_to_write,
write_count_alive,
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
signal i_MemAdr : MemoryAddressALL;
signal i_MemDB : MemoryDataByte;
signal o_MemDB : MemoryDataByte;
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
<<<<<<< HEAD
signal countAlive : std_logic_vector(2 downto 0);
--signal slivearray : std_logic_vector(2 downto 0);
signal CellAlive : std_logic;
--signal LiveArray : LiveArrayType;
signal CD : integer := DIVIDER_CLOCK; -- XXX
signal CD_DISPLAY : integer := DIVIDER_CLOCK; -- XXX
signal CD_CALCULATE : integer := DIVIDER_CLOCK*100; -- XXX
signal CD_COPYMEMORY : integer := DIVIDER_CLOCK; -- XXX
=======
signal countAlive : std_logic_vector(3 downto 0);
signal CellAlive : std_logic;
signal CD : integer := DIVIDER_CLOCK;
signal CD_DISPLAY : integer := DIVIDER_CLOCK*1; -- XXX
signal CD_CALCULATE : integer := DIVIDER_CLOCK*10000; -- XXX
>>>>>>> oled_glidergun_32x32

function To_Std_Logic(x_vot : BOOLEAN) return std_ulogic is
begin
	if x_vot then
		return('1');
	else
		return('0');
	end if;
end function To_Std_Logic;

signal LCDChar : LCDHex;

signal o_Mem1 : MemoryDataByte;
signal o_Mem2 : MemoryDataByte;

signal MemOE : std_logic;
signal MemWR : std_logic;
signal RamAdv : std_logic;
signal RamCS : std_logic;
signal RamLB : std_logic;
signal RamUB : std_logic;
signal RamCRE : std_logic;
signal RamClk : std_logic;
signal MemAdr : MemoryAddressALL;
signal MemDB : MemoryDataByte;

constant address1 : integer := 8888;
constant address2 : integer := 9999;
constant startAddressValue : integer := address1;
signal startAddress : MemoryAddressALL := std_logic_vector(to_unsigned(startAddressValue,G_MemoryAddress));
signal startAddress0 : MemoryAddressALL;
signal startAddress1 : MemoryAddressALL;
signal stppY : std_logic_vector(31 downto 0);

begin

<<<<<<< HEAD
io_FlashCS <= '1'; -- flash is always off

io_MemOE <= MemOE;
io_MemWR <= MemWR;
io_RamAdv <= RamAdv;
io_RamCS <= RamCS;
io_RamLB <= RamLB;
io_RamUB <= RamUB;
io_RamCRE <= RamCRE;
io_RamClk <= RamClk;
io_MemAdr <= MemAdr;
io_MemDB <= MemDB;

i_reset <= btn_1;

pa : process (clk_1s) is
	variable flag : boolean := false;
	variable counter : integer := 0;
begin
	if (rising_edge(clk_1s)) then
		if (flag) then
			LCDChar <= (MemDB(12 to 15),MemDB(8 to 11),MemDB(4 to 7),MemDB(0 to 3));
		else
			LCDChar <= (MemAdr(12 to 15),MemAdr(8 to 11),MemAdr(4 to 7),MemAdr(0 to 3));
		end if;
		if (counter < 1) then
			counter := counter + 1;
		else
			flag := not flag;
			counter := 0;
		end if;
	end if;
end process pa;

c_lcd_display : lcd_display
Port Map (
	i_clock => clk,
	i_LCDChar => LCDChar,
	o_anode => an,
	o_segment => seg
=======
U_BUFG: BUFG 
port map (
I => clk,
O => CLK_BUFG
);

i_reset <= btn_1;

U_RAMB16_S4: RAMB16_S4
port map (
DI => DATA_IN,
ADDR => ADDRESS,
EN => ENABLE,
WE => WRITE_EN,
SSR => i_reset,
CLK => CLK_BUFG,
DO => DATA_OUT
>>>>>>> oled_glidergun_32x32
);

clk_div : clock_divider
port map (
	i_clk => CLK_BUFG,
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
	i_clk => CLK_BUFG,
	i_rst => i_reset,
	i_clear => btn_2,
	i_draw => draw,
	i_x => row,
	i_y => col_block,
	i_byte => display_byte,
	i_all_pixels => all_pixels,
	o_busy => o_disbusy,
	o_display_initialize => display_initialize,
	io_sda => sda,
	io_scl => scl
);

<<<<<<< HEAD
mm : memorymodule PORT MAP (
	i_clock => clk_1s,
	i_enable => i_enable,
	i_write => i_write,
	i_read => i_read,
	o_busy => o_membusy,
	i_MemAdr => i_MemAdr,
	i_MemDB => i_MemDB,
	o_MemDB => o_MemDB,
	io_MemOE => MemOE,
	io_MemWR => MemWR,
	io_RamAdv => RamAdv,
	io_RamCS => RamCS,
	io_RamLB => RamLB,
	io_RamUB => RamUB,
	io_RamCRE => RamCRE,
	io_RamClk => RamClk,
	io_MemAdr => MemAdr,
	io_MemDB => MemDB
=======
m1 : memory1
port map (
	i_clk => CLK_BUFG,
	i_reset => i_reset,
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
>>>>>>> oled_glidergun_32x32
);

gof_logic : process (clk_1s,i_reset) is
	constant W : integer := 1;
<<<<<<< HEAD
	variable waiting : integer range W downto 0 := W;
	variable vppX : natural range 0 to ROWS-1;
	variable vppYb : natural range 0 to COLS_BLOCK-1;
	variable vppYp : natural range 0 to COLS_PIXEL-1;
=======
	variable waiting : integer range W-1 downto 0 := 0;
	variable vppX : integer range 0 to ROWS-1;
	variable vppYb : integer range 0 to COLS_BLOCK-1;
	variable vppYp : integer range 0 to COLS_PIXEL-1;
>>>>>>> oled_glidergun_32x32
	variable vppXm1 : integer range -1 to ROWS-1;
	variable vppXp1 : integer range 0 to ROWS;
	variable vppYm1 : integer range -1 to COLS_PIXEL-1;
	variable vppYp1 : integer range 0 to COLS_PIXEL;
<<<<<<< HEAD
	variable vcountAlive : integer;
	variable vCellAlive,newCellAlive : boolean;
	variable m1 : MEMORY := memory_content;
	variable rowIndex : integer range 0 to ROWS-1;
	variable tppY : integer;
	variable t : MemoryDataByte;
=======
	variable vcountAlive : integer range 0 to 15;
	variable vCellAlive : boolean;
>>>>>>> oled_glidergun_32x32
begin
	if (i_reset = '1') then
		all_pixels <= '0';
		vppX := 0;
		vppYb := 0;
		vppYp := 0;
		cstate <= set_cd_memorycopy;
	elsif (rising_edge(clk_1s)) then
		startAddress0 <= std_logic_vector(to_unsigned(to_integer(unsigned(startAddress))+0,G_MemoryAddress));
		startAddress1 <= std_logic_vector(to_unsigned(to_integer(unsigned(startAddress))+1,G_MemoryAddress));
		if (waiting > 0) then
			waiting := waiting - 1;
		end if;
		case cstate is
			----------------------------------------------------------------------------------
			-- copy memory content
			when set_cd_memorycopy =>
				cstate <= enable_memory_module;
				CD <= CD_COPYMEMORY;
				startAddress <= std_logic_vector(to_unsigned(startAddressValue,G_MemoryAddress));
				rowIndex := 0;
				draw <= '0';
			when enable_memory_module =>
				cstate <= enable_write_fh;
				i_enable <= '1';
			when enable_write_fh =>
				cstate <= copy_first_halfword;
				i_write <= '1';
			when copy_first_halfword =>
				cstate <= disable_write_fh;
				i_MemAdr <= startAddress0(0 to G_MemoryAddress-1);
				i_MemDB <= m1(rowIndex)(0 to 15);
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
				i_MemAdr <= startAddress1(0 to G_MemoryAddress-1);
				i_MemDB <= m1(rowIndex)(16 to 31);
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
				if (rowIndex < ROWS-1) then
					cstate <= enable_memory_module;
					startAddress <= std_logic_vector(to_unsigned(to_integer(unsigned(startAddress))+2,G_MemoryAddress));
					rowIndex := rowIndex + 1;
				else
					cstate <= idle;
				end if;
			----------------------------------------------------------------------------------
			-- display content from memory
			when idle =>
				if (display_initialize = '1') then
					cstate <= display_is_initialize;
					i_MemDB <= (others=> '0');
				else
					cstate <= idle;
				end if;
			when display_is_initialize =>
				cstate <= enable_memory_module_read_fh;
				vppX := 0;
				vppYb := 0;
				vppYp := 0;
				all_pixels <= '0';
				startAddress <= std_logic_vector(to_unsigned(startAddressValue,G_MemoryAddress));
				rowIndex := 0;
				CD <= CD_DISPLAY;
				draw <= '1';
			when enable_memory_module_read_fh =>
				cstate <= enable_read_memory_fh;
				i_enable <= '1';
			when enable_read_memory_fh =>
				cstate <= read_fh;
				i_read <= '1';
			when read_fh =>
				cstate <= store_fh;
				i_MemAdr <= startAddress0(0 to G_MemoryAddress-1);
			when store_fh =>
				cstate <= disable_read_memory_fh;
			when disable_read_memory_fh =>
				cstate <= disable_memory_module_read_fh;
				i_read <= '0';
			when disable_memory_module_read_fh =>
				cstate <= send_fh1;
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
				i_MemAdr <= startAddress1(0 to G_MemoryAddress-1);
			when store_sh =>
				cstate <= disable_read_memory_sh;
			when disable_read_memory_sh =>
				cstate <= disable_memory_module_read_sh;
				i_read <= '0';
			when disable_memory_module_read_sh =>
				cstate <= send_sh1;
				i_enable <= '0';
			when send_fh1 =>
				if (o_membusy = '1') then
					cstate <= send_fh1;
				else
					cstate <= send_fh1_waitdisplay;
					row <= std_logic_vector(to_unsigned(rowIndex,ROWS_BITS));
					col_block <= std_logic_vector(to_unsigned(0,COLS_BLOCK_BITS));
					display_byte <= o_MemDB(8 to 15);
				end if;
			when send_fh1_waitdisplay =>
				if (o_disbusy = '1') then
					cstate <= send_fh1_waitdisplay;
				else
					cstate <= send_fh2;
				end if;
			when send_fh2 =>
				if (o_membusy = '1') then
					cstate <= send_fh2;
				else
					cstate <= send_fh2_waitdisplay;
					row <= std_logic_vector(to_unsigned(rowIndex,ROWS_BITS));
					col_block <= std_logic_vector(to_unsigned(1,COLS_BLOCK_BITS));
					display_byte <= o_MemDB(0 to 7);
				end if;
			when send_fh2_waitdisplay =>
				if (o_disbusy = '1') then
					cstate <= send_fh2_waitdisplay;
				else
					cstate <= enable_memory_module_read_sh;
				end if;
			when send_sh1 =>
				if (o_membusy = '1') then
					cstate <= send_sh1;
				else
					cstate <= send_sh1_waitdisplay;
					row <= std_logic_vector(to_unsigned(rowIndex,ROWS_BITS));
					col_block <= std_logic_vector(to_unsigned(2,COLS_BLOCK_BITS));
					display_byte <= o_MemDB(8 to 15);
				end if;
			when send_sh1_waitdisplay =>
				if (o_disbusy = '1') then
					cstate <= send_sh1_waitdisplay;
				else
					cstate <= send_sh2;
				end if;
			when send_sh2 =>
				if (o_membusy = '1') then
					cstate <= send_sh2;
				else
					cstate <= send_sh2_waitdisplay;
					row <= std_logic_vector(to_unsigned(rowIndex,ROWS_BITS));
					col_block <= std_logic_vector(to_unsigned(3,COLS_BLOCK_BITS));
					display_byte <= o_MemDB(0 to 7);
				end if;
			when send_sh2_waitdisplay =>
				if (o_disbusy = '1') then
					cstate <= send_sh2_waitdisplay;
				else
					cstate <= check_ranges_read;
				end if;
			when check_ranges_read =>
				if (rowIndex < ROWS-1) then
					cstate <= enable_memory_module_read_fh;
					startAddress <= std_logic_vector(to_unsigned(to_integer(unsigned(startAddress))+2,G_MemoryAddress));
					rowIndex := rowIndex + 1;
				else
					cstate <= set_cd_calculate;
					all_pixels <= '1';
				end if;
			----------------------------------------------------------------------------------
			-- calculate cells
			when set_cd_calculate =>
				cstate <= reset_counters_1;
				CD <= CD_CALCULATE;
			when reset_counters_1 =>
				cstate <= check_coordinations;
				all_pixels <= '1';
				vppX := 0;
				vppYb := 0;
				vppYp := 0;
			when check_coordinations =>
				cstate <= memory_enable_bit;
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
			when memory_enable_bit =>
				cstate <= reset_count_alive;
			when reset_count_alive =>
				cstate <= c1_me;
				vcountAlive := 0;
<<<<<<< HEAD
				countAlive <= "000";
			--
			when c1_me =>
				cstate <= c1_mr;
				i_enable <= '1';
			when c1_mr =>
				cstate <= set_c1;
				i_read <= '1';
=======
				countAlive <= (others => '0');
>>>>>>> oled_glidergun_32x32
			when set_c1 =>
				cstate <= c1;
				if (vppYm1 > (COLS_PIXEL/2)-1) then
					i_MemAdr <= std_logic_vector(to_unsigned(vppX+1,G_MemoryAddress));
				else
					i_MemAdr <= std_logic_vector(to_unsigned(vppX+0,G_MemoryAddress));
				end if;
			when c1 =>
				cstate <= c1_mdr;
				if (vppYp /= 0) then
					if (vppYm1 > (COLS_PIXEL/2)-1) then
						tppY := (COLS_PIXEL/2)-vppYm1;
						if(tppY < 0) then
							tppY := -tppY;
						end if;
					else
						tppY := vppYm1;
					end if;
					if (o_MemDB(tppY) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c1_mdr =>
				if (o_membusy = '1') then
					cstate <= c1_mdr;
				else
					cstate <= c1_md;
					i_read <= '0';
				end if;
			when c1_md =>
				cstate <= c2_me;
				i_enable <= '0';
			--
			when c2_me =>
				cstate <= c2_mr;
				i_enable <= '1';
			when c2_mr =>
				cstate <= set_c2;
				i_read <= '1';
			when set_c2 =>
				cstate <= c2;
				if (vppYp1 > (COLS_PIXEL/2)-1) then
					i_MemAdr <= std_logic_vector(to_unsigned(vppX+1,G_MemoryAddress));
				else
					i_MemAdr <= std_logic_vector(to_unsigned(vppX+0,G_MemoryAddress));
				end if;
			when c2 =>
				cstate <= c2_mdr;
				if (vppYp /= COLS_PIXEL-1) then
					if (vppYp1 > (COLS_PIXEL/2)-1) then
						tppY := (COLS_PIXEL/2)-vppYp1;
						if (tppY < 0) then
							tppY := -tppY;
						end if;
					else
						tppY := vppYp1;
					end if;
					if (o_MemDB(tppY) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c2_mdr =>
				if (o_membusy = '1') then
					cstate <= c2_mdr;
				else
					cstate <= c2_md;
					i_read <= '0';
				end if;
			when c2_md =>
				cstate <= c3_me;
				i_enable <= '0';
			--
			when c3_me =>
				cstate <= c3_mr;
				i_enable <= '1';
			when c3_mr =>
				cstate <= set_c3;
				i_read <= '1';
			when set_c3 =>
				cstate <= c3;
				if (vppYp > (COLS_PIXEL/2)-1) then
					i_MemAdr <= std_logic_vector(to_unsigned(vppXp1+1,G_MemoryAddress));
				else
					i_MemAdr <= std_logic_vector(to_unsigned(vppXp1+0,G_MemoryAddress));
				end if;
			when c3 =>
				cstate <= c3_mdr;
				if (vppX /= ROWS-1) then
					if (vppYp > (COLS_PIXEL/2)-1) then
						tppY := (COLS_PIXEL/2)-vppYp;
						if (tppY < 0) then
							tppY := -tppY;
						end if;
					else
						tppY := vppYp;
					end if;
					if (o_MemDB(tppY) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c3_mdr =>
				if (o_membusy = '1') then
					cstate <= c3_mdr;
				else
					cstate <= c3_md;
					i_read <= '0';
				end if;
			when c3_md =>
				cstate <= c4_me;
				i_enable <= '0';
			--
			when c4_me =>
				cstate <= c4_mr;
				i_enable <= '1';
			when c4_mr =>
				cstate <= set_c4;
				i_read <= '1';
			when set_c4 =>
				cstate <= c4;
				if (vppYp > (COLS_PIXEL/2)-1) then
					i_MemAdr <= std_logic_vector(to_unsigned(vppXm1+1,G_MemoryAddress));
				else
					i_MemAdr <= std_logic_vector(to_unsigned(vppXm1+0,G_MemoryAddress));
				end if;
			when c4 =>
				cstate <= c4_mdr;
				if (vppX /= 0) then
					if (vppYp > (COLS_PIXEL/2)-1) then
						tppY := (COLS_PIXEL/2)-vppYp;
						if (tppY < 0) then
							tppY := -tppY;
						end if;
					else
						tppY := vppYp;
					end if;
					if (o_MemDB(tppY) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c4_mdr =>
				if (o_membusy = '1') then
					cstate <= c4_mdr;
				else
					cstate <= c4_md;
					i_read <= '0';
				end if;
			when c4_md =>
				cstate <= c5_me;
				i_enable <= '0';
			--
			when c5_me =>
				cstate <= c5_mr;
				i_enable <= '1';
			when c5_mr =>
				cstate <= set_c5;
				i_read <= '1';
			when set_c5 =>
				cstate <= c5;
				if (vppYm1 > (COLS_PIXEL/2)-1) then
					i_MemAdr <= std_logic_vector(to_unsigned(vppXm1+1,G_MemoryAddress));
				else
					i_MemAdr <= std_logic_vector(to_unsigned(vppXm1+0,G_MemoryAddress));
				end if;
			when c5 =>
				cstate <= c5_mdr;
				if ((vppX /= 0) and (vppYp /= 0)) then
					if (vppYm1 > (COLS_PIXEL/2)-1) then
						tppY := (COLS_PIXEL/2)-vppYm1;
						if (tppY < 0) then
							tppY := -tppY;
						end if;
					else
						tppY := vppYm1;
					end if;
					if (o_MemDB(tppY) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c5_mdr =>
				if (o_membusy = '1') then
					cstate <= c5_mdr;
				else
					cstate <= c5_md;
					i_read <= '0';
				end if;
			when c5_md =>
				cstate <= c6_me;
				i_enable <= '0';
			--
			when c6_me =>
				cstate <= c6_mr;
				i_enable <= '1';
			when c6_mr =>
				cstate <= set_c6;
				i_read <= '1';
			when set_c6 =>
				cstate <= c6;
				if (vppYm1 > (COLS_PIXEL/2)-1) then
					i_MemAdr <= std_logic_vector(to_unsigned(vppXp1+1,G_MemoryAddress));
				else
					i_MemAdr <= std_logic_vector(to_unsigned(vppXp1+0,G_MemoryAddress));
				end if;
			when c6 =>
				cstate <= c6_mdr;
				if ((vppX /= ROWS-1) and (vppYp /= 0)) then
					if (vppYm1 > (COLS_PIXEL/2)-1) then
						tppY := (COLS_PIXEL/2)-vppYm1;
						if (tppY < 0) then
							tppY := -tppY;
						end if;
					else
						tppY := vppYm1;
					end if;
					if (o_MemDB(tppY) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c6_mdr =>
				if (o_membusy = '1') then
					cstate <= c6_mdr;
				else
					cstate <= c6_md;
					i_read <= '0';
				end if;
			when c6_md =>
				cstate <= c7_me;
				i_enable <= '0';
			--
			when c7_me =>
				cstate <= c7_mr;
				i_enable <= '1';
			when c7_mr =>
				cstate <= set_c7;
				i_read <= '1';
			when set_c7 =>
				cstate <= c7;
				if (vppYp1 > (COLS_PIXEL/2)-1) then
					i_MemAdr <= std_logic_vector(to_unsigned(vppXm1+1,G_MemoryAddress));
				else
					i_MemAdr <= std_logic_vector(to_unsigned(vppXm1+0,G_MemoryAddress));
				end if;
			when c7 =>
				cstate <= c7_mdr;
				if ((vppX /= 0) and (vppYp /= COLS_PIXEL-1)) then
					if (vppYp1 > (COLS_PIXEL/2)-1) then
						tppY := (COLS_PIXEL/2)-vppYp1;
						if (tppY < 0) then
							tppY := -tppY;
						end if;
					else
						tppY := vppYp1;
					end if;
					if (o_MemDB(tppY) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c7_mdr =>
				if (o_membusy = '1') then
					cstate <= c7_mdr;
				else
					cstate <= c7_md;
					i_read <= '0';
				end if;
			when c7_md =>
				cstate <= c8_me;
				i_enable <= '0';
			--
			when c8_me =>
				cstate <= c8_mr;
				i_enable <= '1';
			when c8_mr =>
				cstate <= set_c8;
				i_read <= '1';
			when set_c8 =>
				cstate <= c8;
				if (vppYp1 > (COLS_PIXEL/2)-1) then
					i_MemAdr <= std_logic_vector(to_unsigned(vppXp1+1,G_MemoryAddress));
				else
					i_MemAdr <= std_logic_vector(to_unsigned(vppXp1+0,G_MemoryAddress));
				end if;
			when c8 =>
				cstate <= c8_mdr;
				if ((vppX /= ROWS-1) and (vppYp /= COLS_PIXEL-1)) then
					if (vppYp1 > (COLS_PIXEL/2)-1) then
						tppY := (COLS_PIXEL/2)-vppYp1;
						if (tppY < 0) then
							tppY := -tppY;
						end if;
					else
						tppY := vppYp1;
					end if;
					if (o_MemDB(tppY) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
<<<<<<< HEAD
			when c8_mdr =>
				if (o_membusy = '1') then
					cstate <= c8_mdr;
				else
					cstate <= c8_md;
					i_read <= '0';
				end if;
			when c8_md =>
				cstate <= store_count_alive_me;
				i_enable <= '0';
			--
			when store_count_alive_me =>
				cstate <= store_count_alive_we;
				i_enable <= '1';
			when store_count_alive_we =>
				cstate <= store_count_alive_sa;
				i_write <= '1';
			when store_count_alive_sa =>
=======
			when waitfor =>
				cstate <= memory_disable_bit;
				countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
			when memory_disable_bit =>
>>>>>>> oled_glidergun_32x32
				cstate <= store_count_alive;
				i_MemAdr <= std_logic_vector(to_unsigned(6666+vppX+vppYp,G_MemoryAddress));
			when store_count_alive =>
				cstate <= store_count_alive_wd;
				i_MemDB <= std_logic_vector(to_unsigned(vcountAlive,G_MemoryData));
			when store_count_alive_wd =>
				cstate <= store_count_alive_wm;
				i_write <= '0';
			when store_count_alive_wm =>
				if (o_membusy='1') then
					cstate <= store_count_alive_wm;
				else
					cstate <= store_count_alive_md;
				end if;
			when store_count_alive_md =>
				cstate <= update_row1;
<<<<<<< HEAD
				i_enable <= '0';
=======
				ENABLE <= '1';
				WRITE_EN <= '1';
				ADDRESS <= std_logic_vector(to_unsigned(vppX+vppYp*WORD_BITS,12));
				DATA_IN <= countAlive;
>>>>>>> oled_glidergun_32x32
			when update_row1 =>
			     ENABLE <= '0';
			     WRITE_EN <= '0';
				if (vppX < ROWS-1) then
					vppX := vppX + 1;
					cstate <= check_coordinations;
				else
					cstate <= update_col1;
				end if;
			when update_col1 =>
				if (vppYp < COLS_PIXEL-1) then
					vppYp := vppYp + 1;
					cstate <= check_coordinations;
					vppX := 0;
				else
					cstate <= reset_counters1;
					vppYp := 0;
				end if;
			----------------------------------------------------------------------------------
			-- store bits in memory
			when reset_counters1 =>
				cstate <= memory_enable_bit1;
				vppX := 0;
				vppYb := 0;
				vppYp := 0;
			when memory_enable_bit1 =>
				cstate <= get_alive;
				i_enable <= '1';
			when memory_enable_read1 =>
				cstate <= memory_sa1;
				i_read <= '1';
			when memory_sa1 =>
				cstate <= get_alive;
				if (vppYp > (COLS_PIXEL/2)-1) then
					i_MemAdr <= std_logic_vector(to_unsigned(vppX+1,G_MemoryAddress));
				else
					i_MemAdr <= std_logic_vector(to_unsigned(vppX+0,G_MemoryAddress));
				end if;
			when get_alive =>
				cstate <= get_alive1;
<<<<<<< HEAD
				if (vppYp > (COLS_PIXEL/2)-1) then
					tppY := (COLS_PIXEL/2)-vppYp;
					if (tppY < 0) then
						tppY := -tppY;
					end if;
				else
					tppY := vppYp;
				end if;
=======
				row <= ppX;
				col_pixel <= ppYp;
>>>>>>> oled_glidergun_32x32
			when get_alive1 =>
				cstate <= memory_disable_read1;
				if (o_MemDB(tppY) = '1') then -- xxx up before read=0
					vCellAlive := true;
				else
					vCellAlive := false;
				end if;
			when memory_disable_read1 =>
				cstate <= memory_disable_read1_wm;
				i_read <= '0';
			when memory_disable_read1_wm =>
				if (o_membusy='1') then
					cstate <= memory_disable_read1_wm;
				else
					cstate <= memory_disable_bit1;
				end if;
			when memory_disable_bit1 =>
				cstate <= enable_m2;
				i_enable <= '0';
			when enable_m2 =>
				cstate <= enable_write_to_memory;
				i_enable <= '1';
			when enable_write_to_memory =>
<<<<<<< HEAD
				cstate <= check_cell_alive_1;
				i_read <= '1';
			when check_cell_alive_1 =>
				cstate <= asdf;
				i_MemAdr <= std_logic_vector(to_unsigned(6666+vppX+vppYp,G_MemoryAddress));
			when asdf =>
				cstate <= check_cell_alive_1a;
				t := o_MemDB;
			when check_cell_alive_1a =>
				cstate <= check_cell_alive_2;
				if (vCellAlive = true) then
					if ((to_integer(unsigned(t)) = 2) or (to_integer(unsigned(t)) = 3)) then
						newCellAlive := true;
=======
				cstate <= write_count_alive;
				i_mem_write_bit <= '1';
			     ENABLE <= '1';
			     WRITE_EN <= '0';
			     ADDRESS <= std_logic_vector(to_unsigned(vppX+vppYp*WORD_BITS,12));
			when write_count_alive =>
				cstate <= disable_write_to_memory;
				if (vCellAlive = true) then
					if ((to_integer(unsigned(DATA_OUT)) = 2) or (to_integer(unsigned(DATA_OUT)) = 3)) then
						i_bit <= '1';
>>>>>>> oled_glidergun_32x32
					else
						newCellAlive := false;
					end if;
				elsif (vCellAlive = false) then
<<<<<<< HEAD
					if ((to_integer(unsigned(t)) = 3)) then
						newCellAlive := true;
=======
					if (to_integer(unsigned(DATA_OUT)) = 3) then
						i_bit <= '1';
>>>>>>> oled_glidergun_32x32
					else
						newCellAlive := false;
					end if;
				end if;				
			when check_cell_alive_2 =>
				cstate <= check_cell_alive_wm;
				i_read <= '0';
			when check_cell_alive_wm =>
				if (o_membusy='1') then
					cstate <= check_cell_alive_wm;
				else
					cstate <= check_cell_alive_3;
				end if;
			when check_cell_alive_3 =>
				cstate <= aa;
				i_enable <= '0';
			when aa =>
				cstate <= aaa;
				i_enable <= '1';
			when aaa =>
				cstate <= aaaa;
				i_write <= '1';
			when aaaa =>
				cstate <= aaaaa;
				if (vppYp > (COLS_PIXEL/2)-1) then
					i_MemAdr <= std_logic_vector(to_unsigned(vppX+1,G_MemoryAddress));
				else
					i_MemAdr <= std_logic_vector(to_unsigned(vppX+0,G_MemoryAddress));
				end if;
			when aaaaa =>
				cstate <= disable_write_to_memory;
				if (newCellAlive = true) then
					i_MemDB(tppY) <= '1';
				else
					i_MemDB(tppY) <= '0';
				end if;
			when disable_write_to_memory =>
<<<<<<< HEAD
				cstate <= vvv_wm;
				i_write <= '0';
			when vvv_wm =>
				if (o_membusy='1') then
					cstate <= vvv_wm;
				else
					cstate <= vvv;
				end if;
			when vvv =>
=======
			     ENABLE <= '0';
			     WRITE_EN <= '0';
>>>>>>> oled_glidergun_32x32
				cstate <= update_row2;
				i_enable <= '0';
			when update_row2 =>
				if (vppX < ROWS-1) then
					vppX := vppX + 1;
					cstate <= get_alive;
				else
					cstate <= update_col2;
				end if;
			when update_col2 =>
				if (vppYp < COLS_PIXEL-1) then
					vppYp := vppYp + 1;
					cstate <= get_alive;
					vppX := 0;
				else
					cstate <= disable_memory;
					vppYp := 0;
					vppYb := 0;
				end if;
			when disable_memory =>
				cstate <= stop;
				i_enable <= '0';
			----------------------------------------------------------------------------------
			-- end
			when stop =>
				cstate <= idle;
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
	stppY <= std_logic_vector(to_unsigned(tppY,32));
end process gof_logic;

end Behavioral;
