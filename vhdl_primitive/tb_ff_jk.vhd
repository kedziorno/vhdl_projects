--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:05:50 05/04/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_ff_jk.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FF_JK
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

ENTITY tb_ff_jk IS
END tb_ff_jk;

ARCHITECTURE behavior OF tb_ff_jk IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT FF_JK
PORT(
J : IN  std_logic;
K : IN  std_logic;
C : IN  std_logic;
Q1 : INOUT  std_logic;
Q2 : INOUT  std_logic
);
END COMPONENT;

--Inputs
signal J : std_logic := '0';
signal K : std_logic := '0';
signal C : std_logic := '0';

--BiDirs
signal Q1 : std_logic := '0';
signal Q2 : std_logic := '0';

signal clock : std_logic := '0';
constant clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: FF_JK PORT MAP (
J => J,
K => K,
C => C,
Q1 => Q1,
Q2 => Q2
);

-- Clock process definitions
clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;

-- Stimulus process
--stim_proc: process (clock) is
--	type vt is array(0 to 3) of std_logic_vector(1 downto 0);
----	variable v : vt := ("00","01","10","11"); -- bin
--	variable v : vt := ("00","01","11","10"); -- grey
--	variable i : integer range 0 to 3 := 0;
--begin
---- insert stimulus here
--C <= '1';
--if (rising_edge(clock)) then
--J <= v(i)(0);
--K <= v(i)(1);
--if (i=3) then
--i := 0;
--else
--i := i + 1;
--end if;
--end if;
--end process;

C <= clock;
stim_proc: process is
begin
-- insert stimulus here
J <= '1';
K <= '1';
wait for clock_period;
J <= '0';
K <= '0';
wait for 10*clock_period;
J <= '1';
K <= '1';
wait for clock_period;
J <= '0';
K <= '0';
wait for 10*clock_period;
J <= '1';
K <= '1';
wait for clock_period;
J <= '0';
K <= '0';
wait for 10*clock_period;
wait;
end process;

END;
