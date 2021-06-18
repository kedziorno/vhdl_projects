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
	constant ABOUT_1coma31_MS: integer := 2**16; --XXX ~1.31ms on 50mhz
--	constant C_CLOCK_COUNTER : integer := 2**16; -- XXX slow
--	constant C_CLOCK_COUNTER : integer := 2**8; -- XXX fast
--	constant C_CLOCK_COUNTER : integer := 2**4; -- XXX very fast
	constant C_CLOCK_COUNTER : integer := 2**3; -- XXX extreme fast
--	constant C_CLOCK_COUNTER : integer := 2**2; -- XXX monster fast,not work

	constant SCREEN_WIDTH : integer := 128;
	constant SCREEN_HEIGHT : integer := 160;
	constant SCREEN_FILL : integer := 2 * SCREEN_WIDTH * SCREEN_HEIGHT;

	constant data_size_initscreen : integer := 83 * 2;
	type data_array_initscreen is array(0 to data_size_initscreen-1) of std_logic_vector(0 to BYTE_SIZE-1);
	-- XXX based on https://github.com/Dungyichao/STM32F4-LCD_ST7735s/blob/master/ST7735/st7735.c
	constant data_rom_initscreen : data_array_initscreen := (
	x"b1",x"01",--FRMCTR1
	x"01",x"00",
	x"2c",x"00",
	x"2d",x"00",
	x"b2",x"01",--FRMCTR2
	x"01",x"00",
	x"2c",x"00",
	x"2d",x"00",
	x"b3",x"01",--FRMCTR3
	x"01",x"00",
	x"2c",x"00",
	x"2d",x"00",
	x"01",x"00",
	x"2c",x"00",
	x"2d",x"00",
	x"b4",x"01",--INVCTR
	x"07",x"00",
	x"c0",x"01",--PWCTR1
	x"a2",x"00",
	x"02",x"00",
	x"84",x"00",
	x"c1",x"01",--PWCTR2
	x"c5",x"00",
	x"c2",x"01",--PWCTR3
	x"0a",x"00",
	x"00",x"00",
	x"c3",x"01",--PWCTR4
	x"8a",x"00",
	x"2a",x"00",
	x"c4",x"01",--PWCTR5
	x"8a",x"00",
	x"ee",x"00",
	x"c5",x"01",--VMCTR1
	x"0e",x"00",
	x"20",x"01",--INVOFF
	x"36",x"01",--MADCTL
	x"c0",x"00",--ROTATION (ST7735_MADCTL_MX | ST7735_MADCTL_MY) 0x40 | 0x80
	x"3a",x"01",--COLMOD
	x"05",x"00",
	x"2a",x"01",--CASET
	x"00",x"00",
	x"00",x"00",
	x"00",x"00",
	x"7f",x"00",
	x"2b",x"01",--RASET
	x"00",x"00",
	x"00",x"00",
	x"00",x"00",
	x"7f",x"00",
	x"e0",x"01",--GMCTRP1
	x"02",x"00",
	x"1c",x"00",
	x"07",x"00",
	x"12",x"00",
	x"37",x"00",
	x"32",x"00",
	x"29",x"00",
	x"2d",x"00",
	x"29",x"00",
	x"25",x"00",
	x"2b",x"00",
	x"39",x"00",
	x"00",x"00",
	x"01",x"00",
	x"03",x"00",
	x"10",x"00",
	x"e1",x"01",--GMCTRN1
	x"03",x"00",
	x"1d",x"00",
	x"07",x"00",
	x"06",x"00",
	x"2e",x"00",
	x"2c",x"00",
	x"29",x"00",
	x"2d",x"00",
	x"2e",x"00",
	x"2e",x"00",
	x"37",x"00",
	x"3f",x"00",
	x"00",x"00",
	x"00",x"00",
	x"02",x"00",
	x"10",x"00");

	constant data_size_blackscreen : integer := 11 * 2;
	type data_array_blackscreen is array(0 to data_size_blackscreen-1) of std_logic_vector(0 to BYTE_SIZE-1);
	constant data_rom_blackscreen : data_array_blackscreen := (
	x"2a",x"01",--CASET
	x"00",x"00",
	x"01",x"00",
	x"00",x"00",
	x"82",x"00",
	x"2b",x"01",--RASET
	x"00",x"00",
	x"02",x"00",
	x"00",x"00",
	x"a1",x"00",
	x"2c",x"01" --RAMWR
	);

	-- XXX for simulation
--	shared variable data_rom_index : integer range 0 to data_size - 1;
--	constant R_EDGE : std_logic := '1';
--	constant F_EDGE : std_logic := '0';
--	shared variable data_temp : std_logic_vector(0 to BYTE_SIZE-1);
--	shared variable data_temp_index : integer range 0 to BYTE_SIZE - 1 := 0;
--	constant Xs : std_logic_vector(0 to BYTE_SIZE - 1) := (others => 'U');

--	function vec2str(vec: std_logic_vector) return string;
--
--	procedure check_test(
--	signal cs : in std_logic;
--	signal do : in std_logic;
--	signal ck : in std_logic);

end p_package;

package body p_package is

--	function vec2str(vec: std_logic_vector) return string is -- XXX for simulation
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
--	procedure check_test( -- XXX for simulation
--		signal cs : in std_logic;
--		signal do : in std_logic;
--		signal ck : in std_logic
--	) is
--	begin
--		if ((ck'event and ck = '1') and cs = '0') then
--			data_temp(data_temp_index) := do;
--			if (data_temp_index = BYTE_SIZE - 1) then
--				data_temp_index := 0;
--			else
--				data_temp_index := data_temp_index + 1;
--			end if;
--		elsif (cs'event and cs = '1') then
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

end p_package;
