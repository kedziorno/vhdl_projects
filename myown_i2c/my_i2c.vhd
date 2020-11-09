----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:47:31 08/21/2020 
-- Design Name: 
-- Module Name:    power_on - Behavioral 
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
use WORK.p_pkg1.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity i2c is
generic(
GLOBAL_CLOCK : INTEGER;
BUS_CLOCK : INTEGER
);
port(
clk : in std_logic;
rst : in std_logic;
slave : std_logic_vector(6 downto 0);
bytes_to_send : array1;
enable : in std_logic;
busy : out std_logic;
sda : out std_logic;
sck : out std_logic
);
end i2c;

architecture Behavioral of i2c is

	constant INPUT_CLOCK : integer := GLOBAL_CLOCK;
	constant I2C_CLOCK : integer := BUS_CLOCK;
	constant NUMBER_BITS : integer := 8;

	constant COUNTER1_MAX : integer := (INPUT_CLOCK / I2C_CLOCK);

	type state is (sda_start,start,slave_address,slave_rw,slave_ack,data_0,data_1,data_2,data_3,data_4,data_5,data_6,data_7,data_ack,stop,sda_stop);
	type clock_mode is (c0,c1,c2,c3);

	signal clock : std_logic := '0';
	signal clock_streth : std_logic := '0';
	signal temp_sda : std_logic := 'Z';
	signal temp_sck : std_logic := 'Z';
	signal instruction_index : std_logic_vector(NUMBER_BITS-1 downto 0) := x"00";
	signal c_state,n_state : state;
	signal c_cmode,n_cmode : clock_mode;

begin

	p0 : process (clk) is
		variable count1 : integer := 0;
		variable count2 : integer := 0;
	begin
		if (rising_edge(clk)) then
			count1 := count1 + 1;
		end if;
		if (count1 = COUNTER1_MAX-1) then
			clock <= '1';
			count1 := 0;
			if (count2 mod 4 = 0) then
				clock_streth <= '1';
				count2 := 0;
			end if;
		else
			clock <= '0';
			clock_streth <= '0';
			count2 := count2 + 1;
		end if;
	end process p0;

	p1 : process (clk,clock,c_cmode) is
	begin
		if (rising_edge(clock)) then
			c_cmode <= n_cmode;
		end if;
		case c_cmode is
			when c0 =>
				n_cmode <= c1;
			when c1 =>
				n_cmode <= c2;
			when c2 =>
				n_cmode <= c3;
			when c3 =>
				n_cmode <= c0;
			when others => null;
		end case;
	end process p1;

	pa : process (clk,clock_streth,c_state,c_cmode,rst,enable,slave,bytes_to_send,instruction_index) is
		constant SLAVE_INDEX_MAX : integer := 7;
		variable slave_index : integer range 0 to SLAVE_INDEX_MAX := 0;
	begin
		if (rst = '1') then
			n_state <= start;
		elsif (enable = '1') then
			if (rising_edge(clock_streth)) then
				c_state <= n_state;
				if (c_state = sda_start) then
					instruction_index <= (others => '0');
				end if;
				if (c_state = slave_address) then
					slave_index := slave_index + 1;
				end if;
				if (c_state = data_ack) then
					instruction_index <= std_logic_vector(unsigned(instruction_index) + 1);
				end if;
			end if;
			case c_state is
				when sda_start =>
					if (c_cmode = c0) then
						temp_sda <= '1';
						temp_sck <= '1';
					end if;
					n_state <= start;
				when start =>
					if ((c_cmode = c0 or c_cmode = c1) and c_cmode /= c2 and c_cmode /= c3) then
						temp_sda <= '1';
					else
						temp_sda <= '0';
					end if;
					if (c_cmode = c0 or c_cmode = c1 or c_cmode = c2) then
						temp_sck <= '1';
					else
						temp_sck <= '0';
					end if;
					n_state <= slave_address;
				when slave_address =>
					if (c_cmode = c0 or c_cmode = c3) then
						temp_sck <= '0';
					end if;
					if (c_cmode = c1 or c_cmode = c2) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						if (slave_index < SLAVE_INDEX_MAX-1) then
							temp_sda <= slave(SLAVE_INDEX_MAX-1-slave_index);
							n_state <= slave_address;
						else
							n_state <= slave_rw;
						end if;
					end if;
				when slave_rw =>
					if (c_cmode = c0 or c_cmode = c3) then
						temp_sck <= '0';
					end if;
					if (c_cmode = c1 or c_cmode = c2) then
						temp_sck <= '1';
					end if;
					temp_sda <= '0';
					n_state <= slave_ack;
				when slave_ack =>
					if (c_cmode = c0 or c_cmode = c3) then
						temp_sck <= '0';
					end if;
					if (c_cmode = c1 or c_cmode = c2) then
						temp_sck <= '1';
					end if;
					temp_sda <= '1';
					n_state <= data_0;
				when data_0 =>
					if (c_cmode = c0 or c_cmode = c3) then
						temp_sck <= '0';
					end if;
					if (c_cmode = c1 or c_cmode = c2) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						temp_sda <= bytes_to_send(to_integer(unsigned(instruction_index)))(7);
						n_state <= data_1;
					end if;
				when data_1 =>
					if (c_cmode = c0 or c_cmode = c3) then
						temp_sck <= '0';
					end if;
					if (c_cmode = c1 or c_cmode = c2) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						temp_sda <= bytes_to_send(to_integer(unsigned(instruction_index)))(6);
						n_state <= data_2;
					end if;
				when data_2 =>
					if (c_cmode = c0 or c_cmode = c3) then
						temp_sck <= '0';
					end if;
					if (c_cmode = c1 or c_cmode = c2) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						temp_sda <= bytes_to_send(to_integer(unsigned(instruction_index)))(5);
						n_state <= data_3;
					end if;
				when data_3 =>
					if (c_cmode = c0 or c_cmode = c3) then
						temp_sck <= '0';
					end if;
					if (c_cmode = c1 or c_cmode = c2) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						temp_sda <= bytes_to_send(to_integer(unsigned(instruction_index)))(4);
						n_state <= data_4;
					end if;
				when data_4 =>
					if (c_cmode = c0 or c_cmode = c3) then
						temp_sck <= '0';
					end if;
					if (c_cmode = c1 or c_cmode = c2) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						temp_sda <= bytes_to_send(to_integer(unsigned(instruction_index)))(3);
						n_state <= data_5;
					end if;
				when data_5 =>
					if (c_cmode = c0 or c_cmode = c3) then
						temp_sck <= '0';
					end if;
					if (c_cmode = c1 or c_cmode = c2) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						temp_sda <= bytes_to_send(to_integer(unsigned(instruction_index)))(2);
						n_state <= data_6;
					end if;
				when data_6 =>
					if (c_cmode = c0 or c_cmode = c3) then
						temp_sck <= '0';
					end if;
					if (c_cmode = c1 or c_cmode = c2) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						temp_sda <= bytes_to_send(to_integer(unsigned(instruction_index)))(1);
						n_state <= data_7;
					end if;
				when data_7 =>
					if (c_cmode = c0 or c_cmode = c3) then
						temp_sck <= '0';
					end if;
					if (c_cmode = c1 or c_cmode = c2) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						temp_sda <= bytes_to_send(to_integer(unsigned(instruction_index)))(0);
						n_state <= data_ack;
					end if;
				when data_ack =>
					if (c_cmode = c0 or c_cmode = c3) then
						temp_sck <= '0';
					end if;
					if (c_cmode = c1 or c_cmode = c2) then
						temp_sck <= '1';
					end if;
					temp_sda <= '1';
					if (to_integer(unsigned(instruction_index)) < bytes_to_send'length-1) then
						n_state <= data_0;
					else
						n_state <= stop;
					end if;
				when stop =>
					if (c_cmode = c0) then
						temp_sck <= '0';
					end if;
					if (c_cmode = c1 or c_cmode = c2 or c_cmode = c3) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c2 or c_cmode = c3) then
						temp_sda <= '1';
					else
						temp_sda <= '0';
					end if;
					n_state <= sda_stop;
				when sda_stop =>
					temp_sck <= '1';
					temp_sda <= '1';
					busy <= '0';
				when others => null;
			end case;
		end if;
	end process pa;

	sda <= '0' when temp_sda = '0' else 'Z';
	sck <= '0' when temp_sck = '0' else 'Z';

end Behavioral;
