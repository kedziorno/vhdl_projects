----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:47:26 04/23/2021 
-- Design Name: 
-- Module Name:    generic_mux - Behavioral 
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

entity generic_mux is
Generic (
	M : integer := 4;
	N : integer := 3
);
Port (
	x : in matrix (0 to M-1,N-1 downto 0);
	sel : in integer range 0 to M-1;
	y : out bit_vector(N-1 downto 0)
);
end generic_mux;

architecture Behavioral of generic_mux is
begin
	chain : for i in N-1 downto 0 generate
		y(i) <= x(sel,i);
	end generate chain;
end Behavioral;
