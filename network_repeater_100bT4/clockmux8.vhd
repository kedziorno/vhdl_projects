----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:31:03 06/12/2021 
-- Design Name: 
-- Module Name:    clockmux8 - Behavioral 
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

entity clockmux8 is
port (
	areset : in std_logic;
	sreset : in std_logic;
	clk1 : in std_logic;
	clk2 : in std_logic;
	clk3 : in std_logic;
	clk4 : in std_logic;
	clk5 : in std_logic;
	clk6 : in std_logic;
	clk7 : in std_logic;
	clk8 : in std_logic;
	clk9 : in std_logic;
	sel1 : in std_logic;
	sel2 : in std_logic;
	sel3 : in std_logic;
	sel4 : in std_logic;
	sel5 : in std_logic;
	sel6 : in std_logic;
	sel7 : in std_logic;
	sel8 : in std_logic;
	sel9 : in std_logic;
	rxclk : out std_logic
);
end clockmux8;

architecture Behavioral of clockmux8 is

begin


end Behavioral;

