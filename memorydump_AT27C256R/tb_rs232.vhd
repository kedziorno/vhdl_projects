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

ENTITY tb_rs232 IS END tb_rs232;

ARCHITECTURE behavior OF tb_rs232 IS 

	constant NUMBER_BITS : integer := 8;
	
	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT rs232
	PORT(
		clk : IN  std_logic;
		rst : IN  std_logic;
		byte_to_send : IN  std_logic_vector (NUMBER_BITS-1 downto 0);
		RsTx : OUT  std_logic;
		RsRx : IN  std_logic
	);
	END COMPONENT;

	--Inputs
	signal clk : std_logic;
	signal rst : std_logic;
	signal byte_to_send : std_logic_vector (NUMBER_BITS-1 downto 0);
	signal rx : std_logic;
	
	--Outputs
	signal tx : std_logic;

	-- Clock period definitions
	constant clk_period : time := 20 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: rs232 PORT MAP (
		clk => clk,
		rst => rst,
		byte_to_send => byte_to_send,
		RsTx => tx,
		RsRx => rx
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
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		--wait for clk_period*10;
		-- insert stimulus here
		byte_to_send <= "10101010";
		wait for 20 ms;
		byte_to_send <= "00000000";
		wait for 20 ms;
		byte_to_send <= "01010101";
		wait for 20 ms;
		byte_to_send <= "11111111";
		wait for 20 ms;
		
		wait;
	end process;

END;
