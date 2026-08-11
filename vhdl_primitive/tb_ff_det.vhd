--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:58:37 06/29/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_ff_det.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FF_D_DUAL_EDGE_TRIGGERED
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

ENTITY tb_ff_det IS
END tb_ff_det;

ARCHITECTURE behavior OF tb_ff_det IS 

	 -- Component Declaration for the Unit Under Test (UUT)

	 COMPONENT FF_D_DUAL_EDGE_TRIGGERED
	 PORT(
				D : IN  std_logic;
				C : IN  std_logic;
				Q : OUT  std_logic
			 );
	 END COMPONENT;
	 

	--Inputs
	signal D : std_logic := '0';
	signal C : std_logic := '0';

	--Outputs
	signal Q : std_logic;
	-- No clocks detected in port list. Replace <clock> below with 
	-- appropriate port name 

	constant C_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
	uut: FF_D_DUAL_EDGE_TRIGGERED PORT MAP (
				 D => D,
				 C => C,
				 Q => Q
			 );

	-- Clock process definitions
	C_process :process
	begin
	C <= '0';
	wait for C_period/2;
	C <= '1';
	wait for C_period/2;
	end process;


	-- Stimulus process
	stim_proc: process
	begin		
		 -- hold reset state for 100 ns.
--      wait for 100 ns;	

--      wait for <clock>_period*10;

		 -- insert stimulus here 
wait for c_period*4.5;
d <= '1';
wait for c_period;
d <= '0';
		 wait;
	end process;

END;
