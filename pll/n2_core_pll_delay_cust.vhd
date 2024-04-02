entity n2_core_pll_delay_cust is
port (
vdd_reg : in bit;
out_delcr : out bit;
i : in bit;
out_del : out bit
);
end entity n2_core_pll_delay_cust;
architecture arch of n2_core_pll_delay_cust is
--supply1 vdd;
--vss = '0';
begin
out_del <= i after 1 ps;
out_delcr <= not i after 1 ps;
end architecture arch;

