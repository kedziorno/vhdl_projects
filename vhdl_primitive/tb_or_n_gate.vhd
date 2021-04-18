--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:16:33 04/18/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_or_n_gate.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: OR_N_GATE
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

ENTITY tb_or_n_gate IS
END tb_or_n_gate;

ARCHITECTURE behavior OF tb_or_n_gate IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT OR_N_GATE
PORT(
input : IN  std_logic_vector(7 downto 0);
output : OUT  std_logic
);
END COMPONENT;


--Inputs
signal input : std_logic_vector(7 downto 0) := (others => '0');

--Outputs
signal output : std_logic;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: OR_N_GATE PORT MAP (
input => input,
output => output
);

-- Stimulus process
stim_proc: process
begin
-- insert stimulus here
input <= (others => '1');
wait for 100 ns;
input <= (others => '0');
wait for 100 ns;
input <= "10101010";
wait for 100 ns;
input <= "01010101";
wait for 100 ns;
input <= "00000001";
wait for 100 ns;
input <= "10000001";
wait for 100 ns;
input <= "11111111";
wait for 100 ns;
wait;
end process;

END;
