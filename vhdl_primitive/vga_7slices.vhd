----------------------------------------------------------------------------------
-- Company:         HomeDL
-- Engineer:        ko
--
-- Create Date:     19:32:23 08/08/2026
-- Design Name:     vhdl_primitve
-- Module Name:     vga_7slices - Behavioral
-- Project Name:    -
-- Target Devices:  Xilinx Spartan-3E (xc3s1200e)
-- Tool versions:   14.7 ISE
-- Description:     Ultra-compact VGA timing generator utilizing LUT as SRL
--                  (SRL16E (xc3, xc4), SRLC32E (xc5)), coprime phasing shift
--                  registers, and carry chain primitives. Based on
--                    Victor Yurkovsky's 7-Slice VGA Technique.
--                  https://www.fpgarelated.com/showarticle/42.php
--
-- Dependencies:    -
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: TODO - check MUXCY, move to Spartan-3E/Virtex-4
-- Currently VGA Horizontal signal timings (10 ns / 100 MHz):
--   - ALL/ONE - 31.68 us / 27.72 us
--   - SYNC - 3.96 us
--   - BP - 1.98 us
--   - FP - 0.99 us
--   - DATA / Between DATA - 24.75 us / 6.93 us
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity vga_7slices is
port (
  i_clock : in std_logic;
  i_reset : in std_logic;
  o_hs : out std_logic;
  o_hb : out std_logic
);
end entity vga_7slices;

architecture Behavioral of vga_7slices is

signal a, b, c, d : std_logic;

begin

div99_9bit : SRL16E
generic map (INIT => x"0001")
port map (
  Q   => a,
  A0  => '0', A1 => '0', A2 => '0', A3 => '1',
  CE  => '1',
  CLK => i_clock,
  D   => a
);

div99_11bit : SRL16E
generic map (INIT => x"0001")
port map (
  Q   => b,
  A0  => '0', A1 => '1', A2 => '0', A3 => '1',
  CE  => '1',
  CLK => a,
  D   => b
);

o_hs <= not c;
hs : entity work.dummyplug_srlc32e
generic map (INIT => "00111100000000000000000000000000")
port map (
  Q     => open,
  Q31   => c,
  A(0)  => '1', A(1) => '1', A(2) => '0', A(3) => '1', A(4) => '0',
  CE    => '1',
  CLK   => b,
  D     => c
);

o_hb <= not d;
hb : entity work.dummyplug_srlc32e
generic map (INIT => "11111110000000000000000000000000")
port map (
  Q     => open,
  Q31   => d,
  A(0)  => '0', A(1) => '0', A(2) => '0', A(3) => '0', A(4) => '0',
  CE    => '1',
  CLK   => b,
  D     => d
);

end architecture Behavioral;
