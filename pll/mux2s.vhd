entity mux2s is
generic (SIZE : integer := 1);
port (
dout : out bit_vector(SIZE-1 downto 0);
in0 : in bit_vector(SIZE-1 downto 0);
in1 : in bit_vector(SIZE-1 downto 0);
sel0 : in bit;
sel1 : in bit
);
end entity mux2s;
architecture arch of mux2s is
signal tdout : bit_vector(SIZE-1 downto 0);
begin
dout <= tdout;
tdout <= in0 when sel0 = '1' else in1 when sel1 = '1';
--assign dout = ( ( in0 & { SIZE { sel0 } } ) | ( in1 & { SIZE { sel1 } } ) );
end architecture arch;

