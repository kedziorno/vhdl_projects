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
INPUT_CLOCK : integer := 50_000_000;
DIVIDER_CLOCK : integer := 1_000
);
port(
clk : in std_logic;
btn_1 : in std_logic;
btn_2 : in std_logic;
btn_3 : in std_logic;
o_cs : out std_logic;
o_do : out std_logic;
o_ck : out std_logic;
o_reset : out std_logic;
o_rs : out std_logic
);
end entity st7735r_gof;

architecture Behavioral of st7735r_gof is

component my_spi is
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
idle,
display_is_initialize,
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
signal CD : integer := DIVIDER_CLOCK;
signal CD_DISPLAY : integer := DIVIDER_CLOCK*1; -- XXX
signal CD_CALCULATE : integer := DIVIDER_CLOCK*10000; -- XXX

signal spi_enable,spi_cs,spi_do,spi_ck,spi_sended : std_logic;
signal spi_data_byte : BYTE_TYPE;
signal initialize_run,initialize_sended : std_logic;
signal initialize_initialized,initialize_enable,initialize_reset,initialize_rs,initialize_cs : std_logic;
signal initialize_color : COLOR_TYPE;
signal initialize_data_byte : BYTE_TYPE;

function To_Std_Logic(x_vot : BOOLEAN) return std_ulogic is
begin
	if x_vot then
		return('1');
	else
		return('0');
	end if;
end function To_Std_Logic;

begin

o_cs <= spi_cs; -- TODO use initialize_cs mux
o_do <= spi_do;
o_ck <= spi_ck;
o_reset <= initialize_reset when initialize_run = '1' else '1';
o_rs <= initialize_rs when initialize_run = '1' else '1';

myspi_entity : my_spi
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
);

clk_div : clock_divider
port map (
	i_clk => CLK_BUFG,
	i_board_clock => INPUT_CLOCK,
	i_divider => CD,
	o_clk => clk_1s
);

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
);

gof_logic : process (clk_1s,i_reset) is
	constant W : integer := 1;
	variable waiting : integer range W-1 downto 0 := 0;
	variable vppX : integer range 0 to ROWS-1;
	variable vppYb : integer range 0 to COLS_BLOCK-1;
	variable vppYp : integer range 0 to COLS_PIXEL-1;
	variable vppXm1 : integer range -1 to ROWS-1;
	variable vppXp1 : integer range 0 to ROWS;
	variable vppYm1 : integer range -1 to COLS_PIXEL-1;
	variable vppYp1 : integer range 0 to COLS_PIXEL;
	variable vcountAlive : integer range 0 to 15;
	variable vCellAlive : boolean;
begin
	if (i_reset = '1') then
		all_pixels <= '0';
		vppX := 0;
		vppYb := 0;
		vppYp := 0;
		cstate <= idle;
	elsif (rising_edge(clk_1s)) then
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
				cstate <= waitone;
				i_mem_e_byte <= '1';
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
				countAlive <= (others => '0');
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
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
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
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when set_c3 =>
				cstate <= c3;
				row <= ppXp1;
				col_pixel <= ppYp;	
			when c3 =>
				cstate <= set_c4;
				if (vppX /= ROWS-1) then
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
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
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
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
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when set_c6 =>
				cstate <= c6;
				row <= ppXp1;
				col_pixel <= ppYm1;	
			when c6 =>
				cstate <= set_c7;
				if ((vppX /= ROWS-1) and (vppYp /= 0)) then
					if (o_bit = '1') then
						vcountAlive := vcountAlive + 1;
					end if;
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
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
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
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
					countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
				end if;
			when waitfor =>
				cstate <= memory_disable_bit;
				countAlive <= std_logic_vector(to_unsigned(vcountALive,4));
			when memory_disable_bit =>
				cstate <= store_count_alive;
				i_mem_e_bit <= '0';
			when store_count_alive =>
				cstate <= update_row1;
				ENABLE <= '1';
				WRITE_EN <= '1';
				ADDRESS <= std_logic_vector(to_unsigned(vppX+vppYp*WORD_BITS,12));
				DATA_IN <= countAlive;
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
			     ENABLE <= '1';
			     WRITE_EN <= '0';
			     ADDRESS <= std_logic_vector(to_unsigned(vppX+vppYp*WORD_BITS,12));
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

end architecture Behavioral;
