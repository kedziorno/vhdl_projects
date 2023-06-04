--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:05:22 06/04/2023
-- Design Name:   Transparent Latch
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_fig33.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fig33
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_fig33 IS
END tb_fig33;

ARCHITECTURE behavior OF tb_fig33 IS 

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT fig33
PORT(
Data : IN  bit;
Enable : IN  bit;
Q_out : OUT  bit;
Qb_out : OUT  bit
);
END COMPONENT;

--Inputs
signal Data : bit := '0';
signal Enable : bit := '0';

--Outputs
signal Q_out : bit;
signal Qb_out : bit;

signal clock : bit := '0';
constant clock_period : time := 20 ns;

BEGIN

process_clock : process is
begin
  clock <= '0';
  wait for clock_period/2;
  clock <= '1';
  wait for clock_period/2;
end process process_clock;

-- Instantiate the Unit Under Test (UUT)
uut: fig33 PORT MAP (
Data => Data,
Enable => Enable,
Q_out => Q_out,
Qb_out => Qb_out
);

Data <= '1',
'0' after 8 ns,
'1' after 12 ns,
'0' after 14 ns,
'1' after 16 ns,
'0' after 24 ns,
'1' after 26 ns,
'0' after 28 ns,
'1' after 34 ns,
'0' after 38 ns,
'1' after 42 ns;

Enable <= '0',
'1' after 10 ns,
'0' after 20 ns,
'1' after 30 ns,
'0' after 40 ns,
'1' after 50 ns;

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
wait for 100 ns;
-- insert stimulus here

report "done tb" severity failure;
end process;

END;
