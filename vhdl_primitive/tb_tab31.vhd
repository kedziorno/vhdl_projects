--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:34:45 06/05/2023
-- Design Name:   BCD and Ex-3 decode from 0-9
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_tab31.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: tab31
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- bit_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_tab31 IS
END tb_tab31;

ARCHITECTURE behavior OF tb_tab31 IS 

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT tab31
PORT(
Decimal_Digit : IN  bit_vector(3 downto 0);
BCD8421_Codes : OUT  bit_vector(3 downto 0);
Excess3_Codes : OUT  bit_vector(3 downto 0)
);
END COMPONENT;

--Inputs
signal Decimal_Digit : bit_vector(3 downto 0) := (others => '0');

--Outputs
signal BCD8421_Codes : bit_vector(3 downto 0);
signal Excess3_Codes : bit_vector(3 downto 0);

signal clock : bit := '0';
constant clock_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: tab31 PORT MAP (
Decimal_Digit => Decimal_Digit,
BCD8421_Codes => BCD8421_Codes,
Excess3_Codes => Excess3_Codes
);

-- Clock process definitions
clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;

Decimal_Digit <= "1111",
"1001" after 10 ns,
"1000" after 20 ns,
"0111" after 30 ns,
"0110" after 40 ns,
"0101" after 50 ns,
"0100" after 60 ns,
"0011" after 70 ns,
"0010" after 80 ns,
"0001" after 90 ns,
"0000" after 100 ns,
"1111" after 110 ns;

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
wait for 200 ns;
-- insert stimulus here
report "tb done" severity failure;
end process;

END;
