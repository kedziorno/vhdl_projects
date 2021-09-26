library IEEE;
use IEEE.STD_LOGIC_1164.all;

package p_constants1 is
	constant G_BOARD_CLOCK : INTEGER := 23_961_600;
	constant G_BUS_CLOCK : INTEGER := 400_000;
	constant G_BYTE_SIZE : integer := 8;
	constant G_SLAVE_ADDRESS_SIZE : integer := 7;

-- i2c oled 128x32 initialization sequence	
	constant BYTES_SEQUENCE_LENGTH : natural := 26;
	type ARRAY_BYTE_SEQUENCE is array(0 to BYTES_SEQUENCE_LENGTH-1) of std_logic_vector(0 to G_BYTE_SIZE-1);
	constant sequence : ARRAY_BYTE_SEQUENCE :=
	(x"AE",x"D5",x"80",x"A8",x"1F",x"D3",x"00",x"40",x"8D",x"14",x"20",x"00",x"A1",x"C8",x"DA",x"02",x"81",x"8F",x"D9",x"F1",x"DB",x"40",x"A4",x"A6",x"2E",x"AF");

	type array1 is array(natural range <>) of std_logic_vector(7 downto 0);
end p_constants1;

package body p_constants1 is
end p_constants1;
