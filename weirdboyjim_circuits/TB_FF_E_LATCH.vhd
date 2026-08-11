--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:24:33 01/12/2022
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/weirdboyjim_circuits/TB_FF_E_LATCH.vhd
-- Project Name:  weirdboyjim_circuits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FF_E_LATCH
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

ENTITY TB_FF_E_LATCH IS
END TB_FF_E_LATCH;

ARCHITECTURE behavior OF TB_FF_E_LATCH IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT FF_E_LATCH
GENERIC(
delay_and : time := 0 ns;
delay_and3 : time := 0 ns;
delay_not : time := 0 ns;
delay_nand2 : time := 0 ns;
delay_nand3 : time := 0 ns
);
PORT(
D : IN  std_logic;
E_H : IN  std_logic;
E_L : IN  std_logic;
Q : OUT  std_logic
);
END COMPONENT FF_E_LATCH;
--for all : FF_E_LATCH use entity WORK.FF_E_LATCH(Behavioral_E_LATCH);
--for all : FF_E_LATCH use entity WORK.FF_E_LATCH(LUT_E_LATCH);
for all : FF_E_LATCH use entity WORK.FF_E_LATCH(LUT_E_LATCH_NAND);


--Inputs
signal D : std_logic := '0';
signal E_H : std_logic := '0';
signal E_L : std_logic := '0';

--Outputs
signal Q : std_logic;

constant clock_period : time := 20 ns;
signal clock : std_logic;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: FF_E_LATCH
GENERIC MAP (
delay_and => 0 ns,
delay_and3 => 0 ns,
delay_not => 0 ns,
delay_nand2 => 1 ns,
delay_nand3 => 0 ns
)
PORT MAP (
D => D,
E_H => E_H,
E_L => E_L,
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

D <= not clock;
-- Stimulus process
stim_proc: process
begin		
E_H <= '0';
E_L <= '1';
wait for 15 ns;
E_H <= '1';
E_L <= '0';
wait for 10 ns;
E_H <= '0';
E_L <= '1';
wait for 10 ns;
E_H <= '1';
E_L <= '0';
wait for 6 ns;
E_H <= '0';
E_L <= '1';
wait for 4 ns;
E_H <= '1';
E_L <= '0';
wait for 10 ns;
E_H <= '0';
E_L <= '1';
wait for 10 ns;
E_H <= '1';
E_L <= '0';
wait for 15 ns;
E_H <= '0';
E_L <= '1';
wait for 5 ns;
E_H <= '1';
E_L <= '0';
wait for 15 ns;
E_H <= '0';
E_L <= '1';
wait for 20 ns;
E_H <= '1';
E_L <= '0';
wait for 5 ns;
E_H <= '0';
E_L <= '1';
wait for 10 ns;
E_H <= '1';
E_L <= '0';
wait for 5 ns;
E_H <= '0';
E_L <= '1';
wait for 5 ns;
E_H <= '1';
E_L <= '0';
wait for 10 ns;
E_H <= '0';
E_L <= '1';
wait for 10 ns;
report "done" severity failure;
end process;

END;
