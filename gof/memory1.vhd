----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:07:54 10/27/2020 
-- Design Name: 
-- Module Name:    memory1 - Behavioral 
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
use WORK.p_memory_content.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory1 is
Generic (
W_BITS : integer := 7;
H_BITS : integer := 2;
BYTE_SIZE : integer := 8);
Port (
i_clk : in std_logic;
i_x : in std_logic_vector(W_BITS-1 downto 0);
i_y : in std_logic_vector(H_BITS-1 downto 0);
o_byte : out std_logic_vector(BYTE_SIZE-1 downto 0));
end memory1;

architecture Behavioral of memory1 is
	signal m1 : MEMORY := memory_content;
begin
	p0 : process(i_clk) is
	begin
		if (rising_edge(i_clk)) then
			o_byte <= m1(to_integer(unsigned(i_x)))((to_integer(unsigned(i_y))*BYTE_SIZE)+(BYTE_SIZE-1) downto (to_integer(unsigned(i_y))*BYTE_SIZE));
		end if;
	end process p0;
end Behavioral;
