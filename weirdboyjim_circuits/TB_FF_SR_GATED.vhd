--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:52:07 08/10/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl/TB_FF_SR_GATED.vhd
-- Project Name:  vhdl
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FF_SR_GATED
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
 
ENTITY TB_FF_SR_GATED IS
END TB_FF_SR_GATED;
 
ARCHITECTURE behavior OF TB_FF_SR_GATED IS 

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

	COMPONENT FF_SR_GATED1
	GENERIC(
	delay_and : time := 0 ns;
	delay_or : time := 0 ns;
	delay_not : time := 0 ns;
	delay_nand2 : time := 0 ns;
	delay_nor2 : time := 0 ns
	);
	PORT(
	S : IN  std_logic;
	R : IN  std_logic;
	E : IN  std_logic;
	Q1 : INOUT  std_logic;
	Q2 : INOUT  std_logic
	);
	END COMPONENT;

	COMPONENT FF_SR_GATED2
	GENERIC(
	delay_and : time := 0 ns;
	delay_or : time := 0 ns;
	delay_not : time := 0 ns;
	delay_nand2 : time := 0 ns;
	delay_nor2 : time := 0 ns
	);
	PORT(
	S : IN  std_logic;
	R : IN  std_logic;
	E : IN  std_logic;
	Q1 : INOUT  std_logic;
	Q2 : INOUT  std_logic
	);
	END COMPONENT;

	COMPONENT FF_SR_GATED3
	GENERIC(
	delay_and : time := 0 ns;
	delay_or : time := 0 ns;
	delay_not : time := 0 ns;
	delay_nand2 : time := 0 ns;
	delay_nor2 : time := 0 ns
	);
	PORT(
	S : IN  std_logic;
	R : IN  std_logic;
	E : IN  std_logic;
	Q1 : INOUT  std_logic;
	Q2 : INOUT  std_logic
	);
	END COMPONENT;

	COMPONENT FF_SR_GATED4
	GENERIC(
	delay_and : time := 0 ns;
	delay_or : time := 0 ns;
	delay_not : time := 0 ns;
	delay_nand2 : time := 0 ns;
	delay_nor2 : time := 0 ns
	);
	PORT(
	S : IN  std_logic;
	R : IN  std_logic;
	E : IN  std_logic;
	Q1 : INOUT  std_logic;
	Q2 : INOUT  std_logic
	);
	END COMPONENT;

	COMPONENT FF_SR_GATED5
	GENERIC(
	delay_and : time := 0 ns;
	delay_or : time := 0 ns;
	delay_not : time := 0 ns;
	delay_nand2 : time := 0 ns;
	delay_nor2 : time := 0 ns
	);
	PORT(
	S : IN  std_logic;
	R : IN  std_logic;
	E : IN  std_logic;
	Q1 : INOUT  std_logic;
	Q2 : INOUT  std_logic
	);
	END COMPONENT;

	COMPONENT FF_SR_GATED6
	GENERIC(
	delay_and : time := 0 ns;
	delay_or : time := 0 ns;
	delay_not : time := 0 ns;
	delay_nand2 : time := 0 ns;
	delay_nor2 : time := 0 ns
	);
	PORT(
	S : IN  std_logic;
	R : IN  std_logic;
	E : IN  std_logic;
	Q1 : INOUT  std_logic;
	Q2 : INOUT  std_logic
	);
	END COMPONENT;

	for all : FF_SR_GATED1 use entity WORK.FF_SR_GATED(Behavioral_GATED_SR_1);
	for all : FF_SR_GATED2 use entity WORK.FF_SR_GATED(Behavioral_GATED_SR_2);
	for all : FF_SR_GATED3 use entity WORK.FF_SR_GATED(LUT_GATED_SR_1);
	for all : FF_SR_GATED4 use entity WORK.FF_SR_GATED(LUT_GATED_SR_2);
	for all : FF_SR_GATED5 use entity WORK.FF_SR_GATED(LUT_GATED_SR_1_WON);
	for all : FF_SR_GATED6 use entity WORK.FF_SR_GATED(LUT_GATED_SR_2_WON);

	signal CLK : std_logic;
	signal S : std_logic := '0';
	signal R : std_logic := '0';
	signal Q1_1,Q1_2,Q1_3,Q1_4,Q1_5,Q1_6 : std_logic;
	signal Q2_1,Q2_2,Q2_3,Q2_4,Q2_5,Q2_6 : std_logic;

	constant delay_and : time := 0 ns;
	constant delay_or : time := 0 ns;
	constant delay_not : time := 0 ns;
	constant delay_nand2 : time := 0 ns;
	constant delay_nor2 : time := 0 ns;
 
BEGIN

	clk_gen(CLK, 10 ns, 20 ns, 20 ns);

	uut1: FF_SR_GATED1
	GENERIC MAP (
	delay_and => delay_and,
	delay_or => delay_or,
	delay_not => delay_not,
	delay_nand2 => delay_nand2,
	delay_nor2 => delay_nor2
	)
	PORT MAP (
	S => S,
	R => R,
	E => CLK,
	Q1 => Q1_1,
	Q2 => Q2_1
	);

	uut2: FF_SR_GATED2
	GENERIC MAP (
	delay_and => delay_and,
	delay_or => delay_or,
	delay_not => delay_not,
	delay_nand2 => delay_nand2,
	delay_nor2 => delay_nor2
	)
	PORT MAP (
	S => S,
	R => R,
	E => CLK,
	Q1 => Q1_2,
	Q2 => Q2_2
	);

	uut3: FF_SR_GATED3
	GENERIC MAP (
	delay_and => delay_and,
	delay_or => delay_or,
	delay_not => delay_not,
	delay_nand2 => delay_nand2,
	delay_nor2 => delay_nor2
	)
	PORT MAP (
	S => S,
	R => R,
	E => CLK,
	Q1 => Q1_3,
	Q2 => Q2_3
	);

	uut4: FF_SR_GATED4
	GENERIC MAP (
	delay_and => delay_and,
	delay_or => delay_or,
	delay_not => delay_not,
	delay_nand2 => delay_nand2,
	delay_nor2 => delay_nor2
	)
	PORT MAP (
	S => S,
	R => R,
	E => CLK,
	Q1 => Q1_4,
	Q2 => Q2_4
	);

	uut5: FF_SR_GATED5
	GENERIC MAP (
	delay_and => delay_and,
	delay_or => delay_or,
	delay_not => delay_not,
	delay_nand2 => delay_nand2,
	delay_nor2 => delay_nor2
	)
	PORT MAP (
	S => S,
	R => R,
	E => CLK,
	Q1 => Q1_5,
	Q2 => Q2_5
	);

	uut6: FF_SR_GATED6
	GENERIC MAP (
	delay_and => delay_and,
	delay_or => delay_or,
	delay_not => delay_not,
	delay_nand2 => delay_nand2,
	delay_nor2 => delay_nor2
	)
	PORT MAP (
	S => S,
	R => R,
	E => CLK,
	Q1 => Q1_6,
	Q2 => Q2_6
	);

	stim_proc: process
	begin
		S <= '0';
		R <= '1';
		wait for 15 ns;
		S <= '1';
		R <= '0';
		wait for 10 ns;
		S <= '0';
		R <= '1';
		wait for 10 ns;
		S <= '1';
		R <= '0';
		wait for 5 ns;
		S <= '0';
		R <= '1';
		wait for 5 ns;
		S <= '1';
		R <= '0';
		wait for 10 ns;
		S <= '0';
		R <= '1';
		wait for 10 ns;
		S <= '1';
		R <= '0';
		wait for 15 ns;
		S <= '0';
		R <= '1';
		wait for 5 ns;
		S <= '1';
		R <= '0';
		wait for 15 ns;
		S <= '0';
		R <= '1';
		wait for 20 ns;
		S <= '1';
		R <= '0';
		wait for 5 ns;
		S <= '0';
		R <= '1';
		wait for 10 ns;
		S <= '1';
		R <= '0';
		wait for 5 ns;
		S <= '0';
		R <= '1';
		wait for 5 ns;
		S <= '1';
		R <= '0';
		wait for 10 ns;
		S <= '0';
		R <= '1';
		wait for 10 ns;
		report "done" severity failure;
	end process;

END;
