--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:16:03 12/17/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/weirdboyjim_circuits/tb_ff_d_ms.vhd
-- Project Name:  weirdboyjim_circuits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FF_D_MASTER_SLAVE
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

ENTITY tb_ff_d_ms IS
END tb_ff_d_ms;

ARCHITECTURE behavior OF tb_ff_d_ms IS

COMPONENT FF_D_MASTER_SLAVE
PORT(
C : IN  std_logic;
D : IN  std_logic;
Q1 : INOUT  std_logic;
Q2 : INOUT  std_logic
);
END COMPONENT FF_D_MASTER_SLAVE;
--for all : FF_D_MASTER_SLAVE use entity WORK.FF_D_MASTER_SLAVE(Behavioral_D_MS);
for all : FF_D_MASTER_SLAVE use entity WORK.FF_D_MASTER_SLAVE(D_MS_LUT);

--Inputs
signal C : std_logic := '0';
signal D : std_logic := '0';

--BiDirs
signal Q1 : std_logic;
signal Q2 : std_logic;

signal clock : std_logic;
constant clock_period : time := 20 ns;

BEGIN

uut: FF_D_MASTER_SLAVE PORT MAP (
C => C,
D => D,
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

C <= clock;

-- Stimulus process
stim_proc : process
begin
wait for clock_period*11;
-- insert stimulus here
D <= '1'; wait for clock_period*0.5;
D <= '0'; wait for clock_period*0.5;
D <= '1'; wait for clock_period*0.5;
D <= '0'; wait for clock_period*0.5;
D <= '1'; wait for clock_period*0.5;
D <= '0'; wait for clock_period*0.5;
D <= 'U'; wait for clock_period*2;
D <= '1'; wait for clock_period*1;
D <= '0'; wait for clock_period*1;
D <= '1'; wait for clock_period*1;
D <= '0'; wait for clock_period*1;
D <= '1'; wait for clock_period*1;
D <= '0'; wait for clock_period*1;

report "done" severity failure;
wait;
end process;

END;
