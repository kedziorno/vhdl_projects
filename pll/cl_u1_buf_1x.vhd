library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;
entity cl_u1_buf_1x is
port (
i : in bit;
o : out bit
);
end entity cl_u1_buf_1x;
architecture arch of cl_u1_buf_1x is
signal tti : std_logic_vector(0 downto 0);
signal tto : std_logic;
begin
tti(0) <= to_stdulogic(i);
b : BUF port map (O=>tto,I=>tti(0));
o <= to_bit(tto);
end architecture arch;

