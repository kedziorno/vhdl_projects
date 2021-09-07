entity decode is
port (
a : in bit_vector(1 downto 0);
d : out bit_vector(3 downto 0)
);
end entity decode;
architecture arch of decode is
begin
p0 : process (a) is
begin
  case (a) is
		when "00" => d <= "0001";
		when "01" => d <= "0010";
		when "10" => d <= "0100";
		when "11" => d <= "1000";
  end case;
end process p0;
end architecture arch;

