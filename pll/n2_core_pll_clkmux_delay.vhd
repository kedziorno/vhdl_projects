entity n2_core_pll_clkmux_delay is
port (
pll_sdel : in bit_vector(1 downto 0);
mux_out : out bit;
d : in bit
);
end entity n2_core_pll_clkmux_delay;
architecture arch of n2_core_pll_clkmux_delay is
component decode is
port (
a : in bit_vector(1 downto 0);
d : out bit_vector(3 downto 0)
);
end component decode;
component mux4
generic (SIZE : integer := 1);
port (
dout : out bit_vector(SIZE-1 downto 0);
in0 : in bit_vector(SIZE-1 downto 0);
in1 : in bit_vector(SIZE-1 downto 0);
in2 : in bit_vector(SIZE-1 downto 0);
in3 : in bit_vector(SIZE-1 downto 0);
sel0 : in bit;
sel1 : in bit;
sel2 : in bit;
sel3 : in bit;
muxtst : in bit
);
end component mux4;
--supply1 vdd;
--vss = '0';
signal sel : bit_vector(3 downto 0);
signal d0, d1, d2, d3, tmux_out : bit_vector(0 downto 0);
begin
mux_out <= tmux_out(0);
d0(0) <= d after 40 ps;
d1(0) <= d0(0) after 40 ps;
d2(0) <= d1(0) after 40 ps;
d3(0) <= d2(0) after 40 ps;
x0 : decode port map (
a => pll_sdel(1 downto 0),
d => sel(3 downto 0)
);
x1 : mux4 port map (
muxtst => '0',
sel0 => sel(0),
sel1 => sel(1),
sel2 => sel(2),
sel3 => sel(3),
in0 => d0,
in1 => d1,
in2 => d2,
in3 => d3,
dout => tmux_out
);
end architecture arch;

