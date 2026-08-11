entity n2_core_pll_vco_sum_cust is
port (
dc_clk : in bit;
volb : out bit;
vdd_reg : in bit;
slow : in bit;
slow_l : in bit;
fast : in bit;
fltr : in bit;
fast_l : in bit
);
end entity n2_core_pll_vco_sum_cust;
architecture arch of n2_core_pll_vco_sum_cust is
begin
volb <= fast;
end architecture arch;

