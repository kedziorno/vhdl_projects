entity n2_core_pll_byp_enb_cust is
port (
sel1 : in bit;
in1 : in bit;
out1 : out bit;
out0 : out bit;
in0 : in bit;
sel0 : in bit
);
end entity n2_core_pll_byp_enb_cust;
architecture arch of n2_core_pll_byp_enb_cust is
--supply1 vdd;
signal vss,vdd : bit;
signal net11,net8 : bit;
component n2_core_pll_inv_8x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_8x_cust;
component n2_core_pll_nand2_2x_cust is
port (
vdd_reg : in bit;
o : out bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_nand2_2x_cust;
begin
vdd <= '1';
vss <= '0';
x4 : n2_core_pll_inv_8x_cust port map (
vdd_reg => vdd,
o => out1,
i => net8
);
x8 : n2_core_pll_nand2_2x_cust port map (
vdd_reg => vdd,
o => net11,
in1 => sel0,
in0 => in0
);
x10 : n2_core_pll_nand2_2x_cust port map (
vdd_reg => vdd,
o => net8,
in1 => sel1,
in0 => in1
);
x11 : n2_core_pll_inv_8x_cust port map (
vdd_reg => vdd,
o => out0,
i => net11
);
end architecture arch;

