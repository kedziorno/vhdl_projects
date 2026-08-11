entity n2_core_pll_pecl_cust is
port (
vdd_reg : in bit;
fb_ck : out bit;
pecl_p : in bit;
pecl_n : in bit;
hdr_p : in bit;
ref_ck : out bit;
hdr_n : in bit
);
end entity n2_core_pll_pecl_cust;
architecture arch of n2_core_pll_pecl_cust is
--vss = '0';
begin
ref_ck <= pecl_p;
fb_ck <= hdr_p;
end architecture arch;

