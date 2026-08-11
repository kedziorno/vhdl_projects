--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:10:24 12/09/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/weirdboyjim_circuits/tb_ic_74hct574.vhd
-- Project Name:  weirdboyjim_circuits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ic_74hct574
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
USE ieee.math_real.ALL; -- XXX random uniform

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

ENTITY tb_ic_74hct574 IS
END tb_ic_74hct574;

ARCHITECTURE behavior OF tb_ic_74hct574 IS

	COMPONENT ic_74hct574
	PORT(
		i_d0 : IN  std_logic;
		i_d1 : IN  std_logic;
		i_d2 : IN  std_logic;
		i_d3 : IN  std_logic;
		i_d4 : IN  std_logic;
		i_d5 : IN  std_logic;
		i_d6 : IN  std_logic;
		i_d7 : IN  std_logic;
		i_cp : IN  std_logic;
		i_oe : IN  std_logic;
		o_q0 : OUT  std_logic;
		o_q1 : OUT  std_logic;
		o_q2 : OUT  std_logic;
		o_q3 : OUT  std_logic;
		o_q4 : OUT  std_logic;
		o_q5 : OUT  std_logic;
		o_q6 : OUT  std_logic;
		o_q7 : OUT  std_logic
	);
	END COMPONENT;

	--Inputs
	signal i_d0 : std_logic := '0';
	signal i_d1 : std_logic := '0';
	signal i_d2 : std_logic := '0';
	signal i_d3 : std_logic := '0';
	signal i_d4 : std_logic := '0';
	signal i_d5 : std_logic := '0';
	signal i_d6 : std_logic := '0';
	signal i_d7 : std_logic := '0';
	signal i_cp : std_logic := '0';
	signal i_oe : std_logic := '0';

	--Outputs
	signal o_q0 : std_logic;
	signal o_q1 : std_logic;
	signal o_q2 : std_logic;
	signal o_q3 : std_logic;
	signal o_q4 : std_logic;
	signal o_q5 : std_logic;
	signal o_q6 : std_logic;
	signal o_q7 : std_logic;

	signal clock : std_logic;
	constant clock_period : time := 20 ns;

	signal temp : std_logic_vector(7 downto 0);

BEGIN

	uut: ic_74hct574 PORT MAP (
		i_d0 => i_d0,
		i_d1 => i_d1,
		i_d2 => i_d2,
		i_d3 => i_d3,
		i_d4 => i_d4,
		i_d5 => i_d5,
		i_d6 => i_d6,
		i_d7 => i_d7,
		i_cp => i_cp,
		i_oe => i_oe,
		o_q0 => o_q0,
		o_q1 => o_q1,
		o_q2 => o_q2,
		o_q3 => o_q3,
		o_q4 => o_q4,
		o_q5 => o_q5,
		o_q6 => o_q6,
		o_q7 => o_q7
	);

	clock_process :process
	begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
	end process;

	i_cp <= clock;

	-- Stimulus process
	stim_proc : process
		variable vtemp : std_logic_vector(7 downto 0);
		variable seed1, seed2 : integer := 999;
		variable random : integer := 0;
		-- XXX https://vhdlwhiz.com/random-numbers/
		impure function rand_int(min_val, max_val : integer) return integer is
			variable r : real;
		begin
			uniform(seed1, seed2, r);
			return integer(
				round(r * real(max_val - min_val + 1) + real(min_val) - 0.5));
		end function;
	begin
		wait for 100 ns;
		wait for clock_period*1;
		-- insert stimulus here
		l0 : for i in 0 to 255 loop
			vtemp := std_logic_vector(to_unsigned(i,8));
			random := rand_int(0,255);
			i_d0 <= vtemp(0);
			i_d1 <= vtemp(1);
			i_d2 <= vtemp(2);
			i_d3 <= vtemp(3);
			i_d4 <= vtemp(4);
			i_d5 <= vtemp(5);
			i_d6 <= vtemp(6);
			i_d7 <= vtemp(7);
			temp <= vtemp;
			wait for clock_period*1;
			if (random = i) then
				i_oe <= '0';
			else
				i_oe <= '1';
			end if;
		end loop l0;
		wait for clock_period*1;
		
		wait;
	end process;

END;
