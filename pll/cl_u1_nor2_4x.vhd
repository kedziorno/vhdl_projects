entity cl_u1_nor2_4x is
port (
in0 : in bit;
in1 : in bit;
o : out bit
);
end entity cl_u1_nor2_4x;
architecture arch of cl_u1_nor2_4x is
begin
o <= not (in0 or in1);
end architecture arch;

