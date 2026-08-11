--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:22:35 02/26/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/pwm_led/tb_pwm.vhd
-- Project Name:  pwm_led
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PWM
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
 
ENTITY tb_pwm IS
END tb_pwm;
 
ARCHITECTURE behavior OF tb_pwm IS 
		constant PWM_RES : integer := 4;
		
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PWM
		GENERIC (PWM_RES : integer);
    PORT(
         clk : IN  std_logic;
         res : IN  std_logic;
         ld : IN  std_logic;
         data : IN  std_logic_vector(PWM_RES-1 downto 0);
         pwm : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal res : std_logic := '0';
   signal ld : std_logic := '0';
   signal data : std_logic_vector(PWM_RES-1 downto 0) := (others => '0');

 	--Outputs
   signal o_pwm : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PWM GENERIC MAP (PWM_RES => PWM_RES)
	 PORT MAP (
          clk => clk,
          res => res,
          ld => ld,
          data => data,
          pwm => o_pwm
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
		variable period : integer := 8*2;
   begin		
      -- hold reset state for 100 ns.
			res <= '1';
      wait for 100 ns;
			res <= '0';
			
			ld <= '1';
			data <= x"F";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
			ld <= '1';
			data <= x"E";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
			ld <= '1';
			data <= x"D";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
			ld <= '1';
			data <= x"C";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
			ld <= '1';
			data <= x"B";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
			ld <= '1';
			data <= x"A";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
			ld <= '1';
			data <= x"9";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
			ld <= '1';
			data <= x"8";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
			ld <= '1';
			data <= x"7";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
			ld <= '1';
			data <= x"6";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
			ld <= '1';
			data <= x"5";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
			ld <= '1';
			data <= x"4";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
			ld <= '1';
			data <= x"3";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
			ld <= '1';
			data <= x"2";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
			ld <= '1';
			data <= x"1";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;

			ld <= '1';
			data <= x"0";
			wait for clk_period;
			ld <= '0';
			wait for period*clk_period;
			
   end process;

END;
