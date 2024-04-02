--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:55:38 07/03/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_edge_clock.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: edge_clock
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
USE ieee.numeric_std.ALL;

ENTITY tb_edge_clock IS
END tb_edge_clock;

ARCHITECTURE behavior OF tb_edge_clock IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT edge_clock
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
i_e1 : IN  std_logic;
i_e2 : IN  std_logic;
o_count : OUT  unsigned(31 downto 0)
);
END COMPONENT;


--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_e1 : std_logic := '0';
signal i_e2 : std_logic := '0';

--Outputs
signal o_count : unsigned(31 downto 0);

-- Clock period definitions
constant i_clock_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: edge_clock PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_e1 => i_e1,
i_e2 => i_e2,
o_count => o_count
);

-- Clock process definitions
i_clock_process :process
begin
i_clock <= '0';
wait for i_clock_period/2;
i_clock <= '1';
wait for i_clock_period/2;
end process;


-- Stimulus process
stim_proc: process
begin		
-- hold reset state for 100 ns.
i_reset <= '1';
wait for 100 ns;	
i_reset <= '0';
wait for i_clock_period*10;

-- insert stimulus here 
i_e1 <= '1';
wait for i_clock_period*8.7;
i_e1 <= '0';
wait for i_clock_period*4.3;
i_e2 <= '1';
wait for i_clock_period*5.1;
i_e2 <= '0';
wait for i_clock_period*6.5;
report "done" severity failure;
wait;
end process;

END;
