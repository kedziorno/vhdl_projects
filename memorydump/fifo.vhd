----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:47:51 02/02/2021 
-- Design Name: 
-- Module Name:    fifo - Behavioral 
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

entity fifo is
Generic (
	WIDTH : integer := 8;
	HEIGHT : integer := 5
);
Port (
	i_clk1 : in  STD_LOGIC;
	i_clk2 : in  STD_LOGIC;
	i_data : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	o_data : out  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	o_full : out  STD_LOGIC;
	o_empty : out  STD_LOGIC;
	o_memory_index : out  std_logic_vector(HEIGHT-1 downto 0)
);
end fifo;

architecture Behavioral of fifo is
	type memory_t is array(0 to HEIGHT-1) of std_logic_vector(WIDTH-1 downto 0);
	signal memory : memory_t := ( others => ( others => '0' ) );
	signal memory_index : natural range 0 to HEIGHT-1 := 0;
	signal full,empty : std_logic;
begin
	empty <= '1' when (memory_index = 0) else '0';
	full <= '1' when (memory_index = HEIGHT) else '0';

	o_memory_index <= std_logic_vector(to_unsigned(memory_index,HEIGHT));
	o_full <= full;
	o_empty <= empty;

	p0 : process (i_clk1,full) is
	begin
		if (full = '0') then
			if (rising_edge(i_clk1)) then
				memory(memory_index) <= i_data;
			end if;
		end if;
	end process p0;
	
	p1 : process (i_clk2,empty) is
	begin
		if (empty = '0') then
			if (rising_edge(i_clk2)) then
				o_data <= memory(memory_index-1);
			end if;
		end if;
	end process p1;

	p2 : process (i_clk1,i_clk2) is
		variable mi : natural range 0 to HEIGHT-1 := 0;
	begin
		if (rising_edge(i_clk1)) then
			if (full='0') then
				if (mi /= HEIGHT) then
					mi := mi + 1;
				end if;
			end if;
		elsif (rising_edge(i_clk2)) then
			if (empty='0') then
				if (mi /= 0) then
					mi := mi - 1;
				end if;
			end if;
		end if;
		memory_index <= mi;
	end process p2;
	
end Behavioral;
