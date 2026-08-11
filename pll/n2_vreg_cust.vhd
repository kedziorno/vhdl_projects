entity n2_vreg_cust is
port (
v1p1reg_lowv : out bit;
vdd_hv15 : in bit;
vref : out bit;
vrefb : out bit;
i50n : out bit_vector(9 downto 0);
selbg_l : in bit
);
end entity n2_vreg_cust;
architecture arch of n2_vreg_cust is
begin
--vss = '0';
v1p1reg_lowv <= '1';
i50n <= (others => '0');
vref <= '1';
vrefb <= '1';
end architecture arch;

