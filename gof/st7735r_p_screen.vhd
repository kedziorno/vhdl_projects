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

package st7735r_p_screen is

	-- XXX based on https://github.com/Dungyichao/STM32F4-LCD_ST7735s/blob/master/ST7735/st7735.c
	-- XXX based on https://github.com/Dungyichao/STM32F4-LCD_ST7735s/blob/master/ST7735/st7735.h

	constant SCREEN_WIDTH : integer := 128;
	constant SCREEN_HEIGHT : integer := 160;
	constant SCREEN_AREA : integer := SCREEN_WIDTH * SCREEN_HEIGHT;
	constant SCREEN_FILL : integer := 2 * SCREEN_AREA;

	subtype COLOR_TYPE is std_logic_vector(15 downto 0);
	constant SCREEN_BLACK : COLOR_TYPE := x"0000";
	constant SCREEN_BLUE : COLOR_TYPE := x"001F";
	constant SCREEN_RED : COLOR_TYPE := x"F800";
	constant SCREEN_GREEN : COLOR_TYPE := x"07E0";
	constant SCREEN_CYAN : COLOR_TYPE := x"07FF";
	constant SCREEN_MAGENTA : COLOR_TYPE := x"F81F";
	constant SCREEN_YELLOW : COLOR_TYPE := x"FFE0";
	constant SCREEN_WHITE : COLOR_TYPE := x"FFFF";
	constant SCREEN_ORANGE : COLOR_TYPE := x"FD60";
	constant SCREEN_LIGHTGREEN : COLOR_TYPE := x"07EF";
	constant SCREEN_LIGHTGREY : COLOR_TYPE := x"A514";
	-- COLOR888_COLOR565(r, g, b) (((r & 0xF8) << 8) | ((g & 0xFC) << 3) | ((b & 0xF8) >> 3))

	constant data_size_initscreen : integer := 83 * 2;
	type data_array_initscreen is array(0 to data_size_initscreen - 1) of BYTE_TYPE;
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
	type data_array_blackscreen is array(0 to data_size_blackscreen - 1) of BYTE_TYPE;
	constant data_rom_blackscreen : data_array_blackscreen := (
	-- XXX sequence for box 1px around
	-- x"2a",x"01",x"00",x"00",x"01",x"00",x"00",x"00",x"7e",x"00",x"2b",x"01",x"00",x"00",x"01",x"00",x"00",x"00",x"9e",x"00",x"2c",x"01"
	x"2a",x"01",--CASET
	x"00",x"00",
	x"00",x"00",
	x"00",x"00",
	x"7f",x"00",
	x"2b",x"01",--RASET
	x"00",x"00",
	x"00",x"00",
	x"00",x"00",
	x"9f",x"00",
	x"2c",x"01" --RAMWR
	);

end st7735r_p_screen;

package body st7735r_p_screen is
end st7735r_p_screen;
