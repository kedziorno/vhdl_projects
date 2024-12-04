--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:09:27 06*05*2023
-- Design Name:   
-- Module Name:   *home*user*workspace*vhdl_projects*vhdl_primitive*tb_fig_3_22.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fig_3_22
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
-- that these types always be used for the top-level I*O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_fig_3_22 IS
END tb_fig_3_22;

ARCHITECTURE behavior OF tb_fig_3_22 IS 

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT fig_3_22
PORT(
clk : IN  std_logic;
reset : IN  std_logic;
Bin : IN  std_logic;
Bout : OUT  std_logic
);
END COMPONENT;

--Inputs
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal Bin : std_logic := '0';

--Outputs
signal Bout : std_logic;

-- Clock period definitions
constant clk_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: fig_3_22 PORT MAP (
clk => clk,
reset => reset,
Bin => Bin,
Bout => Bout
);

-- Clock process definitions
clk_process :process
begin
clk <= '0';
wait for clk_period/2;
clk <= '1';
wait for clk_period/2;
end process;

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
reset <= '1';
wait for 100 ns;
reset <= '0';
-- insert stimulus here
wait for clk_period*0.5;
Bin <= '1'; wait for clk_period;
Bin <= '0'; wait for clk_period;
Bin <= '0'; wait for clk_period;
Bin <= '0'; wait for clk_period;
Bin <= '0';
wait for 8*clk_period;

Bin <= '1'; wait for clk_period;
Bin <= '0'; wait for clk_period;
Bin <= '0'; wait for clk_period;
Bin <= '0'; wait for clk_period;
Bin <= '0';
wait for 8*clk_period;

Bin <= '1'; wait for clk_period;
Bin <= '0'; wait for clk_period;
Bin <= '0'; wait for clk_period;
Bin <= '0'; wait for clk_period;
Bin <= '0';
wait for 8*clk_period;

report "done tb" severity failure;
end process;

END;
