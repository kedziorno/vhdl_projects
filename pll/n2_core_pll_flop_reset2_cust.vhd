library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity n2_core_pll_flop_reset2_cust is
port (
d : in bit;
clk : in bit;
q_l : out bit;
q : out bit
);
end entity n2_core_pll_flop_reset2_cust;
architecture arch of n2_core_pll_flop_reset2_cust is
--supply1 vdd;
signal qq,q_b : bit;
begin
p0 : process (clk,d) is
begin
if (clk = '0') then
q_b <= d;
else
q_b <= q_b;
end if;
end process p0;
p1 : process (clk) is
begin
if (clk = '1') then
qq <= q_b;
else
qq <= qq;
end if;
end process p1;
q <= qq;
q_l <= not qq;
--p0 : process (clk) is
--begin
--if (rising_edge(clk)) then
--q <= d;
--end if;
--end process p0;
end architecture arch;

