--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:22:53 04/28/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_ones_detector.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ones_detector
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

ENTITY tb_ones_detector IS
END tb_ones_detector;

ARCHITECTURE behavior OF tb_ones_detector IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT ones_detector
PORT(
x : IN  std_logic_vector(15 downto 1);
y : OUT  std_logic_vector(3 downto 0)
);
END COMPONENT;

--Inputs
signal x : std_logic_vector(15 downto 1) := (others => '0');

--Outputs
signal y : std_logic_vector(3 downto 0);

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: ones_detector PORT MAP (
x => x,
y => y
);

-- Stimulus process
stim_proc: process
begin		
-- insert stimulus here
wait for 500 ns;
x <= "010101010101010";
wait;
end process;

END;
