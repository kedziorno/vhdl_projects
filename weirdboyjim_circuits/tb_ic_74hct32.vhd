--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:22:01 11/28/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/weirdboyjim_circuits/tb_ic_74hct32.vhd
-- Project Name:  weirdboyjim_circuits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ic_74hct32
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

ENTITY tb_ic_74hct32 IS
END tb_ic_74hct32;

ARCHITECTURE behavior OF tb_ic_74hct32 IS

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ic_74hct32
	PORT(
		i_1a : IN  std_logic;
		i_1b : IN  std_logic;
		o_1y : OUT  std_logic;
		i_2a : IN  std_logic;
		i_2b : IN  std_logic;
		o_2y : OUT  std_logic;
		i_3a : IN  std_logic;
		i_3b : IN  std_logic;
		o_3y : OUT  std_logic;
		i_4a : IN  std_logic;
		i_4b : IN  std_logic;
		o_4y : OUT  std_logic
	);
	END COMPONENT;

	--Inputs
	signal i_1a : std_logic := 'U';
	signal i_1b : std_logic := 'U';
	signal i_2a : std_logic := 'U';
	signal i_2b : std_logic := 'U';
	signal i_3a : std_logic := 'U';
	signal i_3b : std_logic := 'U';
	signal i_4a : std_logic := 'U';
	signal i_4b : std_logic := 'U';

	--Outputs
	signal o_1y : std_logic;
	signal o_2y : std_logic;
	signal o_3y : std_logic;
	signal o_4y : std_logic;

	signal clock : std_logic;
	constant clock_period : time := 20 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ic_74hct32 PORT MAP (
		i_1a => i_1a,
		i_1b => i_1b,
		o_1y => o_1y,
		i_2a => i_2a,
		i_2b => i_2b,
		o_2y => o_2y,
		i_3a => i_3a,
		i_3b => i_3b,
		o_3y => o_3y,
		i_4a => i_4a,
		i_4b => i_4b,
		o_4y => o_4y
	);

	-- Clock process definitions
	clock_process : process
	begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
	end process;

	-- Stimulus process
	stim_proc: process
	begin
		-- hold reset state for 100 ns.
		wait for 100 ns;
		wait for clock_period * 10;

		-- insert stimulus here

		i_1a <= '0'; i_1b <= '0'; wait for clock_period * 10;
		i_1a <= '0'; i_1b <= '1'; wait for clock_period * 10;
		i_1a <= '1'; i_1b <= '0'; wait for clock_period * 10;
		i_1a <= '1'; i_1b <= '1'; wait for clock_period * 10;
		i_1a <= 'U'; i_1b <= 'U'; wait for clock_period * 10;

		i_2a <= '0'; i_2b <= '0'; wait for clock_period * 10;
		i_2a <= '0'; i_2b <= '1'; wait for clock_period * 10;
		i_2a <= '1'; i_2b <= '0'; wait for clock_period * 10;
		i_2a <= '1'; i_2b <= '1'; wait for clock_period * 10;
		i_2a <= 'U'; i_2b <= 'U'; wait for clock_period * 10;

		i_3a <= '0'; i_3b <= '0'; wait for clock_period * 10;
		i_3a <= '0'; i_3b <= '1'; wait for clock_period * 10;
		i_3a <= '1'; i_3b <= '0'; wait for clock_period * 10;
		i_3a <= '1'; i_3b <= '1'; wait for clock_period * 10;
		i_3a <= 'U'; i_3b <= 'U'; wait for clock_period * 10;

		i_4a <= '0'; i_4b <= '0'; wait for clock_period * 10;
		i_4a <= '0'; i_4b <= '1'; wait for clock_period * 10;
		i_4a <= '1'; i_4b <= '0'; wait for clock_period * 10;
		i_4a <= '1'; i_4b <= '1'; wait for clock_period * 10;
		i_4a <= 'U'; i_4b <= 'U'; wait for clock_period * 10;

		wait;
	end process;

END;
