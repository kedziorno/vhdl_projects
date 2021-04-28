--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:45:41 04/26/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_mem_decoder_col.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mem_decoder_col
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

ENTITY tb_mem_decoder_col IS
END tb_mem_decoder_col;

ARCHITECTURE behavior OF tb_mem_decoder_col IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT mem_decoder_col
PORT(
decoder_col_input : IN  std_logic_vector(5 downto 0);
decoder_col_output : OUT  std_logic_vector(63 downto 0);
e : IN  STD_LOGIC
);
END COMPONENT;

--Inputs
signal decoder_col_input : std_logic_vector(5 downto 0) := (others => '0');
signal e : std_logic := '0';

--Outputs
signal decoder_col_output : std_logic_vector(63 downto 0);

constant clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: mem_decoder_col PORT MAP (
decoder_col_input => decoder_col_input,
decoder_col_output => decoder_col_output,
e => e
);

-- Stimulus process
stim_proc: process
variable data_in : std_logic_vector(5 downto 0) := (others => '0');
function one_position(v : std_logic_vector) return integer is
	variable r : integer := 0;
begin
	l0 : for i in v'range loop
		if (v(v'high-i) = '1') then
			exit;
		else
			r := r + 1;
		end if;
	end loop l0;
	return r;
end function one_position;
function vec2str(vec: std_logic_vector) return string is
	variable result: string(vec'left + 1 downto 1);
begin
	for i in vec'reverse_range loop
		if (vec(i) = '1') then
			result(i + 1) := '1';
		elsif (vec(i) = '0') then
			result(i + 1) := '0';
		else
			result(i + 1) := 'X';
		end if;
	end loop;
return result;
end; 
begin
-- insert stimulus here
loop0 : for i in 0 to 2**6-1 loop
e <= '1';
decoder_col_input <= std_logic_vector(to_unsigned(i,6));
wait for clock_period;
assert (one_position(decoder_col_output)=i) report time'image(NOW) & " error at " & integer'image(i) & " : decoder_col_output is " & vec2str(decoder_col_output) & " 1 on position " & integer'image(one_position(decoder_col_output)) & " , expect " & integer'image(i) severity note;
e <= '0';
wait for clock_period;
end loop loop0;
wait;
end process;

END;
