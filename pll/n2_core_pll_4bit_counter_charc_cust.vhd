entity n2_core_pll_4bit_counter_charc_cust is
port (
clk : in bit;
reset : in bit;
cnt3 : in bit;
qout_0 : out bit;
qout_1 : out bit;
qout_2 : out bit;
qout_3 : out bit;
count_out : out bit;
cnt1 : in bit;
cnt2 : in bit;
cnt0 : in bit
);
end entity n2_core_pll_4bit_counter_charc_cust;
architecture arch of n2_core_pll_4bit_counter_charc_cust is
--supply1 vdd;
--vss = '0';
signal vdd,vss : bit;
signal net115,net88,net121,net127,sel,net133,nand_out,zero_0,zero_1,zero_2,zero_3,sel_b,din_0,din_1,din_2,din_3,next_0,next_1,next_2,next_3 : bit;
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
component n2_core_pll_tpm_muxa_cust is
port (
opb : out bit;
op : out bit;
d0 : in bit;
d1 : in bit;
sel : in bit;
sel_b : in bit
);
end component n2_core_pll_tpm_muxa_cust;
component n2_core_pll_inv_8x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_8x_cust;
component n2_core_pll_buf_8x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_buf_8x_cust;
component n2_core_pll_inv_4x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_4x_cust;
component n2_core_pll_nand4_4x_cust is
port (
in3 : in bit;
o : out bit;
in2 : in bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_nand4_4x_cust;
component n2_core_pll_4bit_counter_next_cust is
port (
q3 : in bit;
q0b : in bit;
q3b : in bit;
d3 : out bit;
q1b : in bit;
q2b : in bit;
d2 : out bit;
d0 : out bit;
q2 : in bit;
q0 : in bit;
q1 : in bit;
d1 : out bit
);
end component n2_core_pll_4bit_counter_next_cust;
signal tqout_0,tqout_1,tqout_2,tqout_3 : bit;
begin
vdd <= '1';
vss <= '0';
qout_0 <= tqout_0;
qout_1 <= tqout_1;
qout_2 <= tqout_2;
qout_3 <= tqout_3;
x2 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vss,
d => din_1,
reset => reset,
clk => clk,
q_l => tqout_1,
q => zero_1
);
x3 : n2_core_pll_tpm_muxa_cust port map (
opb => net127,
op => din_0,
d0 => next_0,
d1 => cnt0,
sel => sel,
sel_b => sel_b
);
x4 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vss,
d => din_2,
reset => reset,
clk => clk,
q_l => tqout_2,
q => zero_2
);
x5 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vss,
d => din_3,
reset => reset,
clk => clk,
q_l => tqout_3,
q => zero_3
);
x6 : n2_core_pll_tpm_muxa_cust port map (
opb => net133,
op => din_1,
d0 => next_1,
d1 => cnt1,
sel => sel,
sel_b => sel_b
);
x7 : n2_core_pll_tpm_muxa_cust port map (
opb => net121,
op => din_2,
d0 => next_2,
d1 => cnt2,
sel => sel,
sel_b => sel_b
);
x8 : n2_core_pll_tpm_muxa_cust port map (
opb => net115,
op => din_3,
d0 => next_3,
d1 => cnt3,
sel => sel,
sel_b => sel_b
);
x13 : n2_core_pll_inv_8x_cust port map (
vdd_reg => vdd,
o => sel,
i => nand_out
);
x14 : n2_core_pll_inv_8x_cust port map (
vdd_reg => vdd,
o => sel_b,
i => net88
);
x15 : n2_core_pll_buf_8x_cust port map (
vdd_reg => vdd,
o => count_out,
i => nand_out
);
x16 : n2_core_pll_inv_4x_cust port map (
vdd_reg => vdd,
o => net88,
i => nand_out
);
x18 : n2_core_pll_nand4_4x_cust port map (
in3 => tqout_3,
o => nand_out,
in2 => tqout_2,
in1 => tqout_1,
in0 => tqout_0
);
x0 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vss,
d => din_0,
reset => reset,
clk => clk,
q_l => tqout_0,
q => zero_0
);
x1 : n2_core_pll_4bit_counter_next_cust port map (
q3 => zero_3,
q0b => tqout_0,
q3b => tqout_3,
d3 => next_3,
q1b => tqout_1,
q2b => tqout_2,
d2 => next_2,
d0 => next_0,
q2 => zero_2,
q0 => zero_0,
q1 => zero_1,
d1 => next_1
);
end architecture arch;

