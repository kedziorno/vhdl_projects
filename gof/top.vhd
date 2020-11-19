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
constant BUS_CLOCK : integer := 400_000; -- increase for speed i2c
constant DIVIDER_CLOCK : integer := 1000; -- increase for speed simulate and i2c

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

procedure GetCellAt(
	signal i_row : in integer;
	signal i_col : in integer;
	signal o_row : out integer;
	signal o_col : out integer
) is begin
	report "getcellat" severity note;
	if (i_row <= 0) then
		report "i_row <= MIN : "&integer'image(i_row) severity note;
		o_row <= 0;
	end if;
	if (i_col <= 0) then
		report "i_col <= MIN : "&integer'image(i_col) severity note;
		o_col <= 0;
	end if;
	if (i_row >= ROWS-1) then
		report "i_row >= MAX-1 : "&integer'image(i_row) severity note;
		o_row <= ROWS-1;
	end if;
	if (i_col >= COLS_PIXEL-1) then
		report "i_col >= MAX-1 : "&integer'image(i_col) severity note;
		o_col <= COLS_PIXEL-1;
	end if;
end GetCellAt;

--shared variable pX : integer range 0 to ROWS-1 := 0;
--shared variable pY : integer range 0 to COLS_BLOCK-1 := 0;
signal pX : integer range 0 to ROWS-1 := 0;
signal pY : integer range 0 to COLS_BLOCK-1 := 0;

signal spX : integer range 0 to ROWS-1 := 0;
signal spY : integer range 0 to COLS_BLOCK-1 := 0;

signal i_mem_e_byte : std_logic;
signal i_mem_e_bit : std_logic;

signal countAlive : integer := 0;

--type state1 is (idle,mem_enable,c1,c2,c3,c4,c5,c6,c7,c8,mem_disable,stop);
type state1 is (idle,mem_enable,calculate,mem_disable,stop);
signal cstate1,nstate1 : state1;

type state2 is (idle,display_is_initialize,update_row,update_col,stop);
signal cstate2,nstate2 : state2;

signal ppX : integer range 0 to ROWS-1 := pX;
signal ppY : integer range 0 to COLS_BLOCK-1 := pY;
--signal ppXm1 : integer;
--signal ppXp1 : integer;
--signal ppYm1 : integer;
--signal ppYp1 : integer;
--signal ppXm1 : integer range 0 to ROWS-1 := ppX-1;
--signal ppXp1 : integer range 0 to ROWS-1 := ppX+1;
--signal ppYm1 : integer range 0 to COLS_BLOCK-1 := ppY-1;
--signal ppYp1 : integer range 0 to COLS_BLOCK-1 := ppY+1;
--signal oppX : integer;
--signal oppY : integer;
	
begin
	
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
--	i_enable_byte => i_mem_e_byte,
	i_enable_byte => '1',
--	i_enable_bit => i_mem_e_bit,
	i_enable_bit => '0',
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

--gof_logic_fsm : process (clk_1s) is
--begin
--	if (rising_edge(clk_1s)) then
--		cstate1 <= nstate1;
--	end if;
--end process gof_logic_fsm;
--
--gof_logic : process (cstate1) is
--	
--begin
--	case cstate1 is
--		when idle =>
--			nstate1 <= mem_enable;
--		when mem_enable =>
--			nstate1 <= calculate;
--		--	nstate1 <= c1;
--			i_mem_e_byte <= '0';
--			i_mem_e_bit <= '1';
--		when calculate =>
--			nstate1 <= mem_disable;
--		--when c1 =>
--		--	nstate1 <= c2;
--			if (ppY /= 0) then
--				GetCellAt(ppX,ppYm1,oppX,oppY);
--				if (o_bit = '1') then
--					countAlive <= countAlive + 1;
--				end if;
--			end if;
--		--when c2 =>
--		--	nstate1 <= c3;
--			if (ppY /= COLS_PIXEL-1) then
--				GetCellAt(ppX,ppYp1,oppX,oppY);
--				if (o_bit = '1') then
--					countAlive <= countAlive + 1;
--				end if;
--			end if;
--		--when c3 =>
--		--	nstate1 <= c4;
--			if (ppX /= ROWS-1) then
--				GetCellAt(ppXp1,ppY,oppX,oppY);
--				if (o_bit = '1') then
--					countAlive <= countAlive + 1;
--				end if;
--			end if;
--		--when c4 =>
--		--	nstate1 <= c5;
--			if (ppX /= 0) then
--				GetCellAt(ppXm1,ppY,oppX,oppY);
--				if (o_bit = '1') then
--					countAlive <= countAlive + 1;
--				end if;
--			end if;
--		--when c5 =>
--		--	nstate1 <= c6;
--			if ((ppX /= 0) and (ppY /= 0)) then
--				GetCellAt(ppXm1,ppYm1,oppX,oppY);
--				if (o_bit = '1') then
--					countAlive <= countAlive + 1;
--				end if;
--			end if;
--		--when c6 =>
--		--	nstate1 <= c7;
--			if ((ppX /= ROWS-1) and (ppY /= 0)) then
--				GetCellAt(ppXp1,ppYm1,oppX,oppY);
--				if (o_bit = '1') then
--					countAlive <= countAlive + 1;
--				end if;
--			end if;
--		--when c7 =>
--		--	nstate1 <= c8;
--			if ((ppX /= 0) and (ppY /= COLS_PIXEL-1)) then
--				GetCellAt(ppXm1,ppYp1,oppX,oppY);
--				if (o_bit = '1') then
--					countAlive <= countAlive + 1;
--				end if;
--			end if;
--		--when c8 =>
--		--	nstate1 <= mem_disable;
--			if ((ppX /= ROWS-1) and (ppY /= COLS_PIXEL-1)) then
--				GetCellAt(ppXp1,ppYp1,oppX,oppY);
--				if (o_bit = '1') then
--					countAlive <= countAlive + 1;
--				end if;
--			end if;
--		when mem_disable =>
--			nstate1 <= idle;
--			i_mem_e_byte <= '1';
--			i_mem_e_bit <= '0';
--		when others => null;
--	end case;
--	pX := oppX;
--	pY := oppY;
--	spX <= oppX;
--	spY <= oppY;
--	ppXm1 <= ppX-1;
--	ppXp1 <= ppX+1;
--	ppYm1 <= ppY-1;
--	ppYp1 <= ppY+1;
--end process gof_logic;

p0_fsm : process (clk_1s) is
begin
	if (btn_1 = '1') then
		all_pixels <= '0';
		pX <= 0;
		pY <= 0;
		cstate2 <= display_is_initialize;
	elsif (rising_edge(clk_1s)) then
		cstate2 <= nstate2;
		if (cstate2 = update_row) then
			if (pX < ROWS-1) then
				pX <= pX + 1;
			end if;
		end if;
		if (cstate2 = update_col) then
			if (pY < COLS_BLOCK-1) then
				pY <= pY + 1;
				pX <= 0;
			end if;
		end if;
	end if;
end process p0_fsm;

p0 : process (cstate2,clk_1s) is
begin
	case (cstate2) is
		when idle =>
			if (display_initialize = '0') then
				nstate2 <= idle;
			else
				nstate2 <= display_is_initialize;
			end if;
		when display_is_initialize =>
			nstate2 <= update_row;
		when update_row =>
			if (pX < ROWS-1) then
				nstate2 <= update_row;
			else
				nstate2 <= update_col;
			end if;
		when update_col =>
			if (pY < COLS_BLOCK-1) then
				nstate2 <= update_row;
			else
				nstate2 <= stop;
			end if;
		when stop =>
			nstate2 <= stop;
		when others => null;
	end case;
end process p0;

row <= std_logic_vector(to_unsigned(pX,row'length));
col_block <= std_logic_vector(to_unsigned(pY,col_block'length));

end Behavioral;
