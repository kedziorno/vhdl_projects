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
signal io_RamClk : inout std_logic;
signal io_MemAdr : inout MemoryAddress;
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

component memorymodule is
Port (
i_clock : in std_logic;
i_enable : in std_logic;
i_write : in std_logic;
i_read : in std_logic;
o_busy : out std_logic;
i_MemAdr : in MemoryAddress;
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
io_MemAdr : out MemoryAddress;
io_MemDB : inout MemoryDataByte
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
signal draw : std_logic;

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
signal i_MemAdr : MemoryAddress;
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
signal MemAdr : MemoryAddress;
signal MemDB : MemoryDataByte;

constant startAddressValue : integer := 0;
signal startAddress : MemoryAddressALL := std_logic_vector(to_unsigned(startAddressValue,G_MemoryAddress));
signal startAddress0 : MemoryAddressALL;
signal startAddress1 : MemoryAddressALL;

begin

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

--pa : process (clk_1s) is
--	variable flag : boolean := false;
--	variable counter : integer := 0;
--begin
--	if (rising_edge(clk_1s)) then
--		if (flag) then
--			LCDChar <= (MemDB(3 downto 0),MemDB(7 downto 4),MemDB(11 downto 8),MemDB(15 downto 12));
--		else
--			LCDChar <= (MemAdr(3 downto 0),MemAdr(7 downto 4),MemAdr(11 downto 8),MemAdr(15 downto 12));
--		end if;
--		if (counter < 1) then
--			counter := counter + 1;
--		else
--			flag := not flag;
--			counter := 0;
--		end if;
--	end if;
--end process pa;

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
	i_clk => clk,
	i_rst => btn_1,
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
);

gof_logic : process (clk_1s,i_reset) is
	constant W : integer := 1;
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
	variable rowIndex : integer range 0 to ROWS-1;
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
			-- copy memory content
			when set_cd_memorycopy =>
				cstate <= enable_memory_module;
				CD <= CD_CALCULATE;
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
				i_MemAdr <= startAddress0(G_MemoryAddress-1 downto 1);
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
				i_MemAdr <= startAddress1(G_MemoryAddress-1 downto 1);
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
				i_MemAdr <= startAddress0(G_MemoryAddress-1 downto 1);
			when store_fh =>
				cstate <= disable_read_memory_fh;
				--o_Mem1 <= o_MemDB;
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
				i_MemAdr <= startAddress1(G_MemoryAddress-1 downto 1);
			when store_sh =>
				cstate <= disable_read_memory_sh;
				--o_Mem2 <= o_MemDB;
			when disable_read_memory_sh =>
				cstate <= disable_memory_module_read_sh;
				i_read <= '0';
			when disable_memory_module_read_sh =>
				cstate <= send_sh1;
				i_enable <= '0';
			when send_fh1 =>
				cstate <= send_fh1_waitdisplay;
				row <= std_logic_vector(to_unsigned(rowIndex,ROWS_BITS));
				col_block <= std_logic_vector(to_unsigned(0,COLS_BLOCK_BITS));
				display_byte <= o_MemDB(15 downto 8);
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
				display_byte <= o_MemDB(7 downto 0);
			when send_fh2_waitdisplay =>
				if (o_disbusy = '1') then
					cstate <= send_fh2_waitdisplay;
				else
					cstate <= enable_memory_module_read_sh;
				end if;
			when send_sh1 =>
				cstate <= send_sh1_waitdisplay;
				row <= std_logic_vector(to_unsigned(rowIndex,ROWS_BITS));
				col_block <= std_logic_vector(to_unsigned(2,COLS_BLOCK_BITS));
				display_byte <= o_MemDB(15 downto 8);
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
				display_byte <= o_MemDB(7 downto 0);
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
					cstate <= memory_enable_byte;
					all_pixels <= '1';
				end if;
			when memory_enable_byte =>
				cstate <= waitone;
				waiting := W-1;
				CD <= CD_DISPLAY;
			when waitone =>
				if (waiting = 0) then
					cstate <= update_row;
				else
					waiting := waiting - 1;
				end if;
				row <= ppX;
				col_block <= ppYb;
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
					cstate <= set_cd_calculate;
					vppYb := 0;
				end if;
			when set_cd_calculate =>
				cstate <= memory_disable_byte;
				CD <= CD_CALCULATE;
			when memory_disable_byte =>
				cstate <= reset_counters_1;
                  -- calculate cells
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
                          i_mem_e_bit <= '1';
                  when reset_count_alive =>
                          cstate <= set_c1;
                          vcountAlive := 0;
                          countAlive <= "000";
                  when set_c1 =>
                          cstate <= c1;
                          row <= ppX;
                          col_pixel <= ppYm1;
                  when c1 =>
                          cstate <= set_c2;
                          if (vppYp /= 0) then
                                  if (o_bit = '1') then
                                          vcountAlive := vcountAlive + 1;
                                  end if;
                                  countAlive <= std_logic_vector(to_unsigned(vcountALive,3));
                          end if;
                  when set_c2 =>
                          cstate <= c2;
                          row <= ppX;
                          col_pixel <= ppYp1;
                  when c2 =>
                          cstate <= set_c3;
                          if (vppYp /= COLS_PIXEL-1) then 
                                  if (o_bit = '1') then
                                          vcountAlive := vcountAlive + 1;
                                  end if;
                                  countAlive <= std_logic_vector(to_unsigned(vcountALive,3));
                          end if;
                          cstate <= set_c4;
                          if (vppX /= ROWS-1) then
                                  if (o_bit = '1') then
                                          vcountAlive := vcountAlive + 1;
                                  end if;
                                  countAlive <= std_logic_vector(to_unsigned(vcountALive,3));
                          end if;
                  when set_c4 =>
                          cstate <= c4;
                          row <= ppXm1;
                          col_pixel <= ppYp;      
                  when c4 =>
                          cstate <= set_c5;
                          if (vppX /= 0) then
                                  if (o_bit = '1') then
                                          vcountAlive := vcountAlive + 1;
                                  end if;
                                  countAlive <= std_logic_vector(to_unsigned(vcountALive,3));
                          end if;
                  when set_c5 =>
                          cstate <= c5;
                          row <= ppXm1;
                          col_pixel <= ppYm1;     
                  when c5 =>
                          cstate <= set_c6;
                          if ((vppX /= 0) and (vppYp /= 0)) then
                                  if (o_bit = '1') then
                                          vcountAlive := vcountAlive + 1;
                                  end if;
                                  countAlive <= std_logic_vector(to_unsigned(vcountALive,3));
                          end if;
                  when set_c6 =>
                          cstate <= c6;
                          row <= ppXp1;
                          col_pixel <= ppYm1;
                          cstate <= set_c7;
                          if ((vppX /= ROWS-1) and (vppYp /= 0)) then
                                  if (o_bit = '1') then
                                          vcountAlive := vcountAlive + 1;
                                  end if;
                                  countAlive <= std_logic_vector(to_unsigned(vcountALive,3));
                          end if;
                  when set_c7 =>
                          cstate <= c7;
                          row <= ppXm1;
                          col_pixel <= ppYp1;     
                  when c7 =>
                          cstate <= set_c8;
                          if ((vppX /= 0) and (vppYp /= COLS_PIXEL-1)) then
                                  if (o_bit = '1') then
                                          vcountAlive := vcountAlive + 1;
                                  end if;
                                  countAlive <= std_logic_vector(to_unsigned(vcountALive,3));
                          end if;
                  when set_c8 =>
                          cstate <= c8;
                          row <= ppXp1;
                          col_pixel <= ppYp1;     
                  when c8 =>
                          cstate <= waitfor;
                          if ((vppX /= ROWS-1) and (vppYp /= COLS_PIXEL-1)) then
                                  if (o_bit = '1') then
                                          vcountAlive := vcountAlive + 1;
                                  end if;
                                  countAlive <= std_logic_vector(to_unsigned(vcountALive,3));
                          end if;
                  when waitfor =>
                          cstate <= memory_disable_bit;
                          countAlive <= std_logic_vector(to_unsigned(vcountALive,3));
                  when memory_disable_bit =>
                          cstate <= store_count_alive;
                          i_mem_e_bit <= '0';
                          cstate <= update_row1;
                          --LiveArray(vppX)(vppYp) <= countAlive;
                  when update_row1 =>
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
                  -- store bits in memory
                  when reset_counters1 =>
                          cstate <= memory_enable_bit1;
                          vppX := 0;
                          vppYb := 0;
                          vppYp := 0;
                  when memory_enable_bit1 =>
                          cstate <= get_alive;
                          i_mem_e_bit <= '1';
                  when get_alive =>
                          cstate <= get_alive1;
                          row <= ppX;
                          col_pixel <= ppYp;
                          --slivearray <= LiveArray(vppX)(vppYp);
                  when get_alive1 =>
                          cstate <= enable_write_to_memory;
                          if (o_bit = '1') then
                                  vCellAlive := true;
                          else
                                  vCellAlive := false;
                          end if;
                  when enable_write_to_memory =>
                          cstate <= write_count_alive;
                          i_mem_write_bit <= '1';
                  when write_count_alive =>
                          cstate <= disable_write_to_memory;
--                        if (vCellAlive = true) then
--                                if ((to_integer(unsigned(LiveArray(vppX)(vppYp))) = 2) or (to_integer(unsigned(LiveArray(vppX)(vppYp))) = 3)) then
--                                        i_bit <= '1';
--                                else
--                                        i_bit <= '0';
--                                end if;
--                        elsif (vCellAlive = false) then
--                                if (to_integer(unsigned(LiveArray(vppX)(vppYp))) = 3) then
--                                        i_bit <= '1';
--                                else
--                                        i_bit <= '0';
--                                end if;
--                        end if;
                  when disable_write_to_memory =>
                          cstate <= update_row2;
                          i_mem_write_bit <= '0';
                          i_bit <= '0';
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
                          i_mem_e_bit <= '0';
                          i_bit <= '0';
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
end process gof_logic;

end Behavioral;
