entity n2_core_pll_mux4_8x_cust is
port (
sel2 : in bit;
sel3 : in bit;
in2 : in bit;
in3 : in bit;
sel0 : in bit;
sel1 : in bit;
dout : out bit;
in0 : in bit;
in1 : in bit
);
end entity n2_core_pll_mux4_8x_cust;
architecture arch of n2_core_pll_mux4_8x_cust is
component mux4 is
generic (SIZE : integer := 1);
port (
dout : out bit_vector(SIZE-1 downto 0);
in0 : in bit_vector(SIZE-1 downto 0);
in1 : in bit_vector(SIZE-1 downto 0);
in2 : in bit_vector(SIZE-1 downto 0);
in3 : in bit_vector(SIZE-1 downto 0);
sel0 : in bit;
sel1 : in bit;
sel2 : in bit;
sel3 : in bit;
muxtst : in bit
);
end component mux4;
signal tin0,tin1,tin2,tin3,tdout : bit_vector(0 downto 0);
begin
tin0(0) <= in0;
tin1(0) <= in1;
tin2(0) <= in2;
tin3(0) <= in3;
dout <= tdout(0);
x1 : mux4 port map (
in0 => tin0,
in1 => tin1,
in2 => tin2,
in3 => tin3,
sel0 => sel0,
sel1 => sel1,
sel2 => sel2,
sel3 => sel3,
muxtst => '0', 
dout => tdout
);
end architecture arch;

