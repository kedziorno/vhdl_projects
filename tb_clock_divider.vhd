--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:42:51 09/18/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/i2c_test_2/tb_clock_divider.vhd
-- Project Name:  i2c_test_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clock_divider
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
 
ENTITY tb_clock_divider IS
END tb_clock_divider;
 
ARCHITECTURE behavior OF tb_clock_divider IS 

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

    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clock_divider
	 Generic(g_board_clock : integer);
    PORT(
         i_clk : IN  std_logic;
         o_clk_25khz : OUT  std_logic;
         o_clk_50khz : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_clk : std_logic := '0';

 	--Outputs
   signal o_clk_25khz : std_logic;
   signal o_clk_50khz : std_logic;

   -- Clock period definitions
	constant board_clock : integer := 50_000_000;

BEGIN

	clk_gen(i_clk, 0 ns, 20 ns, 20 ns);

	-- Instantiate the Unit Under Test (UUT)
   uut: clock_divider
	Generic map (g_board_clock => board_clock)
	PORT MAP (
          i_clk => i_clk,
          o_clk_25khz => o_clk_25khz,
          o_clk_50khz => o_clk_50khz
        );

 

   -- Stimulus process
   stim_proc: process
   begin
      wait;
   end process;

END;
