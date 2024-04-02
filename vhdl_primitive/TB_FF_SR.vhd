--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:59:46 08/08/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl/TB_FF_SR.vhd
-- Project Name:  vhdl
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FF_SR
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
USE WORK.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY TB_FF_SR IS
END TB_FF_SR;

ARCHITECTURE behavior OF TB_FF_SR IS 

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

	COMPONENT FF_SR_NOR
	PORT(
	S : IN  std_logic;
	R : IN  std_logic;
	Q1 : INOUT  std_logic;
	Q2 : INOUT  std_logic
	);
	END COMPONENT;

	COMPONENT FF_SR_NAND
	PORT(
	S : IN  std_logic;
	R : IN  std_logic;
	Q1 : INOUT  std_logic;
	Q2 : INOUT  std_logic
	);
	END COMPONENT;

	COMPONENT FF_SR_ANDOR
	PORT(
	S : IN  std_logic;
	R : IN  std_logic;
	Q1 : INOUT  std_logic;
	Q2 : INOUT  std_logic
	);
	END COMPONENT;

	COMPONENT FF_SR_NOTS_NOTR
	PORT(
	S : IN  std_logic;
	R : IN  std_logic;
	Q1 : INOUT  std_logic;
	Q2 : INOUT  std_logic
	);
	END COMPONENT;

	for all : FF_SR_NOR use entity WORK.FF_SR(Behavioral_NOR);
	for all : FF_SR_NAND use entity WORK.FF_SR(Behavioral_NAND);
	for all : FF_SR_ANDOR use entity WORK.FF_SR(Behavioral_ANDOR);
	for all : FF_SR_NOTS_NOTR use entity WORK.FF_SR(Behavioral_NOT_S_NOT_R);

	signal CLK1 : std_logic;
	signal CLK2 : std_logic;
	signal S : std_logic := '0';
	signal R : std_logic := '0';
	signal NOR_Q1,NAND_Q1,ANDOR_Q1,NOTSR_Q1 : std_logic;
	signal NOR_Q2,NAND_Q2,ANDOR_Q2,NOTSR_Q2 : std_logic;

BEGIN

	clk_gen(CLK1, 3 ns, 20 ns, 50 ns);
	clk_gen(CLK2, 7 ns, 35 ns, 10 ns);
	  
	uut_NOR: FF_SR_NOR PORT MAP (
	S => S,
	R => R,
	Q1 => NOR_Q1,
	Q2 => NOR_Q2
	);

	uut_NAND: FF_SR_NAND PORT MAP (
	S => S,
	R => R,
	Q1 => NAND_Q1,
	Q2 => NAND_Q2
	);

	uut_ANDOR: FF_SR_ANDOR PORT MAP (
	S => S,
	R => R,
	Q1 => ANDOR_Q1,
	Q2 => ANDOR_Q2
	);

	uut_NOTSR: FF_SR_NOTS_NOTR PORT MAP (
	S => S,
	R => R,
	Q1 => NOTSR_Q1,
	Q2 => NOTSR_Q2
	);

	stim_proc: process (CLK1,CLK2) is
	begin
		S <= CLK1;
		R <= CLK2;
	end process stim_proc;

END;
