library IEEE;
use IEEE.STD_LOGIC_1164.all;
package p_GAMMA_CORRECTION_GREEN is
-- GAMMA_CORRECTION GREEN = 0.40
constant NUMBER_GAMMA_CORRECTION_GREEN : natural := 256;
type ARRAY_GAMMA_CORRECTION_GREEN is array (0 to NUMBER_GAMMA_CORRECTION_GREEN-1) of std_logic_vector(7 downto 0);
constant C_GAMMA_CORRECTION_GREEN : ARRAY_GAMMA_CORRECTION_GREEN :=
(

x"00",x"00",x"00",x"00",x"00",x"00",x"00",
x"00",x"00",x"00",x"00",x"00",x"00",x"00",
x"00",x"00",x"00",x"00",x"00",x"00",x"00",
x"00",x"00",x"00",x"01",x"01",x"01",x"01",
x"01",x"01",x"01",x"01",x"02",x"02",x"02",
x"02",x"02",x"02",x"03",x"03",x"03",x"03",
x"04",x"04",x"04",x"04",x"04",x"05",x"05",
x"05",x"06",x"06",x"06",x"07",x"07",x"07",
x"08",x"08",x"08",x"09",x"09",x"0A",x"0A",
x"0B",x"0B",x"0B",x"0C",x"0C",x"0D",x"0D",
x"0E",x"0E",x"0F",x"0F",x"10",x"10",x"11",
x"12",x"12",x"13",x"13",x"14",x"14",x"15",
x"16",x"17",x"17",x"18",x"19",x"19",x"1A",
x"1B",x"1C",x"1C",x"1D",x"1E",x"1E",x"1F",
x"21",x"21",x"22",x"23",x"24",x"24",x"25",
x"27",x"28",x"28",x"29",x"2A",x"2B",x"2C",
x"2E",x"2F",x"2F",x"30",x"31",x"32",x"33",
x"35",x"36",x"37",x"38",x"39",x"3A",x"3B",
x"3D",x"3E",x"3F",x"41",x"42",x"43",x"44",
x"46",x"47",x"49",x"4A",x"4B",x"4C",x"4D",
x"50",x"51",x"52",x"54",x"55",x"56",x"57",
x"5A",x"5B",x"5D",x"5E",x"60",x"61",x"62",
x"65",x"67",x"68",x"6A",x"6B",x"6D",x"6E",
x"71",x"73",x"74",x"76",x"77",x"79",x"7B",
x"7E",x"7F",x"81",x"83",x"84",x"86",x"88",
x"8B",x"8D",x"8F",x"91",x"92",x"94",x"96",
x"9A",x"9C",x"9D",x"9F",x"A1",x"A3",x"A5",
x"A9",x"AB",x"AD",x"AF",x"B1",x"B3",x"B5",
x"B9",x"BB",x"BD",x"BF",x"C1",x"C3",x"C6",
x"CA",x"CC",x"CE",x"D0",x"D3",x"D5",x"D7",
x"DC",x"DE",x"E0",x"E3",x"E5",x"E7",x"EA",
x"EE",x"F1",x"F3",x"F6",x"F8",x"FB",x"FD"
);
end package p_GAMMA_CORRECTION_GREEN;
package body p_GAMMA_CORRECTION_GREEN is
end package body p_GAMMA_CORRECTION_GREEN;

