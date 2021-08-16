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
--G_BOARD_CLOCK : integer := 5_000_000;
G_BOARD_CLOCK : integer := 200_000;
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
o_end : out  STD_LOGIC
);
end component succesive_approximation_register;

signal divclock : std_logic;
signal done : std_logic;
constant count_max : integer := G_BOARD_CLOCK;

--constant ccount : integer := 2**data_size;
--signal count : integer range 0 to ccount-1 := 0;

signal ladder : std_logic_vector(data_size-1 downto 0);

begin

p0 : process (i_clock,i_reset) is
	variable count : integer range 0 to count_max-1 := 0;
begin
	if (i_reset = '1') then
		count := 0;
		divclock <= '0';
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

--p1 : process (divclock,i_reset,andgate) is
--begin
--	if (i_reset = '1') then
--		count <= 0;
--	elsif (rising_edge(divclock)) then
--		if (andgate = '1') then
--			if (count = ccount-1) then
--				count <= 0;
--			else
--				count <= count + 1;
--			end if;
--		end if;
--		if (andgate = '0') then
--			if (count = 0) then
--				count <= ccount-1;
--			else
--				count <= count - 1;
--			end if;
--		end if;
--		io_ladder <= std_logic_vector(to_unsigned(count,data_size));
--	end if;
--end process p1;

--o_data <= io_ladder when done = '1' else (others => '0');
o_data <= io_ladder;
o_done <= done;
o_catch <= i_catch;

sar_entity : succesive_approximation_register
Generic map (n=>data_size)
Port map (i_clock=>divclock,i_reset=>not i_reset,i_select=>not i_from_comparator,o_q=>ladder,o_end=>done);
io_ladder <= ladder;
end Behavioral;
