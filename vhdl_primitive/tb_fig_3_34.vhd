--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:16:36 06/06/2023
-- Design Name:   Mo-type NRZ-to-Manchester encoder
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_fig_3_34.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fig_3_34
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

ENTITY tb_fig_3_34 IS
END tb_fig_3_34;

ARCHITECTURE behavior OF tb_fig_3_34 IS 

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT fig_3_34
PORT(
clk : IN  std_logic;
reset : IN  std_logic;
Bin : IN  std_logic;
Bout : OUT  std_logic
);
END COMPONENT;

--Inputs
signal reset : std_logic := '0';
signal Bin : std_logic := '0';

--Outputs
signal Bout : std_logic;

signal clk1x : std_logic := '0';
signal clk2x : std_logic := '0';
-- Clock period definitions
constant clk_period1x : time := 20 ns;
constant clk_period2x : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: fig_3_34 PORT MAP (
clk => clk2x,
reset => reset,
Bin => Bin,
Bout => Bout
);

-- Clock process definitions
clk_process1x :process
begin
clk1x <= '0';
wait for clk_period1x/2;
clk1x <= '1';
wait for clk_period1x/2;
end process;

clk_process2x :process
begin
clk2x <= '1';
wait for clk_period2x/2;
clk2x <= '0';
wait for clk_period2x/2;
end process;

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
reset <= '1';
wait for 100 ns;
reset <= '0';
-- insert stimulus here
--wait for clk_period1x/1.7;
Bin <= '0'; wait for clk_period1x;
Bin <= '1'; wait for clk_period1x;
Bin <= '1'; wait for clk_period1x;
Bin <= '1'; wait for clk_period1x;
Bin <= '0'; wait for clk_period1x;
Bin <= '0'; wait for clk_period1x;
Bin <= '1'; wait for clk_period1x;
Bin <= '0'; wait for clk_period1x;
report "tb done" severity failure;
end process;

END;
