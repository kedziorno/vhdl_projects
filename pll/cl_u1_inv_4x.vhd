entity cl_u1_inv_4x is
port (
i : in bit;
o : out bit
);
end entity cl_u1_inv_4x;
architecture arch of cl_u1_inv_4x is
begin
o <= not i;
end architecture arch;

