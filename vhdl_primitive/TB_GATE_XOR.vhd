--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:48:40 08/08/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl/TB_GATE_XOR.vhd
-- Project Name:  vhdl
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GATE_XOR
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
 
ENTITY TB_GATE_XOR IS
END TB_GATE_XOR;
 
ARCHITECTURE behavior OF TB_GATE_XOR IS 

	COMPONENT GATE_XOR_1
	PORT(
	A : IN  std_logic;
	B : IN  std_logic;
	C : OUT  std_logic
	);
	END COMPONENT;

	COMPONENT GATE_XOR_2
	PORT(
	A : IN  std_logic;
	B : IN  std_logic;
	C : OUT  std_logic
	);
	END COMPONENT;
	
	for all : GATE_XOR_1 use entity WORK.GATE_XOR(GATE_XOR_BEHAVIORAL_1);
	for all : GATE_XOR_2 use entity WORK.GATE_XOR(GATE_XOR_BEHAVIORAL_2);
	
	signal A : std_logic := '0';
	signal B : std_logic := '0';
	signal C1,C2 : std_logic;
	
BEGIN

	uut1: GATE_XOR_1 PORT MAP (
	A => A,
	B => B,
	C => C1
	);

	uut2: GATE_XOR_2 PORT MAP (
	A => A,
	B => B,
	C => C2
	);

	stim_proc: process
	begin		
		wait for 100 ns;
		A <= '1';
		B <= '1';
		wait for 100 ns;
		A <= '0';
		B <= '1';
		wait for 100 ns;
		A <= '1';
		B <= '0';
		wait for 100 ns;
		A <= '0';
		B <= '0';
		wait;
	end process;

END;
