--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:09:18 06/04/2023
-- Design Name:   CMOS MS DFF
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_fig37.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fig37
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

ENTITY tb_fig37 IS
END tb_fig37;

ARCHITECTURE behavior OF tb_fig37 IS 

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT fig37
PORT(
Data : IN  std_logic;
Clear_bar : IN  std_logic;
clock : IN  std_logic;
Q,Qb : OUT  std_logic
);
END COMPONENT;

--Inputs
signal Data : std_logic := '0';
signal Clear_bar : std_logic := '0';
signal clock : std_logic := '0';

--Outputs
signal Q : std_logic;
signal Qb : std_logic;

-- Clock period definitions
constant clock_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: fig37 PORT MAP (
Data => Data,
Clear_bar => Clear_bar,
clock => clock,
Qb => Qb,
Q => Q
);

-- Clock process definitions
clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;

Data <= '0',
'1' after 12.5 ns,
'0' after 17.5 ns,
'1' after 22.5 ns,
'0' after 27.5 ns,
'1' after 42.5 ns,
'0' after 52.5 ns;

Clear_bar <= '1', '0' after 3 ns, '1' after 4 ns;

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
wait for 100 ns;
-- insert stimulus here
report "done tb" severity failure;
end process;

END;
