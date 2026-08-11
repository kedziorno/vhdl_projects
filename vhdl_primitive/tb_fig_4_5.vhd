--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:42:59 06/06/2023
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_fig_4_5.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fig_4_5
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

ENTITY tb_fig_4_5 IS
END tb_fig_4_5;

ARCHITECTURE behavior OF tb_fig_4_5 IS 

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT fig_4_5
PORT(
x_in1 : IN  std_logic;
x_in2 : IN  std_logic;
x_in3 : IN  std_logic;
x_in4 : IN  std_logic;
x_in5 : IN  std_logic;
y_out : OUT  std_logic
);
END COMPONENT;

--Inputs
signal x_in1 : std_logic := '0';
signal x_in2 : std_logic := '0';
signal x_in3 : std_logic := '0';
signal x_in4 : std_logic := '0';
signal x_in5 : std_logic := '0';

--Outputs
signal y_out : std_logic;

signal clock : std_logic := '0';
constant clock_period : time := 10 ns;

BEGIN

cp : process is
begin
clock <= not clock; wait for clock_period; 
end process cp;

-- Instantiate the Unit Under Test (UUT)
uut: fig_4_5 PORT MAP (
x_in1 => x_in1,
x_in2 => x_in2,
x_in3 => x_in3,
x_in4 => x_in4,
x_in5 => x_in5,
y_out => y_out
);

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
wait for 100 ns;
-- insert stimulus here
wait for clock_period*2;
x_in1 <= '1';
x_in2 <= '1';
x_in3 <= '1';
x_in4 <= '1';
x_in5 <= '1';
wait for clock_period;
x_in1 <= '0';
x_in2 <= '1';
x_in3 <= '1';
x_in4 <= '1';
x_in5 <= '1';
wait for clock_period;
x_in1 <= '1';
x_in2 <= '0';
x_in3 <= '1';
x_in4 <= '1';
x_in5 <= '1';
wait for clock_period;
x_in1 <= '1';
x_in2 <= '1';
x_in3 <= '0';
x_in4 <= '1';
x_in5 <= '1';
wait for clock_period;
x_in1 <= '1';
x_in2 <= '1';
x_in3 <= '1';
x_in4 <= '0';
x_in5 <= '1';
wait for clock_period;
x_in1 <= '1';
x_in2 <= '1';
x_in3 <= '1';
x_in4 <= '1';
x_in5 <= '0';
wait for clock_period;
x_in1 <= '1';
x_in2 <= '1';
x_in3 <= '1';
x_in4 <= '1';
x_in5 <= '1';
wait for clock_period;
x_in1 <= '0';
x_in2 <= '0';
x_in3 <= '0';
x_in4 <= '0';
x_in5 <= '0';
wait for clock_period;
x_in1 <= '1';
x_in2 <= '0';
x_in3 <= '0';
x_in4 <= '0';
x_in5 <= '0';
wait for clock_period;
x_in1 <= '0';
x_in2 <= '1';
x_in3 <= '0';
x_in4 <= '0';
x_in5 <= '0';
wait for clock_period;
x_in1 <= '0';
x_in2 <= '0';
x_in3 <= '1';
x_in4 <= '0';
x_in5 <= '0';
wait for clock_period;
x_in1 <= '0';
x_in2 <= '0';
x_in3 <= '0';
x_in4 <= '1';
x_in5 <= '0';
wait for clock_period;
x_in1 <= '0';
x_in2 <= '0';
x_in3 <= '0';
x_in4 <= '0';
x_in5 <= '1';
wait for clock_period;
x_in1 <= '0';
x_in2 <= '0';
x_in3 <= '0';
x_in4 <= '0';
x_in5 <= '0';
wait for clock_period;

x_in1 <= '1';
x_in2 <= '0';
x_in3 <= '1';
x_in4 <= '0';
x_in5 <= '0';
wait for clock_period;
x_in1 <= '1';
x_in2 <= '1';
x_in3 <= '1';
x_in4 <= '1';
x_in5 <= '0';
wait for clock_period;
x_in1 <= '1';
x_in2 <= '0';
x_in3 <= '1';
x_in4 <= '1';
x_in5 <= '1';
wait for clock_period;

x_in1 <= '0';
x_in2 <= '1';
x_in3 <= '0';
x_in4 <= '1';
x_in5 <= '1';
wait for clock_period;
x_in1 <= '0';
x_in2 <= '0';
x_in3 <= '0';
x_in4 <= '0';
x_in5 <= '1';
wait for clock_period;
x_in1 <= '0';
x_in2 <= '1';
x_in3 <= '0';
x_in4 <= '0';
x_in5 <= '0';
wait for clock_period;

report "done tb" severity failure;
end process;

END;
