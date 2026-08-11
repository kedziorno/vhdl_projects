--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:26:17 01/21/2022
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/myown_i2c/TB_MUX21.vhd
-- Project Name:  myown_i2c
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MUX_21
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

ENTITY TB_MUX21 IS
END TB_MUX21;

ARCHITECTURE behavior OF TB_MUX21 IS

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT MUX_21
PORT(
S : IN  std_logic;
A : IN  std_logic;
B : IN  std_logic;
C : OUT  std_logic
);
END COMPONENT;

--Inputs
signal S : std_logic := '0';
signal A : std_logic := '0';
signal B : std_logic := '0';

--Outputs
signal C : std_logic;

constant clock_period : time := 10 ns;
signal clock : std_logic;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: MUX_21 PORT MAP (
S => S,
A => A,
B => B,
C => C
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
stim_proc : process
begin
-- hold reset state for 100 ns.
wait for 100 ns;
wait for clock_period*10;
-- insert stimulus here
A <= '1';
B <= '0';
S <= '0';
wait for clock_period;
A <= '1';
B <= '0';
S <= '1';
wait for clock_period;
A <= '0';
B <= '1';
S <= '0';
wait for clock_period;
A <= '0';
B <= '1';
S <= '1';
wait for clock_period;

wait;
end process;

END;
