-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/clk_gate1.sch - Tue Aug 29 15:19:47 2023
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
ENTITY clk_gate1_clk_gate1_sch_tb IS
END clk_gate1_clk_gate1_sch_tb;
ARCHITECTURE behavioral OF clk_gate1_clk_gate1_sch_tb IS 

COMPONENT clk_gate1
PORT( clk_in	:	IN	STD_LOGIC; 
enable	:	IN	STD_LOGIC; 
clk_out	:	OUT	STD_LOGIC);
END COMPONENT;

SIGNAL clk_in	:	STD_LOGIC := '0';
SIGNAL enable	:	STD_LOGIC := '0';
SIGNAL clk_out	:	STD_LOGIC := '0';

constant clk_in_period : time := 10 ns;

BEGIN

UUT: clk_gate1 PORT MAP(
clk_in => clk_in, 
enable => enable, 
clk_out => clk_out
);

pc : process is
begin
clk_in <= '0';
wait for clk_in_period/2;
clk_in <= '1';
wait for clk_in_period/2;
end process pc;

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN
--wait for 111.13 ns;
wait for 109.13 ns;
enable <= '1';
--wait for 205.13 ns;
wait for 206.13 ns;
enable <= '0';
wait for 10 us;
report "tb done" severity failure;
WAIT; -- will wait forever
END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
