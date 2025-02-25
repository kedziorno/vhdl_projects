--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:59:57 02/25/2025
-- Design Name:   
-- Module Name:   /home/user/_WORKSPACE_/kedziorno/vhdl_projects/vhdl_primitive/tb_counter_test2.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: counter_test2
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
USE ieee.numeric_std.ALL;

ENTITY tb_counter_test2 IS
END tb_counter_test2;

ARCHITECTURE behavior OF tb_counter_test2 IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT counter_test2
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
i_a : IN  std_logic;
i_b : IN  std_logic;
o_counter : OUT  std_logic_vector (31 downto 0)
);
END COMPONENT counter_test2;

--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_a : std_logic := '0';
signal i_b : std_logic := '0';

--Outputs
signal o_counter : std_logic_vector (31 downto 0);

-- Clock period definitions
constant i_clock_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: counter_test2
PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_a => i_a,
i_b => i_b,
o_counter => o_counter
);

-- Clock process definitions
i_clock_process : process
begin
i_clock <= '0';
wait for i_clock_period/2;
i_clock <= '1';
wait for i_clock_period/2;
end process i_clock_process;

-- Stimulus process
stim_proc : process
begin
-- hold reset state for 100 ns.
i_reset <= '1';
wait for 100 ns;	
i_reset <= '0';
wait for i_clock_period*10;
-- insert stimulus here
i_a <= '0';
i_b <= '0';
wait for i_clock_period*11;
-- count up
i_a <= '0';
i_b <= '1';
wait for i_clock_period*22;
-- count down
i_a <= '1';
i_b <= '0';
wait for i_clock_period*22;
i_a <= '1';
i_b <= '1';
wait for i_clock_period*11;
i_a <= '0';
i_b <= '0';
wait for i_clock_period*11;
wait for i_clock_period*1;
report "tb done" severity failure;
wait;
end process;

END;
