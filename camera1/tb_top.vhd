--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:33:49 06/23/2022
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/camera1/tb_top.vhd
-- Project Name:  camera1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
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

ENTITY tb_top IS
END tb_top;

ARCHITECTURE behavior OF tb_top IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT top
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
o_r : OUT  std_logic_vector(2 downto 0);
o_g : OUT  std_logic_vector(2 downto 0);
o_b : OUT  std_logic_vector(1 downto 0);
o_h : OUT  std_logic;
o_v : OUT  std_logic
);
END COMPONENT;


--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';

--Outputs
signal o_r : std_logic_vector(2 downto 0);
signal o_g : std_logic_vector(2 downto 0);
signal o_b : std_logic_vector(1 downto 0);
signal o_h : std_logic;
signal o_v : std_logic;

-- Clock period definitions
constant i_clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: top PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
o_r => o_r,
o_g => o_g,
o_b => o_b,
o_h => o_h,
o_v => o_v
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
