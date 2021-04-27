--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:45:41 04/26/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_mem_decoder_col.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mem_decoder_col
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

ENTITY tb_mem_decoder_col IS
END tb_mem_decoder_col;

ARCHITECTURE behavior OF tb_mem_decoder_col IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT mem_decoder_col
PORT(
decoder_col_input : IN  std_logic_vector(5 downto 0);
decoder_col_output : OUT  std_logic_vector(63 downto 0);
e : IN  STD_LOGIC
);
END COMPONENT;

--Inputs
signal decoder_col_input : std_logic_vector(5 downto 0) := (others => '0');
signal e : std_logic := '0';

--Outputs
signal decoder_col_output : std_logic_vector(63 downto 0);

constant clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: mem_decoder_col PORT MAP (
decoder_col_input => decoder_col_input,
decoder_col_output => decoder_col_output,
e => e
);

-- Stimulus process
stim_proc: process
begin
wait for 1 us;
-- insert stimulus here
e <= '1';
decoder_col_input <= "000000";
wait for clock_period;
e <= '0';

wait for clock_period;
e <= '1';
decoder_col_input <= "000001";
wait for clock_period;
e <= '0';

wait for clock_period;
e <= '1';
decoder_col_input <= "000010";
wait for clock_period;
e <= '0';

wait for clock_period;
e <= '1';
decoder_col_input <= "000100";
wait for clock_period;
e <= '0';

wait for clock_period;
e <= '1';
decoder_col_input <= "001000";
wait for clock_period;
e <= '0';

wait for clock_period;
e <= '1';
decoder_col_input <= "010000";
wait for clock_period;
e <= '0';

wait for clock_period;
e <= '1';
decoder_col_input <= "100000";
wait for clock_period;
e <= '0';

wait;
end process;

END;
