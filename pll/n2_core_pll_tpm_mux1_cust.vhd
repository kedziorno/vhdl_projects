entity n2_core_pll_tpm_mux1_cust is
port (
sel_l : in bit;
vdd_reg : in bit;
out_l : out bit;
d0 : in bit;
d1 : in bit;
sel : in bit
);
end entity n2_core_pll_tpm_mux1_cust;
architecture arch of n2_core_pll_tpm_mux1_cust is
--vss = '0';
component mux2s
generic (SIZE : integer := 1);
port (
dout : out bit_vector(SIZE-1 downto 0);
in0 : in bit_vector(SIZE-1 downto 0);
in1 : in bit_vector(SIZE-1 downto 0);
sel0 : in bit;
sel1 : in bit
);
end component mux2s;
signal td0,td1,tdout : bit_vector(0 downto 0);
begin
td0(0) <= d0;
td1(0) <= d1;
x1 : mux2s port map (
sel0 => sel_l,
sel1 => sel,
in0 => td0,
in1 => td1,
dout => tdout
);
out_l <= not tdout(0);
end architecture arch;
--XXX check
