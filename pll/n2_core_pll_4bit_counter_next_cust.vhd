entity n2_core_pll_4bit_counter_next_cust is
port (
q3 : in bit;
q0b : in bit;
q3b : in bit;
d3 : out bit;
q1b : in bit;
q2b : in bit;
d2 : out bit;
d0 : out bit;
q2 : in bit;
q0 : in bit;
q1 : in bit;
d1 : out bit
);
end entity n2_core_pll_4bit_counter_next_cust;
architecture arch of n2_core_pll_4bit_counter_next_cust is
--supply1 vdd;
signal vdd : bit;
signal net31,net34,net53 : bit;
component cl_u1_xnor2_4x is
port (
in0 : in bit;
in1 : in bit;
o : out bit
);
end component cl_u1_xnor2_4x;
component cl_u1_nor2_2x is
port (
in0 : in bit;
in1 : in bit;
o : out bit
);
end component cl_u1_nor2_2x;
component cl_u1_nor3_2x is
port (
in0 : in bit;
in1 : in bit;
in2 : in bit;
o : out bit
);
end component cl_u1_nor3_2x;
begin
vdd <= '1';
x2 : cl_u1_xnor2_4x port map (
o => d2,
in0 => q2b,
in1 => net34
);
x3 : cl_u1_xnor2_4x port map (
o => d3,
in0 => q3b,
in1 => net53
);
x4 : cl_u1_nor2_2x port map (
o => net31,
in1 => vdd,
in0 => q3
);
xi45 : cl_u1_nor2_2x port map (
o => net34,
in1 => q0,
in0 => q1
);
xi46 : cl_u1_nor3_2x port map (
o => net53,
in2 => q0,
in1 => q1,
in0 => q2
);
x0 : cl_u1_xnor2_4x port map (
o => d0,
in0 => q0b,
in1 => vdd
);
x1 : cl_u1_xnor2_4x port map (
o => d1,
in0 => q1b,
in1 => q0b
);
end architecture arch;

