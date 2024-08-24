-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/fig_5_11.sch - Fri Aug 11 18:47:05 2023
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
ENTITY fig_5_11_fig_5_11_sch_tb IS
END fig_5_11_fig_5_11_sch_tb;
ARCHITECTURE behavioral OF fig_5_11_fig_5_11_sch_tb IS 

COMPONENT fig_5_11
PORT( Data5	:	IN	STD_LOGIC; 
Data4	:	IN	STD_LOGIC; 
Data6	:	IN	STD_LOGIC; 
Data3	:	IN	STD_LOGIC; 
Data2	:	IN	STD_LOGIC; 
Data1	:	IN	STD_LOGIC; 
Data7	:	IN	STD_LOGIC; 
Code0	:	OUT	STD_LOGIC; 
Code1	:	OUT	STD_LOGIC; 
Code2	:	OUT	STD_LOGIC);
END COMPONENT;

SIGNAL Data5	:	STD_LOGIC;
SIGNAL Data4	:	STD_LOGIC;
SIGNAL Data6	:	STD_LOGIC;
SIGNAL Data3	:	STD_LOGIC;
SIGNAL Data2	:	STD_LOGIC;
SIGNAL Data1	:	STD_LOGIC;
SIGNAL Data7	:	STD_LOGIC;
SIGNAL Code0	:	STD_LOGIC;
SIGNAL Code1	:	STD_LOGIC;
SIGNAL Code2	:	STD_LOGIC;

signal Data : std_logic_vector (7 downto 1);
signal Code : std_logic_vector (2 downto 0);

BEGIN

Data7 <= Data (7);
Data6 <= Data (6);
Data5 <= Data (5);
Data4 <= Data (4);
Data3 <= Data (3);
Data2 <= Data (2);
Data1 <= Data (1);

Code (2) <= Code2;
Code (1) <= Code1;
Code (0) <= Code0;

UUT: fig_5_11 PORT MAP(
Data5 => Data5, 
Data4 => Data4, 
Data6 => Data6, 
Data3 => Data3, 
Data2 => Data2, 
Data1 => Data1, 
Data7 => Data7, 
Code0 => Code0, 
Code1 => Code1, 
Code2 => Code2
);

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN

Data <= "0000000"; wait for 10 ns;
Data <= "1000000"; wait for 10 ns;
Data <= "0100000"; wait for 10 ns;
Data <= "0010000"; wait for 10 ns;
Data <= "0001000"; wait for 10 ns;
Data <= "0000100"; wait for 10 ns;
Data <= "0000010"; wait for 10 ns;
Data <= "0000001"; wait for 10 ns;
Data <= "0000000"; wait for 10 ns;
Data <= "0000001"; wait for 10 ns;
Data <= "0000010"; wait for 10 ns;
Data <= "0000100"; wait for 10 ns;
Data <= "0001000"; wait for 10 ns;
Data <= "0010000"; wait for 10 ns;
Data <= "0100000"; wait for 10 ns;
Data <= "1000000"; wait for 10 ns;
Data <= "0000000"; wait for 10 ns;

report "tb done" severity failure;

WAIT; -- will wait forever
END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
