entity imaginary_vco_gen is
port (
pll_arst_l : in bit;
sysclk : in bit;
fdbkclk : in bit;
div : in bit_vector(5 downto 0);
vco_out : out bit
); 
end entity imaginary_vco_gen;
architecture arch of imaginary_vco_gen is
signal div_lat : bit_vector(5 downto 0);
signal rst_lat,sysclk_gated : bit;
signal aaa : bit;
component pll_core is
port (
pll_arst_l : in bit;
sysclk : in bit;
fdbkclk : in bit;
div : in bit_vector(5 downto 0);
vco_out : out bit
);
end component pll_core;
begin
aaa <= not pll_arst_l;
p0 : process (pll_arst_l,div) is
begin
	if (aaa = '1') then -- XXX not
		div_lat <= div;
	end if;
end process p0;
--p1 : process (pll_arst_l,sysclk) is
--begin
--	if (not sysclk) then
--		rst_lat <= pll_arst_l;
--	end if;
--end process p1;
--sysclk_gated <= rst_lat and sysclk;
sysclk_gated <= sysclk;
pllc : pll_core port map (
pll_arst_l => pll_arst_l,
sysclk => sysclk_gated,
fdbkclk => fdbkclk,
div => div_lat,
vco_out => vco_out 
);
end architecture arch;

