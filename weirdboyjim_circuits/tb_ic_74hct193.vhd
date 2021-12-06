--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:08:54 12/03/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/weirdboyjim_circuits/tb_ic_74hct193.vhd
-- Project Name:  weirdboyjim_circuits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ic_74hct193
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

ENTITY tb_ic_74hct193 IS
END tb_ic_74hct193;

ARCHITECTURE behavior OF tb_ic_74hct193 IS

	COMPONENT ic_74hct193
	PORT(
		i_clock : IN  std_logic;
		i_d0 : IN  std_logic;
		i_d1 : IN  std_logic;
		i_d2 : IN  std_logic;
		i_d3 : IN  std_logic;
		o_q0 : OUT  std_logic;
		o_q1 : OUT  std_logic;
		o_q2 : OUT  std_logic;
		o_q3 : OUT  std_logic;
		i_cpd : IN  std_logic;
		i_cpu : IN  std_logic;
		i_pl : IN  std_logic;
		o_tcu : OUT  std_logic;
		o_tcd : OUT  std_logic;
		i_mr : IN  std_logic
	);
	END COMPONENT;

	--Inputs
	signal i_d0 : std_logic := '0';
	signal i_d1 : std_logic := '0';
	signal i_d2 : std_logic := '0';
	signal i_d3 : std_logic := '0';
	signal i_cpd : std_logic := '0';
	signal i_cpu : std_logic := '0';
	signal i_pl : std_logic := '0';
	signal i_mr : std_logic := '0';

	--Outputs
	signal o_q0 : std_logic;
	signal o_q1 : std_logic;
	signal o_q2 : std_logic;
	signal o_q3 : std_logic;
	signal o_tcu : std_logic;
	signal o_tcd : std_logic;

	signal o_d03 : std_logic_vector(3 downto 0);

	signal clock : std_logic;
	constant clock_period : time := 10 ns;

BEGIN

	o_d03(0) <= o_q0;
	o_d03(1) <= o_q1;
	o_d03(2) <= o_q2;
	o_d03(3) <= o_q3;

	uut: ic_74hct193 PORT MAP (
		i_clock => clock,
		i_d0 => i_d0,
		i_d1 => i_d1,
		i_d2 => i_d2,
		i_d3 => i_d3,
		o_q0 => o_q0,
		o_q1 => o_q1,
		o_q2 => o_q2,
		o_q3 => o_q3,
		i_cpd => i_cpd,
		i_cpu => i_cpu,
		i_pl => i_pl,
		o_tcu => o_tcu,
		o_tcd => o_tcd,
		i_mr => i_mr
	);

	clock_process :process
	begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
	end process;

	i_cpu <= clock;
	i_cpd <= '1';

	stim_proc: process
	begin
		wait for clock_period*10;
		-- insert stimulus here
		i_mr <= '1';
		i_pl <= '0';
		
		wait for clock_period*10;
		i_mr <= '0';
		i_pl <= '0';

		wait;
	end process;

END;
