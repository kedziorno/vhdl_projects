entity n2_core_pll_tpm_zd1_cust is
port (
vdd_reg : in bit;
zero1 : out bit;
zero1_b : out bit;
q4b : in bit;
q0b : in bit;
q1b : in bit;
q2b : in bit;
q3b : in bit;
q5b : in bit
);
end entity n2_core_pll_tpm_zd1_cust;
architecture arch of n2_core_pll_tpm_zd1_cust is
component n2_core_pll_nand2_2x_cust is
port (
vdd_reg : in bit;
o : out bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_nand2_2x_cust;
component n2_core_pll_nor2_4x_cust is
port (
vdd_reg : in bit;
o : out bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_nor2_4x_cust;
component n2_core_plllvt_nand2_16x_cust is
port (
vdd_reg : in bit;
o : out bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_plllvt_nand2_16x_cust;
component n2_core_pll_nand3_2x_cust is
port (
vdd_reg : in bit;
o : out bit;
in2 : in bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_nand3_2x_cust;
component n2_core_pll_inv_16x_a_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_16x_a_cust;
signal net28,net33,net38 : bit;
signal tzero1_b : bit;
begin
zero1_b <= tzero1_b;
x2 : n2_core_pll_nand2_2x_cust port map (
vdd_reg => vdd_reg,
o => net33,
in1 => q1b,
in0 => q2b
);
x3 : n2_core_pll_nor2_4x_cust port map (
vdd_reg => vdd_reg,
o => net28,
in1 => net33,
in0 => net38
);
x4 : n2_core_plllvt_nand2_16x_cust port map (
vdd_reg => vdd_reg,
o => tzero1_b,
in1 => q0b,
in0 => net28
);
x0 : n2_core_pll_nand3_2x_cust port map (
vdd_reg => vdd_reg,
o => net38,
in2 => q3b,
in1 => q4b,
in0 => q5b
);
x1 : n2_core_pll_inv_16x_a_cust port map (
vdd_reg => vdd_reg,
o => zero1,
i => tzero1_b
);
end architecture arch;

