--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:06:34 08/27/2023
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_test_add4.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: test_add4
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
 
ENTITY tb_test_add4 IS
END tb_test_add4;
 
ARCHITECTURE behavior OF tb_test_add4 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT test_add4
    PORT(
         i_clock : IN  std_logic;
         i_reset : IN  std_logic;
         ia : IN  std_logic_vector(3 downto 0);
         io : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_clock : std_logic := '0';
   signal i_reset : std_logic := '0';
   signal a : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal o : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant i_clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: test_add4 PORT MAP (
          i_clock => i_clock,
          i_reset => i_reset,
          ia => a,
          io => o
        );

   -- Clock process definitions
   i_clock_process :process
   begin
		i_clock <= '0';
		wait for i_clock_period/2;
		i_clock <= '1';
		wait for i_clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      i_reset <= '1';
      wait for 100 ns;	
i_reset <= '0';
      wait for i_clock_period*10;

      -- insert stimulus here 
a <= "0001"; wait for i_clock_period;
a <= "0010"; wait for i_clock_period;
a <= "0011"; wait for i_clock_period;
a <= "0100"; wait for i_clock_period;
a <= "0101"; wait for i_clock_period;
a <= "0110"; wait for i_clock_period;
a <= "0111"; wait for i_clock_period;
a <= "1000"; wait for i_clock_period;
a <= "1001"; wait for i_clock_period;
a <= "1010"; wait for i_clock_period;
a <= "1011"; wait for i_clock_period;
a <= "1100"; wait for i_clock_period;
a <= "1101"; wait for i_clock_period;
a <= "1110"; wait for i_clock_period;
a <= "1111"; wait for i_clock_period;
      wait;
   end process;

END;
