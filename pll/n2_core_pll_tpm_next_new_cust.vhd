entity n2_core_pll_tpm_next_new_cust is
port (
vdd_reg : in bit;
d5 : out bit;
q0b : in bit;
q3b : in bit;
d3 : out bit;
q5b : in bit;
q1b : in bit;
q2b : in bit;
d2 : out bit;
d0 : out bit;
d4 : out bit;
q2 : in bit;
q0 : in bit;
q1 : in bit;
d1 : out bit;
q4b : in bit
);
end entity n2_core_pll_tpm_next_new_cust;
architecture arch of n2_core_pll_tpm_next_new_cust is
component n2_core_pll_xnor2_4x_new_cust is
port (
vdd_reg : in bit;
o : out bit;
in0 : in bit;
in1 : in bit
);
end component n2_core_pll_xnor2_4x_new_cust;
component n2_core_pll_nand2_2x_cust is
port (
vdd_reg : in bit;
o : out bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_nand2_2x_cust;
component n2_core_pll_nor2_2x_cust is
port (
vdd_reg : in bit;
o : out bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_nor2_2x_cust;
component n2_core_pll_nand3_2x_cust is
port (
vdd_reg : in bit;
o : out bit;
in2 : in bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_nand3_2x_cust;
component n2_core_pll_nor3_2x_cust is
port (
vdd_reg : in bit;
o  : out bit;
in2 : in bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_nor3_2x_cust;
signal net73,net76,net091,net0115,net53,net55,net64,net69 : bit;
begin
x2 : n2_core_pll_xnor2_4x_new_cust port map (
vdd_reg => vdd_reg,
o => d1,
in0 => q1b,
in1 => q0b
);
x3 : n2_core_pll_xnor2_4x_new_cust port map (
vdd_reg => vdd_reg,
o => d2,
in0 => q2b,
in1 => net76
);
x4 : n2_core_pll_xnor2_4x_new_cust port map (
vdd_reg => vdd_reg,
o => d3,
in0 => q3b,
in1 => net73
);
x5 : n2_core_pll_nand2_2x_cust port map (
vdd_reg => vdd_reg,
o => net53,
in1 => q1b,
in0 => q0b
);
x6 : n2_core_pll_nor2_2x_cust port map (
vdd_reg => vdd_reg,
o => net76,
in1 => q1,
in0 => q0
);
x7 : n2_core_pll_nor2_2x_cust port map (
vdd_reg => vdd_reg,
o => net55,
in1 => net64,
in0 => net53
);
x8 : n2_core_pll_xnor2_4x_new_cust port map (
vdd_reg => vdd_reg,
o => d4,
in0 => q4b,
in1 => net69
);
x9 : n2_core_pll_xnor2_4x_new_cust port map (
vdd_reg => vdd_reg,
o => d5,
in0 => q5b,
in1 => net55
);
x13 : n2_core_pll_nand3_2x_cust port map (
vdd_reg => vdd_reg,
o => net64,
in2 => q4b,
in1 => q3b,
in0 => q2b
);
x14 : n2_core_pll_nand2_2x_cust port map (
vdd_reg => vdd_reg,
o => net0115,
in1 => q1b,
in0 => q0b
);
x15 : n2_core_pll_nand2_2x_cust port map (
vdd_reg => vdd_reg,
o => net091,
in1 => q3b,
in0 => q2b
);
x16 : n2_core_pll_nor2_2x_cust port map (
vdd_reg => vdd_reg,
o => net69,
in1 => net091,
in0 => net0115
);
x0 : n2_core_pll_nor3_2x_cust port map (
vdd_reg => vdd_reg,
o => net73,
in2 => q2,
in1 => q1,
in0 => q0
);
x1 : n2_core_pll_xnor2_4x_new_cust port map (
vdd_reg => vdd_reg,
o => d0,
in0 => q0b,
in1 => vdd_reg
);
end architecture arch;

