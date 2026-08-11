--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:46:06 05/08/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_universal_function.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: universal_function
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

ENTITY tb_universal_function IS
END tb_universal_function;

ARCHITECTURE behavior OF tb_universal_function IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT universal_function
PORT(
i_x1 : IN  std_logic;
i_x2 : IN  std_logic;
o_x1b : OUT  std_logic;
o_x2b : OUT  std_logic;
o_x1b_or_x2b : OUT  std_logic;
o_x1_and_x2 : OUT  std_logic;
o_x1_or_x2b : OUT  std_logic;
o_x1b_and_x2 : OUT  std_logic;
o_x1_xor_x2 : OUT  std_logic;
o_x1_eq_x2 : OUT  std_logic;
o_x1b_or_x2 : OUT  std_logic;
o_x1_and_x2b : OUT  std_logic;
o_x1_or_x2 : OUT  std_logic;
o_x1b_and_x2b : OUT  std_logic
);
END COMPONENT;

--Inputs
signal i_x1 : std_logic := '0';
signal i_x2 : std_logic := '0';

--Outputs
signal o_x1b : std_logic;
signal o_x2b : std_logic;
signal o_x1b_or_x2b : std_logic;
signal o_x1_and_x2 : std_logic;
signal o_x1_or_x2b : std_logic;
signal o_x1b_and_x2 : std_logic;
signal o_x1_xor_x2 : std_logic;
signal o_x1_eq_x2 : std_logic;
signal o_x1b_or_x2 : std_logic;
signal o_x1_and_x2b : std_logic;
signal o_x1_or_x2 : std_logic;
signal o_x1b_and_x2b : std_logic;

constant clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: universal_function PORT MAP (
i_x1 => i_x1,
i_x2 => i_x2,
o_x1b => o_x1b,
o_x2b => o_x2b,
o_x1b_or_x2b => o_x1b_or_x2b,
o_x1_and_x2 => o_x1_and_x2,
o_x1_or_x2b => o_x1_or_x2b,
o_x1b_and_x2 => o_x1b_and_x2,
o_x1_xor_x2 => o_x1_xor_x2,
o_x1_eq_x2 => o_x1_eq_x2,
o_x1b_or_x2 => o_x1b_or_x2,
o_x1_and_x2b => o_x1_and_x2b,
o_x1_or_x2 => o_x1_or_x2,
o_x1b_and_x2b => o_x1b_and_x2b
);

-- Stimulus process
stim_proc: process
	constant N : integer := 4;
	type input_array is array(0 to N-1) of std_logic_vector(1 downto 0);
	variable xi : input_array := ("00","01","10","11");
begin
	wait for clock_period*10;
	-- insert stimulus here
	l0 : for i in 0 to N-1 loop
		i_x1 <= xi(i)(0);
		i_x2 <= xi(i)(1);

		assert(o_x1b         = ( not i_x1 )                  ) report "fail on x1b"         severity warning;
		assert(o_x2b         = ( not i_x2 )                  ) report "fail on x2b"         severity warning;

		assert(o_x1b_or_x2b  = ( not i_x1   or     not i_x2) ) report "fail on x1b or x2b"  severity warning;
		assert(o_x1_and_x2   = ( i_x1       and    i_x2)     ) report "fail on x1 and x2"   severity warning;
		assert(o_x1_or_x2b   = ( i_x1       or     not i_x2) ) report "fail on x1 or x2b"   severity warning;
		assert(o_x1b_and_x2  = ( not i_x1   and    i_x2)     ) report "fail on x1b and x2"  severity warning;
		assert(o_x1_xor_x2   = ( i_x1       xor    i_x2)     ) report "fail on x1 xor x2"   severity warning;
		assert(o_x1_eq_x2    = ( i_x1       xnor   i_x2)     ) report "fail on x1 xnor x2"  severity warning;
		assert(o_x1b_or_x2   = ( not i_x1   or     i_x2)     ) report "fail on x1b or x2"   severity warning;
		assert(o_x1_and_x2b  = ( i_x1       and    not i_x2) ) report "fail on x1 and x2b"  severity warning;
		assert(o_x1_or_x2    = ( i_x1       or     i_x2)     ) report "fail on x1 or x2"    severity warning;
		assert(o_x1b_and_x2b = ( not i_x1   and    not i_x2) ) report "fail on x1b and x2b" severity warning;

		wait for clock_period;
	end loop l0;
	wait;
end process;

END;
