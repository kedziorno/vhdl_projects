--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:41:51 04/18/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_succesive_approximation_register.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: succesive_approximation_register
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

ENTITY tb_succesive_approximation_register IS
END tb_succesive_approximation_register;

ARCHITECTURE behavior OF tb_succesive_approximation_register IS

constant N : integer := 16;

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT succesive_approximation_register
GENERIC(
n : INTEGER := N
);
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
i_select : IN  std_logic;
o_q : OUT  std_logic_vector(N-1 downto 0);
o_end : INOUT  std_logic
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_select : std_logic := '0';

--BiDirs
signal o_end : std_logic;

--Outputs
signal o_q : std_logic_vector(N-1 downto 0);

-- Clock period definitions
constant i_clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: succesive_approximation_register
GENERIC MAP (
n => N
)
PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_select => i_select,
o_q => o_q,
o_end => o_end
);

-- Clock process definitions
i_clock_process :process
begin
i_clock <= '0';
wait for i_clock_period/2;
i_clock <= '1';
wait for i_clock_period/2;
end process;

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
i_reset <= '1';
wait for 100 ns;
i_reset <= '0';
wait for i_clock_period*10;
-- insert stimulus here
wait for i_clock_period*(N+5);
i_select <= '1';
wait for i_clock_period;
i_select <= '0';
<<<<<<< HEAD
wait for i_clock_period*3;
i_select <= '1';
wait for i_clock_period;
i_select <= '0';
wait;
end process;

END;
