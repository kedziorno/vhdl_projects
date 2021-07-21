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
use WORK.st7735r_p_package.ALL;

package st7735r_p_store_image_data is

	constant R_EDGE : std_logic := '1';
	constant F_EDGE : std_logic := '0';
	subtype byte is std_logic_vector(0 to BYTE_SIZE-1);
	constant Xs : std_logic_vector(0 to BYTE_SIZE - 1) := (others => 'U');

	function vec2str(vec: std_logic_vector) return string;

	procedure spi_get_byte (
		signal i_reset : in std_logic;
		signal cs : in std_logic;
		signal do : in std_logic;
		signal ck : in std_logic;
		variable do_data : out byte
	);

	type states is (idle,pattern1,pattern2,pattern3,start,stop);

	procedure st7735r_store_image_fsm (
		signal i_reset : in std_logic;
		signal cs : in std_logic;
		signal do : in std_logic;
		signal ck : in std_logic
	);

end st7735r_p_store_image_data;

package body st7735r_p_store_image_data is

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

	procedure spi_get_byte (
		signal i_reset : in std_logic;
		signal cs : in std_logic;
		signal do : in std_logic;
		signal ck : in std_logic;
		variable do_data : out byte
	) is
		variable data_temp_index : integer := 0;
	begin
		if (i_reset = '1') then
			data_temp_index := 0;
		elsif ((ck'event and ck = R_EDGE) and cs = '0') then -- XXX on cs = '0'
			do_data(data_temp_index) := do;
			if (data_temp_index = BYTE_SIZE - 1) then
				data_temp_index := 0;
			else
				data_temp_index := data_temp_index + 1;
			end if;
		elsif (cs'event and cs = R_EDGE) then -- XXX at cs = '1', do have byte

--			assert (data_rom(data_rom_index) = data_temp) report "FAIL : (" & integer'image(data_rom_index) & ") " & vec2str(data_temp) & " expect " & vec2str(data_rom(data_rom_index)) severity note;
--			assert (data_rom(data_rom_index) /= data_temp) report "OK   : (" & integer'image(data_rom_index) & ") " & vec2str(data_temp) & " equals " & vec2str(data_rom(data_rom_index)) severity note;
--			data_temp_index := 0;
--			if (data_rom_index = data_size - 1) then
--				data_rom_index := 0;
--				assert (false) report "=== END TEST ===" severity note;
--			else
--				if (data_temp /= Xs) then -- XXX omit first undefined/uninitialized
--					data_rom_index := data_rom_index + 1;
--				end if;
--			end if;

		end if;
	end procedure spi_get_byte;

	procedure st7735r_store_image_fsm (
		signal i_reset : in std_logic;
		signal cs : in std_logic;
		signal do : in std_logic;
		signal ck : in std_logic
	) is
		variable do_data : byte;
		variable state : states;
	begin
		if (i_reset = '1') then
			state := idle;
			do_data := (others => 'U');
		else
			case (state) is
				when idle =>
					state := pattern1;
				when pattern1 =>
					if (do_data = x"2b") then
						state := pattern1;
					else
						state := pattern2;
					end if;
				when pattern2 =>
					if (do_data = x"2a") then
						state := pattern2;
					else
						state := pattern3;
					end if;
				when pattern3 =>
					if (do_data = x"2c") then
						state := pattern3;
					else
						state := start;
					end if;
				when start =>
					state := stop;
					report "asd" severity note;
				when stop =>
					state := idle;
			end case;
			spi_get_byte(i_reset,cs,do,ck,do_data);
		end if;
	end procedure st7735r_store_image_fsm;

end st7735r_p_store_image_data;
