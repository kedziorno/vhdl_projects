--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:15:12 05/09/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_hurst_gates.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: hurst_gates
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

ENTITY tb_hurst_gates IS
END tb_hurst_gates;

ARCHITECTURE behavior OF tb_hurst_gates IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT hurst_gates
PORT(
a : IN  std_logic;
b : IN  std_logic;
c : IN  std_logic;
y1 : OUT  std_logic;
y2 : OUT  std_logic;
y3 : OUT  std_logic;
y4 : OUT  std_logic;
y5 : OUT  std_logic;
y6 : OUT  std_logic
);
END COMPONENT;

--Inputs
signal a : std_logic := '0';
signal b : std_logic := '0';
signal c : std_logic := '0';

--Outputs
signal y1 : std_logic;
signal y2 : std_logic;
signal y3 : std_logic;
signal y4 : std_logic;
signal y5 : std_logic;
signal y6 : std_logic;

constant clock_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: hurst_gates PORT MAP (
a => a,
b => b,
c => c,
y1 => y1,
y2 => y2,
y3 => y3,
y4 => y4,
y5 => y5,
y6 => y6
);

-- Stimulus process
stim_proc: process
	constant N : integer := 4;
	type input_array is array(0 to N-1) of std_logic_vector(1 downto 0);
	variable input : input_array := ("01","01","10","11");
	constant M : integer := 16;
	type fy1_record is record
		ip : std_logic_vector(2 downto 0);
		op : std_logic;
	end record fy1_record;
	type fy1_array is array(0 to M-1) of fy1_record;
	variable fy1 : fy1_array := ( -- a b c
		(('1',               '0',               input(0)(1)),     input(0)(0)), -- 1 0 x2
		(('0',               '0',               input(0)(1)),     input(0)(1)), -- 0 0 x2
		((not input(0)(0),   '0',               input(0)(1)),     input(0)(0)), -- x1b 0 x2
		((input(0)(0),       '0',               input(0)(1)),     not input(0)(0)), -- x1 0 x2
		((not input(0)(1),   '0',               input(0)(1)),     input(0)(1)), -- x2b 0 x2
		((input(0)(1),       '0',               input(0)(1)),     not input(0)(1)), -- x2 0 x2
		((input(0)(0),       '1',               input(0)(1)),     input(0)(0) and input(0)(1)), -- x1 1 x2
		((input(0)(0),       '1',               not input(0)(1)), input(0)(0) and not input(0)(1)), -- x1 1 x2b
		((not input(0)(0),   '1',               not input(0)(1)), not input(0)(0) and input(0)(1)), -- x1b 1 x2b
		((not input(0)(0),   '1',               not input(0)(1)), not input(0)(0) and not input(0)(1)), -- x1b 1 x2b
		((not input(0)(0),   not input(0)(0),   input(0)(1)),     input(0)(0) or input(0)(1)), -- x1b x1b x2
		((not input(0)(0),   not input(0)(0),   not input(0)(1)), input(0)(0) or not input(0)(1)), -- x1b x1b x2b
		((input(0)(0),       input(0)(0),       input(0)(1)),     not input(0)(0) or input(0)(1)), -- x1 x1 x2
		((input(0)(0),       input(0)(0),       not input(0)(1)), not input(0)(0) or not input(0)(1)), -- x1 x1 x2b
		((not input(0)(0),   input(0)(1),       input(0)(1)),     input(0)(0) xor input(0)(1)), -- x1b x2 x2
		((input(0)(0),       input(0)(1),       input(0)(1)),     input(0)(0) xnor input(0)(1)) -- x1 x2 x2
	);
begin
	wait for clock_period;
	-- insert stimulus here
	l0 : for i in fy1'range loop
		a <= fy1(i).ip(0);
		b <= fy1(i).ip(1);
		c <= fy1(i).ip(2);
		assert (y1=fy1(i).op)
			report
			"fail on i="&integer'image(i)&",y="&std_logic'image(y1)&" expected "&std_logic'image(fy1(i).op)
			severity warning;
		wait for clock_period;
	end loop l0;	
wait;
end process;

END;
