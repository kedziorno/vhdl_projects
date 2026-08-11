-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/osc_test1.sch - Sun Aug 27 20:46:24 2023
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
ENTITY osc_test1_osc_test1_sch_tb IS
END osc_test1_osc_test1_sch_tb;
ARCHITECTURE behavioral OF osc_test1_osc_test1_sch_tb IS 

   COMPONENT osc_test1
   PORT( op	:	OUT	STD_LOGIC; 
          ip	:	IN	STD_LOGIC);
   END COMPONENT;

   SIGNAL op	:	STD_LOGIC := '0';
   SIGNAL ip	:	STD_LOGIC := '0';

BEGIN

   UUT: osc_test1 PORT MAP(
		op => op, 
		ip => ip
   );

-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
   ip <= '1';
      WAIT for 1 ms; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
