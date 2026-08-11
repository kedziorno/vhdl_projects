-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/HANDSHAKE_BASED_PULSE_SYNCHRONIZER.sch - Fri Sep 29 16:29:27 2023
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
ENTITY HANDSHAKE_BASED_PULSE_SYNCHRONIZER_HANDSHAKE_BASED_PULSE_SYNCHRONIZER_sch_tb IS
END HANDSHAKE_BASED_PULSE_SYNCHRONIZER_HANDSHAKE_BASED_PULSE_SYNCHRONIZER_sch_tb;

ARCHITECTURE behavioral OF HANDSHAKE_BASED_PULSE_SYNCHRONIZER_HANDSHAKE_BASED_PULSE_SYNCHRONIZER_sch_tb IS 

COMPONENT HANDSHAKE_BASED_PULSE_SYNCHRONIZER
PORT( s_input	:	IN	STD_LOGIC; 
clk_a	:	IN	STD_LOGIC; 
clk_b	:	IN	STD_LOGIC; 
sync_out	:	OUT	STD_LOGIC; 
busy	:	OUT	STD_LOGIC);
END COMPONENT;

SIGNAL s_input	:	STD_LOGIC := '0';
SIGNAL clk_a	:	STD_LOGIC := '0';
SIGNAL clk_b	:	STD_LOGIC := '0';
SIGNAL sync_out	:	STD_LOGIC := '0';
SIGNAL busy	:	STD_LOGIC := '0';

constant clk_a_period : time := 10 ns;
constant clk_b_period : time := 20 ns;

BEGIN

pclka : process is
begin
clk_a <= not clk_a;
wait for clk_a_period/2;
end process pclka;

pclkb : process is
begin
clk_b <= not clk_b;
wait for clk_b_period/2;
end process pclkb;

UUT: HANDSHAKE_BASED_PULSE_SYNCHRONIZER PORT MAP(
s_input => s_input, 
clk_a => clk_a, 
clk_b => clk_b, 
sync_out => sync_out, 
busy => busy
);

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN
wait for clk_a_period*10;
s_input <= '1'; wait for clk_a_period*1; s_input <= '0';
wait for 1 us;
report "tb done" severity failure;
WAIT; -- will wait forever
END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
