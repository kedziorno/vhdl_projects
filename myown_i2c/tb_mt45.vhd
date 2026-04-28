--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:47:42 04/28/2026
-- Design Name:   
-- Module Name:   /home/user/_WORKSPACE_/kedziorno/vhdl_projects/myown_i2c/tb_mt45.vhd
-- Project Name:  myown_i2c
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mt45w8mw16bgx
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
 
ENTITY tb_mt45 IS
END tb_mt45;
 
ARCHITECTURE behavior OF tb_mt45 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mt45w8mw16bgx
    PORT(
         Addr : IN  std_logic_vector(22 downto 0);
         Adv_n : IN  std_logic;
         Ce_n : IN  std_logic;
         Clk : IN  std_logic;
         Cre : IN  std_logic;
         Dq : INOUT  std_logic_vector(15 downto 0);
         Lb_n : IN  std_logic;
         Oe_n : IN  std_logic;
         oWait : OUT  std_logic;
         Ub_n : IN  std_logic;
         We_n : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Addr : std_logic_vector(22 downto 0) := (others => '0');
   signal Adv_n : std_logic := '0';
   signal Ce_n : std_logic := '0';
   signal Clk : std_logic := '0';
   signal Cre : std_logic := '0';
   signal Lb_n : std_logic := '0';
   signal Oe_n : std_logic := '0';
   signal Ub_n : std_logic := '0';
   signal We_n : std_logic := '0';

	--BiDirs
   signal Dq : std_logic_vector(15 downto 0);

 	--Outputs
   signal oWait : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mt45w8mw16bgx PORT MAP (
          Addr => Addr,
          Adv_n => Adv_n,
          Ce_n => Ce_n,
          Clk => Clk,
          Cre => Cre,
          Dq => Dq,
          Lb_n => Lb_n,
          Oe_n => Oe_n,
          oWait => oWait,
          Ub_n => Ub_n,
          We_n => We_n
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for Clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
