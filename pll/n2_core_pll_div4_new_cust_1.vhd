entity n2_core_pll_div4_new_cust is
port (
clk : in bit;
arst_l : in bit;
clk_div_out : out bit
);
end entity n2_core_pll_div4_new_cust;
architecture arch of n2_core_pll_div4_new_cust is
--supply1 vdd;
signal div4_l,clk_div,n1,n2,n3,n4,net19,net038,net26,net33,clk_div_l,div2_l : bit;
begin
x2 : n2_core_pll_inv_8x_cust port map (
vdd_reg => vdd,
o => clk_div_l,
i => clk_div
);
x3 : cl_u1_inv_4x port map (
o => net038,
i => arst_l
);
x4 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => n2,
reset => net038,
clk => clk,
q_l => div2_l,
q => net33
);
x5 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => n4,
reset => net038,
clk => div2_l,
q_l => div4_l,
q => net26
);
x6 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => div4_l,
reset => net038,
clk => clk,
q_l => clk_div,
q => net19
);
x9 : n2_core_pll_buf_2x_cust port map (
vdd_reg => vdd,
o => n2,
i => n1
);
x10 : n2_core_pll_buf_2x_cust port map (
vdd_reg => vdd,
o => n3,
i => div4_l
);
x11 : n2_core_pll_buf_2x_cust port map (
vdd_reg => vdd,
o => n4,
i => n3
);
x0 : n2_core_pll_buf_2x_cust port map (
vdd_reg => vdd,
o => n1,
i => div2_l
);
x1 : n2_core_pll_inv_32x_cust port map (
vdd_reg => vdd,
o => clk_div_out,
i => clk_div_l
);
end architecture arch;

