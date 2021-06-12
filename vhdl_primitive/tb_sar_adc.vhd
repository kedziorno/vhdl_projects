--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:28:32 05/07/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_sar_adc.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sar_adc
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

ENTITY tb_sar_adc IS
END tb_sar_adc;

ARCHITECTURE behavior OF tb_sar_adc IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT sar_adc
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
o_data : OUT  std_logic_vector(7 downto 0);
o_to_pluscomparator : OUT  std_logic;
i_from_comparator : IN  std_logic;
o_sar_end : inout std_logic
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_from_comparator : std_logic := '0';

--Outputs
signal o_data : std_logic_vector(7 downto 0);
signal o_to_pluscomparator : std_logic;
signal o_sar_end : std_logic;

-- Clock period definitions
constant i_clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: sar_adc PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
o_data => o_data,
o_to_pluscomparator => o_to_pluscomparator,
i_from_comparator => i_from_comparator,
o_sar_end => o_sar_end
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
wait for 100 ns;
i_reset <= '0';
wait for i_clock_period*10;
i_from_comparator <= '1';
wait for i_clock_period;
i_from_comparator <= '0';
wait for i_clock_period;
i_from_comparator <= '1';
wait for i_clock_period;
i_from_comparator <= '0';
wait for i_clock_period;
i_from_comparator <= '1';
wait for i_clock_period;
i_from_comparator <= '0';
wait for i_clock_period;
i_from_comparator <= '1';
wait for i_clock_period;
i_from_comparator <= '0';
wait for i_clock_period;
--o_sar_end <= '1';
wait;
end process;

END;
