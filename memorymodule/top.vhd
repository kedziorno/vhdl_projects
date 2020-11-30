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
Generic (
g_board_clock : integer := G_BOARD_CLOCK;
g_clock_divider : integer := 3;
g_lcd_clock_divider : integer := G_LCDClockDivider
);
Port (
i_clock : in std_logic;
io_MemOE : inout std_logic;
io_MemWR : inout std_logic;
io_RamAdv : inout std_logic;
io_RamCS : inout std_logic;
io_RamLB : inout std_logic;
io_RamUB : inout std_logic;
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
	Generic (
		LCDClockDivider : integer := G_LCDClockDivider
	);
	Port (
		i_clock : in std_logic;
		i_LCDChar : LCDHex;
		o_anode : out std_logic_vector(G_LCDAnode-1 downto 0);
		o_segment : out std_logic_vector(G_LCDSegment-1 downto 0)
	);
	end component lcd_display;
	for all : lcd_display use entity WORK.lcd_display(Behavioral);

	component memorymodule is
	Port (
		i_clock : in std_logic;
		io_MemOE : inout std_logic;
		io_MemWR : inout std_logic;
		io_RamAdv : inout std_logic;
		io_RamCS : inout std_logic;
		io_RamLB : inout std_logic;
		io_RamUB : inout std_logic;
		io_MemAdr : inout std_logic_vector(G_MemoryAddress-1 downto 0);
		io_MemDB : inout std_logic_vector(G_MemoryData-1 downto 0);
		o_MemDB : out std_logic_vector(G_MemoryData-1 downto 0)
	);
	end component memorymodule;
	for all : memorymodule use entity WORK.memorymodule(behavioral);

	signal LCDChar : LCDHex;
	signal o_clock : std_logic;
	signal o_MemDB : std_logic_vector(G_MemoryData-1 downto 0);

begin

	c_clock_divider : clock_divider
	Generic Map (
		g_divider => g_clock_divider
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

	M45W8MW16 : memorymodule
	Port Map (
		i_clock => i_clock,
		io_MemOE => io_MemOE,
		io_MemWR => io_MemWR,
		io_RamAdv => io_RamAdv,
		io_RamCS => io_RamCS,
		io_RamLB => io_RamLB,
		io_RamUB => io_RamUB,
		io_MemAdr => io_MemAdr,
		io_MemDB => io_MemDB,
		o_MemDB => o_MemDB
	);

--	LCDChar <= (o_MemDB(15 downto 12),o_MemDB(11 downto 8),o_MemDB(7 downto 4),o_MemDB(3 downto 0));
	LCDChar <= (io_MemDB(15 downto 12),io_MemDB(11 downto 8),io_MemDB(7 downto 4),io_MemDB(3 downto 0));

	o_Led <= i_sw;
	o_dp <= '1'; -- off all dot points

end Behavioral;
