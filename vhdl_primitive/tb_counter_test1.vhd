--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:08:30 12/04/2024
-- Design Name:   
-- Module Name:   /home/user/_WORKSPACE_/kedziorno/vhdl_projects/vhdl_primitive/tb_counter_test1.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: counter_test1
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
USE ieee.numeric_std.ALL;

ENTITY tb_counter_test1 IS
END tb_counter_test1;

ARCHITECTURE behavior OF tb_counter_test1 IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT counter_test1
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
y_inc : OUT  signed(31 downto 0);
y_dec : OUT  signed(31 downto 0)
);
END COMPONENT;


--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';

--Outputs
signal y_inc : signed(31 downto 0);
signal y_dec : signed(31 downto 0);

-- Clock period definitions
constant i_clock_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: counter_test1 PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
y_inc => y_inc,
y_dec => y_dec
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
wait for 1 ms;
report "tb done" severity failure;
end process;

END;
