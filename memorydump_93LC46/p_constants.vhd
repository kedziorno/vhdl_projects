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

package p_constants is
	constant G_BOARD_CLOCK_HARDWARE : integer := 50_000_000;
	constant G_BOARD_CLOCK_SIMULATE : integer := 1_000_000;
	constant G_CLOCK_DIV1 : integer := 50; -- XXX SPI MAX 1MHZ,VCC=3V+/-10%
	constant NUMBER_BITS : integer := 8;
	constant G_MemoryAddress : integer := 7; -- XXX 1K 93LC46 128x8 or 64x16
	constant G_MemoryData : integer := NUMBER_BITS;
	subtype MemoryAddress is std_logic_vector(G_MemoryAddress-1 downto 0);
	constant MemoryAddressMAX : MemoryAddress := (others => '1');
	constant MemoryAddressMIN : MemoryAddress := (others => '0');
	subtype MemoryDataByte is std_logic_vector(G_MemoryData-1 downto 0);
	constant MemoryDataByteMAX : MemoryDataByte := (others => '1');
	constant MemoryDataByteMIN : MemoryDataByte := (others => '0');
--	constant G_BAUD_RATE : integer := 115200;
--	constant G_BAUD_RATE : integer := 57600;
--	constant G_BAUD_RATE : integer := 38400;
--	constant G_BAUD_RATE : integer := 19200;
--	constant G_BAUD_RATE : integer := 9600;
--	constant G_BAUD_RATE : integer := 4800;
--	constant G_BAUD_RATE : integer := 2400;
--	constant G_BAUD_RATE : integer := 1200;
	constant G_BAUD_RATE : integer := 300;
--	constant G_BR_OVERSAMPLING : integer := 16;
--	constant G_PARITY : integer := 0;
--	constant G_PARITY_EO : std_logic := '0'; -- even/odd
	constant slaves  : INTEGER := 1; -- number of spi slaves
	constant d_width : INTEGER := 2; -- data bus width
end p_constants;

package body p_constants is
end p_constants;
