library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;
entity n2_core_pll_bufi_4x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end entity n2_core_pll_bufi_4x_cust;
architecture arch of n2_core_pll_bufi_4x_cust is
--vss = '0';
signal tti : std_logic_vector(0 downto 0);
signal tto : std_logic;
begin
tti(0) <= to_stdulogic(i);
bufinst : BUF port map (O => tto,I => tti(0));
o <= to_bit(tto);
end architecture arch;

