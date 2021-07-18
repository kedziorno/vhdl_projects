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
use WORK.NUMERIC_STD.ALL;

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

component memorymodule_bram is
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
end component memorymodule_bram;

type state is (
set_cd_memorycopy,enable_memory_module,enable_write_fh,copy_first_halfword,disable_write_fh,disable_memory_module,memory_wait_fh,
check_ranges_write1,check_ranges_write2,idle,display_is_initialize,reset_counters,enable_memory_module_read_fh,
enable_read_memory_fh,read_fh,store_fh,disable_read_memory_fh,disable_memory_module_read_fh,memory_busy,set_color,
draw_box_state0,draw_box_state1,draw_box_state2,draw_box_state3,draw_box_state4,draw_box_state5,draw_box_state6,draw_box_state7,draw_box_state8,draw_box_state9,
incrementk,check_i,check_rowindex,reset_counters_1,
check_coordinations,reset_count_alive,
c1_m_e,c1_m_r_e,c1_s_a,c1_m_r_d,c1_m_d,c1_busy,c1,
c2_m_e,c2_m_r_e,c2_s_a,c2_m_r_d,c2_m_d,c2_busy,c2,
c3_m_e,c3_m_r_e,c3_s_a,c3_m_r_d,c3_m_d,c3_busy,c3,
c4_m_e,c4_m_r_e,c4_s_a,c4_m_r_d,c4_m_d,c4_busy,c4,
c5_m_e,c5_m_r_e,c5_s_a,c5_m_r_d,c5_m_d,c5_busy,c5,
c6_m_e,c6_m_r_e,c6_s_a,c6_m_r_d,c6_m_d,c6_busy,c6,
c7_m_e,c7_m_r_e,c7_s_a,c7_m_r_d,c7_m_d,c7_busy,c7,
c8_m_e,c8_m_r_e,c8_s_a,c8_m_r_d,c8_m_d,c8_busy,c8,
waitfor,memory_disable_bit,
store_count_alive1,store_count_alive2,store_count_alive3,store_count_alive4,store_count_alive5,update_row1,update_col1,reset_counters1,
get_alive1,get_alive2,get_alive3,get_alive4,get_alive5,get_alive6,get_alive7,
enable_write_to_memory1,enable_write_to_memory2,enable_write_to_memory3,enable_write_to_memory4,enable_write_to_memory5,enable_write_to_memory6,enable_write_to_memory7,
write_count_alive1,write_count_alive2,write_count_alive3,write_count_alive4,write_count_alive5,write_count_alive6,write_count_alive7,
cellalive_check_k,cellalive_check_i,update_row2,update_col2,
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
signal slv_startAddress : std_logic_vector(G_MemoryAddress - 1 downto 0);
signal slv_storeAddress : std_logic_vector(G_MemoryAddress - 1 downto 0);
signal slv_i : std_logic_vector(G_MemoryAddress - 1 downto 0);
signal slv_k : std_logic_vector(G_MemoryAddress - 1 downto 0);
signal slv_address_cc,slv_address_disp,slv_address_c1,slv_address_c2,slv_address_c3,slv_address_c4,slv_address_c5,slv_address_c6,slv_address_c7,slv_address_c8,slv_address_sca,slv_address_ga,slv_address_ewm,slv_address_wca : std_logic_vector(G_MemoryAddress - 1 downto 1);

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

-- for debug memory on LA example - 0-15 bits (2 bytes)
--jc(3 downto 0) <= io_MemDB(3 downto 0) when MemOE = '0' else (others => 'Z'); --1st byte,0-7 bits
--jd(3 downto 0) <= io_MemDB(7 downto 4) when MemOE = '0' else (others => 'Z');
--jc(7 downto 4) <= io_MemDB(11 downto 8) when MemOE = '0' else (others => 'Z'); --2st byte,8-15 bits
--jd(7 downto 4) <= io_MemDB(15 downto 12) when MemOE = '0' else (others => 'Z');

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

--st7735rinit_entity : st7735r_initialize
--generic map (
--C_CLOCK_COUNTER => SPI_SPEED_MODE
--)
--port map (
--i_clock => CLK_BUFG,
--i_reset => i_reset,
--i_run => initialize_run,
--i_color => initialize_color,
--i_sended => initialize_sended,
--o_initialized => initialize_initialized,
--o_cs => initialize_cs,
--o_reset => initialize_reset,
--o_rs => initialize_rs,
--o_enable => initialize_enable,
--o_data_byte => initialize_data_byte
--);
initialize_initialized <= '1'; -- XXX omit initialize in simulation

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

mm1 : memorymodule_bram
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
	variable address_cc,address_disp,address_c1,address_c2,address_c3,address_c4,address_c5,address_c6,address_c7,address_c8,address_sca,address_ga,address_ewm,address_wca : std_logic_vector(G_MemoryAddress - 1 downto 1);
begin
	if (i_reset = '1') then
		cstate <= set_cd_memorycopy;
	elsif (rising_edge(CLK_BUFG)) then
		case cstate is
			-- copy memory content
			when set_cd_memorycopy =>
				cstate <= enable_memory_module;
				vppX := 0;
				vppYp := 0;
				vppXm1 := 0;
				vppXp1 := 0;
				vppYm1 := 0;
				vppYp1 := 0;
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
				address_cc := (others => '0');
				address_disp := (others => '0');
				address_c1 := (others => '0');
				address_c2 := (others => '0');
				address_c3 := (others => '0');
				address_c4 := (others => '0');
				address_c5 := (others => '0');
				address_c6 := (others => '0');
				address_c7 := (others => '0');
				address_c8 := (others => '0');
				address_sca := (others => '0');
				address_ga := (others => '0');
				address_ewm := (others => '0');
				address_wca := (others => '0');
				Led6 <= '1';
				Led7 <= '1';
--				report "i_max = " & integer'image(i_max);
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
--				assert (G_MemoryData - 1 = COL_DIFF) report "diff ranges";
				address_cc := std_logic_vector(to_unsigned(startAddress + rowIndex*i_max + i,G_MemoryAddress-1));
				mm_i_MemAdr(23 downto 1) <= address_cc;
				mm_i_MemDB(G_MemoryData-1 downto 0) <= COL(COL_UP downto COL_DOWN);
				slv_address_cc <= address_cc;
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
				address_disp := std_logic_vector(to_unsigned(startAddress + rowIndex*i_max + i,G_MemoryAddress-1));
				mm_i_MemAdr(23 downto 1) <= address_disp;
				slv_address_disp <= address_disp;
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
--				drawbox_ikindex := i*(G_MemoryData-1)+k;
				drawbox_ikindex := (i*G_MemoryData)+k;
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
--				cstate <= reset_counters_1; -- XXX stay after show memory content
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
					address_c1 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				else
					address_c1 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
				mm_i_MemAdr(23 downto 1) <= address_c1;
				slv_address_c1 <= address_c1;
			when c1_m_r_d =>
				cstate <= c1_m_d;
				mm_i_read <= '0';
			when c1_m_d =>
				cstate <= c1_busy;
				mm_i_enable <= '0';
			when c1_busy =>
				if (mm_o_busy = '1') then
					cstate <= c1_busy;
				else
					cstate <= c1;
				end if;
			when c1 =>
				cstate <= c2_m_e;
				if (vppYm1 > G_MemoryData - 1) then
					if (io_MemDB(vppYm1 - G_MemoryData) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				else
					if (io_MemDB(vppYm1) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;				
				end if;
				countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
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
					address_c2 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				else
					address_c2 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
				mm_i_MemAdr(23 downto 1) <= address_c2;
				slv_address_c2 <= address_c2;
			when c2_m_r_d =>
				cstate <= c2_m_d;
				mm_i_read <= '0';
			when c2_m_d =>
				cstate <= c2_busy;
				mm_i_enable <= '0';
			when c2_busy =>
				if (mm_o_busy = '1') then
					cstate <= c2_busy;
				else
					cstate <= c2;
				end if;
			when c2 =>
				cstate <= c3_m_e;
				if (vppYp1 > G_MemoryData - 1) then
					if (io_MemDB(vppYp1 - G_MemoryData) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				else
					if (io_MemDB(vppYp1) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				end if;
				countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
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
					address_c3 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				else
					address_c3 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
				mm_i_MemAdr(23 downto 1) <= address_c3;
				slv_address_c3 <= address_c3;
			when c3_m_r_d =>
				cstate <= c3_m_d;
				mm_i_read <= '0';
			when c3_m_d =>
				cstate <= c3_busy;
				mm_i_enable <= '0';
			when c3_busy =>
				if (mm_o_busy = '1') then
					cstate <= c3_busy;
				else
					cstate <= c3;
				end if;
			when c3 =>
				cstate <= c4_m_e;
				if (vppYp > G_MemoryData - 1) then
					if (io_MemDB(vppYp - G_MemoryData) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				else
					if (io_MemDB(vppYp) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;				
				end if;
				countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
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
					address_c4 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				else
					address_c4 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
				mm_i_MemAdr(23 downto 1) <= address_c4;
				slv_address_c4 <= address_c4;
			when c4_m_r_d =>
				cstate <= c4_m_d;
				mm_i_read <= '0';
			when c4_m_d =>
				cstate <= c4_busy;
				mm_i_enable <= '0';
			when c4_busy =>
				if (mm_o_busy = '1') then
					cstate <= c4_busy;
				else
					cstate <= c4;
				end if;
			when c4 =>
				cstate <= c5_m_e;
				if (vppYp > G_MemoryData - 1) then
					if (io_MemDB(vppYp - G_MemoryData) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				else
					if (io_MemDB(vppYp) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				end if;
				countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
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
					address_c5 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				else
					address_c5 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
				mm_i_MemAdr(23 downto 1) <= address_c5;
				slv_address_c5 <= address_c5;
			when c5_m_r_d =>
				cstate <= c5_m_d;
				mm_i_read <= '0';
			when c5_m_d =>
				cstate <= c5_busy;
				mm_i_enable <= '0';
			when c5_busy =>
				if (mm_o_busy = '1') then
					cstate <= c5_busy;
				else
					cstate <= c5;
				end if;
			when c5 =>
				cstate <= c6_m_e;
				if (vppYm1 > G_MemoryData - 1) then
					if (io_MemDB(vppYm1 - G_MemoryData) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				else
					if (io_MemDB(vppYm1) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;				
				end if;
				countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
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
					address_c6 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				else
					address_c6 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
				mm_i_MemAdr(23 downto 1) <= address_c6;
				slv_address_c6 <= address_c6;
			when c6_m_r_d =>
				cstate <= c6_m_d;
				mm_i_read <= '0';
			when c6_m_d =>
				cstate <= c6_busy;
				mm_i_enable <= '0';
			when c6_busy =>
				if (mm_o_busy = '1') then
					cstate <= c6_busy;
				else
					cstate <= c6;
				end if;
			when c6 =>
				cstate <= c7_m_e;
				if (vppYm1 > G_MemoryData - 1) then
					if (io_MemDB(vppYm1 - G_MemoryData) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				else
					if (io_MemDB(vppYm1) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;				
				end if;
				countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
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
					address_c7 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				else
					address_c7 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
				mm_i_MemAdr(23 downto 1) <= address_c7;
				slv_address_c7 <= address_c7;
			when c7_m_r_d =>
				cstate <= c7_m_d;
				mm_i_read <= '0';
			when c7_m_d =>
				cstate <= c7_busy;
				mm_i_enable <= '0';
			when c7_busy =>
				if (mm_o_busy = '1') then
					cstate <= c7_busy;
				else
					cstate <= c7;
				end if;
			when c7 =>
				cstate <= c8_m_e;
				if (vppYp1 > G_MemoryData - 1) then
					if (io_MemDB(vppYp1 - G_MemoryData) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				else
					if (io_MemDB(vppYp1) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				end if;
				countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
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
					address_c8 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				else
					address_c8 := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				end if;
				mm_i_MemAdr(23 downto 1) <= address_c8;
				slv_address_c8 <= address_c8;
			when c8_m_r_d =>
				cstate <= c8_m_d;
				mm_i_read <= '0';
			when c8_m_d =>
				cstate <= c8_busy;
				mm_i_enable <= '0';
			when c8_busy =>
				if (mm_o_busy = '1') then
					cstate <= c8_busy;
				else
					cstate <= c8;
				end if;
			when c8 =>
				cstate <= waitfor;
				if (vppYp1 > G_MemoryData - 1) then
					if (io_MemDB(vppYp1 - G_memoryData) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
				else
					if (io_MemDB(vppYp1) = '1') then
						vcountAlive := vcountAlive + 1;
					end if;				
				end if;
				countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
			when waitfor =>
				cstate <= memory_disable_bit;
				countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				assert (vcountALive = 0) report "AROUND (X,Y) = (" & integer'image(vppX) & "," & integer'image(vppYp) & ") countalive = " & integer'image(vcountALive) severity note;
			when memory_disable_bit =>
				cstate <= store_count_alive1;
				mm_i_enable <= '1';
			when store_count_alive1 =>
				cstate <= store_count_alive2;
				mm_i_write <= '1';
			when store_count_alive2 =>
				cstate <= store_count_alive3;
				address_sca := std_logic_vector(to_unsigned(storeAddress + vppX*COLS_PIXEL + vppYp,G_MemoryAddress-1));
				mm_i_MemAdr(23 downto 1) <= address_sca;
				slv_address_sca <= address_sca;
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
				i := 0;
				k := 0;
			when get_alive1 =>
				cstate <= get_alive2;
				mm_i_enable <= '1';
			when get_alive2 =>
				cstate <= get_alive3;
				mm_i_read <= '1';
			when get_alive3 =>
				cstate <= get_alive4;
				address_ga := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				mm_i_MemAdr(23 downto 1) <= address_ga;
				slv_address_ga <= address_ga;
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
				if (io_MemDB(k) = '1') then
					vCellAlive := true;
					report "get_alive cell at (X,Y)(" & integer'image(vppX) & "," & integer'image(vppYp) & ") = 1 , upper memory data" severity note;
				else
					vCellAlive := false;
--						report "get_alive cell at (X,Y)(" & integer'image(vppX) & "," & integer'image(vppYp) & ") = 0 , upper memory data" severity note;
				end if;
--				if (vppYp > G_MemoryData - 1) then
--					if (io_MemDB(vppYp - G_MemoryData) = '1') then
--						vCellAlive := true;
--						report "get_alive cell at (X,Y)(" & integer'image(vppX) & "," & integer'image(vppYp) & ") = 1 , upper memory data" severity note;
--					else
--						vCellAlive := false;
----						report "get_alive cell at (X,Y)(" & integer'image(vppX) & "," & integer'image(vppYp) & ") = 0 , upper memory data" severity note;
--					end if;
--				else
--					if (io_MemDB(vppYp) = '1') then
--						vCellAlive := true;
--						report "get_alive cell at (X,Y)(" & integer'image(vppX) & "," & integer'image(vppYp) & ") = 1 , lower memory data" severity note;
--					else
--						vCellAlive := false;
----						report "get_alive cell at (X,Y)(" & integer'image(vppX) & "," & integer'image(vppYp) & ") = 0 , lower memory data" severity note;
--					end if;
--				end if;
			when enable_write_to_memory1 =>
				cstate <= enable_write_to_memory2;
				mm_i_enable <= '1';
			when enable_write_to_memory2 =>
				cstate <= enable_write_to_memory3;
				mm_i_read <= '1';
			when enable_write_to_memory3 =>
				cstate <= enable_write_to_memory4;
				address_ewm := std_logic_vector(to_unsigned(storeAddress + vppX*COLS_PIXEL + vppYp,G_MemoryAddress-1));
				mm_i_MemAdr(23 downto 1) <= address_ewm;
				slv_address_ewm <= address_ewm;
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
						report "previous cell 1,read stored cell at (X,Y)(" & integer'image(vppX) & "," & integer'image(vppYp) & ") = 1 , 2/3" severity note;
					else
						vCellAlive2 := false;
--						report "previous cell 1,read stored cell at (X,Y)(" & integer'image(vppX) & "," & integer'image(vppYp) & ") = 0 , not 2/3" severity note;
					end if;
				elsif (vCellAlive = false) then
					if (io_MemDB = x"0003") then
						vCellAlive2 := true;
						report "previous cell 0,read stored cell at (X,Y)(" & integer'image(vppX) & "," & integer'image(vppYp) & ") = 1 , 3" severity note;
					else
						vCellAlive2 := false;
--						report "previous cell 0,read stored cell at (X,Y)(" & integer'image(vppX) & "," & integer'image(vppYp) & ") = 0 , not 3" severity note;
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
				address_wca := std_logic_vector(to_unsigned(startAddress + vppX*i_max + i,G_MemoryAddress-1));
				mm_i_MemAdr(23 downto 1) <= address_wca;
				slv_address_wca <= address_wca;
			when write_count_alive4 =>
				cstate <= write_count_alive5;
				if (vCellAlive2 = true) then
					if (vppYp > G_MemoryData - 1) then
						mm_i_MemDB(vppYp - G_MemoryData) <= '1';
						report "new cell 1,store new cell at (X,Y)(" & integer'image(vppX) & "," & integer'image(vppYp) & ") = 1 , upper memory data" severity note;
					else
						mm_i_MemDB(vppYp) <= '1';
						report "new cell 1,store new cell at (X,Y)(" & integer'image(vppX) & "," & integer'image(vppYp) & ") = 1 , lower memory data" severity note;
					end if;
				elsif (vCellAlive2 = false) then
					if (vppYp > G_MemoryData - 1) then
						mm_i_MemDB(vppYp - G_MemoryData) <= '0';
--						report "new cell 0,store new cell at (X,Y)(" & integer'image(vppX) & "," & integer'image(vppYp) & ") = 0 , upper memory data" severity note;
					else
						mm_i_MemDB(vppYp) <= '0';
--						report "new cell 0,store new cell at (X,Y)(" & integer'image(vppX) & "," & integer'image(vppYp) & ") = 0 , lower memory data" severity note;
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
					cstate <= cellalive_check_k;
				end if;
			when cellalive_check_k =>
				if (k = G_MemoryData-1) then
					cstate <= cellalive_check_i;
					k := 0;
				else
					cstate <= get_alive1;
					k := k + 1;
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
	slv_startAddress <= std_logic_vector(to_unsigned(startAddress,G_MemoryAddress));
	slv_storeAddress <= std_logic_vector(to_unsigned(storeAddress,G_MemoryAddress));
	slv_i <= std_logic_vector(to_unsigned(i,G_MemoryAddress));
	slv_k <= std_logic_vector(to_unsigned(k,G_MemoryAddress));
end process gof_logic;

end architecture Behavioral;
