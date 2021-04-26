--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:06:44 04/25/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_mem_decoder_row.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mem_decoder_row
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

ENTITY tb_mem_decoder_row IS
END tb_mem_decoder_row;

ARCHITECTURE behavior OF tb_mem_decoder_row IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT mem_decoder_row
PORT(
decoder_row_input : IN  std_logic_vector(8 downto 0);
decoder_row_output : OUT  std_logic_vector(511 downto 0)
);
END COMPONENT;

--Inputs
signal decoder_row_input : std_logic_vector(8 downto 0) := (others => '0');

--Outputs
signal decoder_row_output : std_logic_vector(511 downto 0);

constant clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: mem_decoder_row PORT MAP (
decoder_row_input => decoder_row_input,
decoder_row_output => decoder_row_output
);

-- Stimulus process
stim_proc: process
begin
-- insert stimulus here
decoder_row_input <= "000000000";
wait for clock_period;
decoder_row_input <= "000000001";
wait for clock_period;
decoder_row_input <= "000000010";
wait for clock_period;
decoder_row_input <= "000000100";
wait for clock_period;
decoder_row_input <= "000001000";
wait for clock_period;
decoder_row_input <= "000010000";
wait for clock_period;
decoder_row_input <= "000100000";
wait for clock_period;
decoder_row_input <= "001000000";
wait for clock_period;
decoder_row_input <= "010000000";
wait for clock_period;
decoder_row_input <= "100000000";
wait for clock_period;
wait;
end process;

END;
