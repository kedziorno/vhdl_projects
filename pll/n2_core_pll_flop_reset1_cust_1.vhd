entity n2_core_pll_flop_reset1_cust is
port(
reset_val_l : in bit;
d : in bit;
reset : in bit;
clk : in bit;
q_l : out bit;
q : out bit
);
end entity n2_core_pll_flop_reset1_cust;
architecture arch of n2_core_pll_flop_reset1_cust is
signal q : bit;
signal qb : bit;
begin
p0 : process (clk,reset) is
begin
	if (reset = '1') then
		q <= not reset_val_l;
	elsif (rising_edge(clk)) then
		q <= d;
	end if;
end process p0;
q_l <= not q;
end architecture arch;

