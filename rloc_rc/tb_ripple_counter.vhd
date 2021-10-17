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

constant N : integer := 9;
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
o_q : INOUT  std_logic_vector(N-1 downto 0)
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_cpb : std_logic := '0';
signal i_mrb : std_logic := '0';
signal i_ud : std_logic := '0';

--BiDirs
signal o_q : std_logic_vector(N-1 downto 0);

signal clock : std_logic := '0';
constant clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: ripple_counter
GENERIC MAP (
N => N,
MAX => MAX
)
PORT MAP (
i_clock => clock,
i_cpb => i_cpb,
i_mrb => i_mrb,
i_ud => i_ud,
o_q => o_q
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
stim_proc: process
begin

---- insert stimulus here

-- reset, ok 0 when reset=1
wait for clock_period;
i_mrb <= '1';
wait for 25*clock_period;
i_mrb <= '0';

-- wait some time, count down when ud=0
wait for 100*clock_period;

-- mrb,cpb must be 1 to reset and start count
i_mrb <= '1';
i_cpb <= '1';
i_ud <= '1'; -- count up
wait for 1*clock_period;
i_mrb <= '0'; -- start counting
wait for 4*MAX*clock_period; -- wait MAX ticks
i_cpb <= '0'; -- ok, count from 0 to MAX-2, MAX-1=0 then ping
i_ud <= '0';

-- wait some time
wait for 100*clock_period;

-- dont want reset, reset in middle cpb
wait for clock_period;
i_cpb <= '1';
i_ud <= '0'; -- count down
wait for (MAX*clock_period)/2 - 241 ns;
i_mrb <= '1';
wait for clock_period;
i_mrb <= '0';
wait for (MAX*clock_period)/2 + 241 ns;
wait for (MAX*clock_period)/2 - 123 ns;
i_mrb <= '1';
wait for clock_period;
i_mrb <= '0';
wait for (MAX*clock_period)/2 + 123 ns;
wait for (MAX*clock_period)/2 - 177 ns;
i_mrb <= '1';
wait for clock_period;
i_mrb <= '0';
wait for (MAX*clock_period)/2 + 177 ns;
wait for (MAX*clock_period)/2 - 89 ns;
i_mrb <= '1';
wait for clock_period;
i_mrb <= '0';
wait for (MAX*clock_period)/2 + 89 ns;
i_cpb <= '0'; -- strange
i_ud <= '0';

-- wait some time, not count, stay on 1
wait for 100*clock_period;

-- mrb,cpb must be 1 to reset and start count
wait for clock_period;
i_mrb <= '1';
i_cpb <= '1';
i_ud <= '0'; -- count down
wait for 1*clock_period; -- wait for reset
i_mrb <= '0'; -- start counting
wait for 4*MAX*clock_period;
i_cpb <= '0'; -- strange
i_ud <= '0';

wait for 10*clock_period; -- XXX reset
i_mrb <= '1';
wait for 100*clock_period;
i_mrb <= '0';

wait;
end process;

END;
