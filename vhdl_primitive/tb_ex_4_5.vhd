-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/ex_4_5.sch - Thu Aug 10 15:44:05 2023
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
ENTITY ex_4_5_ex_4_5_sch_tb IS
END ex_4_5_ex_4_5_sch_tb;
ARCHITECTURE behavioral OF ex_4_5_ex_4_5_sch_tb IS 

COMPONENT ex_4_5
PORT( A1	:	IN	STD_LOGIC; 
B1	:	IN	STD_LOGIC; 
A0	:	IN	STD_LOGIC; 
B0	:	IN	STD_LOGIC; 
A3	:	IN	STD_LOGIC; 
B3	:	IN	STD_LOGIC; 
A2	:	IN	STD_LOGIC; 
B2	:	IN	STD_LOGIC; 
A_eq_B	:	OUT	STD_LOGIC; 
A_gt_B	:	OUT	STD_LOGIC; 
A_lt_B	:	OUT	STD_LOGIC);
END COMPONENT;

SIGNAL A1	:	STD_LOGIC;
SIGNAL B1	:	STD_LOGIC;
SIGNAL A0	:	STD_LOGIC;
SIGNAL B0	:	STD_LOGIC;
SIGNAL A3	:	STD_LOGIC;
SIGNAL B3	:	STD_LOGIC;
SIGNAL A2	:	STD_LOGIC;
SIGNAL B2	:	STD_LOGIC;
SIGNAL A_eq_B	:	STD_LOGIC;
SIGNAL A_gt_B	:	STD_LOGIC;
SIGNAL A_lt_B	:	STD_LOGIC;

signal a,b : std_logic_vector (3 downto 0);

BEGIN

a3 <= a (3);
a2 <= a (2);
a1 <= a (1);
a0 <= a (0);

b3 <= b (3);
b2 <= b (2);
b1 <= b (1);
b0 <= b (0);

UUT: ex_4_5 PORT MAP(
A1 => A1, 
B1 => B1, 
A0 => A0, 
B0 => B0, 
A3 => A3, 
B3 => B3, 
A2 => A2, 
B2 => B2, 
A_eq_B => A_eq_B, 
A_gt_B => A_gt_B, 
A_lt_B => A_lt_B
);

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN

l0 : for i in 0 to 15 loop

a <= std_logic_vector (to_unsigned (i, 4)); b <= "0000";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "0001";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "0010";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "0011";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "0100";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "0101";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "0110";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "0111";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "1000";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "1001";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "1010";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "1011";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "1100";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "1101";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "1110";
wait for 10 ns;
a <= std_logic_vector (to_unsigned (i, 4)); b <= "1111";
wait for 10 ns;

end loop l0;


report "tb done" severity failure;
WAIT; -- will wait forever
END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
