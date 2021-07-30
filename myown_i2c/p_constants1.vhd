library IEEE;
use IEEE.STD_LOGIC_1164.all;

package p_constants1 is
	constant G_BOARD_CLOCK : INTEGER := 50_000_000;
	constant G_BUS_CLOCK : INTEGER := 100_000;
	constant G_BYTE_SIZE : integer := 8;
	constant G_SLAVE_ADDRESS_SIZE : integer := 7;

	type array1 is array(natural range <>) of std_logic_vector(7 downto 0);
end p_constants1;

package body p_constants1 is
end p_constants1;
