--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:50:27 12/09/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/weirdboyjim_circuits/tb_ic_sn74als165.vhd
-- Project Name:  weirdboyjim_circuits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ic_sn74als165
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

ENTITY tb_ic_sn74als165 IS
END tb_ic_sn74als165;

ARCHITECTURE behavior OF tb_ic_sn74als165 IS

	COMPONENT ic_sn74als165
	PORT(
		i_sh_ld : IN  std_logic;
		i_clk : IN  std_logic;
		i_clk_inh : IN  std_logic;
		i_ser : IN  std_logic;
		i_d0 : IN  std_logic;
		i_d1 : IN  std_logic;
		i_d2 : IN  std_logic;
		i_d3 : IN  std_logic;
		i_d4 : IN  std_logic;
		i_d5 : IN  std_logic;
		i_d6 : IN  std_logic;
		i_d7 : IN  std_logic;
		o_q7 : OUT  std_logic;
		o_q7_not : OUT  std_logic
	);
	END COMPONENT;

	--Inputs
	signal i_sh_ld : std_logic := '0';
	signal i_clk : std_logic := '0';
	signal i_clk_inh : std_logic := '0';
	signal i_ser : std_logic := '0';
	signal i_d0 : std_logic := '0';
	signal i_d1 : std_logic := '0';
	signal i_d2 : std_logic := '0';
	signal i_d3 : std_logic := '0';
	signal i_d4 : std_logic := '0';
	signal i_d5 : std_logic := '0';
	signal i_d6 : std_logic := '0';
	signal i_d7 : std_logic := '0';

	--Outputs
	signal o_q7 : std_logic;
	signal o_q7_not : std_logic;

	signal clock : std_logic;
	constant clock_period : time := 20 ns;

BEGIN

	uut: ic_sn74als165 PORT MAP (
		i_sh_ld => i_sh_ld,
		i_clk => i_clk,
		i_clk_inh => i_clk_inh,
		i_ser => i_ser,
		i_d0 => i_d0,
		i_d1 => i_d1,
		i_d2 => i_d2,
		i_d3 => i_d3,
		i_d4 => i_d4,
		i_d5 => i_d5,
		i_d6 => i_d6,
		i_d7 => i_d7,
		o_q7 => o_q7,
		o_q7_not => o_q7_not
	);

	clock_process :process
	begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
	end process;

	i_clk <= clock;
	i_clk_inh <= '1';

	-- Stimulus process
	stim_proc : process
	begin
		i_sh_ld <= '1';
		wait for 100 ns;
		i_sh_ld <= '0';
		wait for clock_period*1;
		i_sh_ld <= '1';
		-- insert stimulus here
		i_ser <= '1'; wait for clock_period*1;
		i_ser <= '1'; wait for clock_period*1;
		i_ser <= '0'; wait for clock_period*1;
		i_ser <= '1'; wait for clock_period*1;
		i_ser <= '0'; wait for clock_period*1;
		i_ser <= '1'; wait for clock_period*1;
		i_ser <= '0'; wait for clock_period*1;
		i_ser <= '1'; wait for clock_period*1;
		i_ser <= 'U';
		wait for clock_period*10;
		i_sh_ld <= '0';
		i_d0 <= '1';
		i_d1 <= '1';
		i_d2 <= '0';
		i_d3 <= '1';
		i_d4 <= '0';
		i_d5 <= '1';
		i_d6 <= '0';
		i_d7 <= '1';
		wait for clock_period*1;
		i_sh_ld <= '1';
		wait;
	end process;

END;
