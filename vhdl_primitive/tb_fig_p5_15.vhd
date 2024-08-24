-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/fig_p5_15.sch - Sat Aug 12 22:31:22 2023
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
ENTITY fig_p5_15_fig_p5_15_sch_tb IS
END fig_p5_15_fig_p5_15_sch_tb;
ARCHITECTURE behavioral OF fig_p5_15_fig_p5_15_sch_tb IS 

COMPONENT fig_p5_15
PORT( P_odd	:	OUT	STD_LOGIC; 
clk	:	IN	STD_LOGIC; 
reset	:	IN	STD_LOGIC; 
D_in	:	IN	STD_LOGIC);
END COMPONENT;

SIGNAL P_odd	:	STD_LOGIC;
SIGNAL clk	:	STD_LOGIC;
SIGNAL reset	:	STD_LOGIC;
SIGNAL D_in	:	STD_LOGIC;

constant clk_period : time := 10 ns;

BEGIN

cp : process is
begin
clk <= '0';
wait for clk_period/2;
clk <= '1';
wait for clk_period/2;
end process cp;

UUT: fig_p5_15 PORT MAP(
P_odd => P_odd, 
clk => clk, 
reset => reset, 
D_in => D_in
);

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN
reset <= '1'; wait for clk_period; reset <= '0';
D_in <= '0'; wait for clk_period;
D_in <= '1'; wait for clk_period;
D_in <= '0'; wait for clk_period;
D_in <= '1'; wait for clk_period;
D_in <= '0'; wait for clk_period;
D_in <= '0'; wait for clk_period;
D_in <= '1'; wait for clk_period;
D_in <= '0'; wait for clk_period;
D_in <= '1'; wait for clk_period;
D_in <= '0'; wait for clk_period;
D_in <= '0'; wait for clk_period;
D_in <= '1'; wait for clk_period;
D_in <= '1'; wait for clk_period;
D_in <= '1'; wait for clk_period;
D_in <= '1'; wait for clk_period;
D_in <= '1'; wait for clk_period;
D_in <= '1'; wait for clk_period;
D_in <= '0'; wait for clk_period;
D_in <= '1'; wait for clk_period;
D_in <= '0'; wait for clk_period;
D_in <= '0'; wait for clk_period;
D_in <= '1'; wait for clk_period;
D_in <= '0'; wait for clk_period;
D_in <= '1'; wait for clk_period;
D_in <= '0'; wait for clk_period;
report "tb done" severity failure;
WAIT; -- will wait forever
END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
