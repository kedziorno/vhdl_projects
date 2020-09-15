--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:54:46 08/10/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl/TB_FF_D_GATED.vhd
-- Project Name:  vhdl
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FF_D_GATED
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
 
ENTITY TB_FF_D_GATED IS
END TB_FF_D_GATED;
 
ARCHITECTURE behavior OF TB_FF_D_GATED IS 

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
	
	COMPONENT FF_D_GATED_NAND
	PORT(
	D : IN  std_logic;
	E : IN  std_logic;
	Q1 : INOUT  std_logic;
	Q2 : INOUT  std_logic
	);
	END COMPONENT;

	COMPONENT FF_D_GATED_NOR
	PORT(
	D : IN  std_logic;
	E : IN  std_logic;
	Q1 : INOUT  std_logic;
	Q2 : INOUT  std_logic
	);
	END COMPONENT;

	for all : FF_D_GATED_NAND use entity WORK.FF_D_GATED(Behavioral_GATED_D_NAND);
	for all : FF_D_GATED_NOR use entity WORK.FF_D_GATED(Behavioral_GATED_D_NOR);
	
	signal CLK : std_logic;
	signal D : std_logic := '0';
	signal Q1_NAND,Q1_NOR : std_logic;
	signal Q2_NAND,Q2_NOR : std_logic;

BEGIN

	clk_gen(CLK, 10 ns, 20 ns, 20 ns);

	uut1: FF_D_GATED_NAND PORT MAP (
	D => D,
	E => CLK,
	Q1 => Q1_NAND,
	Q2 => Q2_NAND
	);

	uut2: FF_D_GATED_NOR PORT MAP (
	D => D,
	E => CLK,
	Q1 => Q1_NOR,
	Q2 => Q2_NOR
	);

	stim_proc: process
	begin		
		D <= '0';
		wait for 15 ns;
		D <= '1';
		wait for 10 ns;
		D <= '0';
		wait for 10 ns;
		D <= '1';
		wait for 5 ns;
		D <= '0';
		wait for 5 ns;
		D <= '1';
		wait for 10 ns;
		D <= '0';
		wait for 10 ns;
		D <= '1';
		wait for 15 ns;
		D <= '0';
		wait for 5 ns;
		D <= '1';
		wait for 15 ns;
		D <= '0';
		wait for 20 ns;
		D <= '1';
		wait for 5 ns;
		D <= '0';
		wait for 10 ns;
		D <= '1';
		wait for 5 ns;
		D <= '0';
		wait for 5 ns;
		D <= '1';
		wait for 10 ns;
		D <= '0';
		wait for 10 ns;
	end process;

END;
