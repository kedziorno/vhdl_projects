--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:38:18 08/25/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/oled_128x32_1/tb_power_on.vhd
-- Project Name:  oled_128x32_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: power_on
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
 
ENTITY tb_power_on IS
END tb_power_on;
 
ARCHITECTURE behavior OF tb_power_on IS 

    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT power_on
    PORT(
         i_clk : IN  std_logic;
         i_reset : IN std_logic;
         o_sda : OUT  std_logic;
         o_scl : OUT  std_logic
        );
    END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal sda : std_logic;
   signal sck : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: power_on PORT MAP (
		i_clk => clk,
		i_reset => reset,
		o_sda => sda,
		o_scl => sck
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
		reset <= '1';
		wait for 100us;
		reset <= '0';
		wait;
	end process;

END;
