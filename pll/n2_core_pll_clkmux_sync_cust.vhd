entity n2_core_pll_clkmux_sync_cust is
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
end entity n2_core_pll_clkmux_sync_cust;
architecture arch of n2_core_pll_clkmux_sync_cust is
--supply1 vdd;
signal net089,net111,net112,net113,net114,net0185,net0186,net0187,net0207,net0189,d0_1,d0_2,d1_1,d0_3,d1_2,d0_4,d1_3,d2_1, d1_4,d2_2,d3_1,d2_3,d3_2,d2_4,d3_3,d3_4,clk_dly1,clk_dly2,clk_dly3,clk_dly4,clk_dly5,net054,net057,net0110,net0191,net0192,net56,net0125,net0126,net078,net63 : bit;
signal bypass_pll_clk_l : bit;
signal vdd : bit;
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
component n2_core_pll_clkrep_cust is
port (
pll_clk : in bit;
clk_dly3 : out bit;
clk_dly5 : out bit;
clk_dly4 : out bit;
clk_dly2 : out bit;
clk_dly1 : out bit
);
end component n2_core_pll_clkrep_cust;
begin
vdd <= '1';
bypass_pll_clk_l <= not bypass_pll_clk;
x2 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => bypass_pll_clk_l,
d => d2_4,
reset => arst,
clk => clk_dly1,
q_l => net0125,
q => d2_sync
);
x3 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d3_4,
reset => arst,
clk => clk_dly1,
q_l => net057,
q => d3_sync
);
x4 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d1_4,
reset => arst,
clk => clk_dly1,
q_l => net0110,
q => d1_sync
);
x5 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d0_4,
reset => arst,
clk => clk_dly1,
q_l => net0192,
q => d0_sync
);
x6 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d0_3,
reset => arst,
clk => clk_dly2,
q_l => net0191,
q => d0_4
);
x7 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d1_3,
reset => arst,
clk => clk_dly2,
q_l => net089,
q => d1_4
);
x8 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d0_1,
reset => arst,
clk => clk_dly4,
q_l => net0186,
q => d0_2
);
x9 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d1_1,
reset => arst,
clk => clk_dly4,
q_l => net0187,
q => d1_2
);
x10 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d1_2,
reset => arst,
clk => clk_dly3,
q_l => net0189,
q => d1_3
);
x12 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d1,
reset => arst,
clk => clk_dly5,
q_l => net054,
q => d1_1
);
x13 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d0_2,
reset => arst,
clk => clk_dly3,
q_l => net0185,
q => d0_3
);
x14 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d0,
reset => arst,
clk => clk_dly5,
q_l => net0207,
q => d0_1
);
x18 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => bypass_pll_clk_l,
d => d2_2,
reset => arst,
clk => clk_dly3,
q_l => net114,
q => d2_3
);
x19 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d3_2,
reset => arst,
clk => clk_dly3,
q_l => net56,
q => d3_3
);
x20 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d3_1,
reset => arst,
clk => clk_dly4,
q_l => net112,
q => d3_2
);
x21 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => bypass_pll_clk_l,
d => d2_1,
reset => arst,
clk => clk_dly4,
q_l => net113,
q => d2_2
);
x22 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => bypass_pll_clk_l,
d => d2,
reset => arst,
clk => clk_dly5,
q_l => net63,
q => d2_1
);
x23 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d3,
reset => arst,
clk => clk_dly5,
q_l => net111,
q => d3_1
);
x24 : n2_core_pll_clkrep_cust port map (
pll_clk => pll_clk,
clk_dly3 => clk_dly3,
clk_dly5 => clk_dly5,
clk_dly4 => clk_dly4,
clk_dly2 => clk_dly2,
clk_dly1 => clk_dly1
);
x0 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => vdd,
d => d3_3,
reset => arst,
clk => clk_dly2,
q_l => net078,
q => d3_4
);
x1 : n2_core_pll_flop_reset_new_cust port map (
vdd_reg => vdd,
reset_val_l => bypass_pll_clk_l,
d => d2_3,
reset => arst,
clk => clk_dly2,
q_l => net0126,
q => d2_4
);
end architecture arch;

