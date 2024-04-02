entity n2_core_pll_mux2_8x_cust is
port (
in0 : in bit;
sel0 : in bit;
dout : out bit;
sel1 : in bit;
in1 : in bit
);
end entity n2_core_pll_mux2_8x_cust;
architecture arch of n2_core_pll_mux2_8x_cust is
component mux2 is
port (
in0,in1,sel0,sel1 : in bit;
y : out bit
);
end component mux2;
begin
x1 : mux2
port map (
sel0 => sel0,
sel1 => sel1,
in0 => in0,
in1 => in1,
y => dout
);
end architecture arch;

