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
rst : in STD_LOGIC;
--btn_1 : in STD_LOGIC;
sda : out STD_LOGIC;
scl : out STD_LOGIC
);
end top;

architecture Behavioral of top is

component power_on is 
port
(
	i_clock : in std_logic;
	i_reset : in std_logic;
--	i_button : in std_logic;
	o_sda : out std_logic;
	o_scl : out std_logic
);
end component power_on;
for all : power_on use entity WORK.power_on(Behavioral);

begin

c0 : power_on
port map
(
	i_clock => clk,
	i_reset => rst,
--	i_button => btn_1,
	o_sda => sda,
	o_scl => scl
);

end Behavioral;
