--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:29:18 02/24/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/logicanalyser/tb_top.vhd
-- Project Name:  logicanalyser
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

	-- Constants
	constant G_BOARD_CLOCK : integer := 50_000_000;

	-- Component Declaration for the Unit Under Test (UUT)

	COMPONENT top
	PORT(
		clk : IN  std_logic;
		btn0 : IN  std_logic;
		RsTx : OUT  std_logic;
		RsRx : IN  std_logic;
		JA : INOUT std_logic_vector(7 downto 0);
		JB : INOUT std_logic_vector(7 downto 0);
		JC : INOUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	--Inputs
	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal RsRx : std_logic := '0';
	signal JA : std_logic_vector(7 downto 0) := (others => '0');
	signal JB : std_logic_vector(7 downto 0) := (others => '0');
	signal JC : std_logic_vector(7 downto 0) := (others => '0');

	--Outputs
	signal RsTx : std_logic;

	-- Clock period definitions
	constant clk_period : time := (1_000_000_000/G_BOARD_CLOCK) * 1 ns;

	signal finish_simulation : std_logic := '0';

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut_top : top
	PORT MAP (
		clk => clk,
		btn0 => rst,
		RsTx => RsTx,
		RsRx => RsRx,
		JA => JA,
		JB => JB,
		JC => JC
	);

	-- Clock process definitions
	clk_process :process
	begin
		while finish_simulation = '0' loop
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
		end loop;
		wait;
	end process;

	rst <= '1', '0' after clk_period;

	-- Stimulus process
	stim_proc: process
	begin
		-- insert stimulus here

		wait;
	end process;

END;
