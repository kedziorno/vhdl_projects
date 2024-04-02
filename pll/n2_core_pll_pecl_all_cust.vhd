entity n2_core_pll_pecl_all_cust is
port (
regdivcr : out bit;
ref_ck : out bit;
slow_l : out bit;
fast : out bit;
fast_l : out bit;
pll_clamp_fltr : in bit;
pll_lock_pulse : out bit;
vdd_reg : in bit;
fb_ck : out bit;
pll_bypass_clk_en : in bit;
ccu_serdes_dtm : in bit;
l2clk : in bit;
slow : out bit;
slow_buf : out bit;
pll_jtag_lock_everlose : out bit;
pll_lock_dyn : out bit;
raw_clk_byp : out bit;
fast_buf : out bit;
l2clkc : in bit;
testmode : in bit;
pll_arst_l : in bit;
pll_div1 : in bit_vector(5 downto 0);
pll_div2 : in bit_vector(5 downto 0);
ref : out bit;
fb : out bit;
pll_sys_clk : in bit_vector(1 downto 0);
l1clk_buf : out bit;
pfd_reset : out bit;
fltr : out bit
);
end entity n2_core_pll_pecl_all_cust;
architecture arch of n2_core_pll_pecl_all_cust is
--supply1 vdd;
signal vdd,vss : bit;
signal net0142,net0111 : bit_vector(5 downto 0);
signal net0164 : bit;
signal arst : bit_vector(1 downto 0);
signal net0178,l1clk_p,net0207,regdiv,fb_ckn,ref_ck_lock,wirenet0164,bypass_clk,net0234,net0139,net153,net155,ref_ckn,net0110,l1clk,l1clk_l,net0118,fb_ck_lock,l1clk_n,net0120,net0122,net0124 : bit;
component n2_core_pll_pecl_bypass_clk_cust is
port (
phase_ck : out bit;
pecl_p : in bit;
pecl_n : in bit
);
end component n2_core_pll_pecl_bypass_clk_cust;
component n2_core_pll_delay_cust is
port (
vdd_reg : in bit;
out_delcr : out bit;
i : in bit;
out_del : out bit
);
end component n2_core_pll_delay_cust;
component n2_core_pll_tpm_cust is
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
end component n2_core_pll_tpm_cust;
component n2_core_pll_inv_16x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_16x_cust;
component n2_core_pll_inv_8x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_8x_cust;
component n2_core_pll_buf_4x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_buf_4x_cust;
component n2_core_pll_vdd_xing_buf_32x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_vdd_xing_buf_32x_cust;
component n2_core_pll_vdd_xing_buf_4x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_vdd_xing_buf_4x_cust;
component n2_core_pll_pecl_cust is
port (
vdd_reg : in bit;
fb_ck : out bit;
pecl_p : in bit;
pecl_n : in bit;
hdr_p : in bit;
ref_ck : out bit;
hdr_n : in bit
);
end component n2_core_pll_pecl_cust;
component n2_core_pll_se2diff_mux_cust is
port (
vdd_reg : in bit;
in1 : in bit;
sel : in bit;
o : out bit;
in0 : in bit;
out_l : out bit
);
end component n2_core_pll_se2diff_mux_cust;
component imaginary_vco_gen is
port (
pll_arst_l : in bit;
sysclk : in bit;
fdbkclk : in bit;
div : in bit_vector(5 downto 0);
vco_out : out bit
); 
end component imaginary_vco_gen;
component n2_core_pll_pecl_enb_cust is
port (
i : in bit;
o : out bit;
enb1 : in bit;
enb0 : in bit
);
end component n2_core_pll_pecl_enb_cust;
signal tnet0142,tnet0111 : bit_vector(5 downto 0);
signal tdiv : bit_vector(5 downto 0);
signal tref,tfast : bit;
begin
ref <= tref;
fast <= tfast;
tdiv <= (pll_div2(4 downto 0)&"1");
(net0142(0),net0142(1),net0142(2),net0142(3),net0142(4),net0142(5)) <= tnet0142;
(net0111(0),net0111(1),net0111(2),net0111(3),net0111(4),net0111(5)) <= tnet0111;
vdd <= '1';
vss <= '0';
x2 : n2_core_pll_pecl_bypass_clk_cust port map (
phase_ck => bypass_clk,
pecl_p => pll_sys_clk(0),
pecl_n => pll_sys_clk(1)
);
xdel1 : n2_core_pll_delay_cust port map (
vdd_reg => vdd_reg,
out_delcr => regdivcr,
i => pll_arst_l,
out_del => regdiv
);
x8 : n2_core_pll_tpm_cust port map (
ip => pll_div2,
op => tnet0142,
reset => arst(0),
vdd_reg => vdd_reg,
sel => net0120,
div_ck_i => regdiv,
pwr_rst => arst(1),
div_ck => fb,
vco_ck => fb_ckn
);
x9 : n2_core_pll_inv_16x_cust port map (
vdd_reg => vdd,
o => l1clk_buf,
i => net0139
);
x1_1 : n2_core_pll_inv_8x_cust port map (
vdd_reg => vdd_reg,
o => arst(1),
i => net0164
);
x12 : n2_core_pll_pecl_enb_cust port map (
i => bypass_clk,
o => raw_clk_byp,
enb1 => ccu_serdes_dtm,
enb0 => pll_bypass_clk_en
);
x13 : n2_core_pll_inv_16x_cust port map (
vdd_reg => vdd_reg,
o => l1clk_n,
i => l1clk
);
x15 : n2_core_pll_buf_4x_cust port map (
vdd_reg => vdd,
o => net0139,
i => l1clk_l
);
x16 : n2_core_pll_vdd_xing_buf_32x_cust port map (
vdd_reg => vdd,
o => fb_ck,
i => fb_ckn
);
x17 : n2_core_pll_vdd_xing_buf_32x_cust port map (
vdd_reg => vdd,
o => ref_ck,
i => ref_ckn
);
x18 : n2_core_pll_vdd_xing_buf_4x_cust port map (
vdd_reg => vdd_reg,
o => net0164,
i => pll_arst_l
);
x19 : n2_core_pll_inv_16x_cust port map (
vdd_reg => vdd_reg,
o => l1clk_p,
i => l1clk_l
);
xpcl : n2_core_pll_pecl_cust port map (
vdd_reg => vdd_reg,
fb_ck => fb_ckn,
pecl_p => pll_sys_clk(0),
pecl_n => pll_sys_clk(1),
hdr_p => l1clk_p,
ref_ck => ref_ckn,
hdr_n => l1clk_n
);
xd1 : n2_core_pll_tpm_cust port map (
ip => pll_div1,
op => tnet0111,
reset => arst(1),
vdd_reg => vdd_reg,
sel => net0110,
div_ck_i => regdiv,
pwr_rst => arst(0),
div_ck => tref,
vco_ck => ref_ckn
); 
xil1clk_hdr : n2_core_pll_se2diff_mux_cust port map (
vdd_reg => vdd,
in1 => l2clk,
sel => testmode,
o => l1clk,
in0 => l2clkc,
out_l => l1clk_l
);
x1_0 : n2_core_pll_inv_8x_cust port map (
vdd_reg => vdd_reg,
o => arst(0),
i => net0164
);
ivg : imaginary_vco_gen port map (
pll_arst_l => pll_arst_l,
sysclk => tref,
fdbkclk => tfast,
div => tdiv,
vco_out => tfast
);
end architecture arch;

