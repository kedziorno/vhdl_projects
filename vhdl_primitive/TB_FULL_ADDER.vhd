--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:50:19 09/09/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl/TB_FULL_ADDER.vhd
-- Project Name:  vhdl
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FULL_ADDER
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
 
ENTITY TB_FULL_ADDER IS
END TB_FULL_ADDER;
 
ARCHITECTURE behavior OF TB_FULL_ADDER IS 

	procedure clk_gen(signal clk : out std_logic; constant wait_start : time; constant HT : time; constant LT : time) is
	begin
		clk <= '0';
		wait for wait_start;
		loop
			clk <= '1';
			wait for HT;
			clk <= '0';
			wait for LT;
		end loop;
	end procedure;
	
	COMPONENT FULL_ADDER
	PORT(
	A : IN  std_logic;
	B : IN  std_logic;
	Cin : IN  std_logic;
	S : OUT  std_logic;
	Cout : OUT  std_logic
	);
	END COMPONENT;

	for all : FULL_ADDER use entity WORK.FULL_ADDER(FULL_ADDER_BEHAVIORAL_1);
	
	signal CLK : std_logic;
	signal A,B,Cin : std_logic := '0';
	signal S,Cout : std_logic;

BEGIN

	clk_gen(CLK, 10 ns, 20 ns, 20 ns);

	uut1: FULL_ADDER PORT MAP (
	A => A,
	B => B,
	Cin => Cin,
	S => S,
	Cout => Cout
	);

	stim_proc: process
	begin
		A <= '0';
		B <= '0';
		Cin <= '0';
		wait for 50 ns;
		A <= '0';
		B <= '0';
		Cin <= '1';
		wait for 50 ns;
		A <= '0';
		B <= '1';
		Cin <= '0';
		wait for 50 ns;
		A <= '0';
		B <= '1';
		Cin <= '1';
		wait for 50 ns;
		A <= '1';
		B <= '0';
		Cin <= '0';
		wait for 50 ns;
		A <= '1';
		B <= '0';
		Cin <= '1';
		wait for 50 ns;
		A <= '1';
		B <= '1';
		Cin <= '0';
		wait for 50 ns;
		A <= '1';
		B <= '1';
		Cin <= '1';
		wait for 50 ns;
	end process;

END;
