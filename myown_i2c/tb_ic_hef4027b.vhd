--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:23:30 01/31/2022
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/myown_i2c/tb_ic_hef4027b.vhd
-- Project Name:  myown_i2c
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ic_hef4027b
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

ENTITY tb_ic_hef4027b IS
END tb_ic_hef4027b;

ARCHITECTURE behavior OF tb_ic_hef4027b IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT ic_hef4027b
PORT(
i_cp : IN  std_logic;
i_j : IN  std_logic;
i_k : IN  std_logic;
i_cd : IN  std_logic;
i_sd : IN  std_logic;
o_q : OUT  std_logic;
o_qb : OUT  std_logic
);
END COMPONENT;


--Inputs
signal i_cp : std_logic := '0';
signal i_j : std_logic := '0';
signal i_k : std_logic := '0';
signal i_cd : std_logic := '0';
signal i_sd : std_logic := '0';

--Outputs
signal o_q : std_logic;
signal o_qb : std_logic;

constant clock_period : time := 20 ns;
signal clock : std_logic;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: ic_hef4027b PORT MAP (
i_cp => i_cp,
i_j => i_j,
i_k => i_k,
i_cd => i_cd,
i_sd => i_sd,
o_q => o_q,
o_qb => o_qb
);

-- Clock process definitions
clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;

i_cp <= clock;
-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
wait for 100 ns;
-- insert stimulus here
-- XXX HEF4027B.pdf p.3 s.7
-- nQ=H nQb=L
i_sd <= '1';
i_cd <= '0';
--i_cp <= 'X';
i_j <= 'X';
i_k <= 'X';
wait for clock_period*10;
-- nQ=L nQb=H
i_sd <= '0';
i_cd <= '1';
--i_cp <= 'X';
i_j <= 'X';
i_k <= 'X';
wait for clock_period*10;
-- nQ=H nQb=H
i_sd <= '1';
i_cd <= '1';
--i_cp <= 'X';
i_j <= 'X';
i_k <= 'X';
wait for clock_period*10;
-- nQ=nochange nQb=nochange
i_sd <= '0';
i_cd <= '0';
--l0 : for i in 0 to 1 loop
--i_cp <= '1'; wait for clock_period/2; i_cp <= '0'; wait for clock_period/2;
--end loop l0;
i_j <= '0';
i_k <= '0';
wait for clock_period*10;
-- nQ=H nQb=L
i_sd <= '0';
i_cd <= '0';
--l1 : for i in 0 to 1 loop
--i_cp <= '1'; wait for clock_period/2; i_cp <= '0'; wait for clock_period/2;
--end loop l1;
i_j <= '1';
i_k <= '0';
wait for clock_period*10;
-- nQ=L nQb=H
i_sd <= '0';
i_cd <= '0';
--l2 : for i in 0 to 1 loop
--i_cp <= '1'; wait for clock_period/2; i_cp <= '0'; wait for clock_period/2;
--end loop l2;
i_j <= '0';
i_k <= '1';
wait for clock_period*10;
-- nQ=nQb nQb=nQ
i_sd <= '0';
i_cd <= '0';
--l3 : for i in 0 to 1 loop
--i_cp <= '1'; wait for clock_period/2; i_cp <= '0'; wait for clock_period/2;
--end loop l3;
i_j <= '1';
i_k <= '1';
wait for clock_period*10;

report "done" severity failure;
end process;

END;
