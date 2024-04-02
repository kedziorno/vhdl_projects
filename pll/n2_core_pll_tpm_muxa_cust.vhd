entity n2_core_pll_tpm_muxa_cust is
port (
opb : out bit;
op : out bit;
d0 : in bit;
d1 : in bit;
sel : in bit;
sel_b : in bit
);
end entity n2_core_pll_tpm_muxa_cust;
architecture arch of n2_core_pll_tpm_muxa_cust is
--supply1 vdd;
--vss = '0';
component mux2 is
port (
in0,in1,sel0,sel1 : in bit;
y : out bit
);
end component mux2;
signal top : bit;
begin
x1 : mux2 port map (
sel0 => sel_b,
sel1 => sel,
in0 => d0,
in1 => d1,
y => top
);
op <= top;
opb <= not top;
end architecture arch;

