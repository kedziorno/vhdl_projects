----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:43:31 04/23/2021 
-- Design Name: 
-- Module Name:    address_decoder - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity address_decoder is
Generic (
	N : integer := 3
);
Port (
	x : in integer range 0 to 2**N-1;
	y : out bit_vector(2**N-1 downto 0)
);
end address_decoder;

architecture Behavioral of address_decoder is
begin
	chain : for i in x'range generate
		y(i) <= '1' when i=x else '0';
	end generate chain;
end Behavioral;
