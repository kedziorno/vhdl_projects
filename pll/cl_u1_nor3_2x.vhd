entity cl_u1_nor3_2x is
port (
in0 : in bit;
in1 : in bit;
in2 : in bit;
o : out bit
);
end entity cl_u1_nor3_2x;
architecture arch of cl_u1_nor3_2x is
begin
o <= not (in0 or in1 or in2);
end architecture arch;

