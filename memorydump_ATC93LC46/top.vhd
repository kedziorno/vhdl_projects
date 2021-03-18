----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:40:48 03/18/2021 
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
Port (
	i_clock : in  STD_LOGIC;
	i_reset : in  STD_LOGIC;
	o_cs : out  STD_LOGIC;
	o_sk : out  STD_LOGIC;
	o_di : out  STD_LOGIC;
	i_do : in  STD_LOGIC;
	o_RsTx : out  STD_LOGIC
);
end top;

architecture Behavioral of top is

begin

end Behavioral;
