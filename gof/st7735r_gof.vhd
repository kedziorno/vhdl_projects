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
INPUT_CLOCK : integer := 50_000_000; --29_952_000;
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
Led6 : out std_logic;
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

type state is (
set_cd_memorycopy,enable_memory_module,enable_write_fh,copy_first_halfword,disable_write_fh,disable_memory_module,memory_wait_fh,
check_ranges_write1,check_ranges_write2,idle,display_is_initialize,reset_counters,enable_memory_module_read_fh,
enable_read_memory_fh,read_fh,store_fh,disable_read_memory_fh,disable_memory_module_read_fh,memory_busy,set_color,
draw_box_state0,draw_box_state1,draw_box_state2,draw_box_state3,draw_box_state4,draw_box_state5,draw_box_state6,draw_box_state7,draw_box_state8,draw_box_state9,
incrementk,check_i,check_rowindex,reset_counters_1,
check_coordinations,reset_count_alive,
c1_m_e,c1_m_r_e,c1_s_a,c1_m_r_d,c1_m_d,c1,
c2_m_e,c2_m_r_e,c2_s_a,c2_m_r_d,c2_m_d,c2,
c3_m_e,c3_m_r_e,c3_s_a,c3_m_r_d,c3_m_d,c3,
c4_m_e,c4_m_r_e,c4_s_a,c4_m_r_d,c4_m_d,c4,
c5_m_e,c5_m_r_e,c5_s_a,c5_m_r_d,c5_m_d,c5,
c6_m_e,c6_m_r_e,c6_s_a,c6_m_r_d,c6_m_d,c6,
c7_m_e,c7_m_r_e,c7_s_a,c7_m_r_d,c7_m_d,c7,
c8_m_e,c8_m_r_e,c8_s_a,c8_m_r_d,c8_m_d,c8,
waitfor,memory_disable_bit,
store_count_alive1,store_count_alive2,store_count_alive3,store_count_alive4,store_count_alive5,update_row1,update_col1,reset_counters1,
get_alive1,get_alive2,get_alive3,get_alive4,get_alive5,get_alive6,get_alive7,
enable_write_to_memory1,enable_write_to_memory2,enable_write_to_memory3,enable_write_to_memory4,enable_write_to_memory5,enable_write_to_memory6,enable_write_to_memory7,
write_count_alive1,write_count_alive2,write_count_alive3,write_count_alive4,write_count_alive5,write_count_alive6,write_count_alive7,
cellalive_check_i,update_row2,update_col2,
stop);
signal cstate : state;

signal ppX : std_logic_vector(ROWS_BITS-1 downto 0);
signal ppYp : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
signal ppXm1 : std_logic_vector(ROWS_BITS-1 downto 0);
signal ppXp1 : std_logic_vector(ROWS_BITS-1 downto 0);
signal ppYm1 : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
signal ppYp1 : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
signal countAlive : std_logic_vector(3 downto 0);
signal CellAlive : std_logic;
signal i_reset : std_logic;
signal CLK_BUFG : std_logic;

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
signal mm_i_MemAdr : MemoryAddress;
signal mm_i_MemDB,mm_o_MemDB : MemoryDataByte;
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

-- for debug 0-15 bits
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
	variable vppX : integer range 0 to ROWS - 1;
	variable vppYp : integer range 0 to COLS_PIXEL - 1;
	variable vppXm1 : integer range 0 to ROWS - 1;
	variable vppXp1 : integer range 0 to ROWS - 1;
	variable vppYm1 : integer range 0 to COLS_PIXEL - 1;
	variable vppYp1 : integer range 0 to COLS_PIXEL - 1;
	variable vcountAlive : integer range 0 to 7;
	variable vCellAlive,vCellAlive2 : boolean;
	constant ALL_PIXELS : integer range 0 to (ROWS * COLS_PIXEL) - 1 := (ROWS * COLS_PIXEL) - 1;
	variable startAddress : integer range 0 to ALL_PIXELS;
	variable storeAddress : integer range ALL_PIXELS to ALL_PIXELS * 2;
	variable rowIndex : integer range 0 to ROWS - 1;
	variable o_Mem1 : MemoryDataByte;
	variable o_Mem2 : MemoryDataByte;
	variable COL : WORD;
	variable COL_UP : integer range 0 to COLS_PIXEL - 1;
	variable COL_DOWN : integer range 0 to COLS_PIXEL - 1;
	variable COL_DIFF : integer range 0 to COLS_PIXEL - 1;
	constant i_max : integer := (COLS_PIXEL/G_MemoryData);
	variable i : integer range 0 to i_max - 1; -- blocks in WORD slv
	variable k : integer range 0 to G_MemoryData - 1; -- read bits in set_color and xy coords
	variable drawbox_ikindex : integer range 0 to 255;
begin
	if (i_reset = '1') then
		vppX := 0;
		vppYp := 0;
		vppXm1 := 0;
		vppXp1 := 0;
		vppYm1 := 0;
		vppYp1 := 0;
		i := 0;
		k := 0;
		cstate <= set_cd_memorycopy;
		initialize_run <= '0';
		COL := (others => '0');
		COL_UP := 0;
		COL_DOWN := 0;
		COL_DIFF := 0;
		vCellAlive := false;
		vCellAlive2 := false;
		vcountAlive := 0;
		startAddress := 0;
		storeAddress := ALL_PIXELS;
		rowIndex := 0;
		o_Mem1 := (others => '0');
		o_Mem2 := (others => '0');
		COL := (others => '0');
		COL_UP := 0;
		COL_DOWN := 0;
		i := 0;
		k := 0;
		drawbox_ikindex := 0;
	elsif (rising_edge(CLK_BUFG)) then
		case cstate is
			-- copy memory content
			when set_cd_memorycopy =>
				cstate <= enable_memory_module;
				i := 0;
			when enable_memory_module =>
				cstate <= enable_write_fh;
				mm_i_enable <= '1';
			when enable_write_fh =>
				cstate <= copy_first_halfword;
				mm_i_write <= '1';
				COL := memory_content(rowIndex);
			when copy_first_halfword =>
				cstate <= disable_write_fh;
				COL_UP := i*G_MemoryData+(G_MemoryData-1);
				COL_DOWN := i*G_MemoryData+0;
				COL_DIFF := COL_UP - COL_DOWN;
--				report "COL_UP,COL_DOWN = " & integer'image(COL_UP) & "," & integer'image(COL_DOWN) & " -> " & integer'image(COL_DIFF);
				assert (G_MemoryData - 1 = COL_DIFF) report "diff ranges";
				mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + rowIndex*i_max + i,G_MemoryAddress-1));
				mm_i_MemDB(G_MemoryData-1 downto 0) <= COL(COL_UP downto COL_DOWN);
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
				mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + rowIndex*i_max + i,G_MemoryAddress-1));
			when store_fh =>
				cstate <= disable_read_memory_fh;
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
				if (io_MemDB(k) = '1') then
						drawbox_color <= x"FFFF";
					else
						drawbox_color <= x"0000";
					end if;			
			when draw_box_state0 =>
				cstate <= draw_box_state1;
				drawbox_run <= '1';
				drawbox_ikindex := i*(G_MemoryData-1)+k;
--				report "ikindex = " & integer'image(drawbox_ikindex);
			when draw_box_state1 =>
				cstate <= draw_box_state2;
				drawbox_raxs <= x"00";
			when draw_box_state2 =>
				cstate <= draw_box_state3;
				drawbox_raxe <= std_logic_vector(to_unsigned(rowIndex,BYTE_SIZE));
			when draw_box_state3 =>
				cstate <= draw_box_state4;
				drawbox_rays <= x"00";
			when draw_box_state4 =>
				cstate <= draw_box_state5;
				drawbox_raye <= std_logic_vector(to_unsigned(drawbox_ikindex,BYTE_SIZE));
			when draw_box_state5 =>
				cstate <= draw_box_state6;
				drawbox_caxs <= x"00";
			when draw_box_state6 =>
				cstate <= draw_box_state7;
				drawbox_caxe <= std_logic_vector(to_unsigned(rowIndex,BYTE_SIZE));
			when draw_box_state7 =>
				cstate <= draw_box_state8;
				drawbox_cays <= x"00";
			when draw_box_state8 =>
				cstate <= draw_box_state9;
				drawbox_caye <= std_logic_vector(to_unsigned(drawbox_ikindex,BYTE_SIZE));
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
					cstate <= reset_counters_1;
					rowIndex := 0;
				else
					cstate <= enable_memory_module_read_fh;
					rowIndex := rowIndex + 1;
				end if;
			-- calculate cells
			when reset_counters_1 =>
				cstate <= check_coordinations;
				vppX := 0;
				vppYp := 0;
				i := 0;
				Led6 <= '1';
				Led7 <= '0';
			when check_coordinations =>
				cstate <= reset_count_alive;
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
			when reset_count_alive =>
				cstate <= c1_m_e;
				vcountAlive := 0;
				countAlive <= (others => '0');
			-- XXX ppX,ppYm1
			when c1_m_e =>
				cstate <= c1_m_r_e;
				mm_i_enable <= '1';
			when c1_m_r_e =>
				cstate <= c1_s_a;
				mm_i_read <= '1';
			when c1_s_a =>
				cstate <= c1_m_r_d;
				if (vppYp > G_MemoryData - 1) then
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + (i+1),G_MemoryAddress-1));
				else
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
			when c1_m_r_d =>
				cstate <= c1_m_d;
				mm_i_read <= '0';
			when c1_m_d =>
				cstate <= c1;
				mm_i_enable <= '0';
			when c1 =>
				cstate <= c2_m_e;
					if (vppYm1 > G_MemoryData) then
						if (io_MemDB(vppYm1 - G_MemoryData) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					elsif (vppYm1 = G_MemoryData) then
						if (io_MemDB(G_MemoryData - 1) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					else
						if (io_MemDB(vppYm1) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;				
					end if;
			-- XXX ppX,ppYp1
			when c2_m_e =>
				cstate <= c2_m_r_e;
				mm_i_enable <= '1';
			when c2_m_r_e =>
				cstate <= c2_s_a;
				mm_i_read <= '1';
			when c2_s_a =>
				cstate <= c2_m_r_d;
				if (vppYp > G_MemoryData - 1) then
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + (i+1),G_MemoryAddress-1));
				else
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
			when c2_m_r_d =>
				cstate <= c2_m_d;
				mm_i_read <= '0';
			when c2_m_d =>
				cstate <= c2;
				mm_i_enable <= '0';
			when c2 =>
				cstate <= c3_m_e;
					if (vppYp1 > G_MemoryData) then
						if (io_MemDB(vppYp1 - G_MemoryData) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					elsif (vppYp1 = G_MemoryData) then
						if (io_MemDB(G_MemoryData - 1) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					else
						if (io_MemDB(vppYp1) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					end if;
			-- XXX ppXp1,ppYp
			when c3_m_e =>
				cstate <= c3_m_r_e;
				mm_i_enable <= '1';
			when c3_m_r_e =>
				cstate <= c3_s_a;
				mm_i_read <= '1';
			when c3_s_a =>
				cstate <= c3_m_r_d;
				if (vppYp > G_MemoryData - 1) then
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + (i+1),G_MemoryAddress-1));
				else
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
			when c3_m_r_d =>
				cstate <= c3_m_d;
				mm_i_read <= '0';
			when c3_m_d =>
				cstate <= c3;
				mm_i_enable <= '0';
			when c3 =>
				cstate <= c4_m_e;
					if (vppYp > G_MemoryData) then
						if (io_MemDB(vppYp - G_MemoryData) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					elsif (vppYp = G_MemoryData) then
						if (io_MemDB(G_MemoryData - 1) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					else
						if (io_MemDB(vppYp) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;				
					end if;
			-- XXX ppXm1,ppYp
			when c4_m_e =>
				cstate <= c4_m_r_e;
				mm_i_enable <= '1';
			when c4_m_r_e =>
				cstate <= c4_s_a;
				mm_i_read <= '1';
			when c4_s_a =>
				cstate <= c4_m_r_d;
				if (vppYp > G_MemoryData - 1) then
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + (i+1),G_MemoryAddress-1));
				else
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
			when c4_m_r_d =>
				cstate <= c4_m_d;
				mm_i_read <= '0';
			when c4_m_d =>
				cstate <= c4;
				mm_i_enable <= '0';
			when c4 =>
				cstate <= c5_m_e;
					if (vppYp > G_MemoryData) then
						if (io_MemDB(vppYp - G_MemoryData) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					elsif(vppYp = G_MemoryData) then
						if (io_MemDB(G_MemoryData - 1) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					else
						if (io_MemDB(vppYp) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					end if;
			-- XXX ppXm1,ppYm1
			when c5_m_e =>
				cstate <= c5_m_r_e;
				mm_i_enable <= '1';
			when c5_m_r_e =>
				cstate <= c5_s_a;
				mm_i_read <= '1';
			when c5_s_a =>
				cstate <= c5_m_r_d;
				if (vppYp > G_MemoryData - 1) then
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + (i+1),G_MemoryAddress-1));
				else
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
			when c5_m_r_d =>
				cstate <= c5_m_d;
				mm_i_read <= '0';
			when c5_m_d =>
				cstate <= c5;
				mm_i_enable <= '0';
			when c5 =>
				cstate <= c6_m_e;
					if (vppYm1 > G_MemoryData) then
						if (io_MemDB(vppYm1 - G_MemoryData) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					elsif (vppYm1 = G_MemoryData) then
						if (io_MemDB(G_MemoryData - 1) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					else
						if (io_MemDB(vppYm1) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;				
					end if;
			-- XXX ppXp1,ppYm1
			when c6_m_e =>
				cstate <= c6_m_r_e;
				mm_i_enable <= '1';
			when c6_m_r_e =>
				cstate <= c6_s_a;
				mm_i_read <= '1';
			when c6_s_a =>
				cstate <= c6_m_r_d;
				if (vppYp > G_MemoryData - 1) then
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + (i+1),G_MemoryAddress-1));
				else
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
			when c6_m_r_d =>
				cstate <= c6_m_d;
				mm_i_read <= '0';
			when c6_m_d =>
				cstate <= c6;
				mm_i_enable <= '0';
			when c6 =>
				cstate <= c7_m_e;
					if (vppYm1 > G_MemoryData) then
						if (io_MemDB(vppYm1 - G_MemoryData) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					elsif (vppYm1 = G_MemoryData) then
						if (io_MemDB(G_MemoryData - 1) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					else
						if (io_MemDB(vppYm1) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;				
					end if;
			-- XXX ppXm1,ppYp1
			when c7_m_e =>
				cstate <= c7_m_r_e;
				mm_i_enable <= '1';
			when c7_m_r_e =>
				cstate <= c7_s_a;
				mm_i_read <= '1';
			when c7_s_a =>
				cstate <= c7_m_r_d;
				if (vppYp > G_MemoryData - 1) then
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + (i+1),G_MemoryAddress-1));
				else
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
			when c7_m_r_d =>
				cstate <= c7_m_d;
				mm_i_read <= '0';
			when c7_m_d =>
				cstate <= c7;
				mm_i_enable <= '0';
			when c7 =>
				cstate <= c8_m_e;
					if (vppYp1 > G_MemoryData) then
						if (io_MemDB(vppYp1 - G_MemoryData) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					elsif (vppYp1 = G_MemoryData) then
						if (io_MemDB(G_MemoryData - 1) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					else
						if (io_MemDB(vppYp1) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					end if;
			-- XXX ppXp1,ppYp1
			when c8_m_e =>
				cstate <= c8_m_r_e;
				mm_i_enable <= '1';
			when c8_m_r_e =>
				cstate <= c8_s_a;
				mm_i_read <= '1';
			when c8_s_a =>
				cstate <= c8_m_r_d;
				if (vppYp > G_MemoryData - 1) then
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + (i+1),G_MemoryAddress-1));
				else
					mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
			when c8_m_r_d =>
				cstate <= c8_m_d;
			when c8_m_d =>
				cstate <= c8;
				mm_i_enable <= '0';
			when c8 =>
				cstate <= waitfor;
					if (vppYp1 > G_MemoryData) then
						if (io_MemDB(vppYp1 - G_memoryData) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					elsif (vppYp1 = G_MemoryData) then
						if (io_MemDB(G_memoryData - 1) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;
					else
						if (io_MemDB(vppYp1) = '1') then
							vcountAlive := vcountAlive + 1;
						end if;				
					end if;
			when waitfor =>
				cstate <= memory_disable_bit;
				countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
--				assert (vcountALive = 0)
--				report "AROUND (X,Y) = (" & integer'image(vppX) & "," & integer'image(vppYp) & ") countalive = " & integer'image(vcountALive)
--				severity warning;
			when memory_disable_bit =>
				cstate <= store_count_alive1;
				mm_i_enable <= '1';
			when store_count_alive1 =>
				cstate <= store_count_alive2;
				mm_i_write <= '1';
			when store_count_alive2 =>
				cstate <= store_count_alive3;
				mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(storeAddress + vppX*i_max + i,G_MemoryAddress-1));
				mm_i_MemDB <= std_logic_vector(to_unsigned(vcountALive,G_MemoryData));
			when store_count_alive3 =>
				cstate <= store_count_alive4;
				mm_i_write <= '0';
			when store_count_alive4 =>
				cstate <= store_count_alive5;
				mm_i_enable <= '0';
			when store_count_alive5 =>
				if (mm_o_busy = '1') then
					cstate <= store_count_alive5;
				else
					cstate <= update_row1;
				end if;
			when update_row1 =>
				if (vppX = ROWS-1) then
					cstate <= update_col1;
				else
					vppX := vppX + 1;
					cstate <= check_coordinations;
				end if;
			when update_col1 =>
				if (vppYp = COLS_PIXEL-1) then
					cstate <= reset_counters1;
					vppYp := 0;
				else
					vppYp := vppYp + 1;
					cstate <= check_coordinations;
					vppX := 0;
				end if;
			-- store bits in memory
			when reset_counters1 =>
				cstate <= get_alive1;
				vppX := 0;
				vppYp := 0;
				Led6 <= '0';
				Led7 <= '1';
			when get_alive1 =>
				cstate <= get_alive2;
				mm_i_enable <= '1';
			when get_alive2 =>
				cstate <= get_alive3;
				mm_i_read <= '1';
			when get_alive3 =>
				cstate <= get_alive4;
				mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
			when get_alive4 =>
				cstate <= get_alive5;
				mm_i_read <= '0';
			when get_alive5 =>
				cstate <= get_alive6;
				mm_i_enable <= '0';
			when get_alive6 =>
				cstate <= get_alive7;
				if (mm_o_busy = '1') then
					cstate <= get_alive6;
				else
					cstate <= get_alive7;
				end if;
			when get_alive7 =>
				cstate <= enable_write_to_memory1;
				if (vppYp > G_MemoryData) then
					if (io_MemDB(vppYp - G_MemoryData) = '1') then
						vCellAlive := true;
					else
						vCellAlive := false;
					end if;
				elsif (vppYp = G_MemoryData) then
					if (io_MemDB(G_MemoryData - 1) = '1') then
						vCellAlive := true;
					else
						vCellAlive := false;
					end if;
				else
					if (io_MemDB(vppYp) = '1') then
						vCellAlive := true;
					else
						vCellAlive := false;
					end if;
				end if;
			when enable_write_to_memory1 =>
				cstate <= enable_write_to_memory2;
				mm_i_enable <= '1';
			when enable_write_to_memory2 =>
				cstate <= enable_write_to_memory3;
				mm_i_read <= '1';
			when enable_write_to_memory3 =>
				cstate <= enable_write_to_memory4;
				mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(storeAddress + vppX*i_max + i,G_MemoryAddress-1));
			when enable_write_to_memory4 =>
				cstate <= enable_write_to_memory5;
				mm_i_read <= '0';
			when enable_write_to_memory5 =>
				cstate <= enable_write_to_memory6;
				mm_i_enable <= '0';
			when enable_write_to_memory6 =>
				if (mm_o_busy = '1') then
					cstate <= enable_write_to_memory6;
				else
					cstate <= enable_write_to_memory7;
				end if;
			when enable_write_to_memory7 =>
				cstate <= write_count_alive1;
				if (vCellAlive = true) then
					if ((io_MemDB = x"0002") or (io_MemDB = x"0003")) then
						vCellAlive2 := true;
					else
						vCellAlive2 := false;
					end if;
				elsif (vCellAlive = false) then
					if (io_MemDB = x"0003") then
						vCellAlive2 := true;
					else
						vCellAlive2 := false;
					end if;
				end if;
			when write_count_alive1 =>
				cstate <= write_count_alive2;
				mm_i_enable <= '1';
			when write_count_alive2 =>
				cstate <= write_count_alive3;
				mm_i_write <= '1';
			when write_count_alive3 =>
				cstate <= write_count_alive4;
				mm_i_MemAdr(23 downto 1) <= std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
			when write_count_alive4 =>
				cstate <= write_count_alive5;
				if (vCellAlive2 = true) then
					if (vppYp > G_MemoryData) then
						mm_i_MemDB(vppYp - G_MemoryData) <= '1';
					elsif (vppYp = G_MemoryData) then
						mm_i_MemDB(G_MemoryData - 1) <= '1';
					else
						mm_i_MemDB(vppYp) <= '1';
					end if;
				elsif (vCellAlive2 = false) then
					if (vppYp > G_MemoryData) then
						mm_i_MemDB(vppYp - G_MemoryData) <= '0';
					elsif (vppYp = G_MemoryData) then
						mm_i_MemDB(G_MemoryData - 1) <= '0';
					else
						mm_i_MemDB(vppYp) <= '0';
					end if;
				end if;
			when write_count_alive5 =>
				cstate <= write_count_alive6;
				mm_i_write <= '0';
			when write_count_alive6 =>
				cstate <= write_count_alive7;
				mm_i_enable <= '0';
			when write_count_alive7 =>
				if (mm_o_busy = '1') then
					cstate <= write_count_alive7;
				else
					cstate <= cellalive_check_i;
				end if;
			when cellalive_check_i =>
				if (i = i_max-1) then
					cstate <= update_row2;
					i := 0;
				else
					cstate <= get_alive1;
					i := i + 1;
				end if;
			when update_row2 =>
				if (vppX = ROWS-1) then
					cstate <= update_col2;					
				else
					vppX := vppX + 1;
					cstate <= get_alive1;
				end if;
			when update_col2 =>
				if (vppYp = COLS_PIXEL-1) then
					cstate <= stop;
					vppYp := 0;
				else
					cstate <= get_alive1;
					vppYp := vppYp + 1;
					vppX := 0;
				end if;
			-- end
			when stop =>
				cstate <= reset_counters;
			when others => null;
		end case;		
	end if;
	CellAlive <= To_Std_Logic(vCellAlive);
	ppX <= std_logic_vector(to_unsigned(vppX,ROWS_BITS));
	ppYp <= std_logic_vector(to_unsigned(vppYp,COLS_PIXEL_BITS));
	ppXm1 <= std_logic_vector(to_unsigned(vppXm1,ROWS_BITS));
	ppXp1 <= std_logic_vector(to_unsigned(vppXp1,ROWS_BITS));
	ppYm1 <= std_logic_vector(to_unsigned(vppYm1,COLS_PIXEL_BITS));
	ppYp1 <= std_logic_vector(to_unsigned(vppYp1,COLS_PIXEL_BITS));
end process gof_logic;

end architecture Behavioral;
