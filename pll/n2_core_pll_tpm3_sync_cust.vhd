entity n2_core_pll_tpm3_sync_cust is
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
end entity n2_core_pll_tpm3_sync_cust;
architecture arch of n2_core_pll_tpm3_sync_cust is
--supply1 vdd;
--supply0 vss;
signal vdd,vss : bit;
signal rstpa,rstpb : bit_vector(1 downto 1);
signal rstp_l,rstp,rstp1,net127 : bit_vector(1 downto 0);
signal net77,net110,net79,net112,net115,net116,net81,net120,vco_clk_d,net63,vco_out,net69 : bit;
signal tdc_clk : bit;
component n2_core_pll_inv1_16x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv1_16x_cust;
component cl_u1_nand2_8x is
port (
in0 : in bit;
in1 : in bit;
o : out bit
);
end component cl_u1_nand2_8x;
component n2_core_pll_fse2diff_out_cust is
port (
vdd_reg : in bit;
i : in bit;
out_l : out bit;
o : out bit
);
end component n2_core_pll_fse2diff_out_cust;
component cl_u1_inv_4x is
port (
i : in bit;
o : out bit
);
end component cl_u1_inv_4x;
component cl_u1_inv_2x is
port (
i : in bit;
o : out bit
);
end component cl_u1_inv_2x;
component n2_core_pll_flop_reset1_cust is
port(
reset_val_l : in bit;
d : in bit;
reset : in bit;
clk : in bit;
q_l : out bit;
q : out bit
);
end component n2_core_pll_flop_reset1_cust;
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
component cl_u1_inv_8x is
port (
i : in bit;
o : out bit
);
end component cl_u1_inv_8x;
component cl_u1_buf_1x is
port (
i : in bit;
o : out bit
);
end component cl_u1_buf_1x;
component n2_core_pll_flop_reset2_cust is
port (
d : in bit;
clk : in bit;
q_l : out bit;
q : out bit
);
end component n2_core_pll_flop_reset2_cust;
signal tvco_clk,tarst : bit;
signal trst : bit_vector(1 downto 1);
begin
vdd <= '1';
vss <= '0';
rst <= trst;
arst <= tarst;
dc_clk <= tdc_clk;
vco_out <= not volb;
tdc_clk <= not vco_out;
tvco_clk <= not tdc_clk;
x2 : n2_core_pll_inv1_16x_cust port map (
vdd_reg => vdd,
o => rstpa(1),
i => rstp_l(1)
);
x5_1 : n2_core_pll_flop_reset2_cust port map (
d => rstp1(0),
clk => vco_clk_d,
q_l => net127(0),
q => rstp1(1)
);
x8 : n2_core_pll_inv1_16x_cust port map (
vdd_reg => vdd,
o => tarst,
i => arst_l
);
x9 : cl_u1_nand2_8x port map (
o => trst(1),
in1 => ccu_serdes_dtm,
in0 => net63
);
x10 : n2_core_pll_fse2diff_out_cust port map (
vdd_reg => vdd,
i => tvco_clk,
out_l => net81,
o => vco_clk_d
);
x11 : cl_u1_inv_4x port map (
o => net77,
i => net69
);
x12 : n2_core_pll_fse2diff_out_cust port map (
vdd_reg => vdd,
i => rstpa(1),
out_l => net112,
o => rstpb(1)
);
x14 : n2_core_pll_inv1_16x_cust port map (
vdd_reg => vdd,
o => arst_d_l,
i => tarst
);
x15 : cl_u1_inv_4x port map (
o => net79,
i => a(2)
);
x16 : cl_u1_inv_2x port map (
o => net63,
i => rstp(1)
);
x17 : n2_core_pll_flop_reset1_cust port map (
reset_val_l => vdd,
d => net116,
reset => trst(1),
clk => dri1_clk,
q_l => net120,
q => net110
);
xb_0 : n2_core_pll_flop_reset2_cust port map (
d => dft_rst_l,
clk => pll1_clk,
q_l => rstp(0),
q => rstp_l(0)
);
x22 : n2_core_pll_inv1_16x_cust port map (
vdd_reg => vdd,
o => rst_l(0),
i => net77
);
xb_1 : n2_core_pll_flop_reset2_cust port map (
d => rstp_l(0),
clk => tvco_clk,
q_l => rstp(1),
q => rstp_l(1)
);
x37 : n2_core_pll_tpm_mux_cust port map (
opb => net69,
vdd_reg => vdd,
op => net115,
d0 => rstp1(1),
d1 => rstp1(0),
sel => a(2),
sel_b => net79
);
x5_0 : n2_core_pll_flop_reset2_cust port map (
d => rstpb(1),
clk => vco_clk_d,
q_l => net127(1),
q => rstp1(0)
);
x0 : cl_u1_inv_8x port map (
o => d4int_out,
i => net110
);
x1 : cl_u1_buf_1x port map (
o => net116,
i => net120
);
end architecture arch;

