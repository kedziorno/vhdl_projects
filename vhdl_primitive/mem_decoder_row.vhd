----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:59:12 04/25/2021 
-- Design Name: 
-- Module Name:    mem_decoder_row - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity mem_decoder_row is
Generic (
	constant C_DECODER_4x16_OUT : integer := 32
);
Port (
	signal decoder_row_input : in std_logic_vector(5-1 downto 0);
	signal decoder_row_output : out std_logic_vector(2**5-1 downto 0);
	e : in std_logic
);
end mem_decoder_row;

architecture Behavioral of mem_decoder_row is
	signal enable_a_row : std_logic_vector(1 downto 0);
	component D4_16E is port(D0:out std_logic;D1:out std_logic;D2:out std_logic;D3:out std_logic;D4:out std_logic;D5:out std_logic;D6:out std_logic;D7:out std_logic;D8:out std_logic;D9:out std_logic;D10:out std_logic;D11:out std_logic;D12:out std_logic;D13:out std_logic;D14:out std_logic;D15:out std_logic;A0:in std_logic;A1:in std_logic;A2:in std_logic;A3:in std_logic;E:in std_logic); end component D4_16E;
begin

enable_a_row(0) <= e and (not decoder_row_input(4));
enable_a_row(1) <= e and (decoder_row_input(4));

a : D4_16E
port map (
D0=>decoder_row_output(0),
D1=>decoder_row_output(1),
D2=>decoder_row_output(2),
D3=>decoder_row_output(3),
D4=>decoder_row_output(4),
D5=>decoder_row_output(5),
D6=>decoder_row_output(6),
D7=>decoder_row_output(7),
D8=>decoder_row_output(8),
D9=>decoder_row_output(9),
D10=>decoder_row_output(10),
D11=>decoder_row_output(11),
D12=>decoder_row_output(12),
D13=>decoder_row_output(13),
D14=>decoder_row_output(14),
D15=>decoder_row_output(15),
A0=>decoder_row_input(3),
A1=>decoder_row_input(2),
A2=>decoder_row_input(1),
A3=>decoder_row_input(0),
E=>enable_a_row(0));

b : D4_16E
port map (
D0=>decoder_row_output(16 + 0),
D1=>decoder_row_output(16 + 1),
D2=>decoder_row_output(16 + 2),
D3=>decoder_row_output(16 + 3),
D4=>decoder_row_output(16 + 4),
D5=>decoder_row_output(16 + 5),
D6=>decoder_row_output(16 + 6),
D7=>decoder_row_output(16 + 7),
D8=>decoder_row_output(16 + 8),
D9=>decoder_row_output(16 + 9),
D10=>decoder_row_output(16 + 10),
D11=>decoder_row_output(16 + 11),
D12=>decoder_row_output(16 + 12),
D13=>decoder_row_output(16 + 13),
D14=>decoder_row_output(16 + 14),
D15=>decoder_row_output(16 + 15),
A0=>decoder_row_input(3),
A1=>decoder_row_input(2),
A2=>decoder_row_input(1),
A3=>decoder_row_input(0),
E=>enable_a_row(1));

end Behavioral;
