----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:31:53 04/12/2021 
-- Design Name: 
-- Module Name:    decoder - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder is
Generic (
SIZE : integer := 4
);
Port (
input : in  integer range 0 to SIZE-1;
output : out  integer range 1 to (2**SIZE)-1
);
end decoder;

architecture Behavioral of decoder is
begin
	-- XXX https://stackoverflow.com/a/4788661 https://stackoverflow.com/a/4788253
	 --output <= 0;
	 p0 : process (input) is
	 begin
		output <= (2**input)-1;
	 end process p0;
--	MUX : for i in 0 to (2**SIZE)-1 generate
--	begin
--		if (i = conv_integer(input)) then
--			output(i) <= '1';
--		else
--			output(i) <= '0';
--		end if;
--	end generate MUX;
end Behavioral;

