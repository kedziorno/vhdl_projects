----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:47:54 05/07/2021 
-- Design Name: 
-- Module Name:    sar_adc - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sar_adc is
Generic (
G_BOARD_CLOCK : integer := 50_000_00;
data_size : integer := 8
);
Port (
i_clock : in std_logic;
i_reset : in std_logic;
i_from_comparator : in std_logic;
i_catch : in std_logic;
o_catch : out std_logic;
io_ladder : inout std_logic_vector(data_size-1 downto 0);
o_data : out std_logic_vector(data_size-1 downto 0);
o_to_pluscomparator : out std_logic;
o_done : out std_logic
);
end sar_adc;

architecture Behavioral of sar_adc is

component succesive_approximation_register is
Generic (
n : integer := data_size
);
Port (
i_clock : in  STD_LOGIC;
i_reset : in  STD_LOGIC;
i_select : in  STD_LOGIC;
o_q : out  STD_LOGIC_VECTOR (n-1 downto 0);
o_end : inout  STD_LOGIC
);
end component succesive_approximation_register;

signal divclock : std_logic;
signal done : std_logic;
constant count_max : integer := G_BOARD_CLOCK;

begin

p0 : process (i_clock,i_reset) is
	variable count : integer range 0 to count_max-1 := 0;
begin
	if (i_reset = '1') then
		count := 0;
	elsif (rising_edge(i_clock)) then
		if (count = count_max-1) then
			count := 0;
			divclock <= '1';
		else
			count := count + 1;
			divclock <= '0';
		end if;
	end if;
end process p0;

--o_data <= io_ladder when done = '1' else (others => '0');
o_data <= io_ladder;
o_done <= done;
o_catch <= i_catch;

sar_entity : succesive_approximation_register
Generic map (n=>data_size)
--Port map (i_clock=>divclock,i_reset=>not i_from_comparator,i_select=>not i_from_comparator,o_q=>io_ladder,o_end=>done);
Port map (i_clock=>divclock,i_reset=>i_catch,i_select=>not i_from_comparator,o_q=>io_ladder,o_end=>done);

end Behavioral;
