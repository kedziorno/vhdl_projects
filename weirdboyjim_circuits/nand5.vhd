----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:15:59 12/07/2021 
-- Design Name: 
-- Module Name:    nand5 - Behavioral 
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

entity my_nand5 is
port (
	signal a,b,c,d,e : in std_logic;
	signal f : out std_logic
);
end my_nand5;

architecture Behavioral of my_nand5 is

	component my_lut5 is
	generic (
		init : std_logic_vector(0 to 31) := "00000000000000000000000000000000"
	);
	port (
		signal i0,i1,i2,i3,i4 : in std_logic;
		signal o : out std_logic
	);
	end component my_lut5;
	for all : my_lut5 use entity WORK.my_lut5(Behavioral_3);

begin

	uut3 : my_lut5
	GENERIC MAP (init => "01111111111111111111111111111111")
	PORT MAP (
		i0 => a,
		i1 => b,
		i2 => c,
		i3 => d,
		i4 => e,
		o => f
	);

end Behavioral;
