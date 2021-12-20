--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:06:40 12/18/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_delayed_circuit.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: delayed_circuit
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

ENTITY tb_delayed_circuit IS
END tb_delayed_circuit;

ARCHITECTURE behavior OF tb_delayed_circuit IS

COMPONENT delayed_circuit
PORT(
i_clock : IN  std_logic;
i_input : IN  std_logic;
o_output : OUT  std_logic
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_input : std_logic := '0';

--Outputs
signal o_output : std_logic;

signal clock : std_logic;
constant i_clock_period : time := 20 ns;

BEGIN

uut: delayed_circuit PORT MAP (
i_clock => i_clock,
i_input => i_input,
o_output => o_output
);

-- Clock process definitions
i_clock_process : process
begin
i_clock <= '0';
wait for i_clock_period/2;
i_clock <= '1';
wait for i_clock_period/2;
end process;

-- Stimulus process
stim_proc : process
	variable v1 : std_logic_vector(7 downto 0) := "00000001";
begin
wait for i_clock_period*1;
-- insert stimulus here
--l0 : for i in 0 to 3 loop
--	l1 : for j in 0 to 7 loop
--		i_input <= v1(j); wait for i_clock_period*1;
--	end loop l1;
--	i_input <= not (v1(0) xor v1(1) xor v1(2) xor v1(3) xor v1(4) xor v1(5) xor v1(6) xor v1(7)); wait for i_clock_period*1;
--	i_input <= (v1(0) xor v1(1) xor v1(2) xor v1(3) xor v1(4) xor v1(5) xor v1(6) xor v1(7)); wait for i_clock_period*1;
--end loop l0;

i_input <= '1'; wait for 1 ns;
i_input <= '0'; wait for 1 ns;
wait for 256 ns;
i_input <= '1'; wait for 1 ns;
i_input <= '0'; wait for 1 ns;
i_input <= '1'; wait for 1 ns;
i_input <= '0'; wait for 1 ns;
i_input <= '1'; wait for 1 ns;
i_input <= '1'; wait for 1 ns;


report "done" severity failure;
wait;
end process;

END;
