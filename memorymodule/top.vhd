----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:21:00 11/28/2020
-- Design Name: 
-- Module Name:    /home/user/workspace/vhdl_projects/memorymodule/top.vhd
-- Project Name:   memorymodule
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
use WORK.p_globals.ALL;
use WORK.p_lcd_display.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port (
i_clock : in std_logic;
io_MemOE : inout std_logic;
io_MemWR : inout std_logic;
io_RamAdv : inout std_logic;
io_RamCS : inout std_logic;
io_RamClk : inout std_logic;
io_RamCRE : inout std_logic;
io_RamLB : inout std_logic;
io_RamUB : inout std_logic;
io_RamWait : inout std_logic;
io_MemAdr : inout std_logic_vector(G_MemoryAddress-1 downto 0);
io_MemDB : inout std_logic_vector(G_MemoryData-1 downto 0);
i_sw : in std_logic_vector(G_Switch-1 downto 0);
i_btn : in std_logic_vector(G_Button-1 downto 0);
o_seg : out std_logic_vector(G_LCDSegment-1 downto 0);
o_dp : out std_logic;
o_an : out std_logic_vector(G_LCDAnode-1 downto 0);
o_Led : out std_logic_vector(G_Led-1 downto 0)
);
end top;

architecture Behavioral of top is

	component clock_divider is
	Generic (
		g_divider : integer
	);
	Port (
		i_clock : in STD_LOGIC;
		o_clock : out STD_LOGIC
	);
	end component clock_divider;
	for all : clock_divider use entity WORK.clock_divider(Behavioral);

	component lcd_display is
	Port (
		i_clock : in std_logic;
		i_LCDChar : LCDHex;
		o_anode : out std_logic_vector(G_LCDAnode-1 downto 0);
		o_segment : out std_logic_vector(G_LCDSegment-1 downto 0)
	);
	end component lcd_display;
	for all : lcd_display use entity WORK.lcd_display(Behavioral);

	signal LCDChar : LCDHex;
	signal o_clock : std_logic;

begin

	c_clock_divider : clock_divider
	Generic Map (
		g_divider => 1
	)
	Port Map (
		i_clock => i_clock,
		o_clock => o_clock
	);

	c_lcd_display : lcd_display
	Port Map (
		i_clock => i_clock,
		i_LCDChar => LCDChar,
		o_anode => o_an,
		o_segment => o_seg
	);

	scroll_left : process (o_clock) is
		type hex_table is array(15 downto 0) of std_logic_vector(G_HalfHex-1 downto 0);
		variable hex : hex_table := (x"0",x"1",x"2",x"3",x"4",x"5",x"6",x"7",x"8",x"9",x"a",x"b",x"c",x"d",x"e",x"f");
		constant scroll_length : integer := hex'length-1;
	begin
		if (rising_edge(o_clock)) then
			l0 : for i in 0 to scroll_length-1 loop
				LCDChar <= LCDChar(G_LCDAnode-2 downto 0)&hex(i);
			end loop l0;
		end if;
	end process scroll_left;

	o_Led <= i_sw;
	o_dp <= '1'; -- off all dot points
	io_MemOE <= 'Z';
	io_MemWR <= 'Z';
	io_RamAdv <= 'Z';
	io_RamCS <= 'Z';
	io_RamClk <= 'Z';
	io_RamCRE <= 'Z';
	io_RamLB <= 'Z';
	io_RamUB <= 'Z';
	io_RamWait <= 'Z';
	io_MemDB <= (others => 'Z');
	io_MemAdr <= (others => 'Z');

end Behavioral;

