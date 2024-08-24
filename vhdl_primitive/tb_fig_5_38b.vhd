-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/fig_5_38b.sch - Sat Aug 12 22:15:00 2023
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
ENTITY fig_5_38b_fig_5_38b_sch_tb IS
END fig_5_38b_fig_5_38b_sch_tb;
ARCHITECTURE behavioral OF fig_5_38b_fig_5_38b_sch_tb IS 

COMPONENT fig_5_38b
PORT( clock	:	IN	STD_LOGIC; 
Synch_out	:	OUT	STD_LOGIC; 
Asynch_in	:	IN	STD_LOGIC);
END COMPONENT;

SIGNAL clock	:	STD_LOGIC;
SIGNAL Synch_out	:	STD_LOGIC;
SIGNAL Asynch_in	:	STD_LOGIC;

constant clock_period : time := 10 ns;

BEGIN

UUT: fig_5_38b PORT MAP(
clock => clock, 
Synch_out => Synch_out, 
Asynch_in => Asynch_in
);

cp : process is
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process cp;

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN
Asynch_in <= '0'; wait for 1 ns;
Asynch_in <= '1'; wait for 0.01 ns;
--Asynch_in <= '0'; wait for 0.01 ns;
Asynch_in <= '0'; wait for 2 ns;
Asynch_in <= '0'; wait for 2 ns;
Asynch_in <= '0'; wait for 1 ns;
Asynch_in <= '0'; wait for 4 ns;
Asynch_in <= '0'; wait for 3 ns;
Asynch_in <= '0'; wait for 5 ns;
Asynch_in <= '0'; wait for 10 ns;
report "tb done" severity failure;
WAIT; -- will wait forever
END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
