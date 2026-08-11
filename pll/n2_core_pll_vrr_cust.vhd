entity n2_core_pll_vrr_cust is
port(
vdd_reg : in bit;
fltr_nw : inout bit;
reset : in bit;
fb : in bit;
div8 : in bit;
div4 : in bit;
div_ck : in bit;
vrr_disbl : in bit;
clamp_fltr : in bit;
pfd_reset : in bit
);
end entity n2_core_pll_vrr_cust;
architecture arch of n2_core_pll_vrr_cust is
--vss = '0';
begin
end architecture arch;

