--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:32:30 05/04/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_logic_analyser.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: logic_analyser
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

ENTITY tb_logic_analyser IS
END tb_logic_analyser;

ARCHITECTURE behavior OF tb_logic_analyser IS 

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT logic_analyser
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
i_data : IN  std_logic_vector(7 downto 0);
o_rs232_tx : OUT  std_logic;
oc0,ain1 : IN  std_logic
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_data : std_logic_vector(7 downto 0) := (others => '0');
signal oc0 : std_logic := '0';
signal ain1 : std_logic := '0';

--Outputs
signal o_rs232_tx : std_logic;

-- Clock period definitions
constant i_clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: logic_analyser PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_data => i_data,
o_rs232_tx => o_rs232_tx,
oc0 => oc0,
ain1 => ain1
);

-- Clock process definitions
i_clock_process :process
begin
i_clock <= '0';
wait for i_clock_period/2;
i_clock <= '1';
wait for i_clock_period/2;
end process;

--oc0 <= i_clock;

-- Stimulus process
stim_proc: process
constant N : integer := 256;
begin
-- hold reset state for 100 ns.
i_reset <= '1';
wait for i_clock_period;
i_reset <= '0';
wait for i_clock_period*10;
-- insert stimulus here
oc0 <= '1','0' after i_clock_period*200;
ain1 <= '1','0' after i_clock_period*200;
l0 : for i in 0 to N-1 loop
--ain1 <= '1';
i_data <= std_logic_vector(to_unsigned(i,8));
--wait for i_clock_period;
--ain1 <= '0';
wait for i_clock_period;
end loop l0;
wait;
end process;

END;
