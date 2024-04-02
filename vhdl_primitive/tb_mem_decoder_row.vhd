--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:06:44 04/25/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_mem_decoder_row.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mem_decoder_row
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

ENTITY tb_mem_decoder_row IS
END tb_mem_decoder_row;

ARCHITECTURE behavior OF tb_mem_decoder_row IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT mem_decoder_row
PORT(
decoder_row_input : IN  std_logic_vector(8 downto 0);
decoder_row_output : OUT  std_logic_vector(511 downto 0);
e : IN  std_logic
);
END COMPONENT;

--Inputs
signal decoder_row_input : std_logic_vector(8 downto 0) := (others => '0');
signal e : std_logic;

--Outputs
signal decoder_row_output : std_logic_vector(511 downto 0);

constant clock_period : time := 20 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: mem_decoder_row PORT MAP (
decoder_row_input => decoder_row_input,
decoder_row_output => decoder_row_output,
e => e
);

-- Stimulus process
stim_proc: process
constant N : integer := 2**(decoder_row_input'left+1);
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
--vec2str(decoder_row_output)
function vec2str(vec: std_logic_vector) return string is
	variable result: string(vec'left downto 0);
begin
	for i in vec'reverse_range loop
		if (vec(i) = '1') then
			result(i) := '1';
		elsif (vec(i) = '0') then
			result(i) := '0';
		else
			result(i) := 'X';
		end if;
	end loop;
return result;
end;
variable vu : std_logic_vector(3 downto 0);
variable vl : std_logic_vector(3 downto 0);
begin

e <= '1'; -- XXX todo

l0 : for i in 0 to 15 loop
	vu := std_logic_vector(to_unsigned(i,4));
	l1 : for j in 0 to 15 loop
		vl := std_logic_vector(to_unsigned(j,4));
		decoder_row_input(8 downto 0) <= '0' & vu & vl;
		wait for clock_period;
		assert (one_position(decoder_row_output) =to_integer(unsigned(decoder_row_input))) report " ERROR " & " : position " & integer'image(one_position(decoder_row_output)) & " , expect " & integer'image(to_integer(unsigned(decoder_row_input))) severity note;
		assert (one_position(decoder_row_output)/=to_integer(unsigned(decoder_row_input))) report " OK    " & " : position " & integer'image(one_position(decoder_row_output)) & " , expect " & integer'image(to_integer(unsigned(decoder_row_input))) severity note;
		wait for clock_period;
	end loop l1;
end loop l0;

wait for clock_period;

ll0 : for i in 0 to 15 loop
	vu := std_logic_vector(to_unsigned(i,4));
	ll1 : for j in 0 to 15 loop
		vl := std_logic_vector(to_unsigned(j,4));
		decoder_row_input(8 downto 0) <= '1' & vu & vl;
		wait for clock_period;
		assert (one_position(decoder_row_output) =to_integer(unsigned(decoder_row_input))) report " ERROR " & " : position " & integer'image(one_position(decoder_row_output)) & " , expect " & integer'image(to_integer(unsigned(decoder_row_input))) severity note;
		assert (one_position(decoder_row_output)/=to_integer(unsigned(decoder_row_input))) report " OK    " & " : position " & integer'image(one_position(decoder_row_output)) & " , expect " & integer'image(to_integer(unsigned(decoder_row_input))) severity note;
		wait for clock_period;
	end loop ll1;
end loop ll0;

wait;

end process;

END;
