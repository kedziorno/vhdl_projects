--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:09:42 08/10/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl/TB_GATE_XNOR.vhd
-- Project Name:  vhdl
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GATE_XNOR
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
 
ENTITY TB_GATES_AND_OR_NOT_XOR_XNOR IS
END TB_GATES_AND_OR_NOT_XOR_XNOR;
 
ARCHITECTURE behavior OF TB_GATES_AND_OR_NOT_XOR_XNOR IS 

	COMPONENT GATE_AND
	PORT(
	A : IN  std_logic;
	B : IN  std_logic;
	C : OUT  std_logic
	);
	END COMPONENT;
	
	COMPONENT GATE_OR
	PORT(
	A : IN  std_logic;
	B : IN  std_logic;
	C : OUT  std_logic
	);
	END COMPONENT;

	COMPONENT GATE_NOT
	PORT(
	A : IN  std_logic;
	B : OUT  std_logic
	);
	END COMPONENT;
	
	COMPONENT GATE_XOR1
	PORT(
	A : IN  std_logic;
	B : IN  std_logic;
	C : OUT  std_logic
	);
	END COMPONENT;
	
	COMPONENT GATE_XOR2
	PORT(
	A : IN  std_logic;
	B : IN  std_logic;
	C : OUT  std_logic
	);
	END COMPONENT;
	
	COMPONENT GATE_XNOR
	PORT(
	A : IN  std_logic;
	B : IN  std_logic;
	C : OUT  std_logic
	);
	END COMPONENT;

	for all : GATE_AND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
	for all : GATE_OR use entity WORK.GATE_OR(GATE_OR_BEHAVIORAL_1);
	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
	for all : GATE_XOR1 use entity WORK.GATE_XOR(GATE_XOR_BEHAVIORAL_1);
	for all : GATE_XOR2 use entity WORK.GATE_XOR(GATE_XOR_BEHAVIORAL_2);
	for all : GATE_XNOR use entity WORK.GATE_XNOR(GATE_XNOR_BEHAVIORAL_1);

	signal A : std_logic := '0';
	signal B : std_logic := '0';
	signal C_AND,C_OR,C_NOT,C_XOR1,C_XOR2,C_XNOR : std_logic;

BEGIN
 
	uut1: GATE_AND PORT MAP (
	A => A,
	B => B,
	C => C_AND
	);
	
	uut2: GATE_OR PORT MAP (
	A => A,
	B => B,
	C => C_OR
	);
	
	uut3: GATE_NOT PORT MAP (
	A => A,
	B => C_NOT
	);
	
	uut4: GATE_XOR1 PORT MAP (
	A => A,
	B => B,
	C => C_XOR1
	);
	
	uut5: GATE_XOR2 PORT MAP (
	A => A,
	B => B,
	C => C_XOR2
	);
	
	uut6: GATE_XNOR PORT MAP (
	A => A,
	B => B,
	C => C_XNOR
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
