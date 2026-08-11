entity n2_core_pll_pecl_bypass_clk_cust is
port (
phase_ck : out bit;
pecl_p : in bit;
pecl_n : in bit
);
end entity n2_core_pll_pecl_bypass_clk_cust;
architecture arch of n2_core_pll_pecl_bypass_clk_cust is
--supply1 vdd;
begin
phase_ck <= pecl_p;
end architecture arch;

