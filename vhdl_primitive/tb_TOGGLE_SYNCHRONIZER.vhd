-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/TOGGLE_SYNCHRONIZER.sch - Wed Sep 20 14:20:16 2023
--
-- Notes: 
-- 1) This testbench template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the unit under test.
-- Xilinx recommends that these types always be used for the top-level
-- I/O of a design in order to guarantee that the testbench will bind
-- correctly to the timing (post-route) simulation model.
-- 2) To use this template as your testbench, change the filename to any
-- name of your choice with the extension .vhd, and use the "Source->Add"
-- menu in Project Navigator to import the testbench. Then
-- edit the user defined section below, adding code to generate the 
-- stimulus for your design.
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY UNISIM;
USE UNISIM.Vcomponents.ALL;
ENTITY TOGGLE_SYNCHRONIZER_TOGGLE_SYNCHRONIZER_sch_tb IS
END TOGGLE_SYNCHRONIZER_TOGGLE_SYNCHRONIZER_sch_tb;
ARCHITECTURE behavioral OF TOGGLE_SYNCHRONIZER_TOGGLE_SYNCHRONIZER_sch_tb IS 

COMPONENT TOGGLE_SYNCHRONIZER
PORT( s_input	:	IN	STD_LOGIC; 
clk_a	:	IN	STD_LOGIC; 
clk_b	:	IN	STD_LOGIC; 
sync_out	:	OUT	STD_LOGIC);
END COMPONENT;

SIGNAL s_input	:	STD_LOGIC := '0';
SIGNAL clk_a	:	STD_LOGIC := '0';
SIGNAL clk_b	:	STD_LOGIC := '0';
SIGNAL sync_out	:	STD_LOGIC;

constant clk_a_period : time := 10.7 ns;
constant clk_b_period : time := 19.3 ns;

BEGIN

clk_a <= not clk_a after clk_a_period/2;
clk_b <= not clk_b after clk_b_period/2;

UUT: TOGGLE_SYNCHRONIZER PORT MAP(
s_input => s_input, 
clk_a => clk_a, 
clk_b => clk_b, 
sync_out => sync_out
);

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN
wait for 4.1 ns;

s_input <= '0';
wait for 10 ns;
s_input <= '1';
wait for 5 ns;
s_input <= '0';

wait for 3.2 ns;

s_input <= '0';
wait for 10 ns;
s_input <= '1';
wait for 5 ns;
s_input <= '0';

END PROCESS;
-- *** End Test Bench - User Defined Section ***

tb_done : process
begin
wait for 10 us;
report "tb done" severity failure;
WAIT; -- will wait forever
end process tb_done;

END;
