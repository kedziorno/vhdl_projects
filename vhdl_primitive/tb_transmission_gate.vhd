--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:21:54 07/01/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_transmission_gate.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: transmission_gate
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

ENTITY tb_transmission_gate IS
END tb_transmission_gate;

ARCHITECTURE behavior OF tb_transmission_gate IS 

COMPONENT transmission_gate
PORT(
	io_a : inout std_logic;
	io_b : inout std_logic;
	i_s : in std_logic
);
END COMPONENT;

signal a : std_logic;
signal b : std_logic;
signal s : std_logic;

constant clock_period : time := 100 ns;
signal clock : std_logic;

signal mux0 : std_logic;

BEGIN

uut: transmission_gate PORT MAP (
io_a => a,
io_b => b,
i_s => s
);

clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;

with s select mux0 <=
a when '1',
b when '0',
'Z' when others;

-- Stimulus process
stim_proc: process
begin
wait for 100 ns;

s <= '1';
a <= '0';
wait for 10*clock_period;
s <= '1';
a <= '1';
wait for 10*clock_period;
s <= '1';
b <= '0';
wait for 10*clock_period;
s <= '1';
b <= '1';
wait for 10*clock_period;

s <= '0';
a <= '0';
wait for 10*clock_period;
s <= '0';
a <= '1';
wait for 10*clock_period;
s <= '0';
b <= '0';
wait for 10*clock_period;
s <= '0';
b <= '1';
wait for 10*clock_period;

wait;
end process;

END;
