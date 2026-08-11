--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:57:37 07/05/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_circuit_ripplecounter_dff.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: circuit_ripplecounter_dff
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

ENTITY tb_circuit_ripplecounter_dff IS
END tb_circuit_ripplecounter_dff;

ARCHITECTURE behavior OF tb_circuit_ripplecounter_dff IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT circuit_ripplecounter_dff
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
i_input : IN  std_logic;
o_output : OUT  std_logic
);
END COMPONENT;


--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_input : std_logic := '0';

--Outputs
signal o_output : std_logic;

-- Clock period definitions
constant i_clock_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: circuit_ripplecounter_dff PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_input => i_input,
o_output => o_output
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
wait for 10*i_clock_period;	
i_reset <= '0';
wait for i_clock_period*10;

-- insert stimulus here 
i_input <= '1';
wait for 20*i_clock_period;
i_input <= '0';
wait for i_clock_period;


wait;
end process;

END;
