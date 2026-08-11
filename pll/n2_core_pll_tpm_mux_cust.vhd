entity n2_core_pll_tpm_mux_cust is
port (
opb : out bit;
vdd_reg : in bit;
op : out bit;
d0 : in bit;
d1 : in bit;
sel : in bit;
sel_b : in bit
);
end entity n2_core_pll_tpm_mux_cust;
architecture arch of n2_core_pll_tpm_mux_cust is
--vss = '0';
signal topb : bit;
begin
topb <= (not (sel and d1)) and (not (sel_b and d0));
opb <= topb;
op <= not topb;
end architecture arch;

