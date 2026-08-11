-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/fig_5_13.sch - Fri Aug 11 22:12:10 2023
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
ENTITY fig_5_13_fig_5_13_sch_tb IS
END fig_5_13_fig_5_13_sch_tb;
ARCHITECTURE behavioral OF fig_5_13_fig_5_13_sch_tb IS 

COMPONENT fig_5_13
PORT( Code2	:	IN	STD_LOGIC; 
Code0	:	IN	STD_LOGIC; 
Code1	:	IN	STD_LOGIC; 
Data3	:	OUT	STD_LOGIC; 
Data4	:	OUT	STD_LOGIC; 
Data1	:	OUT	STD_LOGIC; 
Data2	:	OUT	STD_LOGIC; 
Data5	:	OUT	STD_LOGIC; 
Data6	:	OUT	STD_LOGIC; 
Data0	:	OUT	STD_LOGIC; 
Data7	:	OUT	STD_LOGIC);
END COMPONENT;

SIGNAL Code2	:	STD_LOGIC;
SIGNAL Code0	:	STD_LOGIC;
SIGNAL Code1	:	STD_LOGIC;
SIGNAL Data3	:	STD_LOGIC;
SIGNAL Data4	:	STD_LOGIC;
SIGNAL Data1	:	STD_LOGIC;
SIGNAL Data2	:	STD_LOGIC;
SIGNAL Data5	:	STD_LOGIC;
SIGNAL Data6	:	STD_LOGIC;
SIGNAL Data0	:	STD_LOGIC;
SIGNAL Data7	:	STD_LOGIC;

signal Data : std_logic_vector (7 downto 0);
signal Code : std_logic_vector (2 downto 0);

BEGIN

Code2 <= Code (2);
Code1 <= Code (1);
Code0 <= Code (0);
Data (7) <= Data7;
Data (6) <= Data6;
Data (5) <= Data5;
Data (4) <= Data4;
Data (3) <= Data3;
Data (2) <= Data2;
Data (1) <= Data1;
Data (0) <= Data0;

UUT: fig_5_13 PORT MAP(
Code2 => Code2, 
Code0 => Code0, 
Code1 => Code1, 
Data3 => Data3, 
Data4 => Data4, 
Data1 => Data1, 
Data2 => Data2, 
Data5 => Data5, 
Data6 => Data6, 
Data0 => Data0, 
Data7 => Data7
);

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN
Code <= "000"; wait for 10 ns;
Code <= "001"; wait for 10 ns;
Code <= "010"; wait for 10 ns;
Code <= "011"; wait for 10 ns;
Code <= "100"; wait for 10 ns;
Code <= "101"; wait for 10 ns;
Code <= "110"; wait for 10 ns;
Code <= "111"; wait for 10 ns;
Code <= "000"; wait for 10 ns;
report "tb done" severity failure;
WAIT; -- will wait forever
END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
