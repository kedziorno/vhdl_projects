----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:02:40 04/23/2021 
-- Design Name: 
-- Module Name:    parity_detector - Behavioral 
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

entity parity_detector is
Generic (
	N : integer := 8
);
Port (
	x : in std_logic_vector(N-1 downto 0);
	y : out std_logic
);
end parity_detector;

architecture Behavioral of parity_detector is
	signal chain : std_logic_vector(N-1 downto 0);
begin
	chain(0) <= x(0);
	xor_chain : for i in 1 to N-1 generate
		chain(i) <= chain(i-1) xor x(i);
	end generate xor_chain;
	y <= chain(N-1);
end Behavioral;
