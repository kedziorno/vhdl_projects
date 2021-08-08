entity n2_core_pll_charc_mux_cust is
port (
clk_fall2 : in bit;
clk_fall3 : in bit;
clk_fall4 : in bit;
clk_fall1 : in bit;
clk_rise3 : in bit;
clk_rise2 : in bit;
clk_rise4 : in bit;
clk_rise1 : in bit;
mux_out1 : out bit;
mux_out2 : out bit;
a3a4 : in bit_vector(3 downto 0);
aoa1a2 : in bit_vector(7 downto 0)
);
end entity n2_core_pll_charc_mux_cust;
architecture arch of n2_core_pll_charc_mux_cust is
signal mux_in,mux_in1 : bit_vector(7 downto 0);
component n2_core_pll_mux4_8x_cust is
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
end component n2_core_pll_mux4_8x_cust;
component n2_core_pll_mux8_8x_cust is
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
end component n2_core_pll_mux8_8x_cust;
begin
x18 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_fall1,
in3 => clk_rise2,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in(0),
in0 => clk_rise1,
in1 => clk_rise1
);
x19 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_rise1,
in3 => clk_rise1,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in1(0),
in0 => clk_fall1,
in1 => clk_rise2
);
x20 : n2_core_pll_mux8_8x_cust port map (
sel0 => aoa1a2(0),
in2 => mux_in(2),
sel2 => aoa1a2(2),
sel5 => aoa1a2(5),
in4 => mux_in(4),
sel7 => aoa1a2(7),
sel4 => aoa1a2(4),
in1 => mux_in(1),
dout => mux_out1,
in0 => mux_in(0),
sel6 => aoa1a2(6),
in5 => mux_in(5),
in7 => mux_in(7),
sel3 => aoa1a2(3),
sel1 => aoa1a2(1),
in3 => mux_in(3),
in6 => mux_in(6)
);
x21 : n2_core_pll_mux8_8x_cust port map (
sel0 => aoa1a2(0),
in2 => mux_in1(2),
sel2 => aoa1a2(2),
sel5 => aoa1a2(5),
in4 => mux_in1(4),
sel7 => aoa1a2(7),
sel4 => aoa1a2(4),
in1 => mux_in1(1),
dout => mux_out2,
in0 => mux_in1(0),
sel6 => aoa1a2(6),
in5 => mux_in1(5),
in7 => mux_in1(7),
sel3 => aoa1a2(3),
sel1 => aoa1a2(1),
in3 => mux_in1(3),
in6 => mux_in1(6)
);
x22 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_rise2,
in3 => clk_fall2,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in(1),
in0 => clk_fall1,
in1 => clk_fall1
);
x23 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_fall2,
in3 => clk_rise3,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in(2),
in0 => clk_rise2,
in1 => clk_rise2
);
x24 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_rise3,
in3 => clk_fall3,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in(3),
in0 => clk_fall2,
in1 => clk_fall2
);
x25 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_fall3,
in3 => clk_rise4,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in(4),
in0 => clk_rise3,
in1 => clk_rise3
);
x26 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_rise4,
in3 => clk_fall4,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in(5),
in0 => clk_fall3,
in1 => clk_fall3
);
x27 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_fall4,
in3 => clk_rise1,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in(6),
in0 => clk_rise4,
in1 => clk_rise4
);
x28 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_rise1,
in3 => clk_fall1,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in(7),
in0 => clk_fall4,
in1 => clk_fall4
);
x29 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_fall1,
in3 => clk_fall1,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in1(1),
in0 => clk_rise2,
in1 => clk_fall2
);
x30 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_rise2,
in3 => clk_rise2,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in1(2),
in0 => clk_fall2,
in1 => clk_rise3
);
x31 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_fall2,
in3 => clk_fall2,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in1(3),
in0 => clk_rise3,
in1 => clk_fall3
);
x32 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_rise3,
in3 => clk_rise3,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in1(4),
in0 => clk_fall3,
in1 => clk_rise4
);
x33 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_fall3,
in3 => clk_fall3,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in1(5),
in0 => clk_rise4,
in1 => clk_fall4
);
x34 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_rise4,
in3 => clk_rise4,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in1(6),
in0 => clk_fall4,
in1 => clk_rise1
);
x35 : n2_core_pll_mux4_8x_cust port map (
sel2 => a3a4(2),
sel3 => a3a4(3),
in2 => clk_fall4,
in3 => clk_fall4,
sel0 => a3a4(0),
sel1 => a3a4(1),
dout => mux_in1(7),
in0 => clk_rise1,
in1 => clk_fall1
);
end architecture arch;


