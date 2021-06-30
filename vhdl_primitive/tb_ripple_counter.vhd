--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:55:32 05/04/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_ripple_counter.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ripple_counter
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

ENTITY tb_ripple_counter IS
END tb_ripple_counter;

ARCHITECTURE behavior OF tb_ripple_counter IS

constant N : integer := 8;
constant MAX : integer := 130;

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT ripple_counter
GENERIC(
N : integer;
MAX : integer
);
PORT(
i_clock : IN  std_logic;
i_cpb : IN  std_logic;
i_mrb : IN  std_logic;
i_ud : IN  std_logic;
o_q : INOUT  std_logic_vector(N-1 downto 0);
o_ping : OUT  std_logic
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_cpb : std_logic := '0';
signal i_mrb : std_logic := '0';
signal i_ud : std_logic := '0';

--BiDirs
signal o_q : std_logic_vector(N-1 downto 0);
signal o_ping : std_logic;

signal clock : std_logic := '0';
constant clock_period : time := 100 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: ripple_counter
GENERIC MAP (
N => N,
MAX => MAX
)
PORT MAP (
i_clock => i_clock,
i_cpb => i_cpb,
i_mrb => i_mrb,
i_ud => i_ud,
o_q => o_q,
o_ping => o_ping
);

-- Clock process definitions
clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;

i_clock <= clock;

-- Stimulus process
stim_proc: process
begin

---- insert stimulus here

wait for clock_period; -- XXX reset
i_mrb <= '1';
i_ud <= '0';
wait for 2*clock_period;
i_mrb <= '0';

wait for clock_period; -- XXX set up
i_ud <= '1';

wait for clock_period; -- XXX count
i_cpb <= '1';
wait for MAX*clock_period;
i_cpb <= '0';
wait for clock_period;

wait for clock_period; -- XXX reset
i_mrb <= '1';
i_ud <= '0';
wait for 2*clock_period;
i_mrb <= '0';

wait for clock_period; -- XXX set down
i_ud <= '0';

wait for clock_period; -- XXX count
i_cpb <= '1';
i_ud <= '0';
wait for MAX*clock_period;
i_cpb <= '0';
wait for clock_period;

wait for clock_period; -- XXX reset
i_mrb <= '1';
wait for 2*clock_period;
i_mrb <= '0';

wait;
end process;

END;
