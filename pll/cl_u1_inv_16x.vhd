entity cl_u1_inv_16x is
port (
i : in bit;
o : out bit
);
end entity cl_u1_inv_16x;
architecture arch of cl_u1_inv_16x is
begin
o <= not i;
end architecture arch;

