entity n2_core_pll_vdd_xing_buf_32x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end entity n2_core_pll_vdd_xing_buf_32x_cust;
architecture arch of n2_core_pll_vdd_xing_buf_32x_cust is
--vss = '0';
begin
o <= i;
end architecture arch;

