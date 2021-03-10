library ieee;
use ieee.std_logic_1164.all;

entity graycode is
generic (G_SIZE : integer);
port (
	reset : in std_logic;
	clk : in std_logic;
	enable : in std_logic;
	input : in std_logic_vector (G_SIZE-1 downto 0);
	output : out std_logic_vector (G_SIZE-1 downto 0)
);
end entity;

architecture rtl of graycode is

	signal count_i : std_logic_vector (G_SIZE-1 downto 0);

begin

	p0 : process (reset, clk)
	begin
		if (reset = '1') then
			count_i <= (others => '0');
		elsif (rising_edge(clk)) then
			if (enable = '1') then
				count_i(G_SIZE-1 downto 0) <= input(G_SIZE-1 downto 0) xor ('0' & input(G_SIZE-1 downto 1));
			else
				count_i <= count_i;
			end if;
		end if;
	end process;

	output <= count_i;

end architecture;

