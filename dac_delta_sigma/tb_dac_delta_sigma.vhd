--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:53:38 03/03/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/dac_delta_sigma/tb_dac_delta_sigma.vhd
-- Project Name:  dac_delta_sigma
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: dac_delta_sigma
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
 
ENTITY tb_dac_delta_sigma IS
END tb_dac_delta_sigma;
 
ARCHITECTURE behavior OF tb_dac_delta_sigma IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dac_delta_sigma
    PORT(
         clk : IN  std_logic;
         data : IN  std_logic_vector(0 to 7);
         PulseStream : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal data : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal PulseStream : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: dac_delta_sigma PORT MAP (
          clk => clk,
          data => data,
          PulseStream => PulseStream
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
		variable cp : integer := 15;
   begin
	 for i in 0 to 255 loop
			data <= std_logic_vector(to_unsigned(i,8));
			wait for cp*clk_period;
	 end loop;
	 for i in 0 to 255 loop
			data <= std_logic_vector(to_unsigned(255-i,8));
			wait for cp*clk_period;
	 end loop;
	 wait;
   end process;

END;
