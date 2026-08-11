-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/CLKDIV_3.sch - Wed Sep 20 12:23:31 2023
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
ENTITY CLKDIV_3_CLKDIV_3_sch_tb IS
END CLKDIV_3_CLKDIV_3_sch_tb;
ARCHITECTURE behavioral OF CLKDIV_3_CLKDIV_3_sch_tb IS 

-- XXX Clock divided by 3 with 75% Duty Cycle
COMPONENT CLKDIV_3
PORT( clk	:	IN	STD_LOGIC; 
clk_out	:	OUT	STD_LOGIC);
END COMPONENT;

SIGNAL clk	:	STD_LOGIC := '0';
SIGNAL clk_out	:	STD_LOGIC;

BEGIN

clk <= not clk after 10 ns;

UUT: CLKDIV_3 PORT MAP(
clk => clk, 
clk_out => clk_out
);

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN
WAIT for 10 us; -- will wait forever
report "tb done" severity failure;
END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
