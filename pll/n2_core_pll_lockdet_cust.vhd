entity n2_core_pll_lockdet_cust is
port (
pll_jtag_lock_everlose : out bit;
l1clk : in bit;
pll_lock_dyn : out bit;
reset_in : in bit;
slow : in bit;
fast : in bit;
pll_lock_pulse : out bit;
ref_ck : in bit
);
end entity n2_core_pll_lockdet_cust;
architecture arch of n2_core_pll_lockdet_cust is
--supply1 vdd;
begin
end architecture arch;

