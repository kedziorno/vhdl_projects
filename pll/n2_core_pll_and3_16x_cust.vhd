entity n2_core_pll_and3_16x_cust is
port (
o : out bit;
in2 : in bit;
in1 : in bit;
in0 : in bit
);
end entity n2_core_pll_and3_16x_cust;
architecture arch of n2_core_pll_and3_16x_cust is
--supply1 vdd;
--vss = '0';
begin
o <= (in0 and in1 and in2);
end architecture arch;

