--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:35:28 03/25/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/hd44780/tb_hd44780.vhd
-- Project Name:  hd44780
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: hd44780
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

ENTITY tb_hd44780 IS
END tb_hd44780;

ARCHITECTURE behavior OF tb_hd44780 IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT hd44780
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
i_enable : IN  std_logic;
i_data_type : IN  std_logic;
i_data : IN  std_logic_vector(7 downto 0);
o_busy : OUT std_logic;
o_rs : OUT  std_logic;
o_rw : OUT  std_logic;
o_e : OUT  std_logic;
o_db : INOUT  std_logic_vector(7 downto 0)
);
END COMPONENT;


--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_enable : std_logic := '0';
signal i_data_type : std_logic := '0';
signal i_data : std_logic_vector(7 downto 0) := (others => '0');

--BiDirs
signal o_db : std_logic_vector(7 downto 0);

--Outputs
signal o_rs : std_logic;
signal o_rw : std_logic;
signal o_e : std_logic;
signal o_busy : std_logic;

-- Clock period definitions
constant i_clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: hd44780 PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_enable => i_enable,
i_data_type => i_data_type,
i_data => i_data,
o_busy => o_busy,
o_rs => o_rs,
o_rw => o_rw,
o_e => o_e,
o_db => o_db
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
i_reset <= '1';
wait for 100 ns;	
i_reset <= '0';
wait for i_clock_period;
-- insert stimulus here 
i_enable <= '1';
i_data_type <= '0';
i_data <= x"38";
wait until o_busy = '0';
i_enable <= '0';
i_data_type <= '1';
i_data <= x"01";

wait;
end process;

END;
