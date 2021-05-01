--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:18:54 05/01/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_sram_row.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sram_row
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

ENTITY tb_sram_row IS
END tb_sram_row;

ARCHITECTURE behavior OF tb_sram_row IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT sram_row
PORT(
i_tristate_input : IN  std_logic;
i_tristate_output : IN  std_logic;
i_address_col : IN  std_logic_vector(3 downto 0);
i_bit : IN  std_logic;
o_bit : OUT  std_logic
);
END COMPONENT;

--Inputs
signal i_tristate_input : std_logic := '0';
signal i_tristate_output : std_logic := '0';
signal i_address_col : std_logic_vector(3 downto 0) := (others => '0');
signal i_bit : std_logic := '0';

--Outputs
signal o_bit : std_logic;

constant clock_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: sram_row PORT MAP (
i_tristate_input => i_tristate_input,
i_tristate_output => i_tristate_output,
i_address_col => i_address_col,
i_bit => i_bit,
o_bit => o_bit
);

-- Stimulus process
stim_proc: process
begin
-- insert stimulus here
-- write
i_tristate_input <= '1';
i_address_col <= x"0";
i_bit <= '1';
wait for clock_period;
i_tristate_input <= '0';
wait for clock_period;

i_tristate_input <= '1';
i_address_col <= x"1";
i_bit <= '0';
wait for clock_period;
i_tristate_input <= '0';
wait for clock_period;

i_tristate_input <= '1';
i_address_col <= x"2";
i_bit <= '1';
wait for clock_period;
i_tristate_input <= '0';
wait for clock_period;

i_tristate_input <= '1';
i_address_col <= x"3";
i_bit <= '0';
wait for clock_period;
i_tristate_input <= '0';
wait for clock_period;

i_tristate_input <= '1';
i_address_col <= x"4";
i_bit <= '1';
wait for clock_period;
i_tristate_input <= '0';
wait for clock_period;

i_tristate_input <= '1';
i_address_col <= x"5";
i_bit <= '0';
wait for clock_period;
i_tristate_input <= '0';
wait for clock_period;

i_tristate_input <= '1';
i_address_col <= x"6";
i_bit <= '1';
wait for clock_period;
i_tristate_input <= '0';
wait for clock_period;

i_tristate_input <= '1';
i_address_col <= x"7";
i_bit <= '0';
wait for clock_period;
i_tristate_input <= '0';
wait for clock_period;

i_tristate_input <= '1';
i_address_col <= x"8";
i_bit <= '1';
wait for clock_period;
i_tristate_input <= '0';
wait for clock_period;

-- read
i_tristate_output <= '1';
i_address_col <= x"0";
wait for clock_period;
i_tristate_output <= '0';
wait for clock_period;

i_tristate_output <= '1';
i_address_col <= x"1";
wait for clock_period;
i_tristate_output <= '0';
wait for clock_period;

i_tristate_output <= '1';
i_address_col <= x"2";
wait for clock_period;
i_tristate_output <= '0';
wait for clock_period;

i_tristate_output <= '1';
i_address_col <= x"3";
wait for clock_period;
i_tristate_output <= '0';
wait for clock_period;

i_tristate_output <= '1';
i_address_col <= x"4";
wait for clock_period;
i_tristate_output <= '0';
wait for clock_period;

i_tristate_output <= '1';
i_address_col <= x"5";
wait for clock_period;
i_tristate_output <= '0';
wait for clock_period;

i_tristate_output <= '1';
i_address_col <= x"6";
wait for clock_period;
i_tristate_output <= '0';
wait for clock_period;

i_tristate_output <= '1';
i_address_col <= x"7";
wait for clock_period;
i_tristate_output <= '0';
wait for clock_period;

i_tristate_output <= '1';
i_address_col <= x"8";
wait for clock_period;
i_tristate_output <= '0';
wait for clock_period;

wait;
end process;

END;
