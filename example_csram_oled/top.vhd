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
signal io_FlashCS : out std_logic
);
end top;

architecture Behavioral of top is

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

signal CD : integer := G_ClockDivider;
signal clk_1s : std_logic;
signal btn_1,btn_2 : std_logic;
signal draw : std_logic;
signal i_x : std_logic_vector(ROWS_BITS-1 downto 0);
signal i_y : std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
signal all_pixels : std_logic;
signal o_disbusy : std_logic;
signal display_initialize : std_logic;
signal display_byte : std_logic_vector(BYTE_SIZE-1 downto 0);
signal i_enable : std_logic;
signal i_write : std_logic;
signal i_read : std_logic;
signal o_membusy : std_logic;
signal i_MemAdr : MemoryAddress;
signal i_MemDB : MemoryDataByte;
signal o_MemDB : MemoryDataByte;
signal diby : std_logic_vector(BYTE_SIZE-1 downto 0);

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

type state is
(
wait0,
wa0_em,wa0_sa,wa0_ew,wa0_dw,wa0_dm,wa0_wait,
wa1_em,wa1_sa,wa1_ew,wa1_dw,wa1_dm,wa1_wait,
wa2_em,wa2_sa,wa2_ew,wa2_dw,wa2_dm,wa2_wait,
wa3_em,wa3_sa,wa3_ew,wa3_dw,wa3_dm,wa3_wait,
ed,
da0_em,da0_er,da0_sa,da0_dr,da0_dm,da0_wait,da0_bfh,da0_fh,da0_waitfh,da0_bsh,da0_sh,da0_waitsh,
da1_em,da1_er,da1_sa,da1_dr,da1_dm,da1_wait,da1_bfh,da1_fh,da1_waitfh,da1_bsh,da1_sh,da1_waitsh,
da2_em,da2_er,da2_sa,da2_dr,da2_dm,da2_wait,da2_bfh,da2_fh,da2_waitfh,da2_bsh,da2_sh,da2_waitsh,
da3_em,da3_er,da3_sa,da3_dr,da3_dm,da3_wait,da3_bfh,da3_fh,da3_waitfh,da3_bsh,da3_sh,da3_waitsh,
dd
);
signal cstate : state;

signal a0 : MemoryAddressAll := x"002040";
signal a1 : MemoryAddressAll := x"003050";
signal a2 : MemoryAddressAll := x"004060";
signal a3 : MemoryAddressAll := x"005070";
signal d0 : MemoryDataByte := x"fff0";
signal d1 : MemoryDataByte := x"0ff0";
signal d2 : MemoryDataByte := x"0ff0";
signal d3 : MemoryDataByte := x"0fff";

begin

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

io_FlashCS <= '1'; -- flash is always off

display_byte <= diby;

clk_div : clock_divider
port map (
	i_clk => clk,
	i_board_clock => G_BOARD_CLOCK,
	i_divider => CD,
	o_clk => clk_1s
);

c0 : oled_display
generic map (
	GLOBAL_CLK => G_BOARD_CLOCK,
	I2C_CLK => G_BUS_CLOCK,
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
	i_x => i_x,
	i_y => i_y,
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

p0 : process (clk_1s) is
	constant W : integer := 5000;
	variable w1 : integer := W;
begin
	if (rising_edge(clk_1s)) then
		if (w1 > 0) then
			w1 := w1 - 1;
		end if;
		case cstate is
			when wait0 =>
				if (display_initialize='1') then
					i_x <= std_logic_vector(to_unsigned(0,ROWS_BITS));
					i_y <= std_logic_vector(to_unsigned(0,COLS_BLOCK_BITS));
					cstate <= wa0_em;
				end if;
				
			when wa0_em =>
				cstate <= wa0_ew;
				i_enable <= '1';
			when wa0_ew =>
				cstate <= wa0_sa;
				i_write <= '1';
			when wa0_sa =>
				cstate <= wa0_dw;
				i_MemAdr <= a0(G_MemoryAddress-1 downto 1);
				i_MemDB <= d0;
			when wa0_dw =>
				cstate <= wa0_dm;
				i_write <= '0';
			when wa0_dm =>
				cstate <= wa0_wait;
				i_enable <= '0';
			when wa0_wait =>
				if (o_membusy='1') then
					cstate <= wa0_wait;
				else
					cstate <= wa1_em;
				end if;
                           
			when wa1_em =>
				cstate <= wa1_ew;
				i_enable <= '1';
			when wa1_ew =>
				cstate <= wa1_sa;
				i_write <= '1';
			when wa1_sa =>
				cstate <= wa1_dw;
				i_MemAdr <= a1(G_MemoryAddress-1 downto 1);
				i_MemDB <= d1;
			when wa1_dw =>
				cstate <= wa1_dm;
				i_write <= '0';
			when wa1_dm =>
				cstate <= wa1_wait;
				i_enable <= '0';
			when wa1_wait =>
				if (o_membusy='1') then
					cstate <= wa1_wait;
				else
					cstate <= wa2_em;
				end if;
				
			when wa2_em =>
				cstate <= wa2_ew;
				i_enable <= '1';
			when wa2_ew =>
				cstate <= wa2_sa;
				i_write <= '1';
			when wa2_sa =>
				cstate <= wa2_dw;
				i_MemAdr <= a2(G_MemoryAddress-1 downto 1);
				i_MemDB <= d2;
			when wa2_dw =>
				cstate <= wa2_dm;
				i_write <= '0';
			when wa2_dm =>
				cstate <= wa2_wait;
				i_enable <= '0';
			when wa2_wait =>
				if (o_membusy='1') then
					cstate <= wa2_wait;
				else
					cstate <= wa3_em;
				end if;
								 
			when wa3_em =>
				cstate <= wa3_ew;
				i_enable <= '1';
			when wa3_ew =>
				cstate <= wa3_sa;
				i_write <= '1';
			when wa3_sa =>
				cstate <= wa3_dw;
				i_MemAdr <= a3(G_MemoryAddress-1 downto 1);
				i_MemDB <= d3;
			when wa3_dw =>
				cstate <= wa3_dm;
				i_write <= '0';
			when wa3_dm =>
				cstate <= wa3_wait;
				i_enable <= '0';
			when wa3_wait =>
				if (o_membusy='1') then
					cstate <= wa3_wait;
				else
					cstate <= ed;
					w1 := W;
				end if;

			when ed =>
				if (w1 = 0) then
					cstate <= da0_em;
					all_pixels <= '0';
					draw <= '1';
				else
					cstate <= ed;
				end if;
				
			when da0_em =>
				cstate <= da0_er;
				i_enable <= '1';
			when da0_er =>
				cstate <= da0_sa;
				i_read <= '1';
			when da0_sa =>
				cstate <= da0_dr;
				i_MemAdr <= a0(G_MemoryAddress-1 downto 1);
			when da0_dr =>
				cstate <= da0_dm;
				i_read <= '0';
			when da0_dm =>
				cstate <= da0_wait;
				i_enable <= '0';
			when da0_wait =>
				if (o_membusy='1') then
					cstate <= da0_wait;
				else
					cstate <= da0_bfh;
				end if;
			when da0_bfh =>
				if (o_disbusy='0') then
					cstate <= da0_bfh;
				else
					cstate <= da0_fh;
				end if;
			when da0_fh =>
				cstate <= da0_waitfh;
				i_x <= std_logic_vector(to_unsigned(0,ROWS_BITS));
				diby <= o_MemDB(15 downto 8);
			when da0_waitfh =>
				if (o_disbusy='1') then
					cstate <= da0_waitfh;
				else
					cstate <= da0_bsh;
				end if;
			when da0_bsh =>
				if (o_disbusy='1') then
					cstate <= da0_bsh;
				else
					cstate <= da0_sh;
				end if;
			when da0_sh =>
				cstate <= da0_waitsh;
				i_x <= std_logic_vector(to_unsigned(1,ROWS_BITS));
				diby <= o_MemDB(7 downto 0);
			when da0_waitsh =>
				if (o_disbusy='1') then
					cstate <= da0_waitsh;
				else
					cstate <= da1_em;
				end if;

			when da1_em =>
				cstate <= da1_er;
				i_enable <= '1';
			when da1_er =>
				cstate <= da1_sa;
				i_read <= '1';
			when da1_sa =>
				cstate <= da1_dr;
				i_MemAdr <= a1(G_MemoryAddress-1 downto 1);
			when da1_dr =>
				cstate <= da1_dm;
				i_read <= '0';
			when da1_dm =>
				cstate <= da1_wait;
				i_enable <= '0';
			when da1_wait =>
				if (o_membusy='1') then
					cstate <= da1_wait;
				else
					cstate <= da1_bfh;
				end if;
			when da1_bfh =>
				if (o_disbusy='1') then
					cstate <= da1_bfh;
				else
					cstate <= da1_fh;
				end if;
			when da1_fh =>
				cstate <= da1_waitfh;
				i_x <= std_logic_vector(to_unsigned(2,ROWS_BITS));
				diby <= o_MemDB(15 downto 8);
			when da1_waitfh =>
				if (o_disbusy='1') then
					cstate <= da1_waitfh;
				else
					cstate <= da1_bsh;
				end if;
			when da1_bsh =>
				if (o_disbusy='1') then
					cstate <= da1_bsh;
				else
					cstate <= da1_sh;
				end if;
			when da1_sh =>
				cstate <= da1_waitsh;
				i_x <= std_logic_vector(to_unsigned(3,ROWS_BITS));
				diby <= o_MemDB(7 downto 0);
			when da1_waitsh =>
				if (o_disbusy='1') then
					cstate <= da1_waitsh;
				else
					cstate <= da2_em;
				end if;

			when da2_em =>
				cstate <= da2_er;
				i_enable <= '1';
			when da2_er =>
				cstate <= da2_sa;
				i_read <= '1';
			when da2_sa =>
				cstate <= da2_dr;
				i_MemAdr <= a2(G_MemoryAddress-1 downto 1);
			when da2_dr =>
				cstate <= da2_dm;
				i_read <= '0';
			when da2_dm =>
				cstate <= da2_wait;
				i_enable <= '0';
			when da2_wait =>
				if (o_membusy='1') then
					cstate <= da2_wait;
				else
					cstate <= da2_bfh;
				end if;
			when da2_bfh =>
				if (o_disbusy='1') then
					cstate <= da2_bfh;
				else
					cstate <= da2_fh;
				end if;
			when da2_fh =>
				cstate <= da2_waitfh;
				i_x <= std_logic_vector(to_unsigned(4,ROWS_BITS));
				diby <= o_MemDB(15 downto 8);
			when da2_waitfh =>
				if (o_disbusy='1') then
					cstate <= da2_waitfh;
				else
					cstate <= da2_bsh;
				end if;
			when da2_bsh =>
				if (o_disbusy='1') then
					cstate <= da2_bsh;
				else
					cstate <= da2_sh;
				end if;
			when da2_sh =>
				cstate <= da2_waitsh;
				i_x <= std_logic_vector(to_unsigned(5,ROWS_BITS));
				diby <= o_MemDB(7 downto 0);
			when da2_waitsh =>
				if (o_disbusy='1') then
					cstate <= da2_waitsh;
				else
					cstate <= da3_em;
				end if;

			when da3_em =>
				cstate <= da3_er;
				i_enable <= '1';
			when da3_er =>
				cstate <= da3_sa;
				i_read <= '1';
			when da3_sa =>
				cstate <= da3_dr;
				i_MemAdr <= a3(G_MemoryAddress-1 downto 1);
			when da3_dr =>
				cstate <= da3_dm;
				i_read <= '0';
			when da3_dm =>
				cstate <= da3_wait;
				i_enable <= '0';
			when da3_wait =>
				if (o_membusy='1') then
					cstate <= da3_wait;
				else
					cstate <= da3_bfh;
				end if;
			when da3_bfh =>
				if (o_disbusy='1') then
					cstate <= da3_bfh;
				else
					cstate <= da3_fh;
				end if;
			when da3_fh =>
				cstate <= da3_waitfh;
				i_x <= std_logic_vector(to_unsigned(6,ROWS_BITS));
				diby <= o_MemDB(15 downto 8);
			when da3_waitfh =>
				if (o_disbusy='1') then
					cstate <= da3_waitfh;
				else
					cstate <= da3_bsh;
				end if;
			when da3_bsh =>
				if (o_disbusy='1') then
					cstate <= da3_bsh;
				else
					cstate <= da3_sh;
				end if;
			when da3_sh =>
				cstate <= da3_waitsh;
				i_x <= std_logic_vector(to_unsigned(7,ROWS_BITS));
				diby <= o_MemDB(7 downto 0);
			when da3_waitsh =>
				if (o_disbusy='1') then
					cstate <= da3_waitsh;
				else
					cstate <= dd;
				end if;

			when dd =>
				cstate <= dd;
				draw <= '0';
				all_pixels <= '1';

			when others => null;
		end case cstate;
	end if;
end process p0;

end Behavioral;
