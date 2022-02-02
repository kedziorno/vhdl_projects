--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:32:10 02/02/2022
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/myown_i2c/tb_ic_74hc73.vhd
-- Project Name:  myown_i2c
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ic_74hc73
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

ENTITY tb_ic_74hc73 IS
END tb_ic_74hc73;

ARCHITECTURE behavior OF tb_ic_74hc73 IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT ic_74hc73
PORT(
i_j : IN  std_logic;
i_k : IN  std_logic;
i_r : IN  std_logic;
i_cpb : IN  std_logic;
o_q : OUT  std_logic;
o_qb : OUT  std_logic
);
END COMPONENT;


--Inputs
signal i_j : std_logic := '0';
signal i_k : std_logic := '0';
signal i_r : std_logic := '1';
signal i_cpb : std_logic := '0';

--Outputs
signal o_q : std_logic;
signal o_qb : std_logic;

constant clock_period : time := 20 ns;
signal clock : std_logic;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: ic_74hc73 PORT MAP (
i_j => i_j,
i_k => i_k,
i_r => i_r,
i_cpb => i_cpb,
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

i_cpb <=
'1' after (200 ns + 50 * clock_period),
'0' after (200 ns + 50 * clock_period) + 10 ns,
'1' after (200 ns + 100 * clock_period),
'0' after (200 ns + 100 * clock_period) + 10 ns,
'1' after (200 ns + 150 * clock_period),
'0' after (200 ns + 150 * clock_period) + 10 ns,
'1' after (200 ns + 200 * clock_period),
'0' after (200 ns + 200 * clock_period) + 10 ns,

'1' after (200 ns + 250 * clock_period),
'0' after (200 ns + 250 * clock_period) + 10 ns,

'1' after (200 ns + 300 * clock_period),
'0' after (200 ns + 300 * clock_period) + 10 ns,

'1' after (200 ns + 350 * clock_period),
'0' after (200 ns + 350 * clock_period) + 10 ns,

'1' after (1000 ns + 400 * clock_period),
'0' after (1000 ns + 400 * clock_period) + 10 ns,
'1' after (1200 ns + 400 * clock_period),
'0' after (1200 ns + 400 * clock_period) + 10 ns,
'1' after (1400 ns + 400 * clock_period),
'0' after (1400 ns + 400 * clock_period) + 10 ns,
'1' after (1600 ns + 400 * clock_period),
'0' after (1600 ns + 400 * clock_period) + 10 ns,
'1' after (1800 ns + 400 * clock_period),
'0' after (1800 ns + 400 * clock_period) + 10 ns
;

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
wait for 100 ns;
wait for clock_period*10;
-- insert stimulus here
-- XXX 75HC73.pdf p.3 t.3
-- nQ=L nQb=H asynchronous reset
i_r <= '0';
i_j <= '1';
i_k <= '1';
wait for 100*clock_period;
-- nQ=nq nQb=q toggle
i_r <= '1';
i_j <= '1';
i_k <= '1';
wait for 100*clock_period;
-- nQ=0 nQb=1 load 0 reset
i_r <= '1';
i_j <= '0';
i_k <= '1';
wait for 100*clock_period;
-- nQ=1 nQb=0 load 1 set
i_r <= '1';
i_j <= '1';
i_k <= '0';
wait for 100*clock_period;
-- nQ=q nQb=nq hold nochange
i_r <= '1';
i_j <= '0';
i_k <= '0';
wait for 100*clock_period;

report "done" severity failure;

end process;

END;
