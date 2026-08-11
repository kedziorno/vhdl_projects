entity fadd is
port (
cin : in bit;
a : in bit;
b : in bit;
s : out bit;
cout : out bit
);
end entity fadd;
architecture arch of fadd is
begin
s <= cin xor a xor b;
cout <= (cin and a) or (cin and b) or (a and b);
end architecture arch;

