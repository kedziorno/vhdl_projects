--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:11:49 01/21/2022
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/myown_i2c/TB_MUX_41.vhd
-- Project Name:  myown_i2c
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MUX_41
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

ENTITY TB_MUX_41 IS
END TB_MUX_41;

ARCHITECTURE behavior OF TB_MUX_41 IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT MUX_41
PORT(
S1 : IN  std_logic;
S2 : IN  std_logic;
A : IN  std_logic;
B : IN  std_logic;
C : IN  std_logic;
D : IN  std_logic;
E : OUT  std_logic
);
END COMPONENT;

--Inputs
signal S1 : std_logic := '0';
signal S2 : std_logic := '0';
signal A : std_logic := '0';
signal B : std_logic := '0';
signal C : std_logic := '0';
signal D : std_logic := '0';

--Outputs
signal E : std_logic;

constant clock_period : time := 10 ns;
signal clock : std_logic;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: MUX_41 PORT MAP (
S1 => S1,
S2 => S2,
A => A,
B => B,
C => C,
D => D,
E => E
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
	variable t : std_logic_vector(1 downto 0);
begin
-- hold reset state for 100 ns.
wait for 100 ns;
--A <= '1'; wait for clock_period;
--B <= '1'; wait for clock_period;
--C <= '1'; wait for clock_period;
--D <= '1'; wait for clock_period;
wait for clock_period*10;
-- insert stimulus here
l0 : for i in 0 to 3 loop
	t := std_logic_vector(to_unsigned(i,2));
	case (i) is
		when 0 => A <= '1'; B <= '0'; C <= '0'; D <= '0';
		when 1 => A <= '0'; B <= '1'; C <= '0'; D <= '0';
		when 2 => A <= '0'; B <= '0'; C <= '1'; D <= '0';
		when 3 => A <= '0'; B <= '0'; C <= '0'; D <= '1';
	end case;
	S1 <= t(0);
	S2 <= t(1);
	wait for clock_period*10;
end loop l0;
wait;
end process;

END;
