----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:32:23 08/08/2026 
-- Design Name: 
-- Module Name:    vga_7slices - Behavioral 
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

entity vga_7slices is
port (
i_clock : in std_logic;
i_reset : in std_logic;
o_hs : out std_logic;
o_hb : out std_logic
);
end entity vga_7slices;

architecture Behavioral of vga_7slices is

-- Based on https://www.fpgarelated.com/showarticle/42.php
signal a, b, c, d : std_logic;

begin

div99_1 : SRL16E
generic map (
INIT => "0000000100000000"
)
port map (
Q => a,       -- SRL data output
A0 => '1',     -- Select[0] input
A1 => '0',     -- Select[1] input
A2 => '1',     -- Select[2] input
A3 => '0',     -- Select[3] input
CE => '1',     -- Clock enable input
CLK => i_clock,   -- Clock input
D => not a -- SRL data input
);

div99_2 : SRL16E
generic map (
INIT => "0000010000000000"
)
port map (
Q => b,       -- SRL data output
A0 => '1',     -- Select[0] input
A1 => '1',     -- Select[1] input
A2 => '0',     -- Select[2] input
A3 => '0',     -- Select[3] input
CE => '1',     -- Clock enable input
CLK => a,   -- Clock input
D => not b -- SRL data input
);

o_hs <= c;
hs : SRLC32E
generic map (
INIT => "00111100000000000000000000000000"
)
port map (
Q => open,       -- SRL data output
Q31 => c,       -- SRL data output
A(0) => '0',     -- Select[0] input
A(1) => '0',     -- Select[1] input
A(2) => '0',     -- Select[2] input
A(3) => '0',     -- Select[3] input
A(4) => '0',     -- Select[3] input
CE => '1',     -- Clock enable input
CLK => b,   -- Clock input
D => not c -- SRL data input
);

o_hb <= d;
hb : SRLC32E
generic map (
INIT => "11111110000000000000000000000000"
)
port map (
Q => open,       -- SRL data output
Q31 => d,       -- SRL data output
A(0) => '0',     -- Select[0] input
A(1) => '0',     -- Select[1] input
A(2) => '0',     -- Select[2] input
A(3) => '0',     -- Select[3] input
A(4) => '0',     -- Select[3] input
CE => '1',     -- Clock enable input
CLK => b,   -- Clock input
D => not d -- SRL data input
);

end architecture Behavioral;
