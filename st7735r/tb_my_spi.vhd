--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:39:23 06/13/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/st7735r/tb_my_spi.vhd
-- Project Name:  st7735r
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: my_spi
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
USE WORK.p_package.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_my_spi IS
END tb_my_spi;

ARCHITECTURE behavior OF tb_my_spi IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT my_spi
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
i_enable : IN  std_logic;
i_data_byte : IN  std_logic_vector(7 downto 0);
o_cs : OUT  std_logic;
o_do : OUT  std_logic;
o_ck : INOUT  std_logic
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_enable : std_logic := '0';
signal i_data_byte : std_logic_vector(7 downto 0) := (others => '0');

--Outputs
signal o_cs : std_logic;
signal o_do : std_logic;
signal o_ck : std_logic;

-- Clock period definitions
constant i_clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: my_spi PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_enable => i_enable,
i_data_byte => i_data_byte,
o_cs => o_cs,
o_do => o_do,
o_ck => o_ck
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

i_reset <= '1';
wait for i_clock_period;
i_reset <= '0';
wait for i_clock_period;

-- insert stimulus here

i_enable <= '1';
i_data_byte <= x"AA";
wait for i_clock_period*BYTE_SIZE*C_CLOCK_COUNTER;
i_enable <= '0';
wait for i_clock_period*C_CLOCK_COUNTER;

i_enable <= '1';
i_data_byte <= x"55";
wait for i_clock_period*BYTE_SIZE*C_CLOCK_COUNTER;
i_enable <= '0';
wait for i_clock_period*C_CLOCK_COUNTER;

wait;
end process;

END;
