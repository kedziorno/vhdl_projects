--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:43:49 01/17/2022
-- Design Name:   
-- Module Name:   
-- Project Name:  
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: my_i2c_pc
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

ENTITY tb_my_i2c_pc IS
END tb_my_i2c_pc;

ARCHITECTURE behavior OF tb_my_i2c_pc IS

constant N : integer := 20;

COMPONENT my_i2c_pc
GENERIC(
CONSTANT N : integer
);
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
i_slave_address : IN  std_logic_vector(0 to 6);
i_slave_rw : in std_logic;
i_bytes_to_send : IN  std_logic_vector(0 to 7);
i_enable : IN  std_logic;
o_busy : OUT  std_logic;
o_sda : OUT  std_logic;
o_scl : OUT  std_logic
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_slave_address : std_logic_vector(0 to 6) := "0011110";
signal i_slave_rw : std_logic := '1';
signal i_bytes_to_send : std_logic_vector(0 to 7) := "11010101";
signal i_enable : std_logic := '0';

--Outputs
signal o_busy : std_logic;
signal o_sda : std_logic;
signal o_scl : std_logic;

-- Clock period definitions
constant i_clock_period : time := 1 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: my_i2c_pc
GENERIC MAP (
N => N
)
PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_slave_rw => i_slave_rw,
i_slave_address => i_slave_address,
i_bytes_to_send => i_bytes_to_send,
i_enable => i_enable,
o_busy => o_busy,
o_sda => o_sda,
o_scl => o_scl
);

-- Clock process definitions
i_clock_process :process
begin
i_clock <= '0';
wait for i_clock_period/2;
i_clock <= '1';
wait for i_clock_period/2;
end process;

i_reset <= '1', '0' after 1 ns;
--i_reset <= i_clock;
-- Stimulus process
stim_proc: process
begin
i_enable <= '1';
-- start + address + rw + byte + ack + stop
wait for (1 + 7 + 1 + 8 + 1 + 1) * i_clock_period * N * 3;
i_enable <= '0';
wait for 1 * i_clock_period * N;
report "done" severity failure;
end process;

END;
