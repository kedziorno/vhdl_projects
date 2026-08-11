entity mux2 is
port (
in0,in1,sel0,sel1 : in bit;
y : out bit
);
end entity mux2;
architecture arch of mux2 is
begin
p0 : process (sel0,sel1,in0,in1) is
variable t : bit_vector(1 downto 0);
begin
t := (sel1,sel0);
case (t) is
	when "01" =>
		y <= in0;
	when "10" =>
		y <= in1;
	when others => null;
end case;
end process p0;
end architecture arch;

