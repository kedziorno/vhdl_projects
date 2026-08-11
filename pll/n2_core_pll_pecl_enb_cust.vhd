entity n2_core_pll_pecl_enb_cust is
port (
i : in bit;
o : out bit;
enb1 : in bit;
enb0 : in bit
);
end entity n2_core_pll_pecl_enb_cust;
architecture arch of n2_core_pll_pecl_enb_cust is
--supply1 vdd;
signal net10,net12,net8 : bit;
signal vdd : bit;
component n2_core_pll_nand2_4x_cust is
port (
vdd_reg : in bit;
o : out bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_nand2_4x_cust;
component n2_core_pll_inv_16x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_16x_cust;
component cl_u1_nor2_2x is
port (
in0 : in bit;
in1 : in bit;
o : out bit
);
end component cl_u1_nor2_2x;
component cl_u1_inv_2x is
port (
i : in bit;
o : out bit
);
end component cl_u1_inv_2x;
begin
vdd <= '1';
x12 : n2_core_pll_nand2_4x_cust port map (
vdd_reg => vdd,
o => net8,
in1 => net10,
in0 => i
);
x22 : n2_core_pll_inv_16x_cust port map (
vdd_reg => vdd,
o => o,
i => net8
);
x0 : cl_u1_nor2_2x port map (
o => net12,
in1 => enb0,
in0 => enb1
);
x1 : cl_u1_inv_2x port map (
o => net10,
i => net12
);
end architecture arch;

