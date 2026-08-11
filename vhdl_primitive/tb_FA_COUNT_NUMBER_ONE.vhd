-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/FA_COUNT_NUMBER_ONE.sch - Mon Sep 18 20:06:41 2023
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
ENTITY FA_COUNT_NUMBER_ONE_FA_COUNT_NUMBER_ONE_sch_tb IS
END FA_COUNT_NUMBER_ONE_FA_COUNT_NUMBER_ONE_sch_tb;
ARCHITECTURE behavioral OF FA_COUNT_NUMBER_ONE_FA_COUNT_NUMBER_ONE_sch_tb IS 

COMPONENT FA_COUNT_NUMBER_ONE
PORT( INPUT	:	IN	STD_LOGIC_VECTOR (6 DOWNTO 0); 
OUTPUT	:	OUT	STD_LOGIC_VECTOR (2 DOWNTO 0));
END COMPONENT;

SIGNAL INPUT	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
SIGNAL OUTPUT	:	STD_LOGIC_VECTOR (2 DOWNTO 0);

BEGIN

UUT: FA_COUNT_NUMBER_ONE PORT MAP(
INPUT => INPUT, 
OUTPUT => OUTPUT
);

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN
l0 : for i in 0 to 2**7-1 loop
INPUT <= std_logic_vector (to_unsigned (i,7));
wait for 10 ns;
end loop l0;
report "tb done" severity failure;
END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
