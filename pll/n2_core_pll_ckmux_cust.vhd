entity n2_core_pll_ckmux_cust is
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
end entity n2_core_pll_ckmux_cust;
architecture arch of n2_core_pll_ckmux_cust is
--supply0 vss;
signal vss,vdd : bit;
signal sel_n0,byp_pll_clk_l,sel_n1,net93,pll_sel0_l,byp_pll_clk,s0_l,sel0,sel1,s1_l,sel2,sel3,net069,psel0_l,psel1_l,d1_clk,net070,net071,sel_n1_l,s0,s1,sel_n0_l,sel2_l,sel3_l,net64 : bit;
signal net069_orig,net070_orig : bit;
component cl_u1_nand2_4x is
port (
in0 : in bit;
in1 : in bit;
o : out bit
);
end component cl_u1_nand2_4x;
component cl_u1_inv_16x is
port (
i : in bit;
o : out bit
);
end component cl_u1_inv_16x;
component cl_u1_inv_4x is
port (
i : in bit;
o : out bit
);
end component cl_u1_inv_4x;
component cl_u1_inv_8x is
port (
i : in bit;
o : out bit
);
end component cl_u1_inv_8x;
component cl_u1_inv_1x is
port (
i : in bit;
o : out bit
);
end component cl_u1_inv_1x;
component n2_core_pll_flopderst_16x_cust is
port (
q_l : out bit;
reset_val : in bit;
d : in bit;
q : out bit;
reset : in bit;
clk : in bit;
ena : in bit
);
end component n2_core_pll_flopderst_16x_cust;
component cl_u1_inv_2x is
port (
i : in bit;
o : out bit
);
end component cl_u1_inv_2x;
component n2_core_pll_ckmux_mxdel_diffout_cust is
port (
ckt_drv_int : out bit;
cktree_drv : out bit;
cktree_drv_l : out bit;
pll1_clk : in bit;
sel1 : in bit;
pll2_clk : in bit;
bypass_clk : in bit;
sel3 : in bit;
d1_clk : out bit; --XXX in
pll_sdel : in bit_vector(1 downto 0);
sel0 : in bit;
sel2 : in bit
);
end component n2_core_pll_ckmux_mxdel_diffout_cust;
component n2_core_pll_clkmux_sync_cust is
port (
bypass_pll_clk : in bit;
pll_clk : in bit;
arst : in bit;
d1 : in bit;
d2 : in bit;
d1_sync : out bit;
d2_sync : out bit;
d0_sync : out bit;
d0 : in bit;
d3_sync : out bit;
d3 : in bit
);
end component n2_core_pll_clkmux_sync_cust;
component cl_u1_nand2_1x is
port (
in0 : in bit;
in1 : in bit;
o : out bit
);
end component cl_u1_nand2_1x;
component n2_core_pll_inv_8x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_8x_cust;
component n2_core_pll_nand2_2x_cust is
port (
vdd_reg : in bit;
o : out bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_nand2_2x_cust;
begin
vdd <= '1';
vss <= '0';
net069 <= net069_orig after 200 ps;
net070 <= net070_orig after 200 ps;
x2 : cl_u1_nand2_4x port map (
o => s1_l,
in1 => sel_n1_l,
in0 => sel_n0
);
x4 : cl_u1_inv_16x port map (
o => sel3,
i => sel3_l
);
x5 : cl_u1_inv_4x port map (
o => s1,
i => s1_l
);
x6 : cl_u1_inv_8x port map (
o => byp_pll_clk_l,
i => bypass_pll_clk
);
x7 : cl_u1_inv_1x port map (
o => pll_sel0_l,
i => pll_sel(0)
);
x8 : cl_u1_nand2_4x port map (
o => sel2_l,
in1 => pll_sel(1),
in0 => pll_sel0_l
);
xi72 : n2_core_pll_flopderst_16x_cust port map (
q_l => net64,
reset_val => byp_pll_clk_l,
d => s0,
q => sel0,
reset => async_reset,
clk => d1_clk,
ena => net071
);
xi74 : n2_core_pll_flopderst_16x_cust port map (
q_l => net93,
reset_val => vss,
d => s1,
q => sel1,
reset => async_reset,
clk => d1_clk,
ena => net071
);
xi75 : n2_core_pll_flopderst_16x_cust port map (
q_l => sel_n1_l,
reset_val => byp_pll_clk,
d => net069,
q => sel_n1,
reset => async_reset,
clk => d1_clk,
ena => net071
);
xi76 : n2_core_pll_flopderst_16x_cust port map (
q_l => sel_n0_l,
reset_val => byp_pll_clk,
d => net070,
q => sel_n0,
reset => async_reset,
clk => d1_clk,
ena => net071
);
x10 : cl_u1_nand2_4x port map (
o => sel3_l,
in1 => pll_sel(1),
in0 => pll_sel(0)
);
x11 : cl_u1_inv_16x port map (
o => sel2,
i => sel2_l
);
x16 : cl_u1_inv_8x port map (
o => psel1,
i => psel1_l
);
x22 : cl_u1_inv_2x port map (
o => psel1_l,
i => sel1
);
x23 : cl_u1_inv_2x port map (
o => psel0_l,
i => sel0
);
x24 : cl_u1_inv_8x port map (
o => psel0,
i => psel0_l
);
x26 : cl_u1_inv_8x port map (
o => byp_pll_clk,
i => byp_pll_clk_l
);
x27 : cl_u1_inv_4x port map (
o => s0,
i => s0_l
);
xmxdel : n2_core_pll_ckmux_mxdel_diffout_cust port map (
pll_sdel => pll_sdel,
ckt_drv_int => ckt_drv_int,
cktree_drv => cktree_drv,
cktree_drv_l => cktree_drv_l,
pll1_clk => pll1_clk,
sel1 => sel1,
pll2_clk => ext_clk,
bypass_clk => bypass_clk,
sel3 => sel3,
d1_clk => d1_clk,
sel0 => sel0,
sel2 => sel2
);
x0 : n2_core_pll_clkmux_sync_cust port map (
bypass_pll_clk => bypass_pll_clk,
pll_clk => pll1_clk,
arst => async_reset,
d1 => pll_sel(0),
d2 => pll_sel(1),
d1_sync => net070_orig,
d2_sync => net069_orig,
d0_sync => net071,	
d0 => stretch_a,
d3_sync => dft_rst_l,
d3 => dft_rst_a_l
);
x1 : cl_u1_nand2_1x port map (
o => s0_l,
in1 => sel_n1_l,
in0 => sel_n0_l
);
end architecture arch;

