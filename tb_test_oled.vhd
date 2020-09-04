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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY tb_test_oled IS
END tb_test_oled;
 
ARCHITECTURE behavior OF tb_test_oled IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT test_oled
    PORT(
         i_clk : IN  std_logic;
         i_char : in std_logic_vector(11 downto 0);
         io_sda : INOUT  std_logic;
         io_scl : INOUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal char : std_logic_vector(11 downto 0) := (others => '0'); -- "000101000101"; -- 325, 'A'

	--BiDirs
   signal sda : std_logic;
   signal scl : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: test_oled PORT MAP (
          i_clk => clk,
          i_char => char,
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
 
   -- Stimulus process
   stim_proc: process
   begin
      -- insert stimulus here
		l0 : for i in 0 to 1 loop
			char <= std_logic_vector(to_unsigned(325+(5*i),char'length));
		end loop l0;
      wait;
   end process;

END;
