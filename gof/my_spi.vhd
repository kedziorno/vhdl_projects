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
use WORK.st7735r_p_package.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity my_spi is
generic (
	C_CLOCK_COUNTER : integer
);
port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	i_enable : in std_logic;
	i_data_byte : in BYTE_TYPE;
	o_cs : out std_logic;
	o_do : out std_logic;
	o_ck : out std_logic;
	o_sended : out std_logic
);
end my_spi;

architecture Behavioral of my_spi is
	signal clock_divider,clock_data : std_logic;
	signal data_index : integer range BYTE_SIZE - 1 downto 0;
	signal ck : std_logic;
begin
	o_cs <= '0' when i_enable = '1' else '1';
	o_do <= i_data_byte(BYTE_SIZE - 1 - data_index) when i_enable = '1' else '0';
	o_sended <= '1' when (data_index = BYTE_SIZE - 1 and i_enable = '1') else '0';

	p0 : process (i_clock,i_reset) is
		variable clock_counter : integer range 0 to C_CLOCK_COUNTER - 1 := 0;
	begin
		if (i_reset = '1') then
			clock_counter := 0;
			clock_divider <= '0';
		elsif (rising_edge(i_clock)) then
			if (i_enable = '1') then
				if (clock_counter = C_CLOCK_COUNTER/4 - 1) then
					clock_divider <= not clock_divider;
					clock_counter := 0;
				else
					clock_divider <= clock_divider;
					clock_counter := clock_counter + 1;
				end if;
			else
				clock_divider <= '0';
				clock_counter := 0;
			end if;
		end if;
	end process p0;

	p1 : process (clock_divider,i_reset) is
	begin
		if (i_reset = '1') then
			ck <= '0';
		elsif (rising_edge(clock_divider)) then
			if (i_enable = '1') then
				ck <= not ck;
			else
				ck <= '0';
			end if;
		end if;
	end process p1;
	o_ck <= ck;

	p2 : process (clock_data,i_reset) is
	begin
		if (i_reset = '1') then
			data_index <= 0;
		elsif (rising_edge(clock_data)) then
			if (i_enable = '1') then
				if (data_index = BYTE_SIZE - 1) then
					data_index <= 0;
				else
					data_index <= data_index + 1;
				end if;
			else
				data_index <= 0;
			end if;
		end if;
	end process p2;

	p3 : process (clock_divider,i_reset) is
		constant cd : integer := 2;
		variable d : integer range 0 to cd - 1;
	begin
		if (i_reset = '1') then
			clock_data <= '0';
			d := 0;
		elsif (rising_edge(clock_divider)) then
			if (i_enable = '1') then
				if (d = cd - 1) then
					clock_data <= '1';
					d := 0;
				else
					clock_data <= '0';
					d := d + 1;
				end if;
			else
				clock_data <= '0';
				d := 0;
			end if;
		end if;
	end process p3;
end Behavioral;
