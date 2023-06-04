--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:19:55 06/03/2023
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_serial_line_code.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: serial_line_code
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types bit and
-- bit_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_serial_line_code IS
END tb_serial_line_code;

ARCHITECTURE behavior OF tb_serial_line_code IS 

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT serial_line_code
PORT(
clock_1 : IN  bit;
clock_2 : IN  bit;
reset : IN  bit;
B_in : IN  bit;
NRZ_Mealy : OUT  bit;
NRZ_Moore : OUT  bit;
NRZI_Mealy : OUT  bit;
NRZI_Moore : OUT  bit;
RZ : OUT  bit;
Manchester : OUT  bit
);
END COMPONENT;

--Inputs
signal clock_1 : bit := '0';
signal clock_2 : bit := '0';
signal reset : bit := '0';
signal B_in : bit := '0';

--Outputs
signal NRZ_Mealy : bit;
signal NRZ_Moore : bit;
signal NRZI_Mealy : bit;
signal NRZI_Moore : bit;
signal RZ : bit;
signal Manchester : bit;

-- Clock period definitions
constant clock_1_period : time := 10 ns; -- speed 1x
constant clock_2_period : time := 5 ns; -- speed 2x

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: serial_line_code PORT MAP (
clock_1 => clock_1,
clock_2 => clock_2,
reset => reset,
B_in => B_in,
NRZ_Mealy => NRZ_Mealy,
NRZ_Moore => NRZ_Moore,
NRZI_Mealy => NRZI_Mealy,
NRZI_Moore => NRZI_Moore,
RZ => RZ,
Manchester => Manchester
);

-- Clock process definitions
clock_1_process :process
begin
clock_1 <= '0';
wait for clock_1_period/2;
clock_1 <= '1';
wait for clock_1_period/2;
end process;

clock_2_process :process
begin
clock_2 <= '0';
wait for clock_2_period/2;
clock_2 <= '1';
wait for clock_2_period/2;
end process;

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
reset <= '1';
wait for 100 ns;	
reset <= '0';
--wait for clock_1_period;
-- insert stimulus here 
B_in <= '0'; wait for clock_1_period;
B_in <= '1'; wait for clock_1_period;
B_in <= '1'; wait for clock_1_period;
B_in <= '1'; wait for clock_1_period;
B_in <= '0'; wait for clock_1_period;
B_in <= '0'; wait for clock_1_period;
B_in <= '1'; wait for clock_1_period;
B_in <= '0'; wait for clock_1_period;
B_in <= '0'; wait for clock_1_period;
B_in <= '0'; wait for clock_1_period;
report "tb done" severity failure;
end process;

END;
