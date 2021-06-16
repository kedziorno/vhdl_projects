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
	-- XXX " lorem ipsum ... "
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
			elsif (vec(i) = 'X') then
				result(i) := 'X';
			elsif (vec(i) = 'U') then
				result(i) := 'U';
			else
				result(i) := '?';
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
		signal cs : in std_logic;
		signal do : in std_logic;
		signal ck : in std_logic
	) is
		constant Xs : std_logic_vector(0 to BYTE_SIZE - 1) := (others => 'U');
	begin
		if ((ck'event and ck = '1') and cs = '0') then
			data_temp(data_temp_index) := do;
			data_temp_index := data_temp_index + 1;
		elsif (cs'event and cs = '1') then
			assert (data_rom(data_rom_index) = data_temp)
			report "FAIL : " & vec2str(data_temp) & " expect " & vec2str(data_rom(data_rom_index)) severity note;
			assert (data_rom(data_rom_index) /= data_temp)
			report "OK   : " & vec2str(data_temp) & " equals " & vec2str(data_rom(data_rom_index)) severity note;
			data_temp_index := 0;
			if (data_rom_index = data_size - 1) then
				data_rom_index := 0;
				assert (false) report "=== END TEST ===" severity note;
			else
				if (data_temp /= Xs) then -- XXX omit first undefined/uninitialized
					data_rom_index := data_rom_index + 1;
				end if;
			end if;
		end if;
	end procedure check_test;

end p_package;

package body p_package is
end p_package;
