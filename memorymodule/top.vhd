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
g_clock_divider : integer := G_ClockDivider;
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
		g_divider : integer := g_clock_divider
	);
	Port (
		i_clock : in STD_LOGIC;
		o_clock : out STD_LOGIC
	);
	end component clock_divider;
	for all : clock_divider use entity WORK.clock_divider(Behavioral);

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

	component memorymodule is
	Port (
		i_clock : in std_logic;
		i_enable : in std_logic;
		i_write : in std_logic;
		i_read : in std_logic;
		i_MemAdr : in std_logic_vector(G_MemoryAddress-1 downto 0);
		i_MemDB : in std_logic_vector(G_MemoryData-1 downto 0);
		o_MemDB : out std_logic_vector(G_MemoryData-1 downto 0);
		io_MemOE : out std_logic;
		io_MemWR : out std_logic;
		io_RamAdv : out std_logic;
		io_RamCS : out std_logic;
		io_RamLB : out std_logic;
		io_RamUB : out std_logic;
		io_MemAdr : out std_logic_vector(G_MemoryAddress-1 downto 0);
		io_MemDB : inout std_logic_vector(G_MemoryData-1 downto 0)
	);
	end component memorymodule;
	for all : memorymodule use entity WORK.memorymodule(behavioral);

	signal LCDChar : LCDHex;
	signal o_clock : std_logic;
	signal i_enable : std_logic;
	signal i_write : std_logic;
	signal i_read : std_logic;
	signal i_MemAdr : std_logic_vector(G_MemoryAddress-1 downto 0);
	signal i_MemDB : std_logic_vector(G_MemoryData-1 downto 0);
	signal o_MemDB : std_logic_vector(G_MemoryData-1 downto 0);
	signal o_MemDB_p : std_logic_vector(G_MemoryData-1 downto 0);

	type test_state is (
	start,
	wait1,enable_module1,enable_write1,data_write1,disable_write1,disable_module1,
	wait2,enable_module2,enable_write2,data_write2,disable_write2,disable_module2,
	wait3,enable_module3,enable_write3,data_write3,disable_write3,disable_module3,
	wait4,enable_display1,read1_display1,read_display1,read0_display1,disable_display1,
	wait5,enable_display2,read1_display2,read_display2,read0_display2,disable_display2,
	wait6,enable_display3,read1_display3,read_display3,read0_display3,disable_display3,
	wait7,stop
	);
	signal ts : test_state;

begin

	c_clock_divider : clock_divider
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
		i_clock => o_clock,
		i_enable => i_enable,
		i_write => i_write,
		i_read => i_read,
		i_MemAdr => i_MemAdr,
		i_MemDB => i_MemDB,
		o_MemDB => o_MemDB,
		io_MemOE => io_MemOE,
		io_MemWR => io_MemWR,
		io_RamAdv => io_RamAdv,
		io_RamCS => io_RamCS,
		io_RamLB => io_RamLB,
		io_RamUB => io_RamUB,
		io_MemAdr => io_MemAdr,
		io_MemDB => io_MemDB
	);

	p0 : process (o_clock,o_MemDB) is
		constant waiting_for_write : integer := 10;
		constant waiting : integer := 1; --g_board_clock / g_clock_divider; -- decrease for simulation speed
		variable w : integer := 0;
		variable t : std_logic_vector(G_MemoryData-1 downto 0);
		variable tz : std_logic_vector(G_MemoryData-1 downto 0) := (others => 'Z');
		variable t0 : std_logic_vector(G_MemoryData-1 downto 0) := (others => '0');
	begin
		if (rising_edge(o_clock)) then
			if (w > 0) then
				w := w - 1;
			end if;
			case ts is
				when start =>
					ts <= wait1;
					w := waiting_for_write;
					
				when wait1 =>
					if (w = 0) then
						ts <= enable_module1;
					end if;
				
				when enable_module1 =>
					ts <= enable_write1;
					i_enable <= '1';
				when enable_write1 =>
					ts <= data_write1;
					i_write <= '1';
				when data_write1 =>
					ts <= disable_write1;
					i_MemAdr <= x"111111";
					i_MemDB <= x"1234";				
				when disable_write1 =>
					ts <= disable_module1;
					i_write <= '0';
				when disable_module1 =>
					ts <= wait2;
					i_enable <= '0';
					w := waiting_for_write;
					
				when wait2 =>
					if (w = 0) then
						ts <= enable_module2;
					end if;
					
				when enable_module2 =>
					ts <= enable_write2;
					i_enable <= '1';
				when enable_write2 =>
					ts <= data_write2;
					i_write <= '1';
				when data_write2 =>
					ts <= disable_write2;
					i_MemAdr <= x"222222";
					i_MemDB <= x"5678";				
				when disable_write2 =>
					ts <= disable_module2;
					i_write <= '0';
				when disable_module2 =>
					ts <= wait3;
					i_enable <= '0';
					w := waiting_for_write;
					
				when wait3 =>
					if (w = 0) then
						ts <= enable_module3;
					end if;
					
				when enable_module3 =>
					ts <= enable_write3;
					i_enable <= '1';
				when enable_write3 =>
					ts <= data_write3;
					i_write <= '1';
				when data_write3 =>
					ts <= disable_write3;
					i_MemAdr <= x"333333";
					i_MemDB <= x"9ABC";				
				when disable_write3 =>
					ts <= disable_module3;
					i_write <= '0';
				when disable_module3 =>
					ts <= wait4;
					i_enable <= '0';
					w := waiting;
					
				when wait4 =>
					if (w = 0) then
						ts <= enable_display1;
					end if;
					
				when enable_display1 =>
					ts <= read1_display1;
					i_enable <= '1';
				when read1_display1 =>
					ts <= read_display1;
					i_read <= '1';
				when read_display1 =>
					ts <= read0_display1;
					i_MemAdr <= x"111111";
				when read0_display1 =>
					ts <= disable_display1;
					i_read <= '0';
				when disable_display1 =>
					ts <= wait5;
					i_enable <= '0';
					w := waiting;
					
				when wait5 =>
					if (w = 0) then
						ts <= enable_display2;
					end if;
					
				when enable_display2 =>
					ts <= read1_display2;
					i_enable <= '1';
				when read1_display2 =>
					ts <= read_display2;
					i_read <= '1';
				when read_display2 =>
					ts <= read0_display2;
					i_MemAdr <= x"222222";
				when read0_display2 =>
					ts <= disable_display2;
					i_read <= '0';
				when disable_display2 =>
					ts <= wait6;
					i_enable <= '0';
					w := waiting;
					
				when wait6 =>
					if (w = 0) then
						ts <= enable_display3;
					end if;
					
				when enable_display3 =>
					ts <= read1_display3;
					i_enable <= '1';
				when read1_display3 =>
					ts <= read_display3;
					i_read <= '1';
				when read_display3 =>
					ts <= read0_display3;
					i_MemAdr <= x"333333";
				when read0_display3 =>
					ts <= disable_display3;
					i_read <= '0';
				when disable_display3 =>
					ts <= wait7;
					i_enable <= '0';
					w := waiting;
					
				when wait7 =>
					if (w = 0) then
						ts <= stop;
					end if;
					
				when stop =>
					ts <= enable_display1;
			end case;
		end if;
--		o_MemDB_p <= o_MemDB;
--		if (o_MemDB /= tz and o_MemDB /= t0) then
--			t := o_MemDB;
--		end if;
--		if (o_MemDB_p /= o_MemDB) then
--			LCDChar <= (o_MemDB(3 downto 0),o_MemDB(7 downto 4),o_MemDB(11 downto 8),o_MemDB(15 downto 12));
--		end if;
--		LCDChar <= (t(3 downto 0),t(7 downto 4),t(11 downto 8),t(15 downto 12));
	end process p0;

	LCDChar <= (o_MemDB(3 downto 0),o_MemDB(7 downto 4),o_MemDB(11 downto 8),o_MemDB(15 downto 12));

	o_Led <= i_sw;
	o_dp <= '1'; -- off all dot points

end Behavioral;
