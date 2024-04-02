--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:37:20 12/11/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/test_oled_mem/tb_top.vhd
-- Project Name:  test_oled_mem
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
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
USE WORK.p_memory_content.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_top IS
END tb_top;
 
ARCHITECTURE behavior OF tb_top IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         clk : IN  std_logic;
         sda : INOUT  std_logic;
         scl : INOUT  std_logic;
         io_MemOE : INOUT  std_logic;
         io_MemWR : INOUT  std_logic;
         io_RamAdv : INOUT  std_logic;
         io_RamCS : INOUT  std_logic;
         io_RamCRE : INOUT  std_logic;
         io_RamLB : INOUT  std_logic;
         io_RamUB : INOUT  std_logic;
         io_RamWait : INOUT  std_logic;
         io_RamClk : INOUT  std_logic;
         io_MemAdr : INOUT  MemoryAddress;
         io_MemDB : INOUT  MemoryDataByte
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';

	--BiDirs
   signal sda : std_logic;
   signal scl : std_logic;
   signal io_MemOE : std_logic;
   signal io_MemWR : std_logic;
   signal io_RamAdv : std_logic;
   signal io_RamCS : std_logic;
   signal io_RamCRE : std_logic;
   signal io_RamLB : std_logic;
   signal io_RamUB : std_logic;
   signal io_RamWait : std_logic;
   signal io_RamClk : std_logic;
   signal io_MemAdr : MemoryAddress;
   signal io_MemDB : MemoryDataByte;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          clk => clk,
          sda => sda,
          scl => scl,
          io_MemOE => io_MemOE,
          io_MemWR => io_MemWR,
          io_RamAdv => io_RamAdv,
          io_RamCS => io_RamCS,
          io_RamCRE => io_RamCRE,
          io_RamLB => io_RamLB,
          io_RamUB => io_RamUB,
          io_RamWait => io_RamWait,
          io_RamClk => io_RamClk,
          io_MemAdr => io_MemAdr,
          io_MemDB => io_MemDB
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      -- insert stimulus here 
      wait;
   end process;

END;
