-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/FA_MUX41.sch - Mon Sep 18 18:48:00 2023
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
ENTITY FA_MUX41_FA_MUX41_sch_tb IS
END FA_MUX41_FA_MUX41_sch_tb;
ARCHITECTURE behavioral OF FA_MUX41_FA_MUX41_sch_tb IS 

COMPONENT FA_MUX41
PORT( Sum	:	OUT	STD_LOGIC; 
Carry_out	:	OUT	STD_LOGIC; 
Carry_in	:	IN	STD_LOGIC; 
A	:	IN	STD_LOGIC; 
B	:	IN	STD_LOGIC);
END COMPONENT;

SIGNAL Sum	:	STD_LOGIC;
SIGNAL Carry_out	:	STD_LOGIC;
SIGNAL Carry_in	:	STD_LOGIC;
SIGNAL A	:	STD_LOGIC;
SIGNAL B	:	STD_LOGIC;

signal CBA : std_logic_vector (2 downto 0);

BEGIN

A <= CBA (2);
B <= CBA (1);
Carry_in <= CBA (0);

UUT: FA_MUX41 PORT MAP(
Sum => Sum, 
Carry_out => Carry_out, 
Carry_in => Carry_in, 
A => A, 
B => B
);

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN
CBA <= "000"; wait for 10 ns;
CBA <= "001"; wait for 10 ns;
CBA <= "010"; wait for 10 ns;
CBA <= "011"; wait for 10 ns;
CBA <= "100"; wait for 10 ns;
CBA <= "101"; wait for 10 ns;
CBA <= "110"; wait for 10 ns;
CBA <= "111"; wait for 10 ns;
report "tb done" severity failure;
END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
