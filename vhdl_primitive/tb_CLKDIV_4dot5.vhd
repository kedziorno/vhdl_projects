-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/CLKDIV_4dot5.sch - Mon Sep 18 21:07:35 2023
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
ENTITY CLKDIV_4dot5_CLKDIV_4dot5_sch_tb IS
END CLKDIV_4dot5_CLKDIV_4dot5_sch_tb;
ARCHITECTURE behavioral OF CLKDIV_4dot5_CLKDIV_4dot5_sch_tb IS 

COMPONENT CLKDIV_4dot5
PORT( clk_in	:	IN	STD_LOGIC; 
clk_out	:	OUT	STD_LOGIC);
END COMPONENT;

SIGNAL clk_in	:	STD_LOGIC := '0';
SIGNAL clk_out	:	STD_LOGIC;

constant clk_in_period : time := 10 ns;

BEGIN

cp : process is
begin
clk_in <= not clk_in;
wait for clk_in_period;
end process cp;

UUT: CLKDIV_4dot5 PORT MAP(
clk_in => clk_in, 
clk_out => clk_out
);

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN
wait for 10 us;
report "tb done" severity failure;
END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
