----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
<<<<<<< HEAD
-- Create Date:    20:56:44 09/07/2020 
=======
-- Create Date:    22:11:54 09/04/2020 
>>>>>>> add rest files , fix rebase conflicts
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
<<<<<<< HEAD

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
=======
use WORK.p_pkg1.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
>>>>>>> add rest files , fix rebase conflicts

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
<<<<<<< HEAD
Port(
clk : in STD_LOGIC;
rst : in STD_LOGIC;
sda : out STD_LOGIC;
sck : out STD_LOGIC
=======
port(
signal clk : in std_logic;
signal sda,scl : inout std_logic
>>>>>>> add rest files , fix rebase conflicts
);
end top;

architecture Behavioral of top is

<<<<<<< HEAD
component power_on is 
port
(
	signal clk,rst : in std_logic;
	signal sda,sck : out std_logic
);
end component power_on;

for all : power_on use entity WORK.power_on(Behavioral);

begin

c0 : power_on
port map
(
	clk => clk,
	rst => rst,
	sda => sda,
	sck => sck
);

end Behavioral;
=======
component test_oled is 
port
(
signal i_clk : in std_logic;
signal i_char : in array1;
signal io_sda,io_scl : inout std_logic
);
end component test_oled;

for all : test_oled use entity WORK.test_oled(Behavioral);

constant TEXT_LENGTH : integer := 26;
signal font_character : array1(0 to TEXT_LENGTH-1);
signal text : array1(0 to TEXT_LENGTH-1) := (x"4C",x"6F",x"52",x"65",x"4D",x"20",x"49",x"70",x"53",x"75",x"4D",x"20",x"64",x"4F",x"6C",x"4F",x"72",x"20",x"73",x"49",x"74",x"20",x"41",x"6D",x"45",x"74"); -- Lorem ipsum dolor sit amet

begin

c0 : test_oled
port map
(
	i_clk => clk,
	i_char => font_character,
	io_sda => sda,
	io_scl => scl
);

p0 : process (clk) is
begin
	if (rising_edge(clk)) then
		font_character <= text;
	end if;
end process p0;

end Behavioral;

>>>>>>> add rest files , fix rebase conflicts
