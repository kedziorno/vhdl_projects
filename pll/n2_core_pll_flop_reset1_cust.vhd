entity n2_core_pll_flop_reset1_cust is
port (
reset_val_l : in bit;
d : in bit;
reset : in bit;
clk : in bit;
q_l : out bit;
q : out bit
);
end entity n2_core_pll_flop_reset1_cust;
architecture arch of n2_core_pll_flop_reset1_cust is
--supply1 vdd;
signal qq,qb : bit;
begin
--p0 : process (clk,d,reset) is
--begin
--	if (reset = '1') then
--		qb <= not reset_val_l;
--	elsif (clk = '0') then
--		qb <= d;
--	end if;
--end process p0;
--p1 : process (clk,reset) is
--begin
--	if (reset = '1') then
--		q <= not reset_val_l;
--	elsif (clk = '1') then
--		q <= qb;
--	end if;
--end process p1;
p0 : process (clk,reset) is
begin
	if (reset = '1') then
		qq <= not reset_val_l;
	elsif (clk'event and clk = '1') then
		qq <= d;
	end if;
end process p0;
q <= qq;
q_l <= not qq;
end architecture arch;

