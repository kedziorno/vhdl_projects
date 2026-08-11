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
	PORT(
	S : IN  std_logic;
	R : IN  std_logic;
	E : IN  std_logic;
	Q1 : INOUT  std_logic;
	Q2 : INOUT  std_logic
	);
	END COMPONENT;

	COMPONENT FF_SR_GATED2
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

	signal CLK : std_logic;
	signal S : std_logic := '0';
	signal R : std_logic := '0';
	signal Q1_1,Q1_2 : std_logic;
	signal Q2_1,Q2_2 : std_logic;
 
BEGIN

	clk_gen(CLK, 10 ns, 20 ns, 20 ns);

	uut1: FF_SR_GATED1 PORT MAP (
	S => S,
	R => R,
	E => CLK,
	Q1 => Q1_1,
	Q2 => Q2_1
	);

	uut2: FF_SR_GATED2 PORT MAP (
	S => S,
	R => R,
	E => CLK,
	Q1 => Q1_2,
	Q2 => Q2_2
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
	end process;

END;
