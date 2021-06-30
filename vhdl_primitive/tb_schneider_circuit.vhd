--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:54:49 06/30/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_schneider_circuit.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: schneider_circuit
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
USE ieee.numeric_std.ALL;
 
ENTITY tb_schneider_circuit IS
END tb_schneider_circuit;
 
ARCHITECTURE behavior OF tb_schneider_circuit IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT schneider_circuit
    PORT(
         x1 : IN  std_logic;
         x2 : IN  std_logic;
         x3 : IN  std_logic;
         x4 : IN  std_logic;
         y : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal x1 : std_logic := '0';
   signal x2 : std_logic := '0';
   signal x3 : std_logic := '0';
   signal x4 : std_logic := '0';

 	--Outputs
   signal y : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

signal clock : std_logic;
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: schneider_circuit PORT MAP (
          x1 => x1,
          x2 => x2,
          x3 => x3,
          x4 => x4,
          y => y
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
variable index : integer range 0 to 15 := 0;
variable xs : std_logic_vector(3 downto 0) := (others => '0');
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*10;

      -- insert stimulus here 

x1 <= '1';
x2 <= '1';
x3 <= '1';
x4 <= '1';
wait for clock_period;

x1 <= '0';
x2 <= '0';
x3 <= '0';
x4 <= '0';
wait for clock_period;

x1 <= 'Z';
x2 <= 'Z';
x3 <= 'Z';
x4 <= 'Z';
wait for clock_period;

x1 <= '-';
x2 <= '-';
x3 <= '-';
x4 <= '-';
wait for clock_period;

x1 <= 'U';
x2 <= 'U';
x3 <= 'U';
x4 <= 'U';
wait for clock_period;

l0 : for i in 0 to 15 loop
assert (false) report "i="&integer'image(i) severity note;
xs := std_logic_vector(to_unsigned(i,4));
x1 <= xs(0);
x2 <= xs(1);
x3 <= xs(2);
x4 <= xs(3);
wait for clock_period;
end loop l0;

      wait;
   end process;

END;
