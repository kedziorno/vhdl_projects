--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:47:33 06/04/2023
-- Design Name:   Master-slave neg-edge D FF
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_fig35.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fig35
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

ENTITY tb_fig35 IS
END tb_fig35;

ARCHITECTURE behavior OF tb_fig35 IS 

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT fig35
PORT(
Data : IN  bit;
clock : IN  bit;
Q : OUT  bit;
Qb : OUT  bit
);
END COMPONENT;

--Inputs
signal Data : bit := '0';
signal clock : bit := '0';

--Outputs
signal Q : bit;
signal Qb : bit;

-- Clock period definitions
constant clock_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: fig35 PORT MAP (
Data => Data,
clock => clock,
Q => Q,
Qb => Qb
);

Data <= '0',
'1' after 12.5 ns,
'0' after 17.5 ns,
'1' after 22.5 ns,
'0' after 27.5 ns,
'1' after 42.5 ns,
'0' after 52.5 ns;

-- Clock process definitions
clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
wait for 100 ns;

-- insert stimulus here

report "done tb" severity failure;
end process;

END;
