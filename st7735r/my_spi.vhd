----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:12:21 06/13/2021 
-- Design Name: 
-- Module Name:    my_spi - Behavioral 
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
use WORK.p_package.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity my_spi is
port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	i_enable : in std_logic;
	i_data_byte : in std_logic_vector(BYTE_SIZE-1 downto 0);
	o_cs : out std_logic;
	o_do : out std_logic;
	o_ck : inout std_logic
);
end my_spi;

architecture Behavioral of my_spi is
	signal clock_divider : std_logic;
begin
	o_cs <= '0' when i_enable = '1' else '1';

	p0 : process (i_clock,i_reset) is
		variable clock_counter : integer range 0 to C_CLOCK_COUNTER - 1 := 0;
	begin
		if (i_reset = '1') then
			clock_counter := 0;
			clock_divider <= '0';
		elsif (rising_edge(i_clock)) then
			if (i_enable = '1') then
				if (clock_counter = C_CLOCK_COUNTER - 1) then
					clock_divider <= '1';
					clock_counter := 0;
				else
					clock_divider <= '0';
					clock_counter := clock_counter + 1;
				end if;
			else
				clock_divider <= '0';
				clock_counter := 0;
			end if;
		end if;
	end process p0;

	p1 : process (clock_divider,i_reset,i_enable) is
	begin
		if (i_reset = '1') then
			o_ck <= '0';
		elsif (rising_edge(clock_divider)) then
			if (i_enable = '1') then
				o_ck <= not o_ck;
			else
				o_ck <= '0';
			end if;
		end if;
	end process p1;

	p2 : process (clock_divider,i_reset,i_enable) is
		variable data_index : integer range 0 to BYTE_SIZE - 1 := 0;
	begin
		if (i_reset = '1') then
			o_do <= '0';
		elsif (rising_edge(clock_divider)) then
			if (i_enable = '1') then
				if (data_index = BYTE_SIZE - 1) then
					data_index := 0;
				else
					data_index := data_index + 1;
				end if;
							o_do <= i_data_byte(data_index);

			else
				o_do <= '0';
			end if;
		end if;
	end process p2;
end Behavioral;
