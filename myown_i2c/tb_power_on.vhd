--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:38:18 08/25/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/oled_128x32_1/tb_power_on.vhd
-- Project Name:  oled_128x32_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: power_on
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
USE WORK.p_constants1.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_power_on IS
END tb_power_on;
 
ARCHITECTURE behavior OF tb_power_on IS 

    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT power_on
    PORT(
         i_clock : IN  std_logic;
         i_reset : IN std_logic;
         o_sda : OUT  std_logic;
         o_scl : OUT  std_logic
        );
    END COMPONENT;

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal sda : std_logic;
   signal scl : std_logic;

   -- Clock period definitions
   constant clock_period_50Mhz : time := (1_000_000_000/G_BOARD_CLOCK) * 1 ns;
   signal clock_50mhz : std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: power_on PORT MAP (
		i_clock => clock_50mhz,
		i_reset => reset,
		o_sda => sda,
		o_scl => scl
	);

	-- Clock process definitions
	clock_process_50MHZ : process
	begin
		clock_50mhz <= '0';
		wait for clock_period_50Mhz/2;
		clock_50mhz <= '1';
		wait for clock_period_50Mhz/2;
	end process;

--	clock_process : process (reset,clock_50mhz) is
----	constant clock_period : time := 18.368 us;
--		constant clock_period : time := 0.23368*2 us;
--		constant t : integer := (clock_period / clock_period_50Mhz);
--		variable v : integer range 0 to t-1;
--	begin
--		if (reset = '1') then
--			v := 0;
--			report "t : " & integer'image(t);
--		elsif (rising_edge(clock_50mhz)) then
--			if (v = t-1) then
--				v := 0;
--				clock <= '1';
--			else
--				v := v + 1;
--				clock <= '0';
--			end if;
--		end if;
--	end process clock_process;

	-- Stimulus process
	stim_proc: process
	begin
		reset <= '1';
		wait for clock_period_50mhz;
		reset <= '0';
		wait for 5000 us;
		report "done" severity failure;
	end process;

END;
