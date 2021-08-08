entity n2_core_pll_tpm_gate_new_cust is
port (
r_b : in bit;
vdd_reg : in bit;
div_ck : out bit;
r : in bit;
ck : in bit;
f : in bit
);
end entity n2_core_pll_tpm_gate_new_cust;
architecture arch of n2_core_pll_tpm_gate_new_cust is
--vss = '0';
signal tdiv_ck : bit;
begin
div_ck <= tdiv_ck;
p0 : process (ck,r,f,tdiv_ck) is
begin
if ((ck = '1') and (r = '1')) then
tdiv_ck <= '1';
elsif ((ck = '1') and (f = '0')) then
tdiv_ck <= '0';
elsif ((ck = '1') and (r = '0') and (tdiv_ck = '1')) then
tdiv_ck <= '0';
else
tdiv_ck <= tdiv_ck;
end if;
end process p0;
end architecture arch;

