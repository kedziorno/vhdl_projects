entity cl_u1_nand2_1x is
port (
in0 : in bit;
in1 : in bit;
o : out bit
);
end entity cl_u1_nand2_1x;
architecture arch of cl_u1_nand2_1x is
begin
o <= not (in0 and in1);
end architecture arch;

