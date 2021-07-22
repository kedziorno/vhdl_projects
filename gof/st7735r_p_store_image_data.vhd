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
use WORK.p_memory_content.ALL;
use STD.textio.ALL;

package st7735r_p_store_image_data is

	constant R_EDGE : std_logic := '1';
	constant F_EDGE : std_logic := '0';
	subtype byte is std_logic_vector(0 to BYTE_SIZE-1);
	constant Xs : std_logic_vector(0 to BYTE_SIZE - 1) := (others => 'U');
	
	type states1 is (idle,start_cs,ck_event,ck_event_increment,stop_cs);
	shared variable state1 : states1;
	type states2 is (idle,
	pattern1,pattern2,pattern3,
	omit1,omit2,omit3,
	start,
	open_file,write_line,check_index_rows,check_index_cols,write_file,close_file,
	stop);
	shared variable state2 : states2;

	shared variable data_temp_index : integer;

	shared variable do_temp : byte;

	shared variable done : std_logic;
	shared variable do_data : byte;

	constant C_FILE_NAME : string  := "DataOut.txt";
	shared variable fstatus : file_open_status;
	shared variable file_line : line;
	file fptr : text;

	shared variable index_rows,index_cols : integer;
	shared variable pattern : string(1 to COLS_PIXEL);
	function vec2str(vec: std_logic_vector) return string;

	procedure spi_get_byte (
		signal i_clock : in std_logic;
		signal i_reset : in std_logic;
		signal cs : in std_logic;
		signal do : in std_logic;
		signal ck : in std_logic;
		variable done : out std_logic;
		variable do_data : inout byte
	);

	procedure st7735r_store_image_fsm (
		signal i_clock : in std_logic;
		signal i_reset : in std_logic;
		signal cs : in std_logic;
		signal do : in std_logic;
		signal ck : in std_logic
	);

end st7735r_p_store_image_data;

package body st7735r_p_store_image_data is

	procedure spi_get_byte (
		signal i_clock : in std_logic;
		signal i_reset : in std_logic;
		signal cs : in std_logic;
		signal do : in std_logic;
		signal ck : in std_logic;
		variable done : out std_logic;
		variable do_data : inout byte -- XXX default out, inout for report
	) is
	begin
		if (i_reset = '1') then
			state1 := idle;
			data_temp_index := 0;
			do_temp := (others => '0');
			done := '0';
		elsif (rising_edge(i_clock)) then
			case (state1) is
				when idle =>
					state1 := start_cs;
					data_temp_index := 0;
					do_temp := (others => '0');
					done := '0';
				when start_cs =>
					if (cs = '0') then
						state1 := ck_event;
					else
						state1 := start_cs;
					end if;
				when ck_event =>
					if (ck = R_EDGE) then
						state1 := ck_event_increment;
						do_temp(data_temp_index) := do;
					else
						state1 := ck_event;
					end if;
				when ck_event_increment =>
					if (data_temp_index = BYTE_SIZE - 1) then
						state1 := stop_cs;
					else
						state1 := ck_event;
						data_temp_index := data_temp_index + 1;
					end if;
				when stop_cs =>
					if (cs = '1') then
						state1 := idle;
						do_data := do_temp;
						done := '1';
--						report "spi_get_byte do_data = " & vec2str(do_data) severity note; -- XXX ok, bin pattern
					elsif (cs = '0') then
						state1 := stop_cs;
					end if;
			end case;
		end if;
	end procedure spi_get_byte;

	procedure st7735r_store_image_fsm (
		signal i_clock : in std_logic;
		signal i_reset : in std_logic;
		signal cs : in std_logic;
		signal do : in std_logic;
		signal ck : in std_logic
	) is
	begin
		if (i_reset = '1') then
			state2 := idle;
			index_rows := 0;
			index_cols := 0;
			file_open(fstatus, fptr, C_FILE_NAME, append_mode);
		elsif (rising_edge(i_clock)) then
			case (state2) is
				when idle =>
					if (cs = '1') then
						state2 := idle;
					else
						state2 := pattern1;
					end if;
				when pattern1 =>
--					if (done = '1') then
						if (do_data = x"2b") then
							state2 := pattern2;
						else
							state2 := pattern1;
						end if;
--					else
--						state2 := pattern1;
--					end if;
				when pattern2 =>
--					if (done = '1') then
						if (do_data = x"2a") then
							state2 := pattern3;
						else
							state2 := pattern2;
						end if;
--					else
--						state2 := pattern2;
--					end if;
				when pattern3 =>
--					if (done = '1') then
						if (do_data = x"2c") then
							state2 := write_line;
						else
							state2 := pattern3;
						end if;
--					else
--						state2 := pattern3;
--					end if;
--				when omit1 =>
--					if (done = '1') then
--						if (do_data = x"00" or do_data = x"ff") then
--							state2 := omit2;
--						else
--							state2 := omit1;
--						end if;
--					else
--						state2 := omit1;
--					end if;
--				when omit2 =>
--					if (done = '1') then
--						if (do_data = x"00" or do_data = x"ff") then
--							state2 := omit3;
--						else
--							state2 := omit2;
--						end if;
--					else
--						state2 := omit2;
--					end if;
--				when omit3 =>
--					if (done = '1') then
--						if (do_data = x"00" or do_data = x"ff") then
--							state2 := start;
--						else
--							state2 := omit3;
--						end if;
--					else
--						state2 := omit3;
--					end if;
				when write_line =>
					state2 := check_index_cols;
--					report "index = " & integer'image(index);
					if (done = '1') then
						if (do_data = x"ff") then
							pattern(index_cols + 1) := '*';
						elsif (do_data = x"00") then
							pattern(index_cols + 1) := '.';
						end if;
					else
						state2 := write_line;
					end if;
				when check_index_cols =>
					if (index_cols = COLS_PIXEL - 1) then
						state2 := write_file;
						index_cols := 0;
						write(file_line, pattern);
					else
						state2 := idle;
						index_cols := index_cols + 1;
					end if;
				when write_file =>
					state2 := check_index_rows;
					writeline(fptr, file_line);
				when check_index_rows =>
					if (index_rows = ROWS - 1) then
						state2 := close_file;
						index_rows := 0;
					else
						state2 := idle;
						index_rows := index_rows + 1;
					end if;
				when close_file =>
					state2 := stop;
					file_close(fptr);
				when stop =>
					state2 := idle;
				when others => null;
			end case;
		end if;
		spi_get_byte(i_clock,i_reset,cs,do,ck,done,do_data);
	end procedure st7735r_store_image_fsm;

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

end st7735r_p_store_image_data;
