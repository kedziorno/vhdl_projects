----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:07:54 10/27/2020 
-- Design Name: 
-- Module Name:    memory1 - Behavioral 
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
use WORK.p_memory_content.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory1 is
Port (
i_clk : in std_logic;
i_enable : in std_logic;
i_write : in std_logic;
i_row : in std_logic_vector(ROWS_BITS-1 downto 0);
i_col_pixel : in std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
i_col_block : in std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
i_byte : in std_logic_vector(BYTE_BITS-1 downto 0);
o_bit : out std_logic;
o_byte : out std_logic_vector(BYTE_BITS-1 downto 0));
end memory1;

architecture Behavioral of memory1 is
	signal t_row : std_logic_vector(ROWS_BITS-1 downto 0);
	signal t_col_pixel : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
	signal t_col_block : std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
	signal m1 : MEMORY := memory_content;

	attribute equivalent_register_removal : string;
	attribute equivalent_register_removal of m1 : signal is "no";
	attribute keep : string;
	attribute keep of m1 : signal is "true";
begin
	p0 : process(i_clk) is
	begin
		if (rising_edge(i_clk)) then
			if (i_enable = '1') then
				if (i_write = '1') then
					m1(to_integer(unsigned(t_row)))
					((to_integer(unsigned(t_col_block))*BYTE_BITS)+(BYTE_BITS-1)
					downto
					(to_integer(unsigned(t_col_block))*BYTE_BITS)) <= i_byte;
				end if;
			end if;
			t_row <= i_row;
			t_col_pixel <= i_col_pixel;
			t_col_block <= i_col_block;
		end if;
	end process p0;
	o_byte <= m1(to_integer(unsigned(t_row)))
	((to_integer(unsigned(t_col_block))*BYTE_BITS)+(BYTE_BITS-1)
	downto
	(to_integer(unsigned(t_col_block))*BYTE_BITS));
	o_bit <= m1(to_integer(unsigned(t_row)))(to_integer(unsigned(i_col_pixel)));
end Behavioral;
