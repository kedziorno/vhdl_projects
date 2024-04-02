--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:20:50 03/18/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/memorydump_93LC46/tb_top.vhd
-- Project Name:  memorydump_93LC46
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
USE WORK.p_constants.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_top IS
END tb_top;

ARCHITECTURE behavior OF tb_top IS

	-- Component Declaration for the Unit Under Test (UUT)

	COMPONENT top
	GENERIC(
	G_BOARD_CLOCK : integer := G_BOARD_CLOCK_SIMULATE;
	G_BAUD_RATE : integer := G_BAUD_RATE
	);
	PORT(
	i_clock : IN  std_logic;
	i_reset : IN  std_logic;
	o_cs : OUT  std_logic;
	o_sk : OUT  std_logic;
	o_di : OUT  std_logic;
	i_do : IN  std_logic;
	o_RsTx : OUT  std_logic;
	i_RsRx : IN  std_logic
	);
	END COMPONENT;

	--Inputs
	signal i_clock : std_logic := '0';
	signal i_reset : std_logic := '0';
	signal i_do : std_logic := 'Z';
	signal i_RsRx : std_logic := '0';

	--Outputs
	signal o_cs : std_logic;
	signal o_sk : std_logic;
	signal o_di : std_logic;
	signal o_RsTx : std_logic;

	-- Clock period definitions
	constant i_clock_period : time := (1_000_000_000/G_BOARD_CLOCK_SIMULATE) * 1 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: top
	GENERIC MAP (
		G_BOARD_CLOCK => G_BOARD_CLOCK_SIMULATE,
		G_BAUD_RATE => G_BAUD_RATE
	)
	PORT MAP (
		i_clock => i_clock,
		i_reset => i_reset,
		o_cs => o_cs,
		o_sk => o_sk,
		o_di => o_di,
		i_do => i_do,
		o_RsTx => o_RsTx,
		i_RsRx => i_RsRx
	);

	-- Clock process definitions
	i_clock_process : process
	begin
		i_clock <= '0';
		wait for i_clock_period/2;
		i_clock <= '1';
		wait for i_clock_period/2;
	end process;

	i_reset <= '1', '0' after i_clock_period;

	-- Stimulus process
	stim_proc: process
	begin
		-- insert stimulus here
--		wait for 2001.45 ms + 250 ns; -- XXX use flag
--		i_do <= '0';
--		wait for 4*G_BOARD_CLOCK_SIMULATE*i_clock_period; -- XXX catch the ready on do pin
--		i_do <= '1';
--		wait for 200 ns + 1100 ns; -- XXX to re CLK
--		i_do <= 'Z';
		wait;
	end process;

END;
