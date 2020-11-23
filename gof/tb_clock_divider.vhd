--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:47:22 11/23/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/gof/tb_clock_divider.vhd
-- Project Name:  gof
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clock_divider
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_clock_divider IS
END tb_clock_divider;

ARCHITECTURE behavior OF tb_clock_divider IS 

constant BC : integer := 50_000_000;
constant CD : integer := 1_000;

COMPONENT clock_divider
GENERIC(
	g_board_clock : integer;
	g_divider : integer
);
PORT(
	i_clk : IN  std_logic;
	i_divider : IN  integer;
	o_clk : OUT  std_logic
);
END COMPONENT;

--Inputs
signal i_clk : std_logic;
signal i_divider : integer;

--Outputs
signal o_clk : std_logic;

-- Clock period definitions
--	constant i_clk_half_period : time := (0.5e15 / 50_000_000) * 1 fs;
--	constant i_clk_period : time := 2 * clk_half_period; 
-- constant i_clk_period : time := time'val(IC);
constant i_clk_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: clock_divider 
GENERIC MAP (
	g_board_clock => BC,
	g_divider => CD
)
PORT MAP (
	i_clk => i_clk,
	i_divider => i_divider,
	o_clk => o_clk
);

-- Clock process definitions
i_clk_process :process
begin
	i_clk <= '0';
	wait for i_clk_period/2;
	i_clk <= '1';
	wait for i_clk_period/2;
end process;

-- Stimulus process
stim_proc: process
begin
	-- hold reset state for 100 ns.
	wait for 100 ns;
	wait for i_clk_period*10;
	-- insert stimulus here
	wait;
end process;

END;
