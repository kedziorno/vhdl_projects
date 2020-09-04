----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:11:54 09/04/2020 
-- Design Name: 
-- Module Name:    top - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
port(
signal clk : in std_logic;
signal sda,scl : inout std_logic
);
end top;

architecture Behavioral of top is

component test_oled is 
port
(
signal i_clk : in std_logic;
signal i_char : in std_logic_vector(11 downto 0);
signal io_sda,io_scl : inout std_logic
);
end component test_oled;

for all : test_oled use entity WORK.test_oled(Behavioral);

signal font_character : std_logic_vector(11 downto 0) := (others => '0');

begin

c0 : test_oled
port map
(
	i_clk => clk,
	i_char => font_character,
	io_sda => sda,
	io_scl => scl
);

font_character <= std_logic_vector(to_unsigned(325,font_character'length)); -- 'A'

end Behavioral;

