--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:04:09 06/29/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_ff_d_pe.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FF_D_POSITIVE_EDGE
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

ENTITY tb_ff_d_pe IS
END tb_ff_d_pe;

ARCHITECTURE behavior OF tb_ff_d_pe IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT FF_D_POSITIVE_EDGE
PORT(
S : IN  std_logic;
R : IN  std_logic;
C : IN  std_logic;
D : IN  std_logic;
Q1 : INOUT  std_logic;
Q2 : INOUT  std_logic
);
END COMPONENT;

--Inputs
signal S : std_logic := '0';
signal R : std_logic := '0';
signal C : std_logic := '0';
signal D : std_logic := '0';

--BiDirs
signal Q1 : std_logic;
signal Q2 : std_logic;

signal clock : std_logic;
constant clock_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: FF_D_POSITIVE_EDGE PORT MAP (
S => S,
R => R,
C => clock,
D => D,
Q1 => Q1,
Q2 => Q2
);

-- Clock process definitions
clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;

-- Stimulus process
stim_proc: process
begin		

-- insert stimulus here 

wait for clock_period*10;

S <= '0';
R <= '0';
wait for 100 ns;	
d <= '1';
wait for clock_period;
d <= '0';
wait for clock_period;
wait for 444 ps;
d <= '1';
wait for clock_period*3;
d <= '0';
wait for clock_period;
wait for 444 ps;
d <= '1';
wait for clock_period*3+clock_period/2+444 ps;
d <= '0';
wait for clock_period;
d <= '1';
wait for clock_period*3+clock_period+444 ps;
d <= '0';
wait for clock_period;
d <= '1';
wait for 1 ns;
d <= '0';
wait for clock_period;
d <= '1';
wait for 6 ns;
d <= '0';
wait for clock_period;
d <= '1';
wait for clock_period;
d <= '0';

-- XXX q1 on '1',q2 have '1' on RE clock and d=0
S <= '0';
R <= '1';
wait for 100 ns;	
d <= '1';
wait for clock_period;
d <= '0';
wait for clock_period;
wait for 444 ps;
d <= '1';
wait for clock_period*3;
d <= '0';
wait for clock_period;
wait for 444 ps;
d <= '1';
wait for clock_period*3+clock_period/2+444 ps;
d <= '0';
wait for clock_period;
d <= '1';
wait for clock_period*3+clock_period+444 ps;
d <= '0';
wait for clock_period;
d <= '1';
wait for 1 ns;
d <= '0';
wait for clock_period;
d <= '1';
wait for 6 ns;
d <= '0';
wait for clock_period;
d <= '1';
wait for clock_period;
d <= '0';

S <= '1';
R <= '0';
wait for 100 ns;	
d <= '1';
wait for clock_period;
d <= '0';
wait for clock_period;
wait for 444 ps;
d <= '1';
wait for clock_period*3;
d <= '0';
wait for clock_period;
wait for 444 ps;
d <= '1';
wait for clock_period*3+clock_period/2+444 ps;
d <= '0';
wait for clock_period;
d <= '1';
wait for clock_period*3+clock_period+444 ps;
d <= '0';
wait for clock_period;
d <= '1';
wait for 1 ns;
d <= '0';
wait for clock_period;
d <= '1';
wait for 6 ns;
d <= '0';
wait for clock_period;
d <= '1';
wait for clock_period;
d <= '0';

-- XXX look ok, q1 on RE clock and D,q2 is q1 bar
S <= '1';
R <= '1';
wait for 100 ns;
d <= '1';
wait for clock_period;
d <= '0';
wait for clock_period;
wait for 444 ps;
d <= '1';
wait for clock_period*3;
d <= '0';
wait for clock_period;
wait for 444 ps;
d <= '1';
wait for clock_period*3+clock_period/2+444 ps;
d <= '0';
wait for clock_period;
d <= '1';
wait for clock_period*3+clock_period+444 ps;
d <= '0';
wait for clock_period;
d <= '1';
wait for 1 ns;
d <= '0';
wait for clock_period;
d <= '1';
wait for 6 ns;
d <= '0';
wait for clock_period;
d <= '1';
wait for clock_period;
d <= '0';
S <= '0';
R <= '0';

wait for 100 ns;	

wait;
end process;

END;
