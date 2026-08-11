entity n2_core_pll_nand4_4x_cust is
port (
in3 : in bit;
o : out bit;
in2 : in bit;
in1 : in bit;
in0 : in bit
);
end entity n2_core_pll_nand4_4x_cust;
architecture arch of n2_core_pll_nand4_4x_cust is
--supply1 vdd;
--vss = '0';
begin
o <= not (in0 and in1 and in2 and in3);
end architecture arch;

