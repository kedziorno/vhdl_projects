--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:04:09 05/09/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_leddet.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: LEDDET
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
 
ENTITY tb_leddet IS
END tb_leddet;
 
ARCHITECTURE behavior OF tb_leddet IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT LEDDET
    PORT(
         Clock : IN  std_logic;
         Reset : IN  std_logic;
         Trigger : IN  std_logic;
         LED : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal Reset : std_logic := '0';
   signal Trigger : std_logic := '0';

 	--Outputs
   signal LED : std_logic;

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: LEDDET PORT MAP (
          Clock => Clock,
          Reset => Reset,
          Trigger => Trigger,
          LED => LED
        );

   -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
			Reset <= '1';
      wait for 100 ns;	
			Reset <= '0';
      wait for Clock_period*10;
			Trigger <= '1';
			wait for Clock_period*100;
			Trigger <= '0';
			wait for Clock_period;
			Trigger <= '1';
			wait for Clock_period*100;
			Trigger <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
