--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:12:11 07/09/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_test_debouncebutton_lcddisplay.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: test_debouncebutton_lcddisplay
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
USE work.p_globals.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_test_debouncebutton_lcddisplay IS
END tb_test_debouncebutton_lcddisplay;

ARCHITECTURE behavior OF tb_test_debouncebutton_lcddisplay IS 

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT test_debouncebutton_lcddisplay
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
i_up : IN  std_logic;
i_down : IN  std_logic;
o_seg : OUT  std_logic_vector(6 downto 0);
o_an : OUT  std_logic_vector(3 downto 0)
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_up : std_logic := '0';
signal i_down : std_logic := '0';

--Outputs
signal o_seg : std_logic_vector(6 downto 0);
signal o_an : std_logic_vector(3 downto 0);

-- Clock period definitions
constant i_clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: test_debouncebutton_lcddisplay PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_up => i_up,
i_down => i_down,
o_seg => o_seg,
o_an => o_an
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
i_up <= '1';
wait for G_DEBOUNCE_MS*1000*1000*1 ns;
i_up <= '0';
wait for i_clock_period;
i_down <= '1';
wait for G_DEBOUNCE_MS*1000*1000*1 ns;
i_down <= '0';
wait for i_clock_period;

wait;
end process;

END;
