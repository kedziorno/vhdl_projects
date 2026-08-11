entity n2_core_pll_d4_sync_cust is
port (
dft_rst_l : in bit;
bs_rstps_4 : out bit;
bs_rstps_0 : out bit;
bs_pclk_4 : in bit;
bs_pclk_0 : in bit
);
end entity n2_core_pll_d4_sync_cust;
architecture arch of n2_core_pll_d4_sync_cust is
--supply1 vdd;
signal net014,net031,net46 : bit;
signal rstp_4 : bit; --bit_vector(4 downto 4);
signal vdd : bit;
component n2_core_pll_flop_reset2_cust is
port (
d : in bit;
clk : in bit;
q_l : out bit;
q : out bit
);
end component n2_core_pll_flop_reset2_cust;
component n2_core_pll_inv1_16x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv1_16x_cust;
begin
vdd <= '1';
x2 : n2_core_pll_flop_reset2_cust port map (
d => rstp_4,
clk => bs_pclk_4,
q_l => net46,
q => net031
);
x7 : n2_core_pll_inv1_16x_cust port map (
vdd_reg => vdd,
o => bs_rstps_0,
i => net014
);
x0 : n2_core_pll_flop_reset2_cust port map (
d => dft_rst_l,
clk => bs_pclk_0,
q_l => rstp_4,
q => net014
);
x1 : n2_core_pll_inv1_16x_cust port map (
vdd_reg => vdd,
o => bs_rstps_4,
i => net46
);
end architecture arch;

