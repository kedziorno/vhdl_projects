entity n2_core_pll_xnor2_4x_new_cust is
port (
vdd_reg : in bit;
o : out bit;
in0 : in bit;
in1 : in bit
);
end entity n2_core_pll_xnor2_4x_new_cust;
architecture arch of n2_core_pll_xnor2_4x_new_cust is
--vss = '0';
begin
o <= not (in0 xor in1);
end architecture arch;

