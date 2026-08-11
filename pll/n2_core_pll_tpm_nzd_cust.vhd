entity n2_core_pll_tpm_nzd_cust is
port (
vdd_reg : in bit;
q2b : in bit;
q4b : in bit;
q3b : in bit;
zero : out bit;
q1b : in bit;
q0b : in bit;
q5b : in bit
);
end entity n2_core_pll_tpm_nzd_cust;
architecture arch of n2_core_pll_tpm_nzd_cust is
component n2_core_pll_nand3_2x_cust is
port (
vdd_reg : in bit;
o : out bit;
in2 : in bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_nand3_2x_cust;
component n2_core_pll_inv_4x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_4x_cust;
component n2_core_pll_nor2_2x_cust is
port (
vdd_reg : in bit;
o : out bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_nor2_2x_cust;
signal net22,net28,net33 : bit;
begin
x2 : n2_core_pll_nand3_2x_cust port map (
vdd_reg => vdd_reg,
o => net28,
in2 => q2b,
in1 => q1b,
in0 => q0b
);
x3 : n2_core_pll_nand3_2x_cust port map (
vdd_reg => vdd_reg,
o => net33,
in2 => q5b,
in1 => q4b,
in0 => q3b
);
x0 : n2_core_pll_inv_4x_cust port map (
vdd_reg => vdd_reg,
o => zero,
i => net22
);
x1 : n2_core_pll_nor2_2x_cust port map (
vdd_reg => vdd_reg,
o => net22,
in1 => net33,
in0 => net28
);
end architecture arch;

