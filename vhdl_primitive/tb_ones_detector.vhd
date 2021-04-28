--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:22:53 04/28/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_ones_detector.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ones_detector
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

ENTITY tb_ones_detector IS
END tb_ones_detector;

ARCHITECTURE behavior OF tb_ones_detector IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT ones_detector
PORT(
x : IN  std_logic_vector(15 downto 1);
y : OUT  std_logic_vector(3 downto 0)
);
END COMPONENT;

--Inputs
signal x : std_logic_vector(15 downto 1) := (others => '0');

--Outputs
signal y : std_logic_vector(3 downto 0);

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: ones_detector PORT MAP (
x => x,
y => y
);

-- Stimulus process
stim_proc: process
constant N : integer := 23;
type array_data_expect is array(integer range <>) of std_logic_vector(3 downto 0);
variable data_expect : array_data_expect(0 to N-1) := (
x"0", -- XXX bad
x"7",x"F",x"0",x"8",
x"8",x"B",x"c",x"3",
x"4",x"7",x"4",x"4",
x"b",x"b",x"c",x"5",
x"6",x"a",x"5",x"6",
x"6",
x"1" -- XXX bad
);
type array_data_in is array(integer range <>) of std_logic_vector(15 downto 1);
variable data_in : array_data_in(0 to N-1) := (
std_logic_vector(to_unsigned(to_integer(unsigned'(x"DEAD")),15)),
"010101010101010",
"111111111111111",
"000000000000000",
"101010101010101",

"110011001100110",
"110111011101110",
"111011101110111",
"000100010001000",

"001000100010001",
"001100110011001",
"010001000100001",
"100010001000100",

"011101110111011",
"101110111011101",
"111011011101111",
"100000010001110",

"001010101000110",
"100111001111011",
"000010000111001",
"100010000100111",

"000011111100000",
std_logic_vector(to_unsigned(to_integer(unsigned'(x"CAFE")),15))
);
begin		
-- insert stimulus here
loop0 : for i in 0 to N-1 loop
x <= data_in(i);
wait for 10 ns;
assert (y=data_expect(i)) report "error at " & integer'image(i) & " : y is " & integer'image(to_integer(unsigned(y(3 downto 0)))) & " , expect " & integer'image(to_integer(unsigned(data_expect(i)))); 
wait for 500 ns;
end loop loop0;
wait;
end process;

END;
