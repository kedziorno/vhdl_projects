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

entity ssd1306_gof is
generic(
INPUT_CLOCK : integer := 50_000_000;
--BUS_CLOCK : integer := 6_000_000; -- increase for speed i2c --XXX scl period=1.28us,start=0.96us,stop=0.16us
BUS_CLOCK : integer := 100_000; --original
DIVIDER_CLOCK : integer := 1
);
port(
signal clk : in std_logic;
signal btn_1 : in std_logic;
signal btn_2 : in std_logic;
signal btn_3 : in std_logic;
signal sda,scl : inout std_logic
);
end ssd1306_gof;

architecture Behavioral of ssd1306_gof is

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
signal o_display_initialize : inout std_logic;
signal o_busy : out std_logic;
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

component memory1 is
Port (
i_clk : in std_logic;
i_reset : in std_logic;
i_copy_content : in std_logic;
o_copy_content : out std_logic;
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
signal display_busy : std_logic;

signal i_mem_e_byte : std_logic;
signal i_mem_e_bit : std_logic;
signal i_mem_write_bit : std_logic;
signal i_bit : std_logic;
signal i_copy_content,o_copy_content : std_logic;

signal CLK_BUFG : std_logic;

signal DATA_IN : std_logic_vector(3 downto 0);
signal ADDRESS : std_logic_vector(11 downto 0);
signal ENABLE : std_logic;
signal WRITE_EN : std_logic;
signal DATA_OUT : std_logic_vector(3 downto 0);

type state is (
idle,
display_is_initialize,
memory_enable_byte,
aaa,
waitone,
waitone1,
update_row,
update_col,
set_cd_calculate,
memory_disable_byte,
reset_counters_1,
check_coordinations,
reset_count_alive,
memory_enable_bit,
set_c1a,set_c2a,set_c3a,set_c4a,set_c5a,set_c6a,set_c7a,set_c8a,
set_c1,c1,set_c2,c2,set_c3,c3,set_c4,c4,set_c5,c5,set_c6,c6,set_c7,c7,set_c8,c8,
c1_end,c2_end,c3_end,c4_end,c5_end,c6_end,c7_end,c8_end,
waitfor,
memory_disable_bit,
store_count_alive,
update_row1,
update_col1,
reset_counters1,
memory_enable_bit1,
get_alive,
get_alive1,
bbb,
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
signal ppX : std_logic_vector(ROWS_BITS-1 downto 0);
signal ppYb : std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
signal ppYp : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
signal ppXm1 : std_logic_vector(ROWS_BITS-1 downto 0);
signal ppXp1 : std_logic_vector(ROWS_BITS-1 downto 0);
signal ppYm1 : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
signal ppYp1 : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
signal oppX : std_logic_vector(ROWS_BITS-1 downto 0);
signal oppY : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
signal countAlive : std_logic_vector(3 downto 0);
signal CellAlive : std_logic;
signal CD : integer := DIVIDER_CLOCK*1_000;
signal CD_DISPLAY : integer := DIVIDER_CLOCK*1_0; -- XXX
signal CD_CALCULATE : integer := DIVIDER_CLOCK*100_000; -- XXX

function To_Std_Logic(x_vot : BOOLEAN) return std_ulogic is
begin
	if x_vot then
		return('1');
	else
		return('0');
	end if;
end function To_Std_Logic;

begin

U_BUFG: BUFG 
port map (
I => clk,
O => CLK_BUFG
);

i_reset <= btn_1;

U_RAMB16_S4: RAMB16_S4
generic map (
WRITE_MODE => "WRITE_FIRST", -- WRITE_FIRST/READ_FIRST/NO_CHANGE
INIT => X"0",
SRVAL => X"0"
)
port map (
DI => DATA_IN,
ADDR => ADDRESS,
EN => ENABLE,
WE => WRITE_EN,
SSR => i_reset,
CLK => CLK_BUFG,
DO => DATA_OUT
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
	i_draw => btn_3,
	i_x => row,
	i_y => col_block,
	i_byte => display_byte,
	i_all_pixels => all_pixels,
	o_display_initialize => display_initialize,
	o_busy => display_busy,
	io_sda => sda,
	io_scl => scl
);

m1 : memory1
port map (
	i_clk => CLK_BUFG,
	i_reset => i_reset,
	i_copy_content => i_copy_content,
	o_copy_content => o_copy_content, 
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

gof_logic : process (CLK_BUFG,i_reset) is
	constant W : integer := 10;
	variable waiting : integer range W-1 downto 0 := 0;
	variable vppX : integer;-- range 0 to ROWS-1;
	variable vppYb : integer;-- range 0 to COLS_BLOCK-1;
	variable vppYp : integer;-- range 0 to COLS_PIXEL-1;
	variable vppXm1 : integer;-- range -1 to ROWS-1;
	variable vppXp1 : integer;-- range 0 to ROWS;
	variable vppYm1 : integer;-- range -1 to COLS_PIXEL-1;
	variable vppYp1 : integer;-- range 0 to COLS_PIXEL;
	variable vcountAlive : integer range 0 to 7;
	variable vCellAlive : boolean;
begin
	if (i_reset = '1') then
		all_pixels <= '0';
		cstate <= idle;
		vCellAlive := false;
		vcountAlive := 0;
		vppX := 0;
		vppYb := 0;
		vppYp := 0;
		vppXm1 := 0;
		vppXp1 := 0;
		vppYm1 := 0;
		vppYp1 := 0;
		i_copy_content <= '0';
		i_mem_e_byte <= '0';
		i_mem_e_bit <= '0';
		i_mem_write_bit <= '0';
		i_bit <= '0';
	elsif (rising_edge(CLK_BUFG)) then
		case cstate is
			-- draw
			when idle =>
				if (display_initialize = '1') then
					cstate <= display_is_initialize;
				else
					cstate <= idle;
				end if;
				all_pixels <= '0';
			when display_is_initialize =>
				cstate <= memory_enable_byte;
				vppX := 0;
				vppYb := 0;
				vppYp := 0;
			when memory_enable_byte =>
				cstate <= aaa;
				i_mem_e_byte <= '1';
				waiting := W-1;
				CD <= CD_DISPLAY;
			when aaa =>
				if (display_busy = '0') then
					cstate <= aaa;
				else
					cstate <= waitone;
				end if;
			when waitone =>
				cstate <= waitone1;
				row <= ppX;
				col_block <= ppYb;
			when waitone1 =>
				if (display_busy = '1') then
					cstate <= waitone1;
				else
					cstate <= update_row;
				end if;
			when update_row =>
				if (vppX = ROWS - 1) then
					cstate <= update_col;
				else
					vppX := vppX + 1;
					cstate <= waitone;
					waiting := W-1;
				end if;
			when update_col =>
				if (vppYb = COLS_BLOCK - 1) then
					cstate <= set_cd_calculate;
					vppYb := 0;
					vppX := 0;
				else
					vppYb := vppYb + 1;
					cstate <= waitone;
					waiting := W-1;
					vppX := 0;
				end if;
			when set_cd_calculate =>
				cstate <= memory_disable_byte;
				CD <= CD_CALCULATE;
			when memory_disable_byte =>
				cstate <= reset_counters_1;
				i_mem_e_byte <= '0';
			-- calculate cells
			when reset_counters_1 =>
				cstate <= check_coordinations;
				all_pixels <= '1';
				vppX := 0;
				vppYb := 0;
				vppYp := 0;
			when check_coordinations =>
				cstate <= memory_enable_bit;
				vppXm1 := vppX - 1;
				if (vppXm1 < 0) then
					vppXm1 := 0; -- ROWS - 1
				end if;
				vppXp1 := vppX + 1;
				if (vppXp1 > ROWS - 1) then
					vppXp1 := ROWS - 1; -- 0
				end if;
				vppYm1 := vppYp - 1;
				if (vppYm1 < 0) then
					vppYm1 := 0; -- COLS_PIXEL - 1
				end if;
				vppYp1 := vppYp+1;
				if (vppYp1 > COLS_PIXEL - 1) then
					vppYp1 := COLS_PIXEL - 1; -- 0
				end if;
			when memory_enable_bit =>
				cstate <= reset_count_alive;
				i_mem_e_bit <= '1';
				i_mem_write_bit <= '0';
			when reset_count_alive =>
				cstate <= set_c1a;
				vcountAlive := 0;
				countAlive <= (others => '0');
			when set_c1a =>
				cstate <= set_c1;
				i_mem_e_bit <= '1';
				i_mem_write_bit <= '0';
			when set_c1 =>
				cstate <= c1;
				row <= ppX;
				col_pixel <= ppYm1;
			when c1 =>
				cstate <= c1_end;
				if (vppYp /= 0) then
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c1_end =>
				cstate <= set_c2a;
				i_mem_e_bit <= '0';
				i_mem_write_bit <= '0';
			when set_c2a =>
				cstate <= set_c2;
				i_mem_e_bit <= '1';
				i_mem_write_bit <= '0';				
			when set_c2 =>
				cstate <= c2;
				row <= ppX;
				col_pixel <= ppYp1;
			when c2 =>
				cstate <= c2_end;
				if (vppYp /= COLS_PIXEL-1) then	
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c2_end =>
				cstate <= set_c3a;
				i_mem_e_bit <= '0';
				i_mem_write_bit <= '0';
			when set_c3a =>
				cstate <= set_c3;
				i_mem_e_bit <= '1';
				i_mem_write_bit <= '0';				
			when set_c3 =>
				cstate <= c3;
				row <= ppXp1;
				col_pixel <= ppYp;	
			when c3 =>
				cstate <= c3_end;
				if (vppX /= ROWS-1) then
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c3_end =>
				cstate <= set_c4a;
				i_mem_e_bit <= '0';
				i_mem_write_bit <= '0';
			when set_c4a =>
				cstate <= set_c4;
				i_mem_e_bit <= '1';
				i_mem_write_bit <= '0';				
			when set_c4 =>
				cstate <= c4;
				row <= ppXm1;
				col_pixel <= ppYp;	
			when c4 =>
				cstate <= c4_end;
				if (vppX /= 0) then
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c4_end =>
				cstate <= set_c5a;
				i_mem_e_bit <= '0';
				i_mem_write_bit <= '0';
			when set_c5a =>
				cstate <= set_c5;
				i_mem_e_bit <= '1';
				i_mem_write_bit <= '0';
			when set_c5 =>
				cstate <= c5;
				row <= ppXm1;
				col_pixel <= ppYm1;	
			when c5 =>
				cstate <= c5_end;
				if ((vppX /= 0) and (vppYp /= 0)) then
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c5_end =>
				cstate <= set_c6a;
				i_mem_e_bit <= '0';
				i_mem_write_bit <= '0';
			when set_c6a =>
				cstate <= set_c6;
				i_mem_e_bit <= '1';
				i_mem_write_bit <= '0';				
			when set_c6 =>
				cstate <= c6;
				row <= ppXp1;
				col_pixel <= ppYm1;	
			when c6 =>
				cstate <= c6_end;
				if ((vppX /= ROWS-1) and (vppYp /= 0)) then
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c6_end =>
				cstate <= set_c7a;
				i_mem_e_bit <= '0';
				i_mem_write_bit <= '0';
			when set_c7a =>
				cstate <= set_c7;
				i_mem_e_bit <= '1';
				i_mem_write_bit <= '0';
			when set_c7 =>
				cstate <= c7;
				row <= ppXm1;
				col_pixel <= ppYp1;	
			when c7 =>
				cstate <= c7_end;
				if ((vppX /= 0) and (vppYp /= COLS_PIXEL-1)) then
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c7_end =>
				cstate <= set_c8a;
				i_mem_e_bit <= '0';
				i_mem_write_bit <= '0';
			when set_c8a =>
				cstate <= set_c8;
				i_mem_e_bit <= '1';
				i_mem_write_bit <= '0';
			when set_c8 =>
				cstate <= c8;
				row <= ppXp1;
				col_pixel <= ppYp1;	
			when c8 =>
				cstate <= c8_end;
				if ((vppX /= ROWS-1) and (vppYp /= COLS_PIXEL-1)) then
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
--					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when c8_end =>
				cstate <= waitfor;
				i_mem_e_bit <= '0';
				i_mem_write_bit <= '0';
			when waitfor =>
				cstate <= memory_disable_bit;
				countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
			when memory_disable_bit =>
				cstate <= store_count_alive;
				i_mem_e_bit <= '0';
				ENABLE <= '1';
				WRITE_EN <= '1';
			when store_count_alive =>
				cstate <= update_row1;
				ADDRESS <= std_logic_vector(to_unsigned(vppX+vppYp*WORD_BITS,12));
				DATA_IN <= countAlive;
				report "store_count_alive " & integer'image(to_integer(unsigned(ppX))) & "," & integer'image(to_integer(unsigned(ppYp)));
			when update_row1 =>
			  ENABLE <= '0';
			  WRITE_EN <= '0';
				if (vppX = ROWS - 1) then
					cstate <= update_col1;
				else
					vppX := vppX + 1;
					cstate <= check_coordinations;
				end if;
			when update_col1 =>
				if (vppYp = COLS_PIXEL - 1) then
					cstate <= reset_counters1;
					vppYp := 0;
				else
					vppYp := vppYp + 1;
					cstate <= check_coordinations;
					vppX := 0;
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
				i_mem_write_bit <= '0';
			when get_alive =>
				cstate <= get_alive1;
				row <= ppX;
				col_pixel <= ppYp;
			when get_alive1 =>
				cstate <= bbb;
				if (o_bit = '1') then
					vCellAlive := true;
				else
					vCellAlive := false;
				end if;
				report "get_alive1 " & integer'image(to_integer(unsigned(ppX))) & "," & integer'image(to_integer(unsigned(ppYp)));
				ENABLE <= '1';
			  WRITE_EN <= '0';
			when bbb =>
				cstate <= enable_write_to_memory;
				i_mem_e_bit <= '0';
				i_mem_write_bit <= '0';
			when enable_write_to_memory =>
				cstate <= write_count_alive;
				i_mem_e_bit <= '1';
				i_mem_write_bit <= '1';
			  ADDRESS <= std_logic_vector(to_unsigned(vppX+vppYp*WORD_BITS,12));
				report "enable_write_to_memory " & integer'image(to_integer(unsigned(ppX))) & "," & integer'image(to_integer(unsigned(ppYp)));
				i_bit <= '0';
				row <= ppX;
				col_pixel <= ppYp;
			when write_count_alive =>
				cstate <= disable_write_to_memory;
				if (vCellAlive = true) then
					if ((to_integer(unsigned(DATA_OUT)) = 2) or (to_integer(unsigned(DATA_OUT)) = 3)) then
						i_bit <= '1';
					else
						i_bit <= '0';
					end if;
				elsif (vCellAlive = false) then
					if (to_integer(unsigned(DATA_OUT)) = 3) then
						i_bit <= '1';
					else
						i_bit <= '0';
					end if;
				end if;
			when disable_write_to_memory =>
			  ENABLE <= '0';
			  WRITE_EN <= '0';
				cstate <= update_row2;
				i_mem_e_bit <= '0';
				i_mem_write_bit <= '0';
				i_bit <= '0';
			when update_row2 =>
				if (vppX = ROWS - 1) then
					cstate <= update_col2;
				else
					vppX := vppX + 1;
					cstate <= get_alive;
				end if;
			when update_col2 =>
				if (vppYp = COLS_PIXEL - 1) then
					cstate <= disable_memory;
					vppYp := 0;
					vppYb := 0;
				else
					vppYp := vppYp + 1;
					cstate <= get_alive;
					vppX := 0;
				end if;
			when disable_memory =>
				cstate <= stop;
--				i_mem_e_bit <= '0';
--				i_bit <= '0';
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
