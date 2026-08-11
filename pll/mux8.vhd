entity mux8 is
generic (SIZE : integer := 1);
port (
dout : out bit_vector(SIZE-1 downto 0);
in0 : in bit_vector(SIZE-1 downto 0);
in1 : in bit_vector(SIZE-1 downto 0);
in2 : in bit_vector(SIZE-1 downto 0);
in3 : in bit_vector(SIZE-1 downto 0);
in4 : in bit_vector(SIZE-1 downto 0);
in5 : in bit_vector(SIZE-1 downto 0);
in6 : in bit_vector(SIZE-1 downto 0);
in7 : in bit_vector(SIZE-1 downto 0);
sel0 : in bit;
sel1 : in bit;
sel2 : in bit;
sel3 : in bit;
sel4 : in bit;
sel5 : in bit;
sel6 : in bit;
sel7 : in bit;
muxtst : in bit
);
end entity mux8;
architecture arch of mux8 is
signal sel : bit_vector(8 downto 0);
begin
sel <= (muxtst,sel7,sel6,sel5,sel4,sel3,sel2,sel1,sel0);
p0 : process (sel,in0,in1,in2,in3,in4,in5,in6,in7) is
begin
	case (sel) is --XXX sel 1st '-'
		when "000000001" => dout <= in0;
		when "000000010" => dout <= in1;
		when "000000100" => dout <= in2;
		when "000001000" => dout <= in3;
		when "000010000" => dout <= in4;
		when "000100000" => dout <= in5;
		when "001000000" => dout <= in6;
		when "010000000" => dout <= in7;
		when "000000000" => dout <= (others => '1');
		when others => dout <= (others => '0'); --XXX X
	end case;
end process p0;
end architecture arch;
