entity n2_core_pll_d4_frac_cust is
port (
dft_rst_l : in bit;
vco_clk : in bit;
a : in bit_vector(4 downto 0);
out_clk : out bit
);
end entity n2_core_pll_d4_frac_cust;
architecture arch of n2_core_pll_d4_frac_cust is
--supply1 vdd;
signal vdd : bit;
signal bs_pi_clk_4,bs_ph_clk_4,bs_csel_1,bs_csel_l_3,
bs_csel_3,bs_csel_l_1 : bit_vector(1 downto 1); --XXX 0-0
signal bs_rstps_0 : bit_vector(0 downto 0);
signal bs_cac_l_4,bs_rstps_4,bs_pclk_0,bs_pclk_4,
bs_cac_l_0,bs_pi_clk_0,bs_ph_clk_0 : bit;
component n2_core_pll_d4_sync_cust is
port (
dft_rst_l : in bit;
bs_rstps_4 : out bit;
bs_rstps_0 : out bit;
bs_pclk_4 : in bit;
bs_pclk_0 : in bit
);
end component n2_core_pll_d4_sync_cust;
component n2_core_pll_d4_mux_cust is
port (
out_clk : out bit;
rstps : in bit_vector(0 downto 0);
bs_pi_clk_4 : in bit;
bs_pi_clk_0 : in bit
);
end component n2_core_pll_d4_mux_cust;
component n2_core_pll_d4_ctl_cust is
port (
cac_l : out bit;
csel_l : out bit_vector(1 downto 1);
pclk : out bit;
out_clk : out bit;
eq : in bit;
in_clk : in bit;
csel : out bit_vector(1 downto 1);
rstps : in bit;
a : in bit_vector(4 downto 0)
);
end component n2_core_pll_d4_ctl_cust;
component n2_core_pll_fse2diff_out_cust is
port (
vdd_reg : in bit;
i : in bit;
out_l : out bit;
o : out bit
);
end component n2_core_pll_fse2diff_out_cust;
begin
vdd <= '1';
x3 : n2_core_pll_d4_sync_cust port map (
dft_rst_l => dft_rst_l,
bs_rstps_4 => bs_rstps_4,
bs_rstps_0 => bs_rstps_0(0),
bs_pclk_4 => bs_pclk_4,
bs_pclk_0 => bs_pclk_0
);
x2_0 : n2_core_pll_d4_ctl_cust port map (
csel_l => bs_csel_l_1,
csel => bs_csel_1,
a => a,
cac_l => bs_cac_l_0,
pclk => bs_pclk_0,
out_clk => bs_pi_clk_0,
eq => bs_csel_l_1(1),
in_clk => bs_ph_clk_0,
rstps => bs_rstps_0(0)
);
x2_1 : n2_core_pll_d4_ctl_cust port map (
csel_l => bs_csel_l_3,
csel => bs_csel_3,
a => a,
cac_l => bs_cac_l_4,
pclk => bs_pclk_4,
out_clk => bs_pi_clk_4(1),
eq => bs_csel_3(1),
in_clk => bs_ph_clk_4(1),
rstps => bs_rstps_4
);
x1_0 : n2_core_pll_fse2diff_out_cust port map (
vdd_reg => vdd,
i => vco_clk,
out_l => bs_ph_clk_4(1),
o => bs_ph_clk_0
);
x0 : n2_core_pll_d4_mux_cust port map (
rstps => bs_rstps_0,
out_clk => out_clk,
bs_pi_clk_4 => bs_pi_clk_4(1),
bs_pi_clk_0 => bs_pi_clk_0
);
end architecture arch;

