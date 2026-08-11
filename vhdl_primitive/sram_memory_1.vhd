----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:00:30 04/23/2021 
-- Design Name: 
-- Module Name:    sram_memory_1 - Behavioral 
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

entity sram_memory_1 is
Generic (
	N : integer := 8;
	M : integer := 4
);
Port (
	clk,wr : in std_logic;
	address : in integer range 0 to 2**M-1;
	data : inout std_logic_vector(N-1 downto 0)
);
end sram_memory_1;

architecture Behavioral of sram_memory_1 is
	type memory is array (0 to 2**M-1) of std_logic_vector(N-1 downto 0);
	signal ram : memory;
begin
	p0 : process (clk) is
	begin
		if (rising_edge(clk)) then
			if (wr = '1') then
				ram(address) <= data;
			end if;
		end if;
	end process p0;
	data <= ram(address) when wr='0' else (others => 'Z');
end Behavioral;

