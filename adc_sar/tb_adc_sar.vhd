--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:18:12 08/25/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/adc_sar/tb_adc_sar.vhd
-- Project Name:  adc_sar
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: adc_sar
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

ENTITY tb_adc_sar IS
END tb_adc_sar;

ARCHITECTURE behavior OF tb_adc_sar IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT adc_sar
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
i_from_comparator : IN  std_logic;
i_soc : IN  std_logic;
o_soc : OUT  std_logic;
io_ladder : INOUT  std_logic_vector(11 downto 0);
o_anode : OUT  std_logic_vector(3 downto 0);
o_segment : OUT  std_logic_vector(6 downto 0);
o_eoc : OUT  std_logic
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_from_comparator : std_logic := '0';
signal i_soc : std_logic := '0';

--BiDirs
signal io_ladder : std_logic_vector(11 downto 0);

--Outputs
signal o_soc : std_logic;
signal o_anode : std_logic_vector(3 downto 0);
signal o_segment : std_logic_vector(6 downto 0);
signal o_eoc : std_logic;

-- Clock period definitions
constant i_clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: adc_sar PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_from_comparator => i_from_comparator,
i_soc => i_soc,
o_soc => o_soc,
io_ladder => io_ladder,
o_anode => o_anode,
o_segment => o_segment,
o_eoc => o_eoc
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

-- insert stimulus here

wait;
end process;

END;
