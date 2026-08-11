entity n2_core_pll_tpm_gate2_cust is
port (
vdd_reg : in bit;
div_ck  : out bit;
r : in bit;
ck : in bit
);
end entity n2_core_pll_tpm_gate2_cust;
architecture arch of n2_core_pll_tpm_gate2_cust is
--vss = '0';
begin
p0 : process (ck,r) is
begin
	if (ck = '1') then
		div_ck <= not r;
	end if;
end process p0;
end architecture arch;

