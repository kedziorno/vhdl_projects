--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:03:35 01/21/2022
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/myown_i2c/TB_MUX_81.vhd
-- Project Name:  myown_i2c
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MUX_81
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

ENTITY TB_MUX_81 IS
END TB_MUX_81;

ARCHITECTURE behavior OF TB_MUX_81 IS

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT MUX_81
PORT(
in0 : IN  std_logic;
in1 : IN  std_logic;
in2 : IN  std_logic;
in3 : IN  std_logic;
in4 : IN  std_logic;
in5 : IN  std_logic;
in6 : IN  std_logic;
in7 : IN  std_logic;
s0 : IN  std_logic;
s1 : IN  std_logic;
s2 : IN  std_logic;
o : OUT  std_logic
);
END COMPONENT;

--Inputs
signal in0 : std_logic := '0';
signal in1 : std_logic := '0';
signal in2 : std_logic := '0';
signal in3 : std_logic := '0';
signal in4 : std_logic := '0';
signal in5 : std_logic := '0';
signal in6 : std_logic := '0';
signal in7 : std_logic := '0';
signal s0 : std_logic := '0';
signal s1 : std_logic := '0';
signal s2 : std_logic := '0';

--Outputs
signal o : std_logic;

constant clock_period : time := 10 ns;
signal clock : std_logic;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: MUX_81 PORT MAP (
in0 => in0,
in1 => in1,
in2 => in2,
in3 => in3,
in4 => in4,
in5 => in5,
in6 => in6,
in7 => in7,
s0 => s0,
s1 => s1,
s2 => s2,
o => o
);

clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;

-- Stimulus process
stim_proc : process
	variable t : std_logic_vector(2 downto 0);
begin
-- hold reset state for 100 ns.
wait for 100 ns;
--in0 <= '1'; wait for clock_period;
--in1 <= '1'; wait for clock_period;
--in2 <= '1'; wait for clock_period;
--in3 <= '1'; wait for clock_period;
--in4 <= '1'; wait for clock_period;
--in5 <= '1'; wait for clock_period;
--in6 <= '1'; wait for clock_period;
--in7 <= '1'; wait for clock_period;
wait for clock_period*10;
-- insert stimulus here
l0 : for i in 0 to 7 loop
	t := std_logic_vector(to_unsigned(i,3));
	case (i) is
		when 0 => in0 <= '1'; in1 <= '0'; in2 <= '0'; in3 <= '0'; in4 <= '0'; in5 <= '0'; in6 <= '0'; in7 <= '0';
		when 1 => in0 <= '0'; in1 <= '1'; in2 <= '0'; in3 <= '0'; in4 <= '0'; in5 <= '0'; in6 <= '0'; in7 <= '0';
		when 2 => in0 <= '0'; in1 <= '0'; in2 <= '1'; in3 <= '0'; in4 <= '0'; in5 <= '0'; in6 <= '0'; in7 <= '0';
		when 3 => in0 <= '0'; in1 <= '0'; in2 <= '0'; in3 <= '1'; in4 <= '0'; in5 <= '0'; in6 <= '0'; in7 <= '0';
		when 4 => in0 <= '0'; in1 <= '0'; in2 <= '0'; in3 <= '0'; in4 <= '1'; in5 <= '0'; in6 <= '0'; in7 <= '0';
		when 5 => in0 <= '0'; in1 <= '0'; in2 <= '0'; in3 <= '0'; in4 <= '0'; in5 <= '1'; in6 <= '0'; in7 <= '0';
		when 6 => in0 <= '0'; in1 <= '0'; in2 <= '0'; in3 <= '0'; in4 <= '0'; in5 <= '0'; in6 <= '1'; in7 <= '0';
		when 7 => in0 <= '0'; in1 <= '0'; in2 <= '0'; in3 <= '0'; in4 <= '0'; in5 <= '0'; in6 <= '0'; in7 <= '1';
	end case;
	s0 <= t(0);
	s1 <= t(1);
	s2 <= t(2);
	wait for clock_period;
end loop l0;
wait;
end process;

END;
