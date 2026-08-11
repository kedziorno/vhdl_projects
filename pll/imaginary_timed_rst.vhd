library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity imaginary_timed_rst is
port (
ref : in bit;
vco_clk : in bit;
pll_div2 : in bit_vector(5 downto 0);
pll_arst_l : in bit;
timed_pll_arst_l : out bit
);
end entity imaginary_timed_rst;
architecture arch of imaginary_timed_rst is
signal t0_pll_arst_l,t1_pll_arst_l,ref_q,ref_pulse : bit;
signal cnt : unsigned(2 downto 0);
begin
p0 : process (ref,pll_arst_l) is
begin
if (pll_arst_l = '0') then
cnt <= (others => '0');
elsif (ref'event and ref = '1') then
if (cnt = "101") then
cnt <= "101";
else 
cnt <= cnt + "1";		
end if;
end if;
end process p0;
p1 : process (vco_clk,pll_arst_l) is
begin
if (pll_arst_l = '0') then
ref_q <= '0';
ref_pulse <= '0';
elsif (vco_clk'event and vco_clk = '0') then
ref_q <= ref; 
ref_pulse <= not ref_q and ref;
end if;
end process p1;
p2 : process (vco_clk,pll_arst_l) is
begin
if (pll_arst_l = '0') then
t0_pll_arst_l <= '0';
elsif (vco_clk'event and vco_clk = '1') then
if (cnt /= "101") then 
t0_pll_arst_l <= '0';
elsif (ref_pulse = '1') then
t0_pll_arst_l <= '1';
else
t0_pll_arst_l <= t0_pll_arst_l;
end if;
end if;
end process p2;
p3 : process (vco_clk,pll_arst_l) is
begin
if (pll_arst_l = '0') then
t1_pll_arst_l <= '0';
elsif (vco_clk'event and vco_clk = '1') then
t1_pll_arst_l <= t0_pll_arst_l;
end if;
end process p3;
timed_pll_arst_l <= t0_pll_arst_l when pll_div2(0) = '1' else t1_pll_arst_l;  
end architecture arch; 

