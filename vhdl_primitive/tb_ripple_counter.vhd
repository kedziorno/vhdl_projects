--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:55:32 05/04/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_ripple_counter.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ripple_counter
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

ENTITY tb_ripple_counter IS
END tb_ripple_counter;

ARCHITECTURE behavior OF tb_ripple_counter IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT ripple_counter
PORT(
i_clock : IN  std_logic;
i_cpb : IN  std_logic;
i_mrb : IN  std_logic;
o_q : INOUT  std_logic_vector(11 downto 0)
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_cpb : std_logic := '0';
signal i_mrb : std_logic := '0';

--BiDirs
signal o_q : std_logic_vector(11 downto 0);

signal clock : std_logic := '0';
constant clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: ripple_counter PORT MAP (
i_clock => i_clock,
i_cpb => i_cpb,
i_mrb => i_mrb,
o_q => o_q
);

-- Clock process definitions
clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;

i_cpb <= '1';
i_clock <= '1';

-- Stimulus process
stim_proc: process
begin
---- hold reset state for 100 ns.
--wait for clock_period;
---- insert stimulus here
wait;
end process;

END;
