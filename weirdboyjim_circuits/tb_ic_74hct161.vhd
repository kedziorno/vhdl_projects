--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:41:12 01/08/2022
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/weirdboyjim_circuits/tb_ic_74hct161.vhd
-- Project Name:  weirdboyjim_circuits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ic_74hct161
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

ENTITY tb_ic_74hct161 IS
END tb_ic_74hct161;

ARCHITECTURE behavior OF tb_ic_74hct161 IS

COMPONENT ic_74hct161
PORT(
i_d0 : IN  std_logic;
i_d1 : IN  std_logic;
i_d2 : IN  std_logic;
i_d3 : IN  std_logic;
i_cet : IN  std_logic;
i_cep : IN  std_logic;
i_pe_b : IN  std_logic;
i_cp : IN  std_logic;
i_mr_b : IN  std_logic;
o_q0 : OUT  std_logic;
o_q1 : OUT  std_logic;
o_q2 : OUT  std_logic;
o_q3 : OUT  std_logic;
o_tc : OUT  std_logic
);
END COMPONENT;

--Inputs
signal i_d0 : std_logic := '0';
signal i_d1 : std_logic := '0';
signal i_d2 : std_logic := '0';
signal i_d3 : std_logic := '0';
signal i_cet : std_logic := '0';
signal i_cep : std_logic := '0';
signal i_pe_b : std_logic := '0';
signal i_cp : std_logic := '0';
signal i_mr_b : std_logic := '0';

--Outputs
signal o_q0 : std_logic;
signal o_q1 : std_logic;
signal o_q2 : std_logic;
signal o_q3 : std_logic;
signal o_tc : std_logic;

signal vtemp1,vtemp2 : std_logic_vector(3 downto 0);

signal clock : std_logic;
constant clock_period : time := 20 ns;

BEGIN

vtemp1(0) <= o_q0;
vtemp1(1) <= o_q1;
vtemp1(2) <= o_q2;
vtemp1(3) <= o_q3;

vtemp2(0) <= i_d0;
vtemp2(1) <= i_d1;
vtemp2(2) <= i_d2;
vtemp2(3) <= i_d3;

uut: ic_74hct161 PORT MAP (
i_d0 => i_d0,
i_d1 => i_d1,
i_d2 => i_d2,
i_d3 => i_d3,
i_cet => i_cet,
i_cep => i_cep,
i_pe_b => i_pe_b,
i_cp => i_cp,
i_mr_b => i_mr_b,
o_q0 => o_q0,
o_q1 => o_q1,
o_q2 => o_q2,
o_q3 => o_q3,
o_tc => o_tc
);

clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;

i_cp <= clock;

-- Stimulus process
stim_proc : process
begin
-- hold reset state for 100 ns.
i_mr_b <= '0';
wait for 100 ns;
i_mr_b <= '1';
wait for clock_period*10;
i_pe_b <= '1';
wait for clock_period;
i_cet <= '1';
i_cep <= '1';
wait for clock_period;
i_d0 <= '0';
i_d1 <= '0';
i_d2 <= '0';
i_d3 <= '0';
i_pe_b <= '0';
wait for clock_period;
i_pe_b <= '1';
wait for clock_period*7;
i_d0 <= '1';
i_d1 <= '1';
i_d2 <= '1';
i_d3 <= '1';
i_pe_b <= '0';
wait for clock_period;
i_pe_b <= '1';
wait for clock_period*5;
i_d0 <= '1';
i_d1 <= '0';
i_d2 <= '0';
i_d3 <= '1';
i_pe_b <= '0';
wait for clock_period;
i_pe_b <= '1';
wait for clock_period*7;
i_d0 <= '0';
i_d1 <= '1';
i_d2 <= '0';
i_d3 <= '1';
i_pe_b <= '0';
wait for clock_period;
i_pe_b <= '1';
wait for clock_period*5;

-- insert stimulus here
report "done" severity failure;

wait;
end process;

END;
