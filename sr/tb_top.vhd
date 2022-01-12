LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

USE ieee.numeric_std.ALL;

ENTITY tb_top IS
END tb_top;

ARCHITECTURE behavior OF tb_top IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT top
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
i_push : IN  std_logic;
i_phase1 : IN  std_logic;
i_phase2 : IN  std_logic;
o_cycles : OUT  std_logic_vector(15 downto 0)
);
END COMPONENT;


--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_push : std_logic := '0';
signal i_phase1 : std_logic := '0';
signal i_phase2 : std_logic := '0';

--Outputs
signal o_cycles : std_logic_vector(15 downto 0);

-- Clock period definitions
constant i_clock_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: top PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_push => i_push,
i_phase1 => i_phase1,
i_phase2 => i_phase2,
o_cycles => o_cycles
);

-- Clock process definitions
i_clock_process :process
begin
i_clock <= '0';
wait for i_clock_period/2;
i_clock <= '1';
wait for i_clock_period/2;
end process;

i_phase2 <= '1' after i_clock_period*20,'0' after i_clock_period*50;
i_phase1 <= '1' after i_clock_period*15,'0' after i_clock_period*45;

-- Stimulus process
stim_proc: process
begin		
-- hold reset state for 100 ns.
i_reset <= '1';
wait for 100 ns;
i_reset <= '0';
wait for i_clock_period*2.5;
i_push <= '1';
wait for i_clock_period*1;
i_push <= '0';
wait for i_clock_period*40;
-- insert stimulus here 
report "done" severity failure;
end process;

END;
