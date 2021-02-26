--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:54:47 02/26/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/pwm_led/tb_pwm_new.vhd
-- Project Name:  pwm_led
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pwm_new
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
 
ENTITY tb_pwm_new IS
END tb_pwm_new;
 
ARCHITECTURE behavior OF tb_pwm_new IS 
 
		constant PWM_WIDTH : integer := 4;
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pwm_new
		GENERIC (PWM_WIDTH : integer);
    PORT(
         i_clock : IN  std_logic;
         i_reset : IN  std_logic;
				 i_load : in  STD_LOGIC;
         i_data : IN  INTEGER RANGE 0 TO 2**PWM_WIDTH;
         o_pwm : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_clock : std_logic := '0';
   signal i_reset : std_logic := '0';
   signal i_load : std_logic := '0';
   signal i_data : INTEGER RANGE 0 TO 2**PWM_WIDTH := 0;

 	--Outputs
   signal o_pwm : std_logic;

   -- Clock period definitions
   constant i_clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pwm_new GENERIC MAP (PWM_WIDTH => PWM_WIDTH) PORT MAP (
          i_clock => i_clock,
          i_reset => i_reset,
          i_load => i_load,
          i_data => i_data,
          o_pwm => o_pwm
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
		variable wait_pwm : integer := 2**PWM_WIDTH-1;
		variable i_clock_period : time := i_clock_period;
   begin		
      -- hold reset state for 100 ns.
			i_reset <= '1';
      wait for i_clock_period;	
			i_reset <= '0';

			for i in 0 to 2**PWM_WIDTH-1 loop
				i_load <= '1';
				i_data <= i;
				wait for i_clock_period;
				i_load <= '0';
				wait for i_clock_period*wait_pwm;
			end loop;

			i_reset <= '1';
			wait for i_clock_period;
			i_reset <= '0';

			for i in 0 to 2**PWM_WIDTH-1 loop
				i_load <= '1';
				i_data <= ((2**PWM_WIDTH-1) - i);
				wait for i_clock_period;
				i_load <= '0';
				wait for i_clock_period*wait_pwm;
			end loop;

   end process;

END;
