entity n2_core_pll_nand2_2x_cust is
port (
vdd_reg : in bit;
o : out bit;
in1 : in bit;
in0 : in bit
);
end entity n2_core_pll_nand2_2x_cust;
architecture arch of n2_core_pll_nand2_2x_cust is
--vss = '0';
begin
o <= not (in0 and in1);
end architecture arch;

