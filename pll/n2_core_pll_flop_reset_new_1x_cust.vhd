entity n2_core_pll_flop_reset_new_1x_cust is
port (
vdd_reg : in bit;
reset_val_l : in bit;
d : in bit;
reset : in bit;
clk : in bit;
q_l : out bit;
q : out bit
);
end entity n2_core_pll_flop_reset_new_1x_cust;
architecture arch of n2_core_pll_flop_reset_new_1x_cust is
--vss = '0';
signal qq : bit;
begin
p0 : process(clk,reset) is
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

