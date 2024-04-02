entity n2_core_pll_cp_cust is
port (
slow_l : in bit;
vdd_reg : in bit;
slow : in bit;
fast : in bit;
fast_l : in bit;
fltr : out bit
);
end entity n2_core_pll_cp_cust;
architecture arch of n2_core_pll_cp_cust is
begin
end architecture arch;

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
out_del <= i after 1 ns;
out_delcr <= not i after 1 ns;
end architecture arch;

