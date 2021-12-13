--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:12:33 12/13/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_signal_generator.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: signal_generator
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

ENTITY tb_signal_generator IS
END tb_signal_generator;

ARCHITECTURE behavior OF tb_signal_generator IS

COMPONENT signal_generator
PORT(
clk : IN  std_logic;
x : BUFFER  std_logic;
y : OUT  std_logic
);
END COMPONENT;

--Inputs
signal clk : std_logic := '0';

--Outputs
signal x : std_logic;
signal y : std_logic;

-- Clock period definitions
constant clk_period : time := 10 ns;

BEGIN

uut: signal_generator PORT MAP (
clk => clk,
x => x,
y => y
);

-- Clock process definitions
clk_process :process
begin
clk <= '1';
wait for (clk_period/2)*1;
clk <= '0';
wait for (clk_period/2)*9;
end process;

-- Stimulus process
stim_proc : process
begin
-- insert stimulus here
--x <= '1';
--wait for clk_period*10;
--x <= '0';
wait;
end process;

END;
