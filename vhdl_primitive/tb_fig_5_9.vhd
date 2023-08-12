-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/fig_5_9.sch - Fri Aug 11 18:06:35 2023
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
ENTITY fig_5_9_fig_5_9_sch_tb IS
END fig_5_9_fig_5_9_sch_tb;
ARCHITECTURE behavioral OF fig_5_9_fig_5_9_sch_tb IS 

COMPONENT fig_5_9
PORT( A_eq_B	:	OUT	STD_LOGIC; 
A_gt_B	:	OUT	STD_LOGIC; 
B1	:	IN	STD_LOGIC; 
A1	:	IN	STD_LOGIC; 
B0	:	IN	STD_LOGIC; 
A0	:	IN	STD_LOGIC; 
A_lt_B	:	OUT	STD_LOGIC);
END COMPONENT;

SIGNAL B1	:	STD_LOGIC;
SIGNAL A1	:	STD_LOGIC;
SIGNAL B0	:	STD_LOGIC;
SIGNAL A0	:	STD_LOGIC;
SIGNAL A_lt_B	:	STD_LOGIC;
SIGNAL A_eq_B	:	STD_LOGIC;
SIGNAL A_gt_B	:	STD_LOGIC;

signal a,b : std_logic_vector (1 downto 0);

BEGIN

A1 <= a (1);
A0 <= a (0);
B1 <= b (1);
B0 <= b (0);

UUT: fig_5_9 PORT MAP(
A_eq_B => A_eq_B, 
A_gt_B => A_gt_B, 
B1 => B1, 
A1 => A1, 
B0 => B0, 
A0 => A0, 
A_lt_B => A_lt_B
);

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN
a <= "00"; b <= "00";
wait for 10 ns;
a <= "00"; b <= "01";
wait for 10 ns;
a <= "00"; b <= "10";
wait for 10 ns;
a <= "00"; b <= "11";
wait for 10 ns;
a <= "01"; b <= "00";
wait for 10 ns;
a <= "01"; b <= "01";
wait for 10 ns;
a <= "01"; b <= "10";
wait for 10 ns;
a <= "01"; b <= "11";
wait for 10 ns;
a <= "10"; b <= "00";
wait for 10 ns;
a <= "10"; b <= "01";
wait for 10 ns;
a <= "10"; b <= "10";
wait for 10 ns;
a <= "10"; b <= "11";
wait for 10 ns;
a <= "11"; b <= "00";
wait for 10 ns;
a <= "11"; b <= "01";
wait for 10 ns;
a <= "11"; b <= "10";
wait for 10 ns;
a <= "11"; b <= "11";
wait for 10 ns;
report "tb done" severity failure;
WAIT; -- will wait forever
END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
