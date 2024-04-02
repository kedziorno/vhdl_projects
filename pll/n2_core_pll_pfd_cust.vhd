entity n2_core_pll_pfd_cust is
port (
vdd_reg : in bit;
f_buf : out bit;
f_buf_l : out bit;
fast_l : out bit;
clamp_fltr : in bit;
s_buf : out bit;
s_buf_l : out bit;
slow_l : out bit;
slow : out bit;
fast : out bit;
pfd_reset : out bit;
fb : in bit;
ref : in bit
);
end entity n2_core_pll_pfd_cust;
architecture arch of n2_core_pll_pfd_cust is
begin
end architecture arch;

