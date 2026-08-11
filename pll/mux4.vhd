entity mux4 is
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
end entity mux4;
architecture arch of mux4 is
signal sel : bit_vector(4 downto 0);
begin
sel <= (muxtst,sel3,sel2,sel1,sel0);
p0 : process (sel,in0,in1,in2,in3) is
begin
	case (sel) is --XXX 0st sel is '-'
  	when "00001" => dout <= in0;
    when "00010" => dout <= in1;
    when "00100" => dout <= in2;
    when "01000" => dout <= in3;
    when "00000" => dout <= (others => '1');
		when others => dout <= (others => '0'); --XXX X
	end case;
end process p0;
end architecture arch;

