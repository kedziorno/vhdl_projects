entity n2_core_pll_d4_ctl_cust is
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
end entity n2_core_pll_d4_ctl_cust;
architecture arch of n2_core_pll_d4_ctl_cust is
--supply1 vdd;
--vss = '0';
signal vdd : bit;
signal vss : bit;
signal carry : bit_vector(3 downto 1);
signal csel_a1,csel_a1_l : bit_vector(1 downto 0);
signal sum : bit_vector(2 downto 0);
signal net089,mux_clk_l,ca2_a1_l,net94,net034,net043,net045,rst1,ca2_a1,mux_clk,nreset : bit;
component n2_core_pll_tpm1_cust is
port (
nreset : in bit;
ca2_a1 : in bit;
cac_l : out bit;
reset : in bit;
sel_l : out bit;
sel : out bit;
ip : in bit_vector(2 downto 0);
vco_ck : in bit
);
end component n2_core_pll_tpm1_cust;
component cl_u1_inv_8x is
port (
i : in bit;
o : out bit
);
end component cl_u1_inv_8x;
component n2_core_pll_inv1_32x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv1_32x_cust;
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
component cl_u1_inv_4x is
port (
i : in bit;
o : out bit
);
end component cl_u1_inv_4x;
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
component n2_core_pll_flop_reset2_cust is
port (
d : in bit;
clk : in bit;
q_l : out bit;
q : out bit
);
end component n2_core_pll_flop_reset2_cust;
component n2_core_pll_csa32_cust is
port (
in0 : in bit;
sum : out bit;
in0_l : in bit;
carry : out bit;
in2 : in bit;
in1 : in bit
);
end component n2_core_pll_csa32_cust;
component cl_u1_buf_1x is
port (
i : in bit;
o : out bit
);
end component cl_u1_buf_1x;
begin
vdd <= '1';
vss <= '0';
x2 : n2_core_pll_tpm1_cust port map (
ip => a(4 downto 2),
nreset => nreset,
ca2_a1 => ca2_a1,
cac_l => cac_l,
reset => rst1,
sel_l => mux_clk,
sel => mux_clk_l,
vco_ck => in_clk
);
x5 : cl_u1_inv_8x port map (
o => net034,
i => rstps
);
xa0 : n2_core_pll_flop_reset1_cust port map (
reset_val_l => vdd,
d => sum(0),
reset => rst1,
clk => mux_clk,
q_l => csel_a1_l(0),
q => csel_a1(0)
);
x6 : n2_core_pll_inv1_32x_cust port map (
vdd_reg => vdd,
o => rst1,
i => net043
);
x7 : cl_u1_nand2_8x port map (
o => nreset,
in1 => a(4),
in0 => net043
);
xa_1 : n2_core_pll_flop_reset1_cust port map (
reset_val_l => vdd,
d => sum(1),
reset => rst1,
clk => mux_clk,
q_l => csel_a1_l(1),
q => csel_a1(1)
);
x11 : cl_u1_nand2_8x port map (
o => out_clk,
in1 => eq,
in0 => mux_clk_l
);
x13 : n2_core_pll_flop_reset2_cust port map (
d => net034,
clk => in_clk,
q_l => net045,
q => net043
);
xa_2 : n2_core_pll_flop_reset1_cust port map (
reset_val_l => vdd,
d => sum(2),
reset => rst1,
clk => mux_clk,
q_l => ca2_a1_l,
q => ca2_a1
);
xb_0 : n2_core_pll_csa32_cust port map (
in0 => csel_a1(0),
sum => sum(0),
in0_l => csel_a1_l(0),
carry => carry(1),
in2 => vss,
in1 => a(0)
);
x22 : n2_core_pll_inv1_16x_cust port map (
vdd_reg => vdd,
o => pclk,
i => net94
);
xb_1 : n2_core_pll_csa32_cust port map (
in0 => csel_a1(1),
sum => sum(1),
in0_l => csel_a1_l(1),
carry => carry(2),
in2 => carry(1),
in1 => a(1)
);
x3_1 : cl_u1_buf_1x port map (
o => net089,
i => csel_a1(1)
);
xb_2 : n2_core_pll_csa32_cust port map (
in0 => vss,
sum => sum(2),
in0_l => vdd,
carry => carry(3),
in2 => carry(2),
in1 => vss
);
x0_1 : n2_core_pll_flop_reset1_cust port map (
reset_val_l => vdd,
d => net089,
reset => rst1,
clk => mux_clk,
q_l => csel_l(1),
q => csel(1)
);
x1 : cl_u1_inv_4x port map (
o => net94,
i => in_clk
);
end architecture arch;

