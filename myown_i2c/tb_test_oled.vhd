--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:51:58 08/28/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/i2c_test_1/tb_test_oled.vhd
-- Project Name:  i2c_test_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: test_oled
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
USE WORK.p_constants1.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY tb_test_oled IS
END tb_test_oled;
 
ARCHITECTURE behavior OF tb_test_oled IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
		COMPONENT test_oled
		GENERIC (
		g_board_clock : integer := G_BOARD_CLOCK;
		g_bus_clock : integer := G_BUS_CLOCK
		);
		PORT(
		i_clk : IN  std_logic;
		i_rst : IN  std_logic;
		i_refresh : IN  std_logic;
		io_sda : INOUT  std_logic;
		io_scl : INOUT  std_logic
		);
		END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal refresh : std_logic := '0';

	--BiDirs
   signal sda : std_logic;
   signal scl : std_logic;

   -- Clock period definitions
	 constant clk_period : time := (1_000_000_000/G_BOARD_CLOCK) * 1 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: test_oled
	GENERIC MAP (
		G_BOARD_CLOCK => G_BOARD_CLOCK,
		G_BUS_CLOCK => G_BUS_CLOCK
	)
	PORT MAP (
		i_clk => clk,
		i_rst => rst,
		i_refresh => refresh,
		io_sda => sda,
		io_scl => scl
	);

	-- Clock process definitions
	clk_process :process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

rst <= '1','0' after clk_period;

	-- Stimulus process
	stim_proc: process
	begin
--		wait for 60 ms;
--		refresh <= '1';
--		wait for 20 ns;
--		refresh <= '0';
		wait;
	end process;

END;
