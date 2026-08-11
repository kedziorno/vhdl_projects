entity n2_core_pll_mux8_8x_cust is
port (
sel0 : in bit;
in2 : in bit;
sel2 : in bit;
sel5 : in bit;
in4 : in bit;
sel7 : in bit;
sel4 : in bit;
in1 : in bit;
dout : out bit;
in0 : in bit;
sel6 : in bit;
in5 : in bit;
in7 : in bit;
sel3 : in bit;
sel1 : in bit;
in3 : in bit;
in6 : in bit
);
end entity n2_core_pll_mux8_8x_cust;
architecture arch of n2_core_pll_mux8_8x_cust is
component mux8 is
generic (SIZE : integer := 1);
port (
dout : out bit_vector(SIZE-1 downto 0);
in0 : in bit_vector(SIZE-1 downto 0);
in1 : in bit_vector(SIZE-1 downto 0);
in2 : in bit_vector(SIZE-1 downto 0);
in3 : in bit_vector(SIZE-1 downto 0);
in4 : in bit_vector(SIZE-1 downto 0);
in5 : in bit_vector(SIZE-1 downto 0);
in6 : in bit_vector(SIZE-1 downto 0);
in7 : in bit_vector(SIZE-1 downto 0);
sel0 : in bit;
sel1 : in bit;
sel2 : in bit;
sel3 : in bit;
sel4 : in bit;
sel5 : in bit;
sel6 : in bit;
sel7 : in bit;
muxtst : in bit
);
end component mux8;
signal tin0,tin1,tin2,tin3,tin4,tin5,tin6,tin7,tdout : bit_vector(0 downto 0);
begin
dout <= tdout(0);
tin0(0) <= in0;
tin1(0) <= in1;
tin2(0) <= in2;
tin3(0) <= in3;
tin4(0) <= in4;
tin5(0) <= in5;
tin6(0) <= in6;
tin7(0) <= in7;
x1 : mux8
port map (
sel0 => sel0,
sel1 => sel1,
sel2 => sel2,
sel3 => sel3,
sel4 => sel4,
sel5 => sel5,
sel6 => sel6,
sel7 => sel7,
in0 => tin0,
in1 => tin1,
in2 => tin2,
in3 => tin3,
in4 => tin4,
in5 => tin5,
in6 => tin6,
in7 => tin7,
muxtst => '0',
dout => tdout
);
end architecture arch;
