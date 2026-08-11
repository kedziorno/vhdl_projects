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
	HEIGHT : integer := 1
);
Port (
	i_clk1 : in  STD_LOGIC;
	i_clk2 : in  STD_LOGIC;
	i_rst : in  STD_LOGIC;
	i_data : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	o_data : out  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	o_full : out  STD_LOGIC;
	o_empty : out  STD_LOGIC;
	o_memory_index : out  std_logic_vector(HEIGHT-1 downto 0)
);
end fifo;

-- fifo one clock

architecture Behavioral of fifo is

	type memory_t is array(0 to HEIGHT-1) of std_logic_vector(WIDTH-1 downto 0);
	signal memory : memory_t;
	signal index : integer range 0 to HEIGHT:= 0;
	signal full,empty : std_logic;
	signal r,w : integer range 0 to HEIGHT-1:= 0;

begin

	empty <= '1' when (index=0) else '0';
	full <= '1' when (index=HEIGHT-1) else '0';

	o_memory_index <= std_logic_vector(to_unsigned(index,HEIGHT));
	o_full <= full;
	o_empty <= empty;

	pc : process (i_clk1,i_rst) is
	begin
		if (i_rst = '1') then
			index <= 0;
		elsif (rising_edge(i_clk1)) then
			if (index = HEIGHT-1) then
				index <= 0;
			else
				index <= index + 1;
			end if;
		end if;
	end process pc;

	pa : process (i_clk1,w,i_rst) is
	begin
		if (i_rst = '1') then
			w <= 0;
		elsif (rising_edge(i_clk1)) then
			memory(w) <= i_data;
			if (w=HEIGHT-1) then
				w <= 0;
			else
				w <= w + 1;
			end if;
		end if;
	end process pa;

	pb : process (i_clk1,r,i_rst) is
	begin
		if (i_rst = '1') then
			r <= 0;
		elsif (rising_edge(i_clk1)) then
			o_data <= memory(r);
			if (r=HEIGHT-1) then
				r <= 0;
			else
				r <= r + 1;
			end if;
		end if;
	end process pb;

end Behavioral;
