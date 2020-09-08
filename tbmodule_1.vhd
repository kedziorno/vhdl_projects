--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:00:19 09/08/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/rs232_1/tbmodule_1.vhd
-- Project Name:  rs232_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: module_1
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

ENTITY tbmodule_1 IS END tbmodule_1;

ARCHITECTURE behavior OF tbmodule_1 IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT module_1
	PORT(
		clk : IN  std_logic_vector(0 downto 0);
		RsTx : OUT  std_logic_vector(0 downto 0);
		RsRx : IN  std_logic_vector(0 downto 0)
	);
	END COMPONENT;

	--Inputs
	signal clk : std_logic_vector(0 downto 0) := (others => '0');
	signal rx : std_logic_vector(0 downto 0) := (others => '0');

	--Outputs
	signal tx : std_logic_vector(0 downto 0) := (others => '0');

	-- Clock period definitions
	constant clk_period : time := 20 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: module_1 PORT MAP (
		clk => clk,
		RsTx => tx,
		RsRx => rx
	);

	-- Clock process definitions
	clk_process :process
	begin
		clk <= std_logic_vector(to_unsigned(0,1));
		wait for clk_period/2;
		clk <= std_logic_vector(to_unsigned(1,1));
		wait for clk_period/2;
	end process;

	-- Stimulus process
	stim_proc: process
	begin
		-- hold reset state for 100 ns.
		--wait for 100 ns;
		--wait for clk_period*10;
		-- insert stimulus here
		wait;
	end process;

END;
