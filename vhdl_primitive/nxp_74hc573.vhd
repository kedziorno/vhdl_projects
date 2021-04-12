----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:01:44 04/12/2021 
-- Design Name: 
-- Module Name:    nxp_74hc573 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity nxp_74hc573 is
generic (
nbit : integer := 8
);
port (
i_le : in std_logic;
i_oeb : in std_logic;
i_d : in std_logic_vector(nbit-1 downto 0);
o_q : out std_logic_vector(nbit-1 downto 0)
);
end nxp_74hc573;

architecture Behavioral of nxp_74hc573 is

signal d : std_logic_vector(nbit-1 downto 0);
signal q : std_logic_vector(nbit-1 downto 0);

begin

IBUF_generate : for i in 0 to nbit-1 generate
begin
IBUF_inst : IBUF
port map (O => d(i),I => i_d(i));
end generate IBUF_generate;

LDCE_generate : for i in 0 to nbit-1 generate
begin
LDCE_inst : LDCE
port map (Q => q(i),CLR => '0',D => d(i),G => d(i),GE => not i_le);
end generate LDCE_generate;

OBUFT_generate : for i in 0 to nbit-1 generate
begin
OBUFT_inst : OBUFT
port map (O => o_q(i),I => q(i),T => not i_oeb);
end generate OBUFT_generate;

end Behavioral;

