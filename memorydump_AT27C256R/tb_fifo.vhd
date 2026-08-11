--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:46:11 02/02/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/logicanalyser/tb_fifo.vhd
-- Project Name:  logicanalyser
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fifo
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
 
ENTITY tb_fifo IS
END tb_fifo;
 
ARCHITECTURE behavior OF tb_fifo IS 
    constant WIDTH : integer := 8;
    constant HEIGHT : integer := 4;
		
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fifo
		GENERIC(
		     WIDTH: integer := WIDTH;
				 HEIGHT : integer := HEIGHT
    );
    PORT(
         i_clk1 : IN  std_logic;
         i_clk2 : IN  std_logic;
         i_data : IN  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
         o_data : OUT  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
         o_full : OUT  std_logic;
         o_empty : OUT  std_logic;
				 o_memory_index : out std_logic_vector(HEIGHT-1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk1 : std_logic := '0';
   signal clk2 : std_logic := '0';
   signal data_in : STD_LOGIC_VECTOR(WIDTH-1 downto 0) := x"00";

 	 --Outputs
   signal data_out : STD_LOGIC_VECTOR(WIDTH-1 downto 0) := x"00";
   signal full : std_logic;
   signal empty : std_logic;
   signal memory_index : std_logic_vector(HEIGHT-1 downto 0);
	 
   -- Clock period definitions
   constant clk1_period : time := 20 ns;
   constant clk2_period : time := 1920 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fifo PORT MAP (
          i_clk1 => clk1,
          i_clk2 => clk2,
          i_data => data_in,
          o_data => data_out,
          o_full => full,
          o_empty => empty,
					o_memory_index => memory_index
        );

   -- Clock process definitions
   clk1_process :process
   begin
		clk1 <= '0';
		wait for clk1_period/2;
		clk1 <= '1';
		wait for clk1_period/2;
		if (full='1') then
		 wait until empty='1';
		end if;
   end process;
 
   clk2_process :process
   begin
	  clk2 <= '0';
		wait for clk2_period/2;
		clk2 <= '1';
		wait for clk2_period/2;
		if (empty='1') then
		 wait until full='1';
		end if;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      --wait for 100 ns;	

      --wait for clk1_period*10;

      -- insert stimulus here 

data_in <= x"12";
wait until rising_edge(clk1);
data_in <= x"23";
wait until rising_edge(clk1);
data_in <= x"34";
wait until rising_edge(clk1);
data_in <= x"45";
wait until rising_edge(clk1);
data_in <= x"56";
wait until rising_edge(clk1);
data_in <= x"67";
wait until rising_edge(clk1);
data_in <= x"78";
wait until rising_edge(clk1);
data_in <= x"89";
wait until rising_edge(clk1);
data_in <= x"90";
wait until rising_edge(clk1);
data_in <= x"00";
wait until rising_edge(clk1);
wait;

   end process;

END;
