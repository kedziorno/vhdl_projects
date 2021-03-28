--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:35:05 11/30/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/memorymodule/tb_memorymodule.vhd
-- Project Name:  memorymodule
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: memorymodule
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

ENTITY tb_memorymodule IS
END tb_memorymodule;

ARCHITECTURE behavior OF tb_memorymodule IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT memorymodule
    PORT(
         i_clock : IN  std_logic;
         i_enable : IN  std_logic;
         i_write : IN  std_logic;
         i_read : IN  std_logic;
         i_MemAdr : IN  std_logic_vector(23 downto 0);
         i_MemDB : IN  std_logic_vector(15 downto 0);
         o_MemDB : OUT  std_logic_vector(15 downto 0);
         io_MemOE : OUT  std_logic;
         io_MemWR : OUT  std_logic;
         io_RamAdv : OUT  std_logic;
         io_RamCS : OUT  std_logic;
         io_RamLB : OUT  std_logic;
         io_RamUB : OUT  std_logic;
         io_MemAdr : OUT  std_logic_vector(23 downto 0);
         io_MemDB : INOUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;

   --Inputs
   signal i_clock : std_logic := '0';
   signal i_enable : std_logic := '0';
   signal i_write : std_logic := '0';
   signal i_read : std_logic := '0';
   signal i_MemAdr : std_logic_vector(23 downto 0) := (others => '0');
   signal i_MemDB : std_logic_vector(15 downto 0) := (others => '0');

	--BiDirs
   signal io_MemDB : std_logic_vector(15 downto 0);

 	--Outputs
   signal o_MemDB : std_logic_vector(15 downto 0);
   signal io_MemOE : std_logic;
   signal io_MemWR : std_logic;
   signal io_RamAdv : std_logic;
   signal io_RamCS : std_logic;
   signal io_RamLB : std_logic;
   signal io_RamUB : std_logic;
   signal io_MemAdr : std_logic_vector(23 downto 0);

   -- Clock period definitions
   constant i_clock_period : time := (1_000_000_000 / G_BOARD_CLOCK) * 1 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: memorymodule PORT MAP (
          i_clock => i_clock,
          i_enable => i_enable,
          i_write => i_write,
          i_read => i_read,
          i_MemAdr => i_MemAdr,
          i_MemDB => i_MemDB,
          o_MemDB => o_MemDB,
          io_MemOE => io_MemOE,
          io_MemWR => io_MemWR,
          io_RamAdv => io_RamAdv,
          io_RamCS => io_RamCS,
          io_RamLB => io_RamLB,
          io_RamUB => io_RamUB,
          io_MemAdr => io_MemAdr,
          io_MemDB => io_MemDB
        );

   -- Clock process definitions
   i_clock_process :process
   begin
		i_clock <= '0';
		wait for i_clock_period/2;
		i_clock <= '1';
		wait for i_clock_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin
      -- hold reset state for 100 ns.
      wait for 100 ns;
      -- insert stimulus here
		-- write
		wait for i_clock_period*10;
		i_enable <= '1';
      wait for i_clock_period;
		i_write <= '1';
		wait for i_clock_period;
		i_MemAdr <= x"222222";
		i_MemDB <= x"1234";
		wait for i_clock_period;
		i_write <= '0';
		wait for i_clock_period;
		i_enable <= '0';
		-- read
		wait for i_clock_period*10;
		i_enable <= '1';
      wait for i_clock_period;
		i_read <= '1';
		wait for i_clock_period;
		i_MemAdr <= x"222222";
		--i_MemDB <= x"1234";
		wait for i_clock_period;
		i_read <= '0';
		wait for i_clock_period;
		i_enable <= '0';
		wait;
   end process;

END;
