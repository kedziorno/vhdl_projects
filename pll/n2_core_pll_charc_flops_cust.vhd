entity n2_core_pll_charc_flops_cust is
port (
data_in : in bit;
clk : in bit;
clk_l : in bit;
clk_rise1 : out bit;
clk_fall1 : out bit;
clk_rise2 : out bit;
clk_fall2 : out bit;
reset : in bit;
clk_rise4 : out bit;
clk_rise3 : out bit;
clk_fall3 : out bit;
clk_fall4 : out bit
);
end entity n2_core_pll_charc_flops_cust;
architecture arch of n2_core_pll_charc_flops_cust is
--supply1 vdd;
signal vdd : bit;
signal net200,net107,net205,net092,net191,net094,net193,net0186,net213,net116,net214,net88,net221,net227,net229,net130,net231,net233,net137,net235,net237,net239,net142,net241,net243,net245,net247,net149,net249,net151,net255,net256,net158,net257,net0193,net165,net265,net267,net268,net170,net172,net270,net177,net179,net100 : bit;
component n2_core_pll_flop_reset_new_1x_cust is
port (
vdd_reg : in bit;
reset_val_l : in bit;
d : in bit;
reset : in bit;
clk : in bit;
q_l : out bit;
q : out bit
);
end component n2_core_pll_flop_reset_new_1x_cust;
component n2_core_pll_bufi_4x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_bufi_4x_cust;
component n2_core_pll_buf_16x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_buf_16x_cust;
component n2_core_pll_flop_reset_new_cust is
port (
vdd_reg : in bit;
reset_val_l : in bit;
d : in bit;
reset : in bit;
clk : in bit;
q_l : out bit;
q : out bit
);
end component n2_core_pll_flop_reset_new_cust;
begin
vdd <= '1';
x2 : n2_core_pll_flop_reset_new_1x_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => data_in,
reset => net213,
clk => clk_l,
q_l => net172,
q => net170
);
x3 : n2_core_pll_flop_reset_new_1x_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => net233,
reset => net213,
clk => clk_l,
q_l => net165,
q => net0193
);
x4 : n2_core_pll_flop_reset_new_1x_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => net239,
reset => net213,
clk => clk_l,
q_l => net257,
q => net142
);
x5 : n2_core_pll_flop_reset_new_1x_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => net249,
reset => net213,
clk => clk,
q_l => net151,
q => net149
);
x6 : n2_core_pll_flop_reset_new_1x_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => net231,
reset => net213,
clk => clk,
q_l => net158,
q => net0186
);
x7 : n2_core_pll_flop_reset_new_1x_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => data_in,
reset => net213,
clk => clk,
q_l => net179,
q => net177
);
x8 : n2_core_pll_flop_reset_new_1x_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => data_in,
reset => net213,
clk => clk,
q_l => net267,
q => net100
);
x9 : n2_core_pll_flop_reset_new_1x_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => data_in,
reset => net213,
clk => clk_l,
q_l => net268,
q => net107
);
x10 : n2_core_pll_flop_reset_new_1x_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => net241,
reset => net213,
clk => clk_l,
q_l => net116,
q => net094
);
x11 : n2_core_pll_flop_reset_new_1x_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => net245,
reset => net213,
clk => clk,
q_l => net265,
q => net092
);
x12 : n2_core_pll_bufi_4x_cust port map (
vdd_reg => vdd,
o => net245,
i => net267
);
x13 : n2_core_pll_bufi_4x_cust port map (
vdd_reg => vdd,
o => net247,
i => net265
);
x14 : n2_core_pll_bufi_4x_cust port map (
vdd_reg => vdd,
o => net243,
i => net116
);
x15 : n2_core_pll_bufi_4x_cust port map (
vdd_reg => vdd,
o => net241,
i => net268
);
x17 : n2_core_pll_bufi_4x_cust port map (
vdd_reg => vdd,
o => net229,
i => net255
);
x18 : n2_core_pll_bufi_4x_cust port map (
vdd_reg => vdd,
o => net227,
i => net193
);
x19 : n2_core_pll_bufi_4x_cust port map (
vdd_reg => vdd,
o => net233,
i => net172
);
x20 : n2_core_pll_bufi_4x_cust port map (
vdd_reg => vdd,
o => net231,
i => net179
);
x21 : n2_core_pll_bufi_4x_cust port map (
vdd_reg => vdd,
o => net249,
i => net158
);
x22 : n2_core_pll_bufi_4x_cust port map (
vdd_reg => vdd,
o => net239,
i => net165
);
x23 : n2_core_pll_bufi_4x_cust port map (
vdd_reg => vdd,
o => net237,
i => net257
);
x24 : n2_core_pll_bufi_4x_cust port map (
vdd_reg => vdd,
o => net235,
i => net151
);
x33 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => net213,
i => reset
);
x34 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => net227,
reset => net213,
clk => clk_l,
q_l => net256,
q => clk_fall2
);
x35 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => net229,
reset => net213,
clk => clk,
q_l => net200,
q => clk_rise2
);
x37 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => data_in,
reset => net213,
clk => clk_l,
q_l => net214,
q => clk_fall1
);
x38 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => data_in,
reset => net213,
clk => clk,
q_l => net221,
q => clk_rise1
);
x41 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => net247,
reset => net213,
clk => clk,
q_l => net88,
q => clk_rise3
);
x42 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => net243,
reset => net213,
clk => clk_l,
q_l => net270,
q => clk_fall3
);
x49 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => net237,
reset => net213,
clk => clk_l,
q_l => net130,
q => clk_fall4
);
x50 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => net235,
reset => net213,
clk => clk,
q_l => net137,
q => clk_rise4
);
x0 : n2_core_pll_flop_reset_new_1x_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => data_in,
reset => net213,
clk => clk,
q_l => net255,
q => net205
);
x1 : n2_core_pll_flop_reset_new_1x_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => data_in,
reset => net213,
clk => clk_l,
q_l => net193,
q => net191
);
end architecture arch;

