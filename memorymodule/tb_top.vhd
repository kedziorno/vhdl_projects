--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    15:34:00 11/28/2020
-- Design Name:   
-- Module Name:    /home/user/workspace/vhdl_projects/memorymodule/tb_top.vhd
-- Project Name:   memorymodule
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE WORK.p_globals.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_top IS
END tb_top;

ARCHITECTURE behavior OF tb_top IS 

	component top is
	Generic (
		g_board_clock : integer := G_BOARD_CLOCK;
		g_clock_divider : integer := 100;
		g_lcd_clock_divider : integer := 50_000_000
	);
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
	end component top;
	for all : top use entity WORK.top(Behavioral);

	constant clk_period : time := (1_000_000_000 / G_BOARD_CLOCK) * 1 ns;

	signal clk : std_logic := '0';
	signal sw : std_logic_vector(G_Switch-1 downto 0);
	signal btn : std_logic_vector(G_Button-1 downto 0);
	signal seg : std_logic_vector(G_LCDSegment-1 downto 0);
	signal dp : std_logic;
	signal an : std_logic_vector(G_LCDAnode-1 downto 0);
	signal Led : std_logic_vector(G_Led-1 downto 0);

BEGIN

	uut : top
	Port Map (
		i_clock => clk,
		io_MemOE => open,
		io_MemWR => open,
		io_RamAdv => open,
		io_RamCS => open,
		io_RamClk => open,
		io_RamCRE => open,
		io_RamLB => open,
		io_RamUB => open,
		io_RamWait => open,
		io_MemAdr => open,
		io_MemDB => open,
		i_sw => sw,
		i_btn => btn,
		o_seg => seg,
		o_dp => dp,
		o_an => an,
		o_Led => led
	);

	clk_process :process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	stim_proc: process
	begin
		-- hold reset state for 100 ns.
		-- wait for 100 ns;
		-- wait for clk_period*10;
		-- insert stimulus here
		wait;
	end process;

END;

