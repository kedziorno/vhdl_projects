entity n2_core_pll_flopderst_16x_cust is
port (
q_l : out bit;
reset_val : in bit;
d : in bit;
q : out bit;
reset : in bit;
clk : in bit;
ena : in bit
);
end entity n2_core_pll_flopderst_16x_cust;
architecture arch of n2_core_pll_flopderst_16x_cust is
signal qb_p,qb_n,qq : bit;
begin
p0 : process (clk,d,reset,reset_val) is
begin
if (reset = '1') then
qb_p <= reset_val;
elsif (clk'event and clk = '1') then
qb_p <= d;
end if;
end process p0;
p1 : process (clk,d,reset,reset_val) is
begin
if (reset = '1') then
qb_n <= reset_val;
elsif (clk'event and clk = '0') then
qb_n <= d;
end if;
end process p1;
p2 : process (clk,reset,ena,reset_val) is
begin
if (reset = '1') then
qq <= reset_val;
elsif (clk = '1' and ena = '1') then -- XXX
qq <= qb_n;
elsif (clk = '0' and ena = '0') then -- XXX
qq <= qb_p;
end if;
end process p2;
q <= qq;
q_l <= not qq;
end architecture arch;

