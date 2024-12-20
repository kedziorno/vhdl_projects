--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:09:48 11/01/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/i2c_test_3/tb_top.vhd
-- Project Name:  i2c_test_3
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
use WORK.p_memory_content.ALL;
use WORK.p_constants1.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY ssd1306_tb_top IS
END ssd1306_tb_top;

ARCHITECTURE behavior OF ssd1306_tb_top IS

constant IC : integer := 50_000_000;
constant BC : integer := 6_000_000;
constant DC : integer := 10_000;

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT ssd1306_gof
generic(
INPUT_CLOCK : integer := G_BOARD_CLOCK;
BUS_CLOCK : integer := G_BUS_CLOCK; -- increase for speed i2c
DIVIDER_CLOCK : integer := G_ClockDivider
);
port(
signal clk : in std_logic;
signal btn_1 : in std_logic;
signal btn_2 : in std_logic;
signal btn_3 : in std_logic;
signal sda,scl : inout std_logic
);
END COMPONENT;

signal MemOE : std_logic;
signal MemWR : std_logic;
signal RamAdv : std_logic;
signal RamCS : std_logic;
signal RamLB : std_logic;
signal RamUB : std_logic;
signal RamCRE : std_logic;
signal RamWait : std_logic;
signal MemAdr : MemoryAddressALL := (others => 'Z');
signal MemDB : MemoryDataByte := (others => 'Z');

--Inputs
signal clk : std_logic := '0';
signal btn_1 : std_logic := '0';
signal btn_2 : std_logic := '0';
signal btn_3 : std_logic := '0';

--BiDirs
signal sda : std_logic;
signal scl : std_logic;

-- Clock period definitions 
constant clk_period : time := (1_000_000_000 / IC) * 1 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: ssd1306_gof 
GENERIC MAP (
INPUT_CLOCK => IC,
BUS_CLOCK => BC,
DIVIDER_CLOCK => DC
)
PORT MAP (
clk => clk,
btn_1 => btn_1,
btn_2 => btn_2,
btn_3 => btn_3,
sda => sda,
scl => scl
);

-- Clock process definitions
clk_process :process
begin
clk <= '0';
wait for clk_period/2;
clk <= '1';
wait for clk_period/2;
end process;

-- Stimulus process
stim_proc: process
begin		
-- hold reset state for 100 ns.
btn_1 <= '1';
wait for 100 ns;
btn_1 <= '0';
wait for clk_period*10;
-- insert stimulus here
wait;
end process;

END;
