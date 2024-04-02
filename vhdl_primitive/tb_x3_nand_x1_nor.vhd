--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:33:31 04/19/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_x3_nand_x1_nor.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: x3_nand_x1_nor
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

ENTITY tb_x3_nand_x1_nor IS
END tb_x3_nand_x1_nor;

ARCHITECTURE behavior OF tb_x3_nand_x1_nor IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT x3_nand_x1_nor
PORT(
A : IN  std_logic;
B : IN  std_logic;
Q : OUT  std_logic
);
END COMPONENT;

--Inputs
signal A : std_logic := '0';
signal B : std_logic := '0';

--Outputs
signal Q : std_logic;

constant clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: x3_nand_x1_nor PORT MAP (
A => A,
B => B,
Q => Q
);

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
wait for 100 ns;
wait for clock_period*10;
-- insert stimulus here
A <= '1';
B <= '1';
wait for clock_period;
A <= '0';
B <= '1';
wait for clock_period;
A <= '1';
B <= '0';
wait for clock_period;
A <= '0';
B <= '0';
wait for clock_period;
A <= '1';
B <= '1';
wait for clock_period;
A <= '1';
B <= '1';
wait for clock_period;
A <= '0';
B <= '1';
wait for clock_period;
A <= '1';
B <= '0';
wait for clock_period;
A <= '0';
B <= '0';
wait for clock_period;
A <= '1';
B <= '1';
wait for clock_period;
wait;
end process;

END;
