entity cl_u1_inv_2x is
port (
i : in bit;
o : out bit
);
end entity cl_u1_inv_2x;
architecture arch of cl_u1_inv_2x is
begin
o <= not i;
end architecture arch;

