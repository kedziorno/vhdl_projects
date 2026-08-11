entity n2_core_pll_se2diff_mux_cust is
port (
vdd_reg : in bit;
in1 : in bit;
sel : in bit;
o : out bit;
in0 : in bit;
out_l : out bit
);
end entity n2_core_pll_se2diff_mux_cust;
architecture arch of n2_core_pll_se2diff_mux_cust is
--vss = '0';
signal ot : bit;
begin
ot <= in1 when sel = '1' else in0 when sel = '0';
o <= ot;
out_l <=  not ot;
end architecture arch;

