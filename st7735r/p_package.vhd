--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package p_package is
	constant BYTE_SIZE : integer := 8;
	constant C_CLOCK_COUNTER : integer := 2**16;

	constant data_size : integer := 32;
	type data_array is array(0 to data_size-1) of std_logic_vector(0 to BYTE_SIZE-1);
	constant data_rom : data_array := (
	x"6c",x"6f",x"72",x"65",x"6d",x"ff",x"69",x"70",
	x"73",x"75",x"6d",x"20",x"64",x"6f",x"6c",x"6f",
	x"72",x"20",x"69",x"6e",x"65",x"73",x"6c",x"6f",
	x"72",x"65",x"6d",x"20",x"69",x"70",x"73",x"75");

	function vec2str(vec: std_logic_vector) return string is
		variable result: string(0 to vec'right);
	begin
		for i in vec'range loop
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

	shared variable data_rom_index : integer range 0 to data_size - 1;
	constant R_EDGE : std_logic := '1';
	constant F_EDGE : std_logic := '0';
	shared variable data_temp : std_logic_vector(0 to BYTE_SIZE-1);
	shared variable data_temp_index : integer range 0 to BYTE_SIZE - 1;

	procedure check_test(
		signal sended : in std_logic;
		signal cs : in std_logic;
		signal do : in std_logic;
		signal ck : in std_logic
	) is
	begin
		if (sended'event and sended = '1') then
			if (data_rom_index = data_size - 1) then
				data_rom_index := 0;
			else
				data_rom_index := data_rom_index + 1;
			end if;
			assert (data_rom(data_rom_index) = data_temp)
			report "FAIL : " & vec2str(data_temp) & " expect " & vec2str(data_rom(data_rom_index)) severity warning;
		elsif (sended = '0') then
			if ((ck'event and ck = '1') and cs = '0') then
--			assert (false) report "AAA" severity WARNING;
				if (data_temp_index = BYTE_SIZE - 1) then
					data_temp_index := 0;
				else
					data_temp_index := data_temp_index + 1;
				end if;
				data_temp(data_temp_index) := do;
			end if;
		end if;
	end procedure check_test;

end p_package;

package body p_package is
end p_package;
