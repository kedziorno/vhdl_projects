library ieee;
use ieee.std_logic_1164.all;

-- https://semiwiki.com/fpga/6129-pseudo-random-generator-tutorial-in-vhdl-part-1-3/

entity lfsr1 is
generic (G_SIZE : integer);
port (
	reset : in std_logic;
	clk : in std_logic;
	enable : in std_logic;
	count : out std_logic_vector (G_SIZE-1 downto 0) -- lfsr output
);
end entity;

architecture rtl of lfsr1 is
	
	signal count_i : std_logic_vector (G_SIZE-1 downto 0);
	signal feedback : std_logic;

begin

	feedback <= not(count_i(G_SIZE-1) xor count_i(G_SIZE-2)); -- LFSR size 4

	process (reset, clk)
	begin
		if (reset = '1') then
			count_i <= (others => '0');
		elsif (rising_edge(clk)) then
			if (enable = '1') then
				count_i <= count_i(G_SIZE-2 downto 0) & feedback;
			else
				count_i <= count_i;
			end if;
		end if;
	end process;

	count <= count_i;

end architecture;
