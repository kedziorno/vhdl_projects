entity n2_core_pll_and2_16x_cust is
port (
o : out bit;
in1,in0 : in bit
);
end entity n2_core_pll_and2_16x_cust;
architecture arch of n2_core_pll_and2_16x_cust is
--supply1 vdd;
--vss = '0';
begin
o <= in0 and in1;
end architecture arch;

