entity n2_core_pll_tpm3_all_cust is
port (
pll_stretch_a : in bit;
ccu_serdes_dtm : in bit;
dr_ext_clk : in bit;
dc_clk : out bit;
pll_clk_out_l : out bit;
pll_div3 : in bit_vector(5 downto 0);
pll_sdel : in bit_vector(1 downto 0);
pll_sel_a : in bit_vector(1 downto 0);
pll_bypass_clk_en : in bit;
pll_arst_l : in bit;
dr_clk_out : out bit;
pll_bypass_clk : in bit;
pll_clk_out : out bit;
dr_clk_out_l : out bit;
dr_stretch_a : in bit;
pll_testmode : in bit;
dr_sdel : in bit_vector(1 downto 0);
vco8_clk : out bit;
dr_sel_a : in bit_vector(1 downto 0);
volb : in bit;
vco2_clk : out bit;
pll_ext_clk : in bit;
pll_div4 : in bit_vector(6 downto 0);
dft_rst_a_l : in bit
);
end entity n2_core_pll_tpm3_all_cust;
architecture arch of n2_core_pll_tpm3_all_cust is
--supply1		vdd ;
--supply0		vss ;
signal vdd,vss : bit;
signal net077 : bit_vector(1 downto 0);
signal net080,tnet080 : bit_vector(5 downto 0);
signal rst : bit_vector(1 downto 1);
signal rst_l : bit_vector(0 downto 0);
signal net088,net0100,net0103,net0104,net095,arst_d_l,net096,net097,net098,pll1_clk,
dr_byp_clk,net0153,net042,dr1_clk,d4int_out,net069,vco_clk,pll_byp_clk : bit;
component n2_core_pll_ckmux_cust is
port (
pll_sdel : in bit_vector(1 downto 0);
ckt_drv_int : out bit;
cktree_drv_l : out bit;
ext_clk : in bit;
dft_rst_a_l : in bit;
dft_rst_l : out bit;
bypass_pll_clk : in bit;
psel1 : out bit;
psel0 : out bit;
stretch_a : in bit;
async_reset : in bit;
cktree_drv : out bit;
pll1_clk : in bit;
pll_sel : in bit_vector(1 downto 0);
bypass_clk : in bit
);
end component n2_core_pll_ckmux_cust;
component n2_core_pll_byp_enb_cust is
port (
sel1 : in bit;
in1 : in bit;
out1 : out bit;
out0 : out bit;
in0 : in bit;
sel0 : in bit
);
end component n2_core_pll_byp_enb_cust;
component n2_core_pll_div4_cust is
port (
clk : in bit;
arst_l : in bit;
clk_div_out : out bit
);
end component n2_core_pll_div4_cust;
component n2_core_pll_inv_32x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_32x_cust;
component n2_core_pll_inv_16x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_16x_cust;
component n2_core_pll_tpm3_cust is
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
end component n2_core_pll_tpm3_cust;
component n2_core_pll_tpm3_sync_cust is
port (
dri1_clk : in bit;
dft_rst_l : in bit;
dc_clk : out bit;
d4int_out : out bit;
ccu_serdes_dtm : in bit;
arst_l : in bit;
arst : out bit;
vco_clk : out bit;
pll1_clk : in bit;
arst_d_l : out bit;
a : in bit_vector(2 downto 2);
rst_l : out bit_vector(0 downto 0);
rst : out bit_vector(1 downto 1);
volb : in bit
);
end component n2_core_pll_tpm3_sync_cust;
component n2_core_pll_inv_1x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_1x_cust;
component n2_core_pll_d4_frac_cust is
port (
dft_rst_l : in bit;
vco_clk : in bit;
a : in bit_vector(4 downto 0);
out_clk : out bit
);
end component n2_core_pll_d4_frac_cust;
begin
(net080(0),net080(1),net080(2),net080(3),net080(4),net080(5)) <= tnet080;
vdd <= '1';
vss <= '0';
x2 : n2_core_pll_ckmux_cust
port map (
pll_sdel => pll_sdel,
pll_sel => pll_sel_a,
ckt_drv_int => net0104,
cktree_drv_l => pll_clk_out_l,
ext_clk => pll_ext_clk,
dft_rst_a_l => vdd,
dft_rst_l => net0153,
bypass_pll_clk => pll_bypass_clk_en,
psel1 => net0103,
psel0 => net096,
stretch_a => pll_stretch_a,
async_reset => net095,
cktree_drv => pll_clk_out,
pll1_clk => pll1_clk,
bypass_clk => pll_byp_clk
);
x3 : n2_core_pll_byp_enb_cust 
port map (
sel1 => ccu_serdes_dtm,
in1 => pll_bypass_clk,
out1 => dr_byp_clk,
out0 => pll_byp_clk,
in0 => pll_bypass_clk,
sel0 => pll_bypass_clk_en
);
x4 : n2_core_pll_ckmux_cust
port map (
pll_sdel => dr_sdel,
pll_sel => dr_sel_a,
ckt_drv_int => net098,
cktree_drv_l => dr_clk_out_l,
ext_clk => dr_ext_clk,
dft_rst_a_l => vdd,
dft_rst_l => net097,
bypass_pll_clk => ccu_serdes_dtm,
psel1 => net0100,
psel0 => net042,
stretch_a => dr_stretch_a,
async_reset => net095,
cktree_drv => dr_clk_out,
pll1_clk => dr1_clk,
bypass_clk => dr_byp_clk
);
x5 : n2_core_pll_div4_cust
port map (
clk => pll1_clk,
arst_l => pll_testmode,
clk_div_out => vco8_clk
);
x6 : n2_core_pll_inv_32x_cust
port map (
vdd_reg => vdd,
o => vco2_clk,
i => net069
);
x7 : n2_core_pll_inv_16x_cust
port map (
vdd_reg => vdd,
o => net069,
i => pll1_clk
);
xd3 : n2_core_pll_tpm3_cust
port map (
ip => pll_div3,
op => tnet080,
reset => net095,
vdd_reg => vdd,
sel => net088,
div_ck_i => vdd,
pwr_rst => vdd,
div_ck => pll1_clk,
vco_ck => vco_clk
);
x11_0 : n2_core_pll_inv_1x_cust
port map (
vdd_reg => vdd,
o => net077(1),
i => pll_div4(5)
);
x11_1 : n2_core_pll_inv_1x_cust
port map (
vdd_reg => vdd,
o => net077(0),
i => pll_div4(6)
);
x0 : n2_core_pll_tpm3_sync_cust
port map (
a => pll_div4(2 downto 2),
rst_l => rst_l(0 downto 0),
rst => rst(1 downto 1),
dri1_clk => vss,
dft_rst_l => dft_rst_a_l,
dc_clk => dc_clk,
d4int_out => d4int_out,
ccu_serdes_dtm => vss,
arst_l => pll_arst_l,
arst => net095,
vco_clk => vco_clk,
pll1_clk => pll1_clk,
arst_d_l => arst_d_l,
volb => volb
);
x1 : n2_core_pll_d4_frac_cust
port map (
a => pll_div4(4 downto 0),
dft_rst_l => rst_l(0),
vco_clk => vco_clk,
out_clk => dr1_clk
);
end architecture arch;

