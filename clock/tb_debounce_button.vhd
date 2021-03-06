--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:32:21 09/15/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/i2c_test_2/tb_debounce_button.vhd
-- Project Name:  i2c_test_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: debounce_button
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
 
ENTITY tb_debounce_button IS
END tb_debounce_button;
 
ARCHITECTURE behavior OF tb_debounce_button IS 

constant board_clock : integer := 50_000_000;

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

COMPONENT debounce_button
generic (g_board_clock : integer);
PORT(
i_button : IN  std_logic;
i_clk : IN  std_logic;
o_stable : OUT  std_logic
);
END COMPONENT;

signal i_button : std_logic := '0';
signal i_clk : std_logic := '0';
signal o_stable : std_logic := '0';

BEGIN

clk_gen(i_clk, 0 ns, 10 ns, 10 ns);

uut: debounce_button
generic map (g_board_clock => board_clock)
PORT MAP (
i_button => i_button,
i_clk => i_clk,
o_stable => o_stable
);

-- Stimulus process
stim_proc: process
begin

wait for 2450 us;
i_button <= '0';
wait for 1 us;
i_button <= '1';
wait for 300 us;
i_button <= '0';
wait for 50 us;
i_button <= '1';
wait for 200 us;
i_button <= '0';
wait for 70 us;
i_button <= '1';
wait for 100 us;
i_button <= '0';
wait for 100 us;

--i_button <= '0';
--wait for 1000 ns;
--i_button <= '1';
--wait for 20 ms;
--i_button <= '0';

wait;
end process;

END;
