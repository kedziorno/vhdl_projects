--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:47:57 12/15/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/weirdboyjim_circuits/tb_ff_d_gated.vhd
-- Project Name:  weirdboyjim_circuits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FF_D_GATED
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

ENTITY tb_ff_d_gated IS
END tb_ff_d_gated;

ARCHITECTURE behavior OF tb_ff_d_gated IS

COMPONENT FF_D_GATED
GENERIC (
delay_and : TIME := 0 ns;
delay_or : TIME := 0 ns;
delay_not : TIME := 0 ns
);
PORT (
D : IN  std_logic;
E : IN  std_logic;
Q1 : INOUT  std_logic;
Q2 : INOUT  std_logic
);
END COMPONENT FF_D_GATED;
--for all : FF_D_GATED use entity work.FF_D_GATED(GATED_D_NOR_LUT);
--for all : FF_D_GATED use entity work.FF_D_GATED(Behavioral_GATED_D_NOR);
--for all : FF_D_GATED use entity work.FF_D_GATED(GATED_D_NAND_LUT);
for all : FF_D_GATED use entity work.FF_D_GATED(Behavioral_GATED_D_NAND);

--Inputs
signal D : std_logic := '0';
signal E : std_logic := '0';

--Out
signal Q1 : std_logic;
signal Q2 : std_logic;

signal clock : std_logic;
constant clock_period : time := 20 ns;

BEGIN

uut: FF_D_GATED
GENERIC MAP (
delay_and => 0 ns,
delay_or => 0 ns,
delay_not => 0 ns
)
PORT MAP (
D => D,
E => E,
Q1 => Q1,
Q2 => Q2
);

-- Clock process definitions
clock_process : process
begin
	clock <= '0';
	wait for clock_period/2;
	clock <= '1';
	wait for clock_period/2;
end process;

-- Stimulus process
stim_proc : process
begin
-- insert stimulus here
E <= '1'; wait for clock_period*1;
D <= '1'; wait for clock_period*0.6;
D <= '0'; wait for clock_period*0.4;
E <= '0'; wait for clock_period*1;

E <= '1'; wait for clock_period*1;
D <= '1'; wait for clock_period*0.6;
E <= '0'; wait for clock_period*0.4;
D <= '0'; wait for clock_period*1;

--D <= '1'; wait for clock_period*1;
--D <= '0'; wait for clock_period*1;
--D <= '1'; wait for clock_period*1;
--D <= '0'; wait for clock_period*1;
--D <= '1'; wait for clock_period*1;
--D <= '0'; wait for clock_period*1;
--D <= '1'; wait for clock_period*1;

report "done" severity failure;
end process;

END;
