entity n2_core_pll_ckmux_mxdel_diffout_cust is
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
end entity n2_core_pll_ckmux_mxdel_diffout_cust;
architecture arch of n2_core_pll_ckmux_mxdel_diffout_cust is
--supply1 vdd;
--vss = '0';
component mux4k is
generic (SIZE : integer := 1);
port (
dout : out bit_vector(SIZE-1 downto 0);
in0 : in bit_vector(SIZE-1 downto 0);
in1 : in bit_vector(SIZE-1 downto 0);
in2 : in bit_vector(SIZE-1 downto 0);
in3 : in bit_vector(SIZE-1 downto 0);
sel0 : in bit;
sel1 : in bit;
sel2 : in bit;
sel3 : in bit;
muxtst : in bit
);
end component mux4k;
component n2_core_pll_clkmux_delay is
port (
pll_sdel : in bit_vector(1 downto 0);
mux_out : out bit;
d : in bit
);
end component n2_core_pll_clkmux_delay;
signal tin0,tin1,tin2,tin3,tcktree_drv : bit_vector(0 downto 0);
begin
tin0(0) <= pll1_clk;
d1_clk <= tin1(0);
tin2(0) <= pll2_clk;
tin3(0) <= bypass_clk;
cktree_drv <= tcktree_drv(0);
x1 : mux4k port map (
muxtst => '0',
in0 => tin0,
in1 => tin1,
in2 => tin2,
in3 => tin3,
sel0 => sel0,
sel1 => sel1,
sel2 => sel2,
sel3 => sel3,
dout => tcktree_drv
);
x0 : n2_core_pll_clkmux_delay port map (
pll_sdel => pll_sdel,
mux_out => tin1(0),
d => pll1_clk
);
cktree_drv_l <= not tcktree_drv(0);
ckt_drv_int <= tcktree_drv(0);
end architecture arch;

