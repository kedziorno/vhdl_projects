----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:47:11 05/02/2021 
-- Design Name: 
-- Module Name:    sram_cell - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity sram_cell is
Generic (
	N : integer := 4
);
Port (
	i_ce : in std_logic;
	i_we : in std_logic;
	i_oe : in std_logic;
	i_address_row : in std_logic_vector(N-1 downto 0);
	i_address_col : in std_logic_vector(N-1 downto 0);
	i_bit : in std_logic;
	o_bit : out std_logic
);
end sram_cell;

architecture Behavioral of sram_cell is

	component sram_row is
	Generic (
		N : integer
	);
	Port (
		i_ce : in std_logic;
		i_we : in std_logic;
		i_oe : in std_logic;
		i_address_col : in std_logic_vector(N-1 downto 0);
		i_bit : in std_logic;
		o_bit : out std_logic
	);
	end component sram_row;

	signal tristate_input,tristate_output : std_logic_vector(15 downto 0);
	signal ibit,obit : std_logic_vector(15 downto 0);

	signal bufi1,bufi2 : std_logic;
	signal bufo1,bufo2 : std_logic;
begin

	LDCPE_bufi1 : LDCPE port map (
	Q => bufi1,
	D => i_we,
	GE => i_ce,
	G => '1',
	CLR => '0',
	PRE => '0');
	LDCPE_bufi2 : LDCPE port map (
	Q => bufi2,
	D => bufi1,
	GE => i_ce,
	G => '1',
	CLR => not i_ce,
	PRE => '0');

	LDCPE_bufo1 : LDCPE port map (
	Q => bufo1,
	D => i_oe,
	GE => i_ce,
	G => '1',
	CLR => '0',
	PRE => '0');
	LDCPE_bufo2 : LDCPE port map (
	Q => bufo2,
	D => bufo1,
	GE => i_ce,
	G => '1',
	CLR => not i_ce,
	PRE => '0');

	sram_row_generate : for i in 0 to 15 generate
		sram_col : sram_row Generic map (n=>4) Port map (
			i_ce=>i_ce,
			i_we=>i_we,
			i_oe=>i_oe,
			i_address_col=>i_address_col,
			i_bit=>ibit(i),
			o_bit=>obit(i)
		);
	end generate sram_row_generate;

	sh : for i in 0 to 15 generate
		tristate_input(i) <= '1' when (i=to_integer(unsigned(i_address_row)) and bufi2='1') else '0';
	end generate sh;
--	tristate_input(to_integer(unsigned(i_address_row))) <= '1' when i_tristate_input='1' else '0';

	si : for i in 0 to 15 generate
		tristate_output(i) <= '1' when (i=to_integer(unsigned(i_address_row)) and bufo2='1') else '0';
	end generate si;
--	tristate_output(to_integer(unsigned(i_address_row))) <= '1' when i_tristate_output='1' else '0';

	sj : for i in 0 to 15 generate
--		ibit(i) <= i_bit when (i=to_integer(unsigned(i_address_row)) and i_tristate_input='1');
		ibit(i) <= i_bit when (i=to_integer(unsigned(i_address_row)) and falling_edge(bufi2));
	end generate sj;

	o_bit <= obit(to_integer(unsigned(i_address_row))) when rising_edge(bufo2);

end Behavioral;
