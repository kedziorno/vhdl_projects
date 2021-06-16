----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:41:34 06/14/2021 
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
use WORK.p_package.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	o_cs : inout std_logic;
	o_do : inout std_logic;
	o_ck : inout std_logic
);
end top;

architecture Behavioral of top is
	component my_spi is
	port (
		i_clock : in std_logic;
		i_reset : in std_logic;
		i_enable : in std_logic;
		i_data_byte : in std_logic_vector(0 to BYTE_SIZE-1);
		o_cs : inout std_logic;
		o_do : inout std_logic;
		o_ck : inout std_logic;
		o_sended : inout std_logic
	);
	end component my_spi;
	signal data_byte : std_logic_vector(0 to BYTE_SIZE-1);
	signal enable,sended : std_logic;
	type states is (idle,smallwait,start,stop,wait0);
	signal state : states;

begin
	u0 : my_spi port map (
		i_clock => i_clock,
		i_reset => i_reset,
		i_enable => enable,
		i_data_byte => data_byte,
		o_cs => o_cs,
		o_do => o_do,
		o_ck => o_ck,
		o_sended => sended
	);
	
	p0 : process (i_clock,i_reset,sended) is
		variable data_index : integer range 0 to data_size - 1 := 0;
		variable w0_index : integer range 0 to C_CLOCK_COUNTER - 1 := 0;
	begin
		if (i_reset = '1') then
			enable <= '0';
			state <= idle;
			w0_index := 0;
			data_index := 0;
		elsif (rising_edge(i_clock)) then
			case state is
				when idle =>
					state <= smallwait;
				when smallwait =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= start;
						w0_index := 0;
					else
						state <= smallwait;
						w0_index := w0_index + 1;
					end if;
				when start =>
					if (data_index = data_size - 1) then
						data_index := 0;
						enable <= '0';
						state <= stop;
					else
						enable <= '1';
						if (sended = '1') then
							data_index := data_index + 1;
							state <= stop;
						else
							state <= start;
						end if;
					end if;
					data_byte <= data_rom(data_index);
				when stop =>
					if (sended = '1') then
						state <= stop;
						enable <= '1';
					else
						state <= wait0;
						enable <= '0';
					end if;
				when wait0 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= start;
						w0_index := 0;
					else
						state <= wait0;
						w0_index := w0_index + 1;
					end if;
			end case;
		end if;
	end process p0;

	check_test(o_cs,o_do,o_ck); -- XXX check the bits on spi and compare with rom data

end Behavioral;

