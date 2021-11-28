----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:10:49 11/28/2021 
-- Design Name: 
-- Module Name:    ic_74hct32 - Behavioral 
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

entity ic_74hct32 is
port (
	i_1a,i_1b : in std_logic;
	o_1y : out std_logic;
	i_2a,i_2b : in std_logic;
	o_2y : out std_logic;
	i_3a,i_3b : in std_logic;
	o_3y : out std_logic;
	i_4a,i_4b : in std_logic;
	o_4y : out std_logic
);
end ic_74hct32;

architecture Behavioral of ic_74hct32 is

	component ic_74hct32_onegate is
		port (
			signal i_A,i_B : in std_logic;
			signal o_Y : out std_logic
		);
	end component ic_74hct32_onegate;
	for all : ic_74hct32_onegate use entity WORK.ic_74hct32_onegate(Behavioral);

begin

	u1 : ic_74hct32_onegate port map (i_A => i_1a, i_B => i_1b, o_Y => o_1y);
	u2 : ic_74hct32_onegate port map (i_A => i_2a, i_B => i_2b, o_Y => o_2y);
	u3 : ic_74hct32_onegate port map (i_A => i_3a, i_B => i_3b, o_Y => o_3y);
	u4 : ic_74hct32_onegate port map (i_A => i_4a, i_B => i_4b, o_Y => o_4y);

end Behavioral;
