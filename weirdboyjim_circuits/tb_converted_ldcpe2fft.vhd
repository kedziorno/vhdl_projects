--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:54:33 12/05/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/weirdboyjim_circuits/tb_converted_ldcpe2fft.vhd
-- Project Name:  weirdboyjim_circuits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: converted_ldcpe2fft
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

ENTITY tb_converted_ldcpe2fft IS
END tb_converted_ldcpe2fft;

ARCHITECTURE behavior OF tb_converted_ldcpe2fft IS

COMPONENT converted_ldcpe2fft
PORT(
i_t : IN  std_logic;
i_sd : IN  std_logic;
i_rd : IN  std_logic;
o_q1 : OUT  std_logic;
o_q2 : OUT  std_logic
);
END COMPONENT converted_ldcpe2fft;
for all : converted_ldcpe2fft use entity WORK.converted_ldcpe2fft(Behavioral);

--Inputs
signal i_t : std_logic := '0';
signal i_sd : std_logic := '0';
signal i_rd : std_logic := '0';

--Outputs
signal o_q1 : std_logic;
signal o_q2 : std_logic;

signal clock : std_logic;
constant clock_period : time := 10 ns;

BEGIN

uut: converted_ldcpe2fft PORT MAP (
	i_t => i_t,
	i_sd => i_sd,
	i_rd => i_rd,
	o_q1 => o_q1,
	o_q2 => o_q2
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
stim_proc : process
begin
i_sd <= '1';
wait for clock_period*1;
i_sd <= '0';
i_rd <= '1';
wait for clock_period*1;
i_rd <= '0';
l0 : for i in 0 to 128 loop
	i_t <= not i_t;
	wait for clock_period*30;
end loop l0;
--i_t <= '1'; wait for clock_period*9;
--i_t <= '0'; wait for clock_period*11;
--i_t <= '1'; wait for clock_period*13;
--i_t <= '0'; wait for clock_period*15;
--i_t <= '1'; wait for clock_period*17;
--i_t <= '0'; wait for clock_period*19;
--i_t <= '1'; wait for clock_period*21;
--i_t <= '1'; wait for clock_period*23;
--i_t <= '1'; wait for clock_period*25;
wait for clock_period*200;
i_sd <= '0';
i_rd <= '0';
-- insert stimulus here
wait for clock_period;
i_t <= '0';

report "done" severity failure;
wait;
end process;

END;
