----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:56:44 09/07/2020 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port(
clk : in STD_LOGIC;
reset : in STD_LOGIC;
sda : inout STD_LOGIC;
sck : inout STD_LOGIC
);
end top;

architecture Behavioral of top is

component power_on is 
port
(
	signal clk : in std_logic;
	signal reset : in std_logic;
	signal sda,sck : inout std_logic
);
end component power_on;

for all : power_on use entity WORK.power_on(Behavioral);

begin

c0 : power_on
port map
(
	clk => clk,
	reset => reset,
	sda => sda,
	sck => sck
);

p0 : process (clk) is
begin
	if (rising_edge(clk)) then
		-- 
	end if;
end process p0;

end Behavioral;
