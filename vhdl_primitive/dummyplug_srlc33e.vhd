----------------------------------------------------------------------------------
-- Company:         HomeDL
-- Engineer:        ko
--
-- Create Date:     16:52:19 08/09/2026
-- Design Name:     vhdl_primitive
-- Module Name:     dummyplug_srlc33e - Behavioral
-- Project Name:    -
-- Target Devices:  Xilinx Spartan 3E xc3s1200e
-- Tool versions:   ISE 14.7
-- Description:     Make longer SRL33 from twice SRL16 and one Flip-Flop (FD)
--
-- Dependencies:    -
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: TODO - check INIT order for hi/lo
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity dummyplug_srlc33e is
generic (
INIT : bit_vector (32 downto 0) := '0'&X"00000000"
);
port (
Q   : out STD_ULOGIC;
Q32 : out STD_ULOGIC;
A   : in STD_LOGIC_VECTOR (5 downto 0);
CE  : in STD_ULOGIC;
CLK : in STD_ULOGIC;
D   : in STD_ULOGIC
);
end entity dummyplug_srlc33e;

architecture behavioral of dummyplug_srlc33e is

signal q15_hi, q15_lo : std_logic;
signal mux, muxb : std_logic;
signal q32_i : std_logic;

begin

q <= q32_i when a (5) = '1' else mux when a (4) = '1' else muxb;
--q32 <= q32_i or q15_hi or q15_lo;
q32 <= q32_i;

srl33_i0 : FDCE
generic map (INIT => INIT (32))
port map (
  Q => q32_i,
  C => clk,
  CE => ce,
  CLR => '0',
  D => q15_hi
);

srlc16e_hi_i0 : SRLC16E
generic map (INIT => INIT (31 downto 16))
port map (
  Q   => mux,
  Q15 => q15_hi,
  A0  => a (0), A1 => a (1), A2 => a (2), A3 => a (3),
  CE  => ce,
  CLK => clk,
  D   => q15_lo
);

srlc16e_lo_i0 : SRLC16E
generic map (INIT => INIT (15 downto 0))
port map (
  Q   => muxb,
  Q15 => q15_lo,
  A0  => a (0), A1 => a (1), A2 => a (2), A3 => a (3),
  CE  => ce,
  CLK => clk,
  D   => d
);

end architecture behavioral;
