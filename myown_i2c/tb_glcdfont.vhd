--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:47:46 09/04/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/i2c_test_1/tb_glcdfont.vhd
-- Project Name:  i2c_test_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: glcdfont
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

ENTITY tb_glcdfont IS END tb_glcdfont;

ARCHITECTURE behavior OF tb_glcdfont IS 
	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT glcdfont
	PORT(
		i_clk : IN  std_logic;
		i_index : IN  std_logic_vector(11 downto 0);
		o_character : OUT  std_logic_vector(7 downto 0)
		);
	END COMPONENT;

   -- Inputs
   signal i_clk : std_logic;
   signal i_index : std_logic_vector(11 downto 0) := (others => '0');

   -- Outputs
   signal o_character : std_logic_vector(7 downto 0);

   constant clock_period : time := 10 ns;
   constant NUMBER_GLCDFONTC : natural := 1275; -- from tested file

BEGIN
	-- Instantiate the Unit Under Test (UUT)
	uut: glcdfont PORT MAP (
		i_clk => i_clk,
		i_index => i_index,
		o_character => o_character
	);

	-- Clock process definitions
	clock_process :process
	begin
		i_clk <= '0';
		wait for clock_period/2;
		i_clk <= '1';
		wait for clock_period/2;
	end process;
 

	-- Stimulus process
	stim_proc: process
	begin		
		-- insert stimulus here 
		i_index <= std_logic_vector(to_unsigned(0,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(5,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(10,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(15,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(20,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(25,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(30,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(35,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(40,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(45,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(NUMBER_GLCDFONTC-25-1,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(NUMBER_GLCDFONTC-20-1,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(NUMBER_GLCDFONTC-15-1,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(NUMBER_GLCDFONTC-10-1,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(NUMBER_GLCDFONTC-5-1,i_index'length));
		wait for 10 ns;
		i_index <= std_logic_vector(to_unsigned(NUMBER_GLCDFONTC-1,i_index'length));
		wait for 10 ns;
	end process;
END;
