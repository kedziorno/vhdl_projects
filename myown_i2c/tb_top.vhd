--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:26:03 07/27/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/myown_i2c/tb_top.vhd
-- Project Name:  myown_i2c
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_top IS
END tb_top;

ARCHITECTURE behavior OF tb_top IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT top
PORT(
clk : IN  std_logic;
btn_1 : IN  std_logic;
sda : OUT  std_logic;
scl : OUT  std_logic
);
END COMPONENT;

--Inputs
signal clk : std_logic := '0';
signal btn_1 : std_logic := '0';

--Outputs
signal sda : std_logic;
signal scl : std_logic;

-- Clock period definitions
constant clk_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: top PORT MAP (
clk => clk,
btn_1 => btn_1,
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
