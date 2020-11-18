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
i_enable_byte : in std_logic;
i_enable_bit : in std_logic;
i_write_byte : in std_logic;
i_write_bit : in std_logic;
i_row : in std_logic_vector(ROWS_BITS-1 downto 0);
i_col_pixel : in std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
i_col_block : in std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
i_byte : in std_logic_vector(BYTE_BITS-1 downto 0);
i_bit : in std_logic;
o_byte : out std_logic_vector(BYTE_BITS-1 downto 0);
o_bit : out std_logic);
end memory1;

architecture Behavioral of memory1 is
	shared variable m1 : MEMORY := memory_content;
begin

	process_byte : process(i_clk) is
		variable t_row : std_logic_vector(ROWS_BITS-1 downto 0);
		variable t_col_block : std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
		variable t_col : std_logic_vector(WORD_BITS-1 downto 0);
		variable t_byte : std_logic_vector(BYTE_BITS-1 downto 0);
		variable v0 : std_logic_vector(BYTE_BITS-1 downto 0);
		variable v1 : std_logic_vector(BYTE_BITS-1 downto 0);
		variable v2 : std_logic_vector(BYTE_BITS-1 downto 0);
		variable v3 : std_logic_vector(BYTE_BITS-1 downto 0);
	begin
		if (rising_edge(i_clk)) then
			t_row := i_row;
			t_col := m1(to_integer(unsigned(t_row)));
			t_col_block := i_col_block;
			t_byte := i_byte;
			v0 := t_col((1*BYTE_BITS)-1 downto 0*BYTE_BITS);
			v1 := t_col((2*BYTE_BITS)-1 downto 1*BYTE_BITS);
			v2 := t_col((3*BYTE_BITS)-1 downto 2*BYTE_BITS);
			v3 := t_col((4*BYTE_BITS)-1 downto 3*BYTE_BITS);
			if (i_enable_byte = '1') then
				if (i_write_byte = '1') then
					case to_integer(unsigned(t_col_block)) is
						when 0 =>
							v0 := t_byte;
						when 1 =>
							v1 := t_byte;
						when 2 =>
							v2 := t_byte;
						when 3 =>
							v3 := t_byte;
						when others => null;
					end case;
					t_col := v3 & v2 & v1 & v0;
					m1(to_integer(unsigned(t_row))) := t_col;
					o_byte <= "ZZZZZZZZ";
				else
					case to_integer(unsigned(t_col_block)) is
						when 0 =>
							t_byte := v0;
						when 1 =>
							t_byte := v1;
						when 2 =>
							t_byte := v2;
						when 3 =>
							t_byte := v3;
						when others => null;
					end case;
					o_byte <= t_byte;
				end if;
			else
				o_byte <= "ZZZZZZZZ";
			end if;
		end if;
	end process process_byte;

	process_bit : process (i_clk) is
		variable t_row : std_logic_vector(ROWS_BITS-1 downto 0);
		variable t_col_pixel : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
		variable t_bit : std_logic;
		variable t_col : std_logic_vector(WORD_BITS-1 downto 0);
		variable v0 : std_logic_vector(BYTE_BITS-1 downto 0);
		variable v1 : std_logic_vector(BYTE_BITS-1 downto 0);
		variable v2 : std_logic_vector(BYTE_BITS-1 downto 0);
		variable v3 : std_logic_vector(BYTE_BITS-1 downto 0);
		variable t_col_p1 : integer range 0 to COLS_PIXEL_BITS-1;
		variable t_col_p2 : integer range 0 to BYTE_BITS-1;
	begin
		if (rising_edge(i_clk)) then
			t_row := i_row;
			t_col_pixel := i_col_pixel;
			t_bit := i_bit;
			t_col_p1 := to_integer(unsigned(t_col_pixel)) / BYTE_BITS;
			t_col_p2 := to_integer(unsigned(t_col_pixel)) mod BYTE_BITS;
			t_col := m1(to_integer(unsigned(t_row)));
			v0 := t_col((1*BYTE_BITS)-1 downto 0*BYTE_BITS);
			v1 := t_col((2*BYTE_BITS)-1 downto 1*BYTE_BITS);
			v2 := t_col((3*BYTE_BITS)-1 downto 2*BYTE_BITS);
			v3 := t_col((4*BYTE_BITS)-1 downto 3*BYTE_BITS);
			if (i_enable_bit = '1') then
				if (i_write_bit = '1') then
					case t_col_p1 is
						when 0 =>
							v0(t_col_p2) := t_bit;
						when 1 =>
							v1(t_col_p2) := t_bit;
						when 2 =>
							v2(t_col_p2) := t_bit;
						when 3 =>
							v3(t_col_p2) := t_bit;
						when others => null;
					end case;
					t_col := v3 & v2 & v1 & v0;
					m1(to_integer(unsigned(t_row))) := t_col;
					o_bit <= 'Z';
				else
					case t_col_p1 is
						when 0 =>
							t_bit := v0(t_col_p2);
						when 1 =>
							t_bit := v1(t_col_p2);
						when 2 =>
							t_bit := v2(t_col_p2);
						when 3 =>
							t_bit := v3(t_col_p2);
						when others => null;
					end case;
					o_bit <= t_bit;
				end if;
			else
				o_bit <= 'Z';
			end if;
		end if;
	end process process_bit;

end Behavioral;
