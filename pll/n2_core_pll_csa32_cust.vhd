entity n2_core_pll_csa32_cust is
port (
in0 : in bit;
sum : out bit;
in0_l : in bit;
carry : out bit;
in2 : in bit;
in1 : in bit
);
end entity n2_core_pll_csa32_cust;
architecture arch of n2_core_pll_csa32_cust is
component fadd is
port (
cin : in bit;
a : in bit;
b : in bit;
s : out bit;
cout : out bit
);
end component fadd;
begin
x1 : fadd port map (
cin => in0,
a => in1,
b => in2,
s => sum,
cout => carry
);
end architecture arch;

