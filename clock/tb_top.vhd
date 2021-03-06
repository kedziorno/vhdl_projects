--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:06:42 09/11/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/i2c_test_2/tb_top.vhd
-- Project Name:  i2c_test_1
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_top IS
END tb_top;
 
ARCHITECTURE behavior OF tb_top IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top GENERIC(
	 g_board_clock : INTEGER;
	 g_bus_clock : INTEGER);
    PORT(
         clk : IN  std_logic;
         btn_1 : IN  std_logic;
         btn_2 : IN  std_logic;
         btn_3 : IN  std_logic;
         btn_4 : IN  std_logic;
         sda : INOUT  std_logic;
         scl : INOUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal btn_1 : std_logic := '0';
   signal btn_2 : std_logic := '0';
   signal btn_3 : std_logic := '0';
   signal btn_4 : std_logic := '0';

	--BiDirs
   signal sda : std_logic;
   signal scl : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant board_clock : integer := 1_000_000; -- 20ms
   constant bus_clock : integer := 2_000; -- 20 ms

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top
	GENERIC MAP (
	g_board_clock => board_clock,
	g_bus_clock => bus_clock)
	PORT MAP (
          clk => clk,
          btn_1 => btn_1,
          btn_2 => btn_2,
          btn_3 => btn_3,
          btn_4 => btn_4,
          sda => sda,
          scl => scl
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
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
