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
use WORK.st7735r_p_package.ALL;
use WORK.st7735r_p_screen.ALL;
use WORK.p_memory_content.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity st7735r_gof is
generic(
INPUT_CLOCK : integer := 29_952_000;
DIVIDER_CLOCK : integer := 1_000;
SPI_SPEED_MODE : integer := C_CLOCK_COUNTER_EF
);
port(
clk : in std_logic;
btn_1 : in std_logic;
--btn_2 : in std_logic;
--btn_3 : in std_logic;
o_cs : out std_logic;
o_do : out std_logic;
o_ck : out std_logic;
o_reset : out std_logic;
o_rs : out std_logic;
Led7 : out std_logic;
o_MemOE : out std_logic;
o_MemWR : out std_logic;
o_RamAdv : out std_logic;
o_RamCS : out std_logic;
o_RamCRE : out std_logic;
o_RamLB : out std_logic;
o_RamUB : out std_logic;
i_RamWait : in std_logic;
o_RamClk : out std_logic;
o_MemAdr : out MemoryAddress;
io_MemDB : inout MemoryDataByte;
o_FlashCS : out std_logic;
-- for debug
jc : out std_logic_vector(7 downto 0);
jd : out std_logic_vector(7 downto 0)
);
end entity st7735r_gof;

architecture Behavioral of st7735r_gof is

component my_spi is
generic (
C_CLOCK_COUNTER : integer
);
port (
i_clock : in std_logic;
i_reset : in std_logic;
i_enable : in std_logic;
i_data_byte : in BYTE_TYPE;
o_cs : out std_logic;
o_do : out std_logic;
o_ck : out std_logic;
o_sended : out std_logic
);
end component my_spi;

component st7735r_initialize is
generic (
C_CLOCK_COUNTER : integer
);
port (
i_clock : in std_logic;
i_reset : in std_logic;
i_run : in std_logic;
i_color : in COLOR_TYPE;
i_sended : in std_logic;
o_initialized : out std_logic;
o_enable : out std_logic;
o_data_byte : out BYTE_TYPE;
o_reset : out std_logic;
o_rs : out std_logic;
o_cs : out std_logic
);
end component st7735r_initialize;

component st7735r_draw_box is
generic (
C_CLOCK_COUNTER : integer
);
port (
i_clock : in std_logic;
i_reset : in std_logic;
i_run : in std_logic;
i_sended : in std_logic;
i_color : in COLOR_TYPE;
i_raxs : in BYTE_TYPE;
i_raxe : in BYTE_TYPE;
i_rays : in BYTE_TYPE;
i_raye : in BYTE_TYPE;
i_caxs : in BYTE_TYPE;
i_caxe : in BYTE_TYPE;
i_cays : in BYTE_TYPE;
i_caye : in BYTE_TYPE;
o_data : out BYTE_TYPE;
o_enable : out std_logic;
o_rs : out std_logic;
o_initialized : out std_logic
);
end component st7735r_draw_box;

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
i_clock : in std_logic;
i_enable : in std_logic;
i_write : in std_logic;
i_read : in std_logic;
o_busy : out std_logic;
i_MemAdr : in MemoryAddress;
i_MemDB : in MemoryDataByte;
o_MemDB : out MemoryDataByte;
o_MemOE : out std_logic;
o_MemWR : out std_logic;
o_RamAdv : out std_logic;
o_RamCS : out std_logic;
o_RamCRE : out std_logic;
o_RamLB : out std_logic;
o_RamUB : out std_logic;
i_RamWait : in std_logic;
o_RamClk : out std_logic;
o_MemAdr : out MemoryAddress;
io_MemDB : inout MemoryDataByte
);
end component memorymodule;

--signal row : std_logic_vector(ROWS_BITS-1 downto 0) := (others => '0');
--signal col_pixel : std_logic_vector(COLS_PIXEL_BITS-1 downto 0) := (others => '0');
--signal col_block : std_logic_vector(COLS_BLOCK_BITS-1 downto 0) := (others => '0');
--signal rst : std_logic;
--signal all_pixels : std_logic;
--signal clk_1s : std_logic;
--signal display_byte : std_logic_vector(BYTE_BITS-1 downto 0);
--signal display_initialize : std_logic;
--signal o_bit : std_logic;
signal i_reset : std_logic;

--signal i_mem_e_byte : std_logic;
--signal i_mem_e_bit : std_logic;
--signal i_mem_write_bit : std_logic;
--signal i_bit : std_logic;

signal CLK_BUFG : std_logic;

--signal DATA_IN : std_logic_vector(3 downto 0);
--signal ADDRESS : std_logic_vector(11 downto 0);
--signal ENABLE : std_logic;
--signal WRITE_EN : std_logic;
--signal DATA_OUT : std_logic_vector(3 downto 0);

type state is (
incrementk,check_rowindex,set_color,check_ranges_write1,check_ranges_write2,check_i,memory_busy,
set_cd_memorycopy,enable_memory_module,enable_write_fh,
copy_first_halfword,disable_write_fh,memory_wait_fh,enable_write_sh,
copy_second_halfword,disable_write_sh,memory_wait_sh,disable_memory_module,
check_ranges_write,
idle,
display_is_initialize,
enable_memory_module_read_fh,enable_read_memory_fh,read_fh,store_fh,disable_read_memory_fh,disable_memory_module_read_fh,
send_fh1,send_fh1_waitdisplay,send_fh2,send_fh2_waitdisplay,
enable_memory_module_read_sh,enable_read_memory_sh,read_sh,store_sh,disable_read_memory_sh,disable_memory_module_read_sh,
send_sh1,send_sh1_waitdisplay,send_sh2,send_sh2_waitdisplay,
wait_two_reads,
check_ranges_read,
reset_counters,
draw_box_state0,draw_box_state1,draw_box_state2,draw_box_state3,draw_box_state4,
draw_box_state5,draw_box_state6,draw_box_state7,draw_box_state8,draw_box_state9,
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
stop);
signal cstate : state;

constant W : integer := 1;
signal waiting : integer range W-1 downto 0 := 0;
--signal ppX : std_logic_vector(ROWS_BITS-1 downto 0);
--signal ppYb : std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
--signal ppYp : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
--signal ppXm1 : std_logic_vector(ROWS_BITS-1 downto 0);
----signal ppXp1 : std_logic_vector(ROWS_BITS-1 downto 0);
--signal ppYm1 : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
--signal ppYp1 : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
--signal oppX : std_logic_vector(ROWS_BITS-1 downto 0);
--signal oppY : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
signal countAlive : std_logic_vector(3 downto 0);
signal CellAlive : std_logic;
signal CD : integer := DIVIDER_CLOCK;
signal CD_DISPLAY : integer := DIVIDER_CLOCK*1; -- XXX
signal CD_CALCULATE : integer := DIVIDER_CLOCK*10000; -- XXX

signal spi_enable,spi_cs,spi_do,spi_ck,spi_sended : std_logic;
signal spi_data_byte : BYTE_TYPE;
signal initialize_run,initialize_sended : std_logic;
signal initialize_initialized,initialize_enable,initialize_reset,initialize_rs,initialize_cs : std_logic;
signal initialize_color : COLOR_TYPE;
signal initialize_data_byte : BYTE_TYPE;
signal drawbox_sended,drawbox_enable,drawbox_rs,drawbox_run,drawbox_initialized : std_logic;
signal drawbox_raxs,drawbox_raxe,drawbox_rays,drawbox_raye,drawbox_caxs,drawbox_caxe,drawbox_cays,drawbox_caye : BYTE_TYPE;
signal drawbox_data_byte : BYTE_TYPE;
signal drawbox_color : COLOR_TYPE;
signal mm_MemAdr,mm_i_MemAdr : MemoryAddress;
signal mm_MemDB_i,mm_MemDB_o,mm_i_MemDB,mm_o_MemDB : MemoryDataByte;
signal mm_i_enable,mm_i_write,mm_i_read,mm_o_busy : std_logic;

function To_Std_Logic(x_vot : BOOLEAN) return std_ulogic is
begin
	if x_vot then
		return('1');
	else
		return('0');
	end if;
end function To_Std_Logic;

signal MemOE : std_logic;
signal MemWR : std_logic;
signal RamAdv : std_logic;
signal RamCS : std_logic;
signal RamCRE : std_logic;
signal RamLB : std_logic;
signal RamUB : std_logic;
signal RamWait : std_logic;
signal RamClk : std_logic;
signal MemAdr : MemoryAddress;
signal MemDB : MemoryDataByte;
signal FlashCS : std_logic;

begin

o_MemOE <= MemOE;
o_MemWR <= MemWR;
o_RamAdv <= RamAdv;
o_RamCS <= RamCS;
o_RamCRE <= RamCRE;
o_RamLB <= RamLB;
o_RamUB <= RamUB;
o_RamClk <= RamClk;
o_MemAdr <= MemAdr;
io_MemDB <= MemDB;
o_FlashCS <= FlashCS;

-- for debug
-- all 0-15 bits, #OE
--jc(0) <= io_MemDB(0) when io_MemOE = '1' else 'Z';
--jc(1) <= io_MemDB(1) when io_MemOE = '1' else 'Z';
--jc(2) <= io_MemDB(2) when io_MemOE = '1' else 'Z';
--jc(3) <= io_MemDB(3) when io_MemOE = '1' else 'Z';
--jc(4) <= io_MemDB(4) when io_MemOE = '1' else 'Z';
--jc(5) <= io_MemDB(5) when io_MemOE = '1' else 'Z';
--jc(6) <= io_MemDB(6) when io_MemOE = '1' else 'Z';
--jc(7) <= io_MemDB(7) when io_MemOE = '1' else 'Z';
--jd(0) <= io_MemDB(8) when io_MemOE = '1' else 'Z';
--jd(1) <= io_MemDB(9) when io_MemOE = '1' else 'Z';
--jd(2) <= io_MemDB(10) when io_MemOE = '1' else 'Z';
--jd(3) <= io_MemDB(11) when io_MemOE = '1' else 'Z';
--jd(4) <= io_MemDB(12) when io_MemOE = '1' else 'Z';
--jd(5) <= io_MemDB(13) when io_MemOE = '1' else 'Z';
--jd(6) <= io_MemDB(14) when io_MemOE = '1' else 'Z';
--jd(7) <= io_MemDB(15) when io_MemOE = '1' else 'Z';
-- 0-15 bits
-- up
jc(0) <= io_MemDB(0) when MemOE = '0' else 'Z';
jc(1) <= io_MemDB(1) when MemOE = '0' else 'Z';
jc(2) <= io_MemDB(2) when MemOE = '0' else 'Z';
jc(3) <= io_MemDB(3) when MemOE = '0' else 'Z';
jd(0) <= io_MemDB(4) when MemOE = '0' else 'Z';
jd(1) <= io_MemDB(5) when MemOE = '0' else 'Z';
jd(2) <= io_MemDB(6) when MemOE = '0' else 'Z';
jd(3) <= io_MemDB(7) when MemOE = '0' else 'Z';
--down
jc(4) <= io_MemDB(8) when MemOE = '0' else 'Z';
jc(5) <= io_MemDB(9) when MemOE = '0' else 'Z';
jc(6) <= io_MemDB(10) when MemOE = '0' else 'Z';
jc(7) <= io_MemDB(11) when MemOE = '0' else 'Z';
jd(4) <= io_MemDB(12) when MemOE = '0' else 'Z';
jd(5) <= io_MemDB(13) when MemOE = '0' else 'Z';
jd(6) <= io_MemDB(14) when MemOE = '0' else 'Z';
jd(7) <= io_MemDB(15) when MemOE = '0' else 'Z';

i_reset <= btn_1;
Led7 <= i_RamWait;
FlashCS <= '1'; -- flash is always off

o_cs <= spi_cs; -- TODO use initialize_cs mux
o_do <= spi_do;
o_ck <= spi_ck;

o_reset <=
initialize_reset when initialize_run = '1'
else
'1';

o_rs <=
initialize_rs when initialize_run = '1'
else
drawbox_rs when drawbox_run = '1'
else
'1';

spi_data_byte <=
initialize_data_byte when initialize_run = '1'
else
drawbox_data_byte when drawbox_run = '1'
else
(others => '0');

spi_enable <=
initialize_enable when initialize_run = '1'
else
drawbox_enable when drawbox_run = '1'
else
'0';

initialize_sended <=
spi_sended when initialize_run = '1'
else
'0';

drawbox_sended <=
spi_sended when drawbox_run = '1'
else
'0';

myspi_entity : my_spi
generic map (
C_CLOCK_COUNTER => SPI_SPEED_MODE
)
port map (
i_clock => CLK_BUFG,
i_reset => i_reset,
i_enable => spi_enable,
i_data_byte => spi_data_byte,
o_cs => spi_cs,
o_do => spi_do,
o_ck => spi_ck,
o_sended => spi_sended
);

st7735rinit_entity : st7735r_initialize
generic map (
C_CLOCK_COUNTER => SPI_SPEED_MODE
)
port map (
i_clock => CLK_BUFG,
i_reset => i_reset,
i_run => initialize_run,
i_color => initialize_color,
i_sended => initialize_sended,
o_initialized => initialize_initialized,
o_cs => initialize_cs,
o_reset => initialize_reset,
o_rs => initialize_rs,
o_enable => initialize_enable,
o_data_byte => initialize_data_byte
);
--initialize_initialized <= '1'; -- XXX omit initialize in simulation

st7735rdrawbox_entity : st7735r_draw_box
generic map (
C_CLOCK_COUNTER => SPI_SPEED_MODE
)
port map (
i_clock => CLK_BUFG,
i_reset => i_reset,
i_run => drawbox_run,
i_sended => drawbox_sended, -- XXX SPI
i_color => drawbox_color,
i_raxs => drawbox_raxs,
i_raxe => drawbox_raxe,
i_rays => drawbox_rays,
i_raye => drawbox_raye,
i_caxs => drawbox_caxs,
i_caxe => drawbox_caxe,
i_cays => drawbox_cays,
i_caye => drawbox_caye,
o_data => drawbox_data_byte,
o_enable => drawbox_enable, -- XXX SPI
o_rs => drawbox_rs,
o_initialized => drawbox_initialized
);

U_BUFG: BUFG 
port map (
I => clk,
O => CLK_BUFG
);

--clk_div : clock_divider
--port map (
--	i_clk => CLK_BUFG,
--	i_board_clock => INPUT_CLOCK,
--	i_divider => CD,
--	o_clk => clk_1s
--);

mm1 : memorymodule
Port map (
i_clock => CLK_BUFG,
i_enable => mm_i_enable,
i_write => mm_i_write,
i_read => mm_i_read,
o_busy => mm_o_busy,
i_MemAdr => mm_i_MemAdr,
i_MemDB => mm_i_MemDB,
o_MemDB => mm_o_MemDB,
o_MemOE => MemOE,
o_MemWR => MemWR,
o_RamAdv => RamAdv,
o_RamCS => RamCS,
o_RamCRE => RamCRE,
o_RamLB => RamLB,
o_RamUB => RamUB,
i_RamWait => RamWait,
o_RamClk => RamClk,
o_MemAdr => MemAdr,
io_MemDB => MemDB
);

gof_logic : process (CLK_BUFG,i_reset) is
	constant W : integer := 1;
	variable waiting : integer range W-1 downto 0 := 0;
	variable vppX : integer range 0 to ROWS-1;
--	variable vppYb : integer range 0 to COLS_BLOCK-1;
	variable vppYp : integer range 0 to COLS_PIXEL-1;
	variable vppXm1 : integer range -1 to ROWS-1;
	variable vppXp1 : integer range 0 to ROWS;
	variable vppYm1 : integer range -1 to COLS_PIXEL-1;
	variable vppYp1 : integer range 0 to COLS_PIXEL;
	variable vcountAlive : integer range 0 to 15;
	variable vCellAlive : boolean;
	variable wi : integer range 0 to 255 := 0;
--	constant W : integer := 10;
--	variable waiting : integer range W downto 0 := W;
--	variable m1 : MEMORY := memory_content;
	variable startAddress : integer range 0 to 16384 := 0;
--	variable copyWords : integer := (ROWS*(COLS_PIXEL/G_MemoryData));
--	variable copyWordsIndex : integer := copyWords - 1;
	variable rowIndex : integer range 0 to 255 := 0;
	variable o_Mem1 : MemoryDataByte;
	variable o_Mem2 : MemoryDataByte;
	variable COL : WORD;
	constant i_max : integer range 0 to 255 := (COLS_PIXEL/G_MemoryData);
	variable i : integer range 0 to 255;
	variable k : integer range 0 to 255;
begin
	if (i_reset = '1') then
--		all_pixels <= '0';
		vppX := 0;
--		vppYb := 0;
		vppYp := 0;
		i := 0;
		k := 0;
--		cstate <= idle;
		cstate <= set_cd_memorycopy;
		initialize_run <= '0';
		COL := (others => '0');
	elsif (rising_edge(CLK_BUFG)) then
		case cstate is
			-- copy memory content
			when set_cd_memorycopy =>
				i := 0;
				cstate <= enable_memory_module;
--				if (i_RamWait = '1') then -- XXX use only in synch transactions
--					cstate <= set_cd_memorycopy;
--				else
--					cstate <= enable_memory_module;
--				end if;
--				CD <= CD_CALCULATE;
			when enable_memory_module =>
				cstate <= enable_write_fh;
				mm_i_enable <= '1';
			when enable_write_fh =>
				cstate <= copy_first_halfword;
				mm_i_write <= '1';
				COL := memory_content(rowIndex);
			when copy_first_halfword =>
				cstate <= disable_write_fh;
				mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + rowIndex*i_max + i,G_MemoryAddress-1));
				mm_i_MemDB(G_MemoryData-1 downto 0) <= COL(i*G_MemoryData+(G_MemoryData-1) downto i*G_MemoryData+0);
			when disable_write_fh =>
				cstate <= disable_memory_module;
				mm_i_write <= '0';
			when disable_memory_module =>
				cstate <= memory_wait_fh;
				mm_i_enable <= '0';
			when memory_wait_fh =>
				if (mm_o_busy = '1') then
					cstate <= memory_wait_fh;
				else
					cstate <= check_ranges_write1;
				end if;
			when check_ranges_write1 =>
				if (i = i_max-1) then
					cstate <= check_ranges_write2;
					i := 0;
				else
					i := i + 1;
					cstate <= enable_memory_module;
				end if;
			when check_ranges_write2 =>
				if (rowIndex = ROWS-1) then
					rowIndex := 0;
					cstate <= idle;
				else
					rowIndex := rowIndex + 1;
					cstate <= enable_memory_module;
				end if;


			when idle =>
				cstate <= display_is_initialize;
				initialize_run <= '1';
				initialize_color <= SCREEN_BLACK;
--				all_pixels <= '0';
			when display_is_initialize =>
				if (initialize_initialized = '1') then
					cstate <= reset_counters;
				else
					cstate <= display_is_initialize;
				end if;
			when reset_counters =>
				initialize_run <= '0';
				cstate <= enable_memory_module_read_fh;
				vppX := 0;
				vppYp := 0;
--				all_pixels <= '0';
				startAddress := 0;
				rowIndex := 0;
				i := 0;
			
			
			
			
			when enable_memory_module_read_fh =>
				cstate <= enable_read_memory_fh;
				mm_i_enable <= '1';
				k := 0;
			when enable_read_memory_fh =>
				cstate <= read_fh;
				mm_i_read <= '1';
			when read_fh =>
				cstate <= store_fh;
				report "rowIndex= " & integer'image(rowIndex);
				report "i= " & integer'image(i);
				mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + rowIndex*i_max + i,G_MemoryAddress-1));
			when store_fh =>
				cstate <= disable_read_memory_fh;
--				o_Mem1 := mm_o_MemDB;
			when disable_read_memory_fh =>
				cstate <= disable_memory_module_read_fh;
				mm_i_read <= '0';
			when disable_memory_module_read_fh =>
				cstate <= memory_busy;
				mm_i_enable <= '0';
			when memory_busy =>
				if (mm_o_busy = '1') then
					cstate <= memory_busy;
				else
					cstate <= set_color;
				end if;

			when set_color =>
				cstate <= draw_box_state0;
--				report "k= " & integer'image(k);
				if (io_MemDB(k) = '1') then
						drawbox_color <= x"FFFF";
					else
						drawbox_color <= x"0000";
					end if;			
			when draw_box_state0 =>
				cstate <= draw_box_state1;
				drawbox_run <= '1';
--				k := 0;
			when draw_box_state1 =>
				cstate <= draw_box_state2;
--				drawbox_raxs <= std_logic_vector(to_unsigned(rowIndex,BYTE_SIZE));
				drawbox_raxs <= x"00";
			when draw_box_state2 =>
				cstate <= draw_box_state3;
				drawbox_raxe <= std_logic_vector(to_unsigned(rowIndex,BYTE_SIZE));
			when draw_box_state3 =>
				cstate <= draw_box_state4;
--				drawbox_rays <= std_logic_vector(to_unsigned(i*G_MemoryAddress+k,BYTE_SIZE));
				drawbox_rays <= x"00";
			when draw_box_state4 =>
				cstate <= draw_box_state5;
				drawbox_raye <= std_logic_vector(to_unsigned(i*(i_max-1)+k,BYTE_SIZE));
			when draw_box_state5 =>
				cstate <= draw_box_state6;
--				drawbox_caxs <= std_logic_vector(to_unsigned(rowIndex,BYTE_SIZE));
				drawbox_caxs <= x"00";
			when draw_box_state6 =>
				cstate <= draw_box_state7;
				drawbox_caxe <= std_logic_vector(to_unsigned(rowIndex,BYTE_SIZE));
			when draw_box_state7 =>
				cstate <= draw_box_state8;
--				drawbox_cays <= std_logic_vector(to_unsigned(i*G_MemoryAddress+k,BYTE_SIZE));
				drawbox_cays <= x"00";
			when draw_box_state8 =>
				cstate <= draw_box_state9;
				drawbox_caye <= std_logic_vector(to_unsigned(i*(i_max-1)+k,BYTE_SIZE));
			when draw_box_state9 =>
				if (drawbox_initialized = '1') then
					cstate <= incrementk;
					drawbox_run <= '0';
				else
					cstate <= draw_box_state9;
				end if;
				
			when incrementk =>
				if (k = G_MemoryData-1) then
					cstate <= check_i;
					k := 0;
				else
					cstate <= set_color;
					k := k + 1;
				end if;
			when check_i =>
				if (i = i_max-1) then
					cstate <= check_rowindex;
					i := 0;
				else
					cstate <= enable_memory_module_read_fh;
					i := i + 1;
				end if;
			when check_rowindex =>
				if (rowIndex = ROWS-1) then
					cstate <= stop;
					rowIndex := 0;
				else
					cstate <= enable_memory_module_read_fh;
					rowIndex := rowIndex + 1;
				end if;
			when others => null;	
				
				
				
			-- draw1
--			
--			
--			when wait_two_reads =>
--				cstate <= enable_memory_module_read_sh;
----				if (waiting = 0) then
----					cstate <= enable_memory_module_read_sh;
----				else
----					cstate <= wait_two_reads;
----				end if;
--			when enable_memory_module_read_sh =>
--				cstate <= enable_read_memory_sh;
--				mm_i_enable <= '1';
--			when enable_read_memory_sh =>
--				cstate <= read_sh;
--				mm_i_read <= '1';
--			when read_sh =>
--				cstate <= store_sh;
--				mm_i_MemAdr <= std_logic_vector(to_unsigned(startAddress + 1,G_MemoryAddress));
--			when store_sh =>
--				cstate <= disable_read_memory_sh;
--				o_Mem2 := o_MemDB;
--			when disable_read_memory_sh =>
--				cstate <= disable_memory_module_read_sh;
--				mm_i_read <= '0';
--			when disable_memory_module_read_sh =>
--				cstate <= send_fh1;
--				mm_i_enable <= '0';
--			when send_fh1 =>
--				cstate <= send_fh1_waitdisplay;
----				if (o_Mem1 /= "ZZZZZZZZZZZZZZZZ") then
----					row <= std_logic_vector(to_unsigned(rowIndex,ROWS_BITS));
----					col_block <= std_logic_vector(to_unsigned(0,COLS_BLOCK_BITS));
----					display_byte <= o_Mem1(15 downto 8);
----				end if;
--			when send_fh1_waitdisplay =>
--				cstate <= send_fh2;
----				if (o_disbusy = '1') then
----					cstate <= send_fh1_waitdisplay;
----				else
----					cstate <= send_fh2;
----				end if;
--			when send_fh2 =>
--				cstate <= send_fh2_waitdisplay;
----				if (o_Mem1 /= "ZZZZZZZZZZZZZZZZ") then
----					row <= std_logic_vector(to_unsigned(rowIndex,ROWS_BITS));
----					col_block <= std_logic_vector(to_unsigned(1,COLS_BLOCK_BITS));
----					display_byte <= o_Mem1(7 downto 0);
----				end if;
--			when send_fh2_waitdisplay =>
--				cstate <= send_sh1;
----				if (o_disbusy = '1') then
----					cstate <= send_fh2_waitdisplay;
----				else
----					cstate <= send_sh1;
----				end if;
--			when send_sh1 =>
--				cstate <= send_sh1_waitdisplay;
----				if (o_Mem2 /= "ZZZZZZZZZZZZZZZZ") then
----					row <= std_logic_vector(to_unsigned(rowIndex,ROWS_BITS));
----					col_block <= std_logic_vector(to_unsigned(2,COLS_BLOCK_BITS));
----					display_byte <= o_Mem2(15 downto 8);
----				end if;
--			when send_sh1_waitdisplay =>
--				cstate <= send_sh2;
----				if (o_disbusy = '1') then
----					cstate <= send_sh1_waitdisplay;
----				else
----					cstate <= send_sh2;
----				end if;
--			when send_sh2 =>
--				cstate <= send_sh2_waitdisplay;
----				if (o_Mem2 /= "ZZZZZZZZZZZZZZZZ") then
----					row <= std_logic_vector(to_unsigned(rowIndex,ROWS_BITS));
----					col_block <= std_logic_vector(to_unsigned(3,COLS_BLOCK_BITS));
----					display_byte <= o_Mem2(7 downto 0);
----				end if;
--			when send_sh2_waitdisplay =>
--				cstate <= check_ranges_read;
----				if (o_disbusy = '1') then
----					cstate <= send_sh2_waitdisplay;
----				else
----					cstate <= check_ranges_read;
----				end if;
--			when draw_box_state0 =>
--				cstate <= draw_box_state1;
--				initialize_run <= '0';
--				drawbox_run <= '1';
--				if (o_Mem1(i) = '1') then
--					drawbox_color <= x"FFFF";
--				else
--					drawbox_color <= x"0000";
--				end if;
--			
--			when check_ranges_read =>
--				if (copyWordsIndex > 0) then
--					startAddress := startAddress + 2;
--					copyWordsIndex := copyWordsIndex - 1;
--					if (rowIndex > 0) then
--						rowIndex := rowIndex - 1;
--					end if;
--					cstate <= enable_memory_module_read_fh;
--				else
--					cstate <= memory_enable_byte;
--				end if;
--				
--				
--				
--				
--				
--				
--				
--				
--				
--			-- draw2
--			when draw_box_state0 =>
--				cstate <= draw_box_state1;
--				initialize_run <= '0';
--				drawbox_run <= '1';
--				if (o_bit = '1') then
--					drawbox_color <= x"FFFF";
--				else
--					drawbox_color <= x"0000";
--				end if;
--			when draw_box_state1 =>
--				cstate <= draw_box_state2;
--				drawbox_raxs <= std_logic_vector(to_unsigned(vppX,BYTE_SIZE));
--			when draw_box_state2 =>
--				cstate <= draw_box_state3;
--				drawbox_raxe <= std_logic_vector(to_unsigned(vppX,BYTE_SIZE));
--			when draw_box_state3 =>
--				cstate <= draw_box_state4;
--				drawbox_rays <= std_logic_vector(to_unsigned(vppYp,BYTE_SIZE));
--			when draw_box_state4 =>
--				cstate <= draw_box_state5;
--				drawbox_raye <= std_logic_vector(to_unsigned(vppYp,BYTE_SIZE));
--			when draw_box_state5 =>
--				cstate <= draw_box_state6;
--				drawbox_caxs <= std_logic_vector(to_unsigned(vppX,BYTE_SIZE));
--			when draw_box_state6 =>
--				cstate <= draw_box_state7;
--				drawbox_caxe <= std_logic_vector(to_unsigned(vppX,BYTE_SIZE));
--			when draw_box_state7 =>
--				cstate <= draw_box_state8;
--				drawbox_cays <= std_logic_vector(to_unsigned(vppYp,BYTE_SIZE));
--			when draw_box_state8 =>
--				cstate <= draw_box_state9;
--				drawbox_caye <= std_logic_vector(to_unsigned(vppYp,BYTE_SIZE));
--			when draw_box_state9 =>
--				if (drawbox_initialized = '1') then
--					cstate <= memory_enable_byte;
--					drawbox_run <= '0';
--				else
--					cstate <= draw_box_state9;
--				end if;
--			when memory_enable_byte =>
--				cstate <= waitone;
--				i_mem_e_bit <= '1';
--				waiting := W-1;
--			when waitone =>
--				if (waiting = 0) then
--					cstate <= update_row;
--				else
--					waiting := waiting - 1;
--				end if;
--				row <= ppX;
--				col_pixel <= ppYp;
--			when update_row =>
--				if (vppX = ROWS-1) then
--					cstate <= update_col;
--				else
--					vppX := vppX + 1;
--					cstate <= draw_box_state0;
--					waiting := W-1;
--				end if;
--			when update_col =>
--				if (vppYp = COLS_PIXEL-1) then
--					cstate <= set_cd_calculate;
--					vppYp := 0;
--				else
--					vppYp := vppYp + 1;
--					cstate <= draw_box_state0;
--					waiting := W-1;
--					vppX := 0;
--				end if;
--			when set_cd_calculate =>
--				cstate <= memory_disable_byte;
--				CD <= CD_CALCULATE;
--			when memory_disable_byte =>
--				cstate <= reset_counters_1;
--				i_mem_e_bit <= '0';
--				
--				
--				
--				
--				
--				
--				
--				
--				
--				
--				
--			-- calculate cells
--			when reset_counters_1 =>
--				cstate <= check_coordinations;
--				all_pixels <= '1';
--				vppX := 0;
--				vppYb := 0;
--				vppYp := 0;
--			when check_coordinations =>
--				cstate <= memory_enable_bit;
--				vppXm1 := vppX-1;
--				if (vppXm1 < 0) then
--					vppXm1 := 0;
--				end if;
--				vppXp1 := vppX+1;
--				if (vppXp1 > ROWS-1) then
--					vppXp1 := ROWS-1;
--				end if;
--				vppYm1 := vppYp-1;
--				if (vppYm1 < 0) then
--					vppYm1 := 0;
--				end if;
--				vppYp1 := vppYp+1;
--				if (vppYp1 > COLS_PIXEL-1) then
--					vppYp1 := COLS_PIXEL-1;
--				end if;
--			when memory_enable_bit =>
--				cstate <= reset_count_alive;
--				i_mem_e_bit <= '1';
--			when reset_count_alive =>
--				cstate <= set_c1;
--				vcountAlive := 0;
--				countAlive <= (others => '0');
--			when set_c1 =>
--				cstate <= c1;
--				row <= ppX;
--				col_pixel <= ppYm1;
--			when c1 =>
--				cstate <= set_c2;
--				if (vppYp /= 0) then
--					if (o_bit = '1') then
--						vcountAlive := vcountAlive + 1;
--					end if;
----					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
--				end if;
--			when set_c2 =>
--				cstate <= c2;
--				row <= ppX;
--				col_pixel <= ppYp1;
--			when c2 =>
--				cstate <= set_c3;
--				if (vppYp /= COLS_PIXEL-1) then	
--					if (o_bit = '1') then
--						vcountAlive := vcountAlive + 1;
--					end if;
----					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
--				end if;
--			when set_c3 =>
--				cstate <= c3;
--				row <= ppXp1;
--				col_pixel <= ppYp;	
--			when c3 =>
--				cstate <= set_c4;
--				if (vppX /= ROWS-1) then
--					if (o_bit = '1') then
--						vcountAlive := vcountAlive + 1;
--					end if;
----					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
--				end if;
--			when set_c4 =>
--				cstate <= c4;
--				row <= ppXm1;
--				col_pixel <= ppYp;	
--			when c4 =>
--				cstate <= set_c5;
--				if (vppX /= 0) then
--					if (o_bit = '1') then
--						vcountAlive := vcountAlive + 1;
--					end if;
----					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
--				end if;
--			when set_c5 =>
--				cstate <= c5;
--				row <= ppXm1;
--				col_pixel <= ppYm1;	
--			when c5 =>
--				cstate <= set_c6;
--				if ((vppX /= 0) and (vppYp /= 0)) then
--					if (o_bit = '1') then
--						vcountAlive := vcountAlive + 1;
--					end if;
----					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
--				end if;
--			when set_c6 =>
--				cstate <= c6;
--				row <= ppXp1;
--				col_pixel <= ppYm1;	
--			when c6 =>
--				cstate <= set_c7;
--				if ((vppX /= ROWS-1) and (vppYp /= 0)) then
--					if (o_bit = '1') then
--						vcountAlive := vcountAlive + 1;
--					end if;
----					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
--				end if;
--			when set_c7 =>
--				cstate <= c7;
--				row <= ppXm1;
--				col_pixel <= ppYp1;	
--			when c7 =>
--				cstate <= set_c8;
--				if ((vppX /= 0) and (vppYp /= COLS_PIXEL-1)) then
--					if (o_bit = '1') then
--						vcountAlive := vcountAlive + 1;
--					end if;
----					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
--				end if;
--			when set_c8 =>
--				cstate <= c8;
--				row <= ppXp1;
--				col_pixel <= ppYp1;	
--			when c8 =>
--				cstate <= waitfor;
--				if ((vppX /= ROWS-1) and (vppYp /= COLS_PIXEL-1)) then
--					if (o_bit = '1') then
--						vcountAlive := vcountAlive + 1;
--					end if;
----					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
--				end if;
--			when waitfor =>
--				cstate <= memory_disable_bit;
--				countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
--				assert (vcountALive = 0)
--				report "AROUND (X,Y) = (" & integer'image(vppX) & "," & integer'image(vppYp) & ") countalive = " & integer'image(vcountALive)
--				severity warning;
--			when memory_disable_bit =>
--				cstate <= store_count_alive;
----			i_mem_e_bit <= '0';
--				mm_i_enable <= '1';
--				mm_i_write <= '1';
--			when store_count_alive =>
--				cstate <= update_row1;
--				mm_i_MemAdr <= std_logic_vector(to_unsigned(vppX+vppYp*COLS_PIXEL,G_MemoryAddress));
--				mm_i_MemDB <= std_logic_vector(to_unsigned(vcountALive,G_MemoryData));
----			ENABLE <= '1';
----			WRITE_EN <= '1';
----			ADDRESS <= std_logic_vector(to_unsigned(vppX+vppYp*COLS_PIXEL,12));
----			DATA_IN <= countAlive;
--			when update_row1 =>
--				mm_i_enable <= '0';
--				mm_i_write <= '0';
----			ENABLE <= '1';
----			WRITE_EN <= '1';
--				if (vppX = ROWS-1) then
--					cstate <= update_col1;
--				else
--					vppX := vppX + 1;
--					cstate <= check_coordinations;
--				end if;
--			when update_col1 =>
--				if (vppYp = COLS_PIXEL-1) then
--					cstate <= reset_counters1;
--					vppYp := 0;
--				else
--					vppYp := vppYp + 1;
--					cstate <= check_coordinations;
--					vppX := 0;
--				end if;
--			-- store bits in memory
--			when reset_counters1 =>
--				cstate <= memory_enable_bit1;
--				vppX := 0;
--				vppYb := 0;
--				vppYp := 0;
--				mm_i_enable <= '1';
--				mm_i_read <= '1';
--			when memory_enable_bit1 =>
--				cstate <= get_alive;
----				i_mem_e_bit <= '1';
--				mm_i_MemAdr <= std_logic_vector(to_unsigned(vppX+vppYp*COLS_PIXEL,G_MemoryAddress));
--			when get_alive =>
--				cstate <= get_alive1;
----				row <= ppX;
----				col_pixel <= ppYp;
--			when get_alive1 =>
--				cstate <= enable_write_to_memory;
--				if (o_bit = '1') then
--					vCellAlive := true;
--				else
--					vCellAlive := false;
--				end if;
--			when enable_write_to_memory =>
--				cstate <= write_count_alive;
--				i_mem_write_bit <= '1';
--			     ENABLE <= '1';
--			     WRITE_EN <= '0';
--			     ADDRESS <= std_logic_vector(to_unsigned(vppX+vppYp*COLS_PIXEL,12));
--			when write_count_alive =>
--				cstate <= disable_write_to_memory;
--				if (vCellAlive = true) then
--					if ((to_integer(unsigned(DATA_OUT)) = 2) or (to_integer(unsigned(DATA_OUT)) = 3)) then
--						i_bit <= '1';
--					else
--						i_bit <= '0';
--					end if;
--				elsif (vCellAlive = false) then
--					if (to_integer(unsigned(DATA_OUT)) = 3) then
--						i_bit <= '1';
--					else
--						i_bit <= '0';
--					end if;
--				end if;
--			when disable_write_to_memory =>
--			     ENABLE <= '0';
--			     WRITE_EN <= '0';
--				cstate <= update_row2;
--				i_mem_write_bit <= '0';
--				i_bit <= '0';
--			when update_row2 =>
--				if (vppX = ROWS-1) then
--					cstate <= update_col2;					
--				else
--					vppX := vppX + 1;
--					cstate <= get_alive;
--				end if;
--			when update_col2 =>
--				if (vppYp = COLS_PIXEL-1) then
--					cstate <= disable_memory;
--					vppYp := 0;
--					vppYb := 0;
--				else
--					vppYp := vppYp + 1;
--					cstate <= get_alive;
--					vppX := 0;
--				end if;
--			when disable_memory =>
--				cstate <= stop;
--				i_mem_e_bit <= '0';
--				i_bit <= '0';
--			-- end
--			when stop =>
--				cstate <= reset_counters;
--			when others => null;
		end case;		
	end if;
	CellAlive <= To_Std_Logic(vCellAlive);
--	ppX <= std_logic_vector(to_unsigned(vppX,ROWS_BITS));
--	ppYp <= std_logic_vector(to_unsigned(vppYp,COLS_PIXEL_BITS));
--	ppYb <= std_logic_vector(to_unsigned(vppYb,COLS_BLOCK_BITS));
--	ppXm1 <= std_logic_vector(to_unsigned(vppXm1,ROWS_BITS));
--	ppXp1 <= std_logic_vector(to_unsigned(vppXp1,ROWS_BITS));
--	ppYm1 <= std_logic_vector(to_unsigned(vppYm1,COLS_PIXEL_BITS));
--	ppYp1 <= std_logic_vector(to_unsigned(vppYp1,COLS_PIXEL_BITS));
end process gof_logic;

end architecture Behavioral;
