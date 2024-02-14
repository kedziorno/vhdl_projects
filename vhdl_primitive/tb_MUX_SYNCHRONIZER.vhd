-- Vhdl test bench created from schematic /home/user/workspace/vhdl_projects/vhdl_primitive/MUX_SYNCHRONIZER.sch - Fri Sep 29 17:35:02 2023
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
ENTITY MUX_SYNCHRONIZER_MUX_SYNCHRONIZER_sch_tb IS
END MUX_SYNCHRONIZER_MUX_SYNCHRONIZER_sch_tb;

ARCHITECTURE behavioral OF MUX_SYNCHRONIZER_MUX_SYNCHRONIZER_sch_tb IS 

COMPONENT MUX_SYNCHRONIZER
PORT( clk_b	:	IN	STD_LOGIC; 
en	:	IN	STD_LOGIC; 
clk_a	:	IN	STD_LOGIC; 
op	:	OUT	STD_LOGIC; 
clk_a_data	:	IN	STD_LOGIC);
END COMPONENT;

SIGNAL clk_a	:	STD_LOGIC := '1';
SIGNAL clk_b	:	STD_LOGIC := '1';
SIGNAL en	:	STD_LOGIC := '0';
SIGNAL op	:	STD_LOGIC := '0';
SIGNAL clk_a_data	:	STD_LOGIC := '0';

constant clk_a_period : time := 10 ns;
constant clk_b_period : time := 20 ns;

BEGIN

pclka : process is
begin
clk_a <= not clk_a;
wait for clk_a_period/2;
end process pclka;

pclkb : process is
begin
clk_b <= not clk_b;
wait for clk_b_period/2;
end process pclkb;

UUT: MUX_SYNCHRONIZER PORT MAP(
clk_b => clk_b, 
en => en, 
clk_a => clk_a, 
op => op, 
clk_a_data => clk_a_data
);

-- *** Test Bench - User Defined Section ***
tb : PROCESS
BEGIN
wait for clk_a_period*2;
clk_a_data <= '1'; en <= '1'; wait for clk_a_period*1; en <= '0'; wait for clk_a_period*1;
clk_a_data <= '1'; en <= '1'; wait for clk_a_period*1; en <= '0'; wait for clk_a_period*1;
clk_a_data <= '1'; en <= '1'; wait for clk_a_period*1; en <= '0'; wait for clk_a_period*1;
clk_a_data <= '0'; en <= '1'; wait for clk_a_period*1; en <= '0'; wait for clk_a_period*1;
clk_a_data <= '1'; en <= '1'; wait for clk_a_period*1; en <= '0'; wait for clk_a_period*1;
clk_a_data <= '0'; en <= '1'; wait for clk_a_period*1; en <= '0'; wait for clk_a_period*1;
clk_a_data <= '1'; en <= '1'; wait for clk_a_period*1; en <= '0'; wait for clk_a_period*1;
clk_a_data <= '0'; en <= '1'; wait for clk_a_period*1; en <= '0'; wait for clk_a_period*1;
wait for clk_a_period*10;
wait for 0.5 us;
report "tb done" severity failure;
WAIT; -- will wait forever
END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
