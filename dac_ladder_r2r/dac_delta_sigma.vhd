----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:50:09 03/03/2021 
-- Design Name: 
-- Module Name:    dac_delta_sigma - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dac_delta_sigma is
Port (
clk : in  STD_LOGIC;
data : in  STD_LOGIC_VECTOR (7 downto 0);
PulseStream : out  STD_LOGIC
);
end dac_delta_sigma;

architecture Behavioral of dac_delta_sigma is
	signal sum : STD_LOGIC_VECTOR(8 downto 0) := (others=>'0');
begin
	PulseStream <= sum(8);
	p0 : process (clk,sum) is
	begin
		if (rising_edge(clk)) then
			sum <= ("0" & sum(7 downto 0)) + ("0" & data);
		end if;
	end process p0;
end Behavioral;
