entity n2_core_pll_fse2diff_out_cust is
port (
vdd_reg : in bit;
i : in bit;
out_l : out bit;
o : out bit
);
end entity n2_core_pll_fse2diff_out_cust;
architecture arch of n2_core_pll_fse2diff_out_cust is
--vss = '0';
begin
o <= i;
out_l <= not i;
end architecture arch;

