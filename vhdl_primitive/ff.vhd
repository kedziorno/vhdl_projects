----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:47:48 04/23/2021 
-- Design Name: 
-- Module Name:    ff - Behavioral 
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

entity ff is
Generic (
	bits : positive
);
Port (
	d : in std_logic; --std_logic_vector(bits-1 downto 0); --d : in bit_vector(bits-1 downto 0);
	clk : in std_logic; --clk : in bit;
	q : out std_logic --std_logic_vector(bits-1 downto 0) --q : out bit_vector(bits-1 downto 0)
);
end ff;

architecture Behavioral of ff is
begin
	p0 : process (clk) is
	begin
		if (rising_edge(clk)) then -- clk'event and clk='1'
			q <= d;
		end if;
	end process p0;
end Behavioral;
