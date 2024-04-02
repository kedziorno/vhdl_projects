----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:03:44 07/10/2022 
-- Design Name: 
-- Module Name:    bram_vga - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

--
-- Dual-Port RAM with Synchronous Read (Read Through)
-- using More than One Clock
-- UG627 PDF p. 153
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bram_vga is
generic (
constant WIDTH : integer := 0;
constant DEPTH : integer := 0
);
port (
clka : in std_logic;
clkb : in std_logic;
wea : in std_logic;
addra : in std_logic_vector(DEPTH-1 downto 0);
addrb : in std_logic_vector(DEPTH-1 downto 0);
dina : in std_logic_vector(WIDTH-1 downto 0);
douta : out std_logic_vector(WIDTH-1 downto 0)
);
end entity bram_vga;

architecture simulation of bram_vga is
	type ram_type is array (0 to 2**DEPTH-1) of std_logic_vector(WIDTH-1 downto 0);
	signal RAM : ram_type := (others => (others => '0'));
	signal read_addra : std_logic_vector(DEPTH-1 downto 0);
	signal read_addrb : std_logic_vector(DEPTH-1 downto 0);
begin
	pa : process (clka)
	begin
		if (rising_edge(clka)) then
			if (wea = '1') then
				RAM(conv_integer(addra)) <= dina;
			end if;
			read_addra <= addra;
		end if;
	end process pa;
	
	pb : process (clkb)
	begin
		if (rising_edge(clkb)) then
			read_addrb <= addrb;
		end if;
	end process pb;
	douta <= RAM(conv_integer(addrb));

end architecture simulation;
