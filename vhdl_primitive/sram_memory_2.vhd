----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:05:07 04/23/2021 
-- Design Name: 
-- Module Name:    sram_memory_2 - Behavioral 
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

entity sram_memory_2 is
Generic (
	N : integer := 8;
	M : integer := 4
);
Port (
	clk1,clk2,wr : in std_logic;
	rd_address,wr_address : in integer range 0 to 2**M-1;
	data_in : in std_logic_vector(N-1 downto 0);
	data_out : out std_logic_vector(N-1 downto 0)
);
end sram_memory_2;

architecture Behavioral of sram_memory_2 is
	type memory is array(0 to 2**M-1) of std_logic_vector(N-1 downto 0);
	signal ram : memory;
begin
	p0 : process (clk1) is
	begin
		if (rising_edge(clk1)) then
			if (wr='1') then
				ram(wr_address) <= data_in;
			end if;
		end if;
	end process p0;
	p1 : process (clk2) is
	begin
		if (rising_edge(clk2)) then
			data_out <= ram(rd_address);
		end if;
	end process p1;
end Behavioral;
