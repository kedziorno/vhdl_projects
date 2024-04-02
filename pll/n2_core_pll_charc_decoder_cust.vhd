entity n2_core_pll_charc_decoder_cust is
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
end entity n2_core_pll_charc_decoder_cust;
architecture arch of n2_core_pll_charc_decoder_cust is
--supply1 vdd;
signal vdd : bit;
signal net188,net191,net194,net197,a0_buf,a1_buf,a2_buf,a3_buf,
a4_buf,net144,net153,a0_inv,a1_inv,a2_inv,a3_inv,a4_inv,net179 : bit;
component n2_core_pll_and3_16x_cust is
port (
o : out bit;
in2 : in bit;
in1 : in bit;
in0 : in bit
);
end component n2_core_pll_and3_16x_cust;
component n2_core_pll_inv_4x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_4x_cust;
component n2_core_pll_buf_16x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_buf_16x_cust;
component n2_core_pll_and2_16x_cust is
port (
o : out bit;
in1,in0 : in bit
);
end component n2_core_pll_and2_16x_cust;
begin
vdd <= '1';
x2 : n2_core_pll_and3_16x_cust port map (
o => aoa1a2(2),
in2 => a0_inv,
in1 => a1_buf,
in0 => a2_inv
);
x3 : n2_core_pll_and3_16x_cust port map (
o => aoa1a2(3),
in2 => a0_buf,
in1 => a1_buf,
in0 => a2_inv
);
x4 : n2_core_pll_inv_4x_cust port map (
vdd_reg => vdd,
o => net197,
i => a0
);
x5 : n2_core_pll_inv_4x_cust port map (
vdd_reg => vdd,
o => net188,
i => a3
);
x6 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => a2_buf,
i => a2
);
x7 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => a3_buf,
i => a3
);
x8 : n2_core_pll_and3_16x_cust port map (
o => aoa1a2(4),
in2 => a0_inv,
in1 => a1_inv,
in0 => a2_buf
);
x9 : n2_core_pll_and3_16x_cust port map (
o => aoa1a2(5),
in2 => a0_buf,
in1 => a1_inv,
in0 => a2_buf
);
x10 : n2_core_pll_and3_16x_cust port map (
o => aoa1a2(6),
in2 => a0_inv,
in1 => a1_buf,
in0 => a2_buf
);
x11 : n2_core_pll_and3_16x_cust port map (
o => aoa1a2(7),
in2 => a0_buf,
in1 => a1_buf,
in0 => a2_buf
);
x12 : n2_core_pll_and2_16x_cust port map (
o => a3a4(0),
in1 => a3_inv,
in0 => a4_inv
);
x13 : n2_core_pll_and2_16x_cust port map (
o => a3a4(1),
in1 => a3_buf,
in0 => a4_inv
);
x14 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => a1_buf,
i => a1
);
x15 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => a0_buf,
i => a0
);
x16 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => a2_inv,
i => net191
);
x17 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => a1_inv,
i => net194
);
x18 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => a0_inv,
i => net197
);
x19 : n2_core_pll_inv_4x_cust port map (
vdd_reg => vdd,
o => net194,
i => a1
);
x20 : n2_core_pll_inv_4x_cust port map (
vdd_reg => vdd,
o => net191,
i => a2
);
x21 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => a4_buf,
i => a4
);
x22 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => a4_inv,
i => net153
);
x23 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => a3_inv,
i => net188
);
x24 : n2_core_pll_inv_4x_cust port map (
vdd_reg => vdd,
o => net153,
i => a4
);
x25 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => a5_out(0),
i => net179
);
x26 : n2_core_pll_and2_16x_cust port map (
o => a3a4(2),
in1 => a3_inv,
in0 => a4_buf
);
x27 : n2_core_pll_and2_16x_cust port map (
o => a3a4(3),
in1 => a3_buf,
in0 => a4_buf
);
x28 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => a6_out(0),
i => net144
);
x39 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => a6_out(1),
i => a6
);
x40 : n2_core_pll_buf_16x_cust port map (
vdd_reg => vdd,
o => a5_out(1),
i => a5
);
x41 : n2_core_pll_inv_4x_cust port map (
vdd_reg => vdd,
o => net144,
i => a6
);
x42 : n2_core_pll_inv_4x_cust port map (
vdd_reg => vdd,
o => net179,
i => a5
);
x0 : n2_core_pll_and3_16x_cust port map (
o => aoa1a2(0),
in2 => a0_inv,
in1 => a1_inv,
in0 => a2_inv
);
x1 : n2_core_pll_and3_16x_cust port map (
o => aoa1a2(1),
in2 => a0_buf,
in1 => a1_inv,
in0 => a2_inv
);
end architecture arch;

