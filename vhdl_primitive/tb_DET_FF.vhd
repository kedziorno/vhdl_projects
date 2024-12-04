-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/DET_FF.sch - Mon Sep 18 19:24:29 2023
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
ENTITY DET_FF_DET_FF_sch_tb IS
END DET_FF_DET_FF_sch_tb;
ARCHITECTURE behavioral OF DET_FF_DET_FF_sch_tb IS 

COMPONENT DET_FF
PORT( CLK	:	IN	STD_LOGIC; 
CLR	:	IN	STD_LOGIC; 
D	:	IN	STD_LOGIC; 
Q	:	OUT	STD_LOGIC);
END COMPONENT;

SIGNAL CLK	:	STD_LOGIC := '0';
SIGNAL CLR	:	STD_LOGIC := '0';
SIGNAL D	:	STD_LOGIC := '0';
SIGNAL Q	:	STD_LOGIC;

signal clock : std_logic := '0';
constant clock_period : time := 10 ns;

BEGIN

cp : process is
begin
clock <= not clock;
wait for clock_period/2;
end process cp;

CLK <= clock;

UUT: DET_FF PORT MAP(
CLK => CLK, 
CLR => CLR, 
D => D, 
Q => Q
);

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN
CLR <= '1';
wait for clock_period*2;
CLR <= '0';
wait for clock_period*3; 
D <= '1';
wait for clock_period*2.5;
D <= '0';
wait for clock_period*2.5;
D <= '1';
wait for clock_period*1.5;
D <= '0';
wait for clock_period*1.5;
report "tb done" severity failure;
END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
