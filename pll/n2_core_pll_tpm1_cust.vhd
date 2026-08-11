library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity n2_core_pll_tpm1_cust is
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
end entity n2_core_pll_tpm1_cust;
architecture arch of n2_core_pll_tpm1_cust is
component n2_core_pll_flop_reset2_cust is
port (
d : in bit;
clk : in bit;
q_l : out bit;
q : out bit
);
end component n2_core_pll_flop_reset2_cust;
component cl_u1_inv_8x is
port (
i : in bit;
o : out bit
);
end component cl_u1_inv_8x;
component n2_core_pll_inv1_16x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv1_16x_cust;
component n2_core_pll_tpm_mux1_cust is
port (
sel_l : in bit;
vdd_reg : in bit;
out_l : out bit;
d0 : in bit;
d1 : in bit;
sel : in bit
);
end component n2_core_pll_tpm_mux1_cust;
component n2_core_pll_inv_32x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_32x_cust;
component n2_core_pll_flop_reset1_cust is
port (
reset_val_l : in bit;
d : in bit;
reset : in bit;
clk : in bit;
q_l : out bit;
q : out bit
);
end component n2_core_pll_flop_reset1_cust;
component cl_u1_nand2_8x
port (
in0 : in bit;
in1 : in bit;
o : out bit
);
end component cl_u1_nand2_8x;
component n2_core_pll_inv1_32x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv1_32x_cust;
component cl_u1_inv_1x
port (
i : in bit;
o : out bit
);
end component cl_u1_inv_1x;
component cl_u1_nand2_2x
port (
in0 : in bit;
in1 : in bit;
o : out bit
);
end component cl_u1_nand2_2x;
component n2_core_pll_nand2_8x_cust is
port (
vsup : in bit;
o : out bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_nand2_8x_cust;
--supply1 vdd;
--vss = '0';
signal vdd : bit;
signal vss : bit;
signal tcac_l : bit;
signal d3,q0_l,q1_l,q2_l,net75,q3_l,vco_ck_l,ca3,net121,d22,net128,d22_l,net130,net132,net0165,net137,net143,sel1,qa2_l,q0,q1,q2,q3,l1clk,net173,net174,sel1_q,d0,d1,d2 : bit;
begin
vdd <= '1';
vss <= '0';
cac_l <= tcac_l;
x2 : n2_core_pll_flop_reset2_cust port map (
d => ca2_a1,
clk => vco_ck,
q_l => net174,
q => qa2_l
);
x3 : cl_u1_inv_8x port map (
o => vco_ck_l,
i => vco_ck
);
x4 : n2_core_pll_inv1_16x_cust port map (
vdd_reg => vdd,
o => d22,
i => q0
);
x5 : n2_core_pll_tpm_mux1_cust port map (
sel_l => d22_l,
vdd_reg => vdd,
out_l => d1,
d0 => net132,
d1 => q2_l,
sel => d22
);
x6 : n2_core_pll_flop_reset2_cust port map (
d => sel1,
clk => vco_ck_l,
q_l => net121,
q => sel1_q
);
x7 : n2_core_pll_inv_32x_cust port map (
vdd_reg => vdd,
o => l1clk,
i => net137
);
x8 : n2_core_pll_flop_reset1_cust port map (
reset_val_l => vss,
d => d1,
reset => reset,
clk => l1clk,
q_l => q1_l,
q => q1
);
x9 : n2_core_pll_flop_reset2_cust port map (
d => ca3,
clk => vco_ck_l,
q_l => net173,
q => tcac_l
);
x10 : cl_u1_nand2_8x port map (
o => ca3 ,
in1 => qa2_l,
in0 => sel1
);
x11 : n2_core_pll_tpm_mux1_cust port map (
sel_l => d22_l,
vdd_reg => vdd,
out_l => d2,
d0 => vdd,
d1 => q3_l,
sel => d22
);
x12 : n2_core_pll_flop_reset1_cust port map (
reset_val_l => vss,
d => d3,
reset => nreset,
clk => l1clk,
q_l => q3_l,
q => q3
);
x13 : n2_core_pll_inv1_32x_cust port map (
vdd_reg => vdd,
o => sel_l,
i => net143
);
x14 : cl_u1_nand2_8x port map (
o => net143,
in1 => sel1_q,
in0 => vco_ck
);
x15 :cl_u1_inv_1x port map (
o => net130,
i => ip(2)
);
x16 : n2_core_pll_tpm_mux1_cust port map (
sel_l => d22_l,
vdd_reg => vdd,
out_l => d3,
d0 => ip(0),
d1 => vss,
sel => d22
);
x17 : n2_core_pll_inv1_16x_cust port map (
vdd_reg => vdd,
o => d22_l,
i => q0_l
);
x18 : cl_u1_nand2_2x port map (
o => net132,
in1 => net130,
in0 => net128
);
x19 : cl_u1_inv_1x port map (
o => net128,
i => ip(0)
);
x20 : cl_u1_inv_1x port map (
o => net0165,
i => ip(1)
);
x22 : n2_core_pll_flop_reset1_cust port map (
reset_val_l => vss,
d => d22,
reset => reset,
clk => vco_ck,
q_l => sel1,
q => net75
);
x36 : n2_core_pll_tpm_mux1_cust port map (
sel_l => d22_l,
vdd_reg => vdd,
out_l => d0,
d0 => vdd,
d1 => q1_l,
sel => d22
);
x45 : n2_core_pll_flop_reset1_cust port map (
reset_val_l => vss,
d => d0,
reset => reset,
clk => l1clk,
q_l => q0_l,
q => q0
);
x46 : n2_core_pll_flop_reset1_cust port map (
reset_val_l => vss,
d => d2,
reset => nreset,
clk => l1clk,
q_l => q2_l,
q => q2
);
x0 : n2_core_pll_nand2_8x_cust port map (
vsup => vdd,
o => net137,
in1 => tcac_l,
in0 => vco_ck
);
x1 : n2_core_pll_inv1_16x_cust port map (
vdd_reg => vdd,
o => sel,
i => net75
);
end architecture arch;

