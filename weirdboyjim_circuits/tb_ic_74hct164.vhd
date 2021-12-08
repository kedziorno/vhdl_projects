--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:59:56 12/08/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/weirdboyjim_circuits/tb_ic_74hct164.vhd
-- Project Name:  weirdboyjim_circuits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ic_74hct164
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

ENTITY tb_ic_74hct164 IS
END tb_ic_74hct164;

ARCHITECTURE behavior OF tb_ic_74hct164 IS

	COMPONENT ic_74hct164
	PORT(
		i_dsa : IN  std_logic;
		i_dsb : IN  std_logic;
		i_cp : IN  std_logic;
		i_mr : IN  std_logic;
		o_q0 : OUT  std_logic;
		o_q1 : OUT  std_logic;
		o_q2 : OUT  std_logic;
		o_q3 : OUT  std_logic;
		o_q4 : OUT  std_logic;
		o_q5 : OUT  std_logic;
		o_q6 : OUT  std_logic;
		o_q7 : OUT  std_logic
	);
	END COMPONENT;
	for all : ic_74hct164 use entity WORK.ic_74hct164(Behavioral);

	--Inputs
	signal i_dsa : std_logic := '0';
	signal i_dsb : std_logic := '0';
	signal i_cp : std_logic := '0';
	signal i_mr : std_logic := '0';

	--Outputs
	signal o_q0 : std_logic;
	signal o_q1 : std_logic;
	signal o_q2 : std_logic;
	signal o_q3 : std_logic;
	signal o_q4 : std_logic;
	signal o_q5 : std_logic;
	signal o_q6 : std_logic;
	signal o_q7 : std_logic;

	signal clock : std_logic;
	constant clock_period : time := 20 ns;

	signal vtemp : std_logic_vector(7 downto 0);

BEGIN

	vtemp(0) <= o_q0;
	vtemp(1) <= o_q1;
	vtemp(2) <= o_q2;
	vtemp(3) <= o_q3;
	vtemp(4) <= o_q4;
	vtemp(5) <= o_q5;
	vtemp(6) <= o_q6;
	vtemp(7) <= o_q7;

	uut: ic_74hct164 PORT MAP (
		i_dsa => i_dsa,
		i_dsb => i_dsb,
		i_cp => i_cp,
		i_mr => i_mr,
		o_q0 => o_q0,
		o_q1 => o_q1,
		o_q2 => o_q2,
		o_q3 => o_q3,
		o_q4 => o_q4,
		o_q5 => o_q5,
		o_q6 => o_q6,
		o_q7 => o_q7
	);

	clock_process :process
	begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
	end process;

	i_cp <= clock;

	-- Stimulus process
	stim_proc: process
	begin
		i_mr <= '0';
		wait for 100 ns;
		i_mr <= '0';
		wait for clock_period*10;
		i_mr <= '1';
		i_dsa <= '1';
		-- insert stimulus here 
		i_dsb <= '1'; wait for clock_period*1;
		i_dsb <= '0'; wait for clock_period*1;
		i_dsb <= '1'; wait for clock_period*1;
		i_dsb <= '0'; wait for clock_period*1;
		i_dsb <= '1'; wait for clock_period*1;
		i_dsb <= '0'; wait for clock_period*1;
		i_dsb <= '1'; wait for clock_period*1;
		i_dsb <= '1'; wait for clock_period*1;
		wait;
	end process;

END;
