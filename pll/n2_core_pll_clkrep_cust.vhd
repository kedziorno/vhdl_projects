entity n2_core_pll_clkrep_cust is
port (
pll_clk : in bit;
clk_dly3 : out bit;
clk_dly5 : out bit;
clk_dly4 : out bit;
clk_dly2 : out bit;
clk_dly1 : out bit
);
end entity n2_core_pll_clkrep_cust;
architecture arch of n2_core_pll_clkrep_cust is
--supply1 vdd;
--vss = '0';
signal tclk_dly3,tclk_dly5,tclk_dly4,tclk_dly2,tclk_dly1 : bit;
begin
tclk_dly1 <= pll_clk;
tclk_dly2 <= tclk_dly1;
tclk_dly3 <= tclk_dly2;
tclk_dly4 <= tclk_dly3;
tclk_dly5 <= tclk_dly4;
clk_dly1 <= tclk_dly1;
clk_dly2 <= tclk_dly2;
clk_dly3 <= tclk_dly3;
clk_dly4 <= tclk_dly4;
clk_dly5 <= tclk_dly5;
end architecture arch;

