entity n2_core_pll_tpm_cust is
port (
reset : in bit;
ip : in bit_vector(5 downto 0);
vdd_reg : in bit;
op : out bit_vector(5 downto 0);
sel : out bit;
div_ck_i : in bit;
pwr_rst : in bit;
div_ck : out bit;
vco_ck : in bit
);
end entity n2_core_pll_tpm_cust;
architecture arch of n2_core_pll_tpm_cust is
--vss = '0';
signal vdd,vss : bit;
signal net183,nz_2,net201,net282,nz_3,nz_4,nz_5,net186,net205,net189,f4q,f5d,net195,vco_ckb,vco_ckd,net198,f5q,net219,f_gate,r_gate,reset_d,net235,zero_0,net236,zero_1,zero_2,f0d,zero_3,zero_4,zero_5,sel_b,f0q,net147,f1d,not_zero,net252,net256,net159,f1q,f2d,nzero_0,nzero_1,net162,nzero_2,nzero_3,nzero_4,nzero_5,f2q,next0,next1,next2,next3,f3d,next4,next5,net171,nip0,nip1,nip2,nip3,nip4,nip5,net0501,f3q,net0502,net0503,net0504,f4d,net0505,net0506,nz_0,nz_1 : bit;
signal tsel : bit;
component n2_core_pll_buf_4x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_buf_4x_cust;
component n2_core_pll_buf_16x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_buf_16x_cust;
component n2_core_pll_tpm_mux_cust is
port (
opb : out bit;
vdd_reg : in bit;
op : out bit;
d0 : in bit;
d1 : in bit;
sel : in bit;
sel_b : in bit
);
end component n2_core_pll_tpm_mux_cust;
component n2_core_pll_buf_8x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_buf_8x_cust;
component n2_core_pll_inv_8x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_8x_cust;
component n2_core_pll_tpm_next_new_cust is
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
end component n2_core_pll_tpm_next_new_cust;
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
component n2_core_pll_inv_32x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_32x_cust;
component n2_core_pll_tpm_zd1_cust is
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
end component n2_core_pll_tpm_zd1_cust;
component n2_core_pll_tpm_nzd_cust is
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
end component n2_core_pll_tpm_nzd_cust;
component n2_core_pll_tpm_gate_new_cust is
port (
r_b : in bit;
vdd_reg : in bit;
div_ck : out bit;
r : in bit;
ck : in bit;
f : in bit
);
end component n2_core_pll_tpm_gate_new_cust;
component n2_core_pll_inv_4x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_4x_cust;
begin
vss <= '0';
sel <= tsel;
x2 : n2_core_pll_buf_4x_cust port map (
vdd_reg => vdd_reg,
o => net205,
i => ip(0)
);
x4 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd_reg,
o => reset_d,
i => reset
);
x5 : n2_core_pll_tpm_mux_cust port map (
opb => nzero_0,
vdd_reg => vdd_reg,
op => nz_0,
d0 => ip(0),
d1 => nip0,
sel => net256,
sel_b => net282
);
x6 : n2_core_pll_buf_8x_cust port map (
vdd_reg => vdd_reg,
o => net282,
i => pwr_rst
);
x7 : n2_core_pll_inv_8x_cust port map (
vdd_reg => vdd_reg,
o => net256,
i => pwr_rst
);
x8 : n2_core_pll_buf_4x_cust port map (
vdd_reg => vdd_reg,
o => net183,
i => ip(1)
);
x9 : n2_core_pll_buf_4x_cust port map (
vdd_reg => vdd_reg,
o => net195,
i => ip(2)
);
x10 : n2_core_pll_buf_4x_cust port map (
vdd_reg => vdd_reg,
o => net159,
i => ip(3)
);
x11 : n2_core_pll_buf_4x_cust port map (
vdd_reg => vdd_reg,
o => net147,
i => ip(4)
);
x12 : n2_core_pll_buf_4x_cust port map (
vdd_reg => vdd_reg,
o => net171,
i => ip(5)
);
x13 : n2_core_pll_buf_8x_cust port map (
vdd_reg => vdd_reg,
o => op(0),
i => nip0
);
x14 : n2_core_pll_buf_8x_cust port map (
vdd_reg => vdd_reg,
o => op(1),
i => nip1
);
x15 : n2_core_pll_buf_8x_cust port map (
vdd_reg => vdd_reg,
o => op(2),
i => nip2
);
x16 : n2_core_pll_tpm_next_new_cust port map (
vdd_reg => vdd_reg,
d5 => next5,
q0b => zero_0,
q3b => zero_3,
d3 => next3,
q5b => zero_5,
q1b => zero_1,
q2b => zero_2,
d2 => next2,
d0 => next0,
d4 => next4,
q2 => f2q,
q0 => f0q,
q1 => f1q,
d1 => next1,
q4b => zero_4
);
x17 : n2_core_pll_tpm_mux_cust port map (
opb => nzero_1,
vdd_reg => vdd_reg,
op => nz_1,
d0 => ip(1),
d1 => nip1,
sel => net256,
sel_b => net282
);
x18 : n2_core_pll_buf_8x_cust port map (
vdd_reg => vdd_reg,
o => op(3),
i => nip3
);
x19 : n2_core_pll_buf_8x_cust port map (
vdd_reg => vdd_reg,
o => op(4),
i => nip4
);
x20 : n2_core_pll_buf_8x_cust port map (
vdd_reg => vdd_reg,
o => op(5),
i => nip5
);
x23 : n2_core_pll_tpm_mux_cust port map (
opb => nzero_2,
vdd_reg => vdd_reg,
op => nz_2,
d0 => ip(2),
d1 => nip2,
sel => net256,
sel_b => net282
);
x24 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd_reg,
reset_val_l => vdd_reg,
d => net205,
reset => reset_d,
clk => div_ck_i,
q_l => net201,
q => nip0
);
x25 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd_reg,
reset_val_l => vdd_reg,
d => net183,
reset => reset_d,
clk => div_ck_i,
q_l => net186,
q => nip1
);
x27 : n2_core_pll_tpm_mux_cust port map (
opb => nzero_3,
vdd_reg => vdd_reg,
op => nz_3,
d0 => ip(3),
d1 => nip3,
sel => net256,
sel_b => net282
);
x28 : n2_core_pll_tpm_mux_cust port map (
opb => nzero_4,
vdd_reg => vdd_reg,
op => nz_4,
d0 => ip(4),
d1 => nip4,
sel => net256,
sel_b => net282
);
x29 : n2_core_pll_tpm_mux_cust port map (
opb => nzero_5,
vdd_reg => vdd_reg,
op => nz_5,
d0 => ip(5),
d1 => nip5,
sel => net256,
sel_b => net282
);
x30 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd_reg,
reset_val_l => vdd_reg,
d => net195,
reset => reset_d,
clk => div_ck_i,
q_l => net198,
q => nip2
);
x31 : n2_core_pll_inv_32x_cust port map (
vdd_reg => vdd_reg,
o => vco_ckd,
i => net252
);
x32 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd_reg,
reset_val_l => vdd_reg,
d => net159,
reset => reset_d,
clk => div_ck_i,
q_l => net162,
q => nip3
);
x33 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd_reg,
reset_val_l => vdd_reg,
d => net147,
reset => reset_d,
clk => div_ck_i,
q_l => net235,
q => nip4
);
x34 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd_reg,
reset_val_l => vdd_reg,
d => net171,
reset => reset_d,
clk => div_ck_i,
q_l => net236,
q => nip5
);
x35 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd_reg,
reset_val_l => vdd_reg,
d => f0d,
reset => reset_d,
clk => vco_ckd,
q_l => zero_0,
q => f0q
);
x36 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd_reg,
reset_val_l => vdd_reg,
d => f1d,
reset => reset_d,
clk => vco_ckd,
q_l => zero_1,
q => f1q
);
x37 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd_reg,
reset_val_l => vdd_reg,
d => f2d,
reset => reset_d,
clk => vco_ckd,
q_l => zero_2,
q => f2q
);
x38 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd_reg,
reset_val_l => vdd_reg,
d => f3d,
reset => reset_d,
clk => vco_ckd,
q_l => zero_3,
q => f3q
);
x39 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd_reg,
reset_val_l => vdd_reg,
d => f4d,
reset => reset_d,
clk => vco_ckd,
q_l => zero_4,
q => f4q
);
x40 : n2_core_pll_tpm_zd1_cust port map (
vdd_reg => vdd_reg,
zero1 => tsel,
zero1_b => sel_b,
q4b => zero_4,
q0b => zero_0,
q1b => zero_1,
q2b => zero_2,
q3b => zero_3,
q5b => zero_5
);
x41 : n2_core_pll_inv_8x_cust port map (
vdd_reg => vdd_reg,
o => net252,
i => vco_ck
);
x42 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd_reg,
reset_val_l => vdd_reg,
d => f5d,
reset => reset_d,
clk => vco_ckd,
q_l => zero_5,
q => f5q
);
x43 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd_reg,
reset_val_l => vss,
d => tsel,
reset => reset_d,
clk => vco_ckb,
q_l => net219,
q => r_gate
);
x44 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd_reg,
reset_val_l => vdd_reg,
d => not_zero,
reset => reset_d,
clk => vco_ckd,
q_l => net189,
q => f_gate
);
x47 : n2_core_pll_tpm_mux_cust port map (
opb => net0506,
vdd_reg => vdd_reg,
op => f0d,
d0 => next0,
d1 => nz_0,
sel => tsel,
sel_b => sel_b
);
x48 : n2_core_pll_tpm_mux_cust port map (
opb => net0505,
vdd_reg => vdd_reg,
op => f1d,
d0 => next1,
d1 => nz_1,
sel => tsel,
sel_b => sel_b
);
x49 : n2_core_pll_tpm_nzd_cust port map (
vdd_reg => vdd_reg,
q2b => nzero_2,
q4b => nzero_4,
q3b => nzero_3,
zero => not_zero,
q1b => nzero_1,
q0b => nzero_0,
q5b => nzero_5
);
x50 : n2_core_pll_tpm_mux_cust port map (
opb => net0504,
vdd_reg => vdd_reg,
op => f2d,
d0 => next2,
d1 => nz_2,
sel => tsel,
sel_b => sel_b
);
x51 : n2_core_pll_tpm_mux_cust port map (
opb => net0503,
vdd_reg => vdd_reg,
op => f3d,
d0 => next3,
d1 => nz_3,
sel => tsel,
sel_b => sel_b
);
x52 : n2_core_pll_tpm_mux_cust port map (
opb => net0502,
vdd_reg => vdd_reg,
op => f4d,
d0 => next4,
d1 => nz_4,
sel => tsel,
sel_b => sel_b
);
x53 : n2_core_pll_tpm_mux_cust port map (
opb => net0501,
vdd_reg => vdd_reg,
op => f5d,
d0 => next5,
d1 => nz_5,
sel => tsel,
sel_b => sel_b
);
x0 : n2_core_pll_tpm_gate_new_cust port map (
r_b => net219,
vdd_reg => vdd_reg,
div_ck => div_ck,
r => r_gate,
ck => vco_ck,
f => f_gate
);
x1 : n2_core_pll_inv_4x_cust port map (
vdd_reg => vdd_reg,
o => vco_ckb,
i => vco_ckd
);
end architecture arch;

