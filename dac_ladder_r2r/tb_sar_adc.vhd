--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:17:33 08/16/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/dac_ladder_r2r/tb_sar_adc.vhd
-- Project Name:  dac_ladder_r2r
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sar_adc
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
use WORK.p_globals.ALL;
use WORK.p_lcd_display.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_sar_adc IS
END tb_sar_adc;

ARCHITECTURE behavior OF tb_sar_adc IS

--constant C_CLOCK : integer := 200; -- XXX tb
constant C_CLOCK : integer := 50_000_000; -- XXX orig
constant C_DATA_SIZE : integer := 12;

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT sar_adc
GENERIC (
G_BOARD_CLOCK : integer;
data_size : integer
);
PORT(
i_clock : in std_logic;
i_reset : in std_logic;
i_from_comparator : in std_logic;
io_ladder : inout std_logic_vector(data_size-1 downto 0);
o_anode : out std_logic_vector(G_LCDAnode-1 downto 0);
o_segment : out std_logic_vector(G_LCDSegment-1 downto 0);
o_eoc : out std_logic
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_from_comparator : std_logic := '0';

signal io_ladder : std_logic_vector(C_DATA_SIZE-1 downto 0);

--Outputs
signal o_anode : std_logic_vector(G_LCDAnode-1 downto 0);
signal o_segment : std_logic_vector(G_LCDSegment-1 downto 0);
signal o_eoc : std_logic;

-- Clock period definitions
--constant i_clock_period : time := (1_000_000_000/C_CLOCK) * 1 ns;
constant i_clock_period : time := 20 ns;

BEGIN
-- Instantiate the Unit Under Test (UUT)
uut: sar_adc
GENERIC MAP (
G_BOARD_CLOCK => C_CLOCK,
data_size => C_DATA_SIZE
)
PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_from_comparator => i_from_comparator,
io_ladder => io_ladder,
o_anode => o_anode,
o_segment => o_segment,
o_eoc => o_eoc
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
-- insert stimulus here
i_reset <= '1';
wait for C_CLOCK * i_clock_period;
i_reset <= '0';

wait for 3 * C_CLOCK * i_clock_period;

i_from_comparator <= '0';

wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;

i_from_comparator <= '0';

wait for 3 * C_CLOCK * i_clock_period;

i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;

i_from_comparator <= '0';

wait for 3 * C_CLOCK * i_clock_period;

i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;

i_from_comparator <= '0';

wait for 3 * C_CLOCK * i_clock_period;

i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;

i_from_comparator <= '0';

wait for 3 * C_CLOCK * i_clock_period;

i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '0';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';
wait for C_CLOCK * i_clock_period;
i_from_comparator <= '1';

wait for C_CLOCK * i_clock_period;

i_from_comparator <= '0';

wait;
end process;

END;
