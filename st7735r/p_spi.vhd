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

package p_spi is

	-- XXX for simulation
--	shared variable data_rom_index : integer;
--	constant R_EDGE : std_logic := '1';
--	constant F_EDGE : std_logic := '0';
--	shared variable data_temp : std_logic_vector(0 to BYTE_SIZE-1);
--	shared variable data_temp_index : integer;
--	constant Xs : std_logic_vector(0 to BYTE_SIZE - 1) := (others => 'U');

--	function vec2str(vec: std_logic_vector) return string;
--
--	procedure check_test(
--	signal cs : in std_logic;
--	signal do : in std_logic;
--	signal ck : in std_logic);

end p_spi;

package body p_spi is

	-- XXX for simulation
--	function vec2str(vec: std_logic_vector) return string is
--		variable result: string(0 to vec'right);
--	begin
--		for i in vec'range loop
--			if (vec(i) = '1') then
--				result(i) := '1';
--			elsif (vec(i) = '0') then
--				result(i) := '0';
--			elsif (vec(i) = 'X') then
--				result(i) := 'X';
--			elsif (vec(i) = 'U') then
--				result(i) := 'U';
--			else
--				result(i) := '?';
--			end if;
--		end loop;
--		return result;
--	end;
--
	-- XXX for simulation
--	procedure check_test(
--		signal cs : in std_logic;
--		signal do : in std_logic;
--		signal ck : in std_logic
--	) is
--	begin
--		if ((ck'event and ck = R_EDGE) and cs = '0') then
--			data_temp(data_temp_index) := do;
--			if (data_temp_index = BYTE_SIZE - 1) then
--				data_temp_index := 0;
--			else
--				data_temp_index := data_temp_index + 1;
--			end if;
--		elsif (cs'event and cs = R_EDGE) then
--			assert (data_rom(data_rom_index) = data_temp)
--			report "FAIL : (" & integer'image(data_rom_index) & ") " & vec2str(data_temp) & " expect " & vec2str(data_rom(data_rom_index)) severity note;
--			assert (data_rom(data_rom_index) /= data_temp)
--			report "OK   : (" & integer'image(data_rom_index) & ") " & vec2str(data_temp) & " equals " & vec2str(data_rom(data_rom_index)) severity note;
--			data_temp_index := 0;
--			if (data_rom_index = data_size - 1) then
--				data_rom_index := 0;
--				assert (false) report "=== END TEST ===" severity note;
--			else
--				if (data_temp /= Xs) then -- XXX omit first undefined/uninitialized
--					data_rom_index := data_rom_index + 1;
--				end if;
--			end if;
--		end if;
--	end procedure check_test;
 
end p_spi;
