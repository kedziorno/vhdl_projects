----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:05:12 05/01/2021 
-- Design Name: 
-- Module Name:    sram_row - Behavioral 
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

entity sram_row is
Generic (
	N : integer := 4
);
Port (
	i_we : in std_logic;
	i_oe : in std_logic;
	i_address_col : in std_logic_vector(N-1 downto 0);
	i_bit : in std_logic;
	o_bit : out std_logic
);
end sram_row;

architecture Behavioral of sram_row is
	signal sram_column : std_logic_vector(2**N-1 downto 0);
	signal address_col : std_logic_vector(N-1 downto 0);

--	signal bufi,bufo : std_logic;
	signal we,oe,ibit : std_logic;
--	attribute keep : string;
--	attribute keep of sram_column : signal is "true";

begin
	we <= i_we;
	oe <= i_oe;
	address_col <= i_address_col;
	ibit <= i_bit;
--BUFG_inst1 : BUFG port map (O => bufi,I => i_tristate_input);
--BUFG_inst2 : BUFG port map (O => bufo,I => i_tristate_output);
--	bufi <= not (not i_tristate_input);
--	bufo <= not (not i_tristate_output);
--	sram_column_generate : for i in sram_column'range generate
--		sram_column(i) <= i_bit when (i=to_integer(unsigned(i_address_col)) and rising_edge(i_tristate_input));
--	end generate sram_column_generate;
--	sram_column(to_integer(unsigned(i_address_col))) <= i_bit when falling_edge(bufi);
--	o_bit <= sram_column(to_integer(unsigned(i_address_col))) when falling_edge(bufo);
--	sram_column(to_integer(unsigned(i_address_col))) <= ibit when we='1' and oe = '0';
--	p0 : process (we,oe,i_bit,sram_column,address_col) is
--	begin
--		if (we = '1' and oe = '0') then
--			sram_column(to_integer(unsigned(address_col))) <= i_bit;
--		elsif (oe = '1' and we = '0') then
--			o_bit <= sram_column(to_integer(unsigned(address_col)));
--		else
--			sram_column(to_integer(unsigned(address_col))) <= sram_column(to_integer(unsigned(address_col)));
--		end if;
--	end process p0;

--	p0 : process (sram_column,address_col,ibit) is
--	begin
--		l0 : for i in 0 to 2**N-1 loop
--			if (i=to_integer(unsigned(address_col))) then
--				sram_column(i) <= ibit;
--			end if;
--		end loop l0;
--	end process p0;

	p0 : process (sram_column,address_col,ibit,we) is
		variable index : integer range 0 to 2**N-1;
	begin
		index := to_integer(unsigned(address_col));
			sram_column(index) <= sram_column(index);
			if (we = '0') then
				sram_column(index) <= sram_column(index);
		elsif (we = '1') then
			sram_column(index) <= ibit;
		end if;
	end process p0;

	p1 : process (sram_column,address_col,ibit,oe) is
		variable index : integer range 0 to 2**N-1;
	begin
		index := to_integer(unsigned(address_col));
		o_bit <= '0';
		l0 : for i in 0 to 2**N-1 loop
			if (i=index) then
				if (oe = '1') then
					o_bit <= sram_column(i);
				end if;
			end if;
		end loop l0;
	end process p1;

--	o_bit <= sram_column(to_integer(unsigned(i_address_col)));

--	g0 : for i in 0 to 2**N-1 generate
--		LDCE_inst : LDCE
--		generic map (INIT=>'0')
--		port map (Q=>sram_column1(i),CLR=>'0',D=>sram_column(i),G=>'1',GE=>'1');
--	end generate g0;

end Behavioral;
