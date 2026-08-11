entity n2_core_pll_d4_mux_cust is
port (
out_clk : out bit;
rstps : in bit_vector(0 downto 0);
bs_pi_clk_4 : in bit;
bs_pi_clk_0 : in bit
);
end entity n2_core_pll_d4_mux_cust;
architecture arch of n2_core_pll_d4_mux_cust is
--supply1 vdd;
--vss = '0';
signal in8_clk_l,net032,mux_clk,in8_clk,net61 : bit;
signal vss,vdd : bit;
component cl_u1_nand2_4x is
port (
in0 : in bit;
in1 : in bit;
o : out bit
);
end component cl_u1_nand2_4x;
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
component cl_u1_buf_1x is
port (
i : in bit;
o : out bit
);
end component cl_u1_buf_1x;
component n2_core_pll_inv_32x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_32x_cust;
component n2_core_pll_inv_8x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_8x_cust;
begin
vdd <= '1';
vss <= '0';
x8 : cl_u1_nand2_4x port map (
o => mux_clk,
in1 => bs_pi_clk_0,
in0 => bs_pi_clk_4
);
x9 : cl_u1_buf_1x port map (
o => net61,
i => in8_clk_l
);
x17 : n2_core_pll_flop_reset1_cust port map (
reset_val_l => vss,
d => net61,
reset => rstps(0),
clk => mux_clk,
q_l => in8_clk_l,
q => in8_clk
);
x0 : n2_core_pll_inv_32x_cust port map (
vdd_reg => vdd,
o => out_clk,
i => net032
);
x1 : n2_core_pll_inv_8x_cust port map (
vdd_reg => vdd,
o => net032,
i => in8_clk
);
end architecture arch;

