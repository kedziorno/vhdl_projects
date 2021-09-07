entity n2_core_pll_charc_cust is
port (
arst_l : in bit;
ccu_rst_ref_buf2_l : out bit;
testmode : in bit;
dr_clk_out : in bit;
ccu_rst_sys_clk : out bit;
lock : in bit;
pll_charc_out : out bit_vector(1 downto 0);
fb_clk_l : in bit;
pll_charc_in : in bit;
ref_clk_l : in bit;
fast : in bit;
slow : in bit;
ref : in bit;
fb : in bit;
vco_clk : in bit;
l1clk : in bit
);
end entity n2_core_pll_charc_cust;
architecture arch of n2_core_pll_charc_cust is
--supply1 vdd;
signal vdd,vss : bit;
signal aoa1a2 : bit_vector(7 downto 0);
signal mxin : bit_vector(9 downto 0);
signal a3a4 : bit_vector(3 downto 0);
signal ta5 : bit_vector(1 downto 0);
signal mxbuf : bit_vector(9 downto 0);
signal out_bot,mux_out1,mux_out2,net76,net77,clk_fall1,clk_fall2,clk_fall3,clk_fall4,
net224,out_top,net227,net238,reset,net0232,a5,a0,l1clk_vcoclk,a1,a2,a3,net251,a4,net252,
a6_0,out_cnt1,a6,a6_1,a7,l1clk_vcoclk_l,net169,clk_rise1,clk_rise2,clk_rise3,clk_rise4,
net174,l1clk_vco_clk,l1clk_vcoclk_div4 : bit;
component n2_core_pll_div4_new_cust is
port (
clk : in bit;
arst_l : in bit;
clk_div_out : out bit
);
end component n2_core_pll_div4_new_cust;
component n2_core_pll_charc_decoder_cust is
port (
a5_out : out bit_vector(1 downto 0);
a6_out : out bit_vector(1 downto 0);
a6 : in bit;
a5 : in bit;
a3a4 : out bit_vector(3 downto 0);
a4 : in bit;
a3 : in bit;
aoa1a2 : out bit_vector(7 downto 0);
a2 : in bit;
a1 : in bit;
a0 : in bit
);
end component n2_core_pll_charc_decoder_cust;
component n2_core_pll_mux8_8x_cust is
port (
sel0 : in bit;
in2 : in bit;
sel2 : in bit;
sel5 : in bit;
in4 : in bit;
sel7 : in bit;
sel4 : in bit;
in1 : in bit;
dout : out bit;
in0 : in bit;
sel6 : in bit;
in5 : in bit;
in7 : in bit;
sel3 : in bit;
sel1 : in bit;
in3 : in bit;
in6 : in bit
);
end component n2_core_pll_mux8_8x_cust;
component n2_core_pll_mux2_8x_cust is
port (
in0 : in bit;
sel0 : in bit;
dout : out bit;
sel1 : in bit;
in1 : in bit
);
end component n2_core_pll_mux2_8x_cust;
component n2_core_pll_buf_16x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_buf_16x_cust;
component n2_core_pll_4bit_counter_charc_cust is
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
end component n2_core_pll_4bit_counter_charc_cust;
component n2_core_pll_charc_flops_cust is
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
end component n2_core_pll_charc_flops_cust;
component n2_core_pll_charc_mux_cust is
port (
clk_fall2 : in bit;
clk_fall3 : in bit;
clk_fall4 : in bit;
clk_fall1 : in bit;
clk_rise3 : in bit;
clk_rise2 : in bit;
clk_rise4 : in bit;
clk_rise1 : in bit;
mux_out1 : out bit;
mux_out2 : out bit;
a3a4 : in bit_vector(3 downto 0);
aoa1a2 : in bit_vector(7 downto 0)
);
end component n2_core_pll_charc_mux_cust;
component n2_core_pll_inv_16x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_16x_cust;
component n2_core_pll_inv_32x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_32x_cust;
component n2_core_pll_inv_2x_cust is
port(
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_2x_cust;
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

signal ta6 : bit_vector(1 downto 0);
begin
vdd <= '1';
vss <= '0';
(a6_1,a6_0) <= ta6;
x2 : n2_core_pll_div4_new_cust port map (
clk => l1clk_vcoclk,
arst_l => testmode,
clk_div_out => l1clk_vcoclk_div4
);
x3 : n2_core_pll_charc_decoder_cust port map (
a5_out => ta5,
a6_out => ta6,
a3a4 => a3a4,
aoa1a2 => aoa1a2,
a6 => a6,
a5 => a5,
a4 => a4,
a3 => a3,
a2 => a2,
a1 => a1,
a0 => a0
);
x4 : n2_core_pll_mux8_8x_cust port map (
sel0 => aoa1a2(0),
in2 => mxin(2),
sel2 => aoa1a2(2),
sel5 => aoa1a2(5),
in4 => mxin(4),
sel7 => aoa1a2(7),
sel4 => aoa1a2(4),
in1 => mxin(9),
dout => out_bot,
in0 => mxin(0),
sel6 => aoa1a2(6),
in5 => mxin(5),
in7 => mxin(7),
sel3 => aoa1a2(3),
sel1 => aoa1a2(1),
in3 => mxin(3),
in6 => mxin(6)
);
x5 : n2_core_pll_mux2_8x_cust port map (
in0 => mxin(8),
sel0 => ta5(0),
dout => l1clk_vcoclk,
sel1 => ta5(1),
in1 => mxin(1)
);
x6 : n2_core_pll_mux2_8x_cust port map (
in0 => out_bot,
sel0 => a6_0,
dout => net169,
sel1 => a6_1,
in1 => mux_out2
);
x7 : n2_core_pll_mux2_8x_cust port map (
in0 => out_top,
sel0 => a6_0,
dout => net174,
sel1 => a6_1,
in1 => mux_out1
);
x42_7 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxbuf(9),
i => mxin(9)
);
x44_3 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxin(3),
i => ref_clk_l
);
x42_0 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxbuf(0),
i => mxin(0)
);
x44_4 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxin(4),
i => fb
);
x12 : n2_core_pll_4bit_counter_charc_cust port map (
clk => out_cnt1,
reset => net77,
cnt3 => vdd,
qout_0 => a4,
qout_1 => a5,
qout_2 => a6,
qout_3 => a7,
count_out => net252,
cnt1 => vdd,
cnt2 => vdd,
cnt0 => vdd
);
x15 : n2_core_pll_4bit_counter_charc_cust port map (
clk => pll_charc_in,
reset => net77,
cnt3 => vdd,
qout_0 => a0,
qout_1 => a1,
qout_2 => a2,
qout_3 => a3,
count_out => out_cnt1,
cnt1 => vdd,
cnt2 => vdd,
cnt0 => vdd
);
x16 : n2_core_pll_charc_flops_cust port map (
data_in => net238,
clk => l1clk_vco_clk,
clk_l => l1clk_vcoclk_l,
clk_rise1 => clk_rise1,
clk_fall1 => clk_fall1,
clk_rise2 => clk_rise2,
clk_fall2 => clk_fall2,
reset => net77,
clk_rise4 => clk_rise4,
clk_rise3 => clk_rise3,
clk_fall3 => clk_fall3,
clk_fall4 => clk_fall4
);
x17 : n2_core_pll_charc_mux_cust port map (
a3a4 => a3a4,
aoa1a2 => aoa1a2,
clk_fall2 => clk_fall2,
clk_fall3 => clk_fall3,
clk_fall4 => clk_fall4,
clk_fall1 => clk_fall1,
clk_rise3 => clk_rise3,
clk_rise2 => clk_rise2,
clk_rise4 => clk_rise4,
clk_rise1 => clk_rise1,
mux_out1 => mux_out1,
mux_out2 => mux_out2
);
x42_1 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxbuf(1),
i => mxin(1)
);
x44_5 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxin(5),
i => ref
);
x42_2 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxbuf(2),
i => mxin(2)
);
x44_6 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxin(6),
i => slow
);
x34 : n2_core_pll_inv_16x_cust port map (
vdd_reg => vdd,
o => l1clk_vcoclk_l,
i => l1clk_vcoclk
);
x35 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => l1clk_vco_clk,
i => l1clk_vcoclk
);
x36 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => net238,
i => net76
);
x37 : n2_core_pll_inv_16x_cust port map (
vdd_reg => vdd,
o => net224,
i => net174
); 
x38 : n2_core_pll_inv_16x_cust port map (
vdd_reg => vdd,
o => net227,
i => net169
);
x39 : n2_core_pll_inv_32x_cust port map (
vdd_reg => vdd,
o => pll_charc_out(1),
i => net224
);
x42_3 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxbuf(4),
i => mxin(4)
);
x44_7 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxin(7),
i => fast
);
x40 : n2_core_pll_inv_32x_cust port map (
vdd_reg => vdd,
o => pll_charc_out(0),
i => net227
);
x41 : n2_core_pll_inv_2x_cust port map (
vdd_reg => vdd,
o => reset,
i => arst_l
); 
x43 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => net77,
i => reset
);
x46 : n2_core_pll_inv_32x_cust port map (
vdd_reg => vdd,
o => ccu_rst_ref_buf2_l,
i => mxin(5)
);
x47 : n2_core_pll_inv_32x_cust port map (
vdd_reg => vdd,
o => ccu_rst_sys_clk,
i => net0232
);
x48 : n2_core_pll_inv_16x_cust port map (
vdd_reg => vdd,
o => net0232,
i => mxin(3)
);
x42_4 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxbuf(6),
i => mxin(6)
);
x44_0 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxin(0),
i => lock
);
x44_8 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxin(8),
i => l1clk
);
x42_5 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxbuf(7),
i => mxin(7)
);
x44_1 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxin(1),
i => vco_clk
);
x44_9 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxin(9),
i => dr_clk_out
);
x42_6 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxbuf(8),
i => mxin(8)
);
x44_2 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => mxin(2),
i => fb_clk_l
);
x0 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => l1clk_vcoclk_div4,
reset => net77,
clk  => l1clk_vcoclk_l,
q_l => net251,
q => net76
);
x1 : n2_core_pll_mux8_8x_cust port map (
sel0 => aoa1a2(0),
in2 => mxin(3),
sel2 => aoa1a2(2),
sel5 => aoa1a2(5),
in4 => mxin(5),
sel7 => aoa1a2(7),
sel4 => aoa1a2(4),
in1 => mxin(1),
dout => out_top,
in0 => mxin(1),
sel6 => aoa1a2(6),
in5 => mxin(4),
in7 => mxin(6),
sel3 => aoa1a2(3),
sel1 => aoa1a2(1),
in3 => mxin(2),
in6 => mxin(7)
);
end architecture arch;
