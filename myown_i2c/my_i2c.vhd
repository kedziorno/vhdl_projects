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
use WORK.p_constants1.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity my_i2c is
generic(
BOARD_CLOCK : INTEGER := G_BOARD_CLOCK;
BUS_CLOCK : INTEGER := G_BUS_CLOCK
);
port(
i_clock : in std_logic;
i_reset : in std_logic;
i_slave_address : in std_logic_vector(0 to G_SLAVE_ADDRESS_SIZE-1);
i_bytes_to_send : in ARRAY_BYTE_SEQUENCE;
i_enable : in std_logic;
o_busy : out std_logic;
o_sda : out std_logic;
o_scl : out std_logic
);
end my_i2c;

architecture Behavioral of my_i2c is
	constant I2C_COUNTER_MAX : integer := (BOARD_CLOCK / BUS_CLOCK) / 4;

	signal clock : std_logic;
	signal temp_sda : std_logic;
	signal temp_sck : std_logic;
--	signal instruction_index : integer range 0 to ARRAY_BYTE_SEQUENCE'length-1 := 0;
	signal instruction_index : std_logic_vector(4 downto 0); -- XXX 32

	type state is (sda_start,start,slave_address,slave_address_lastbit,slave_rw,slave_ack,get_instruction,data,data_lastbit,data_ack,stop,sda_stop);
	signal c_state,n_state : state;

	type clock_mode is (c0,c1,c2,c3);
	signal c_cmode,n_cmode : clock_mode;

	constant SLAVE_INDEX_MAX : integer := G_SLAVE_ADDRESS_SIZE;
	constant SDA_WIDTH_MAX : integer := 2;
	signal data_index : integer range 0 to G_BYTE_SIZE-1 := 0;
	signal slave_index : integer range 0 to SLAVE_INDEX_MAX-1 := 0;
	signal sda_width: integer range 0 to SDA_WIDTH_MAX-1 := 0;

begin

	i2c_clock_process : process (i_clock,i_reset) is
		variable count : integer range 0 to (I2C_COUNTER_MAX*4)-1 := 0;
	begin
		if (i_reset = '1') then
			clock <= '0';
			count := 0;
		elsif (rising_edge(i_clock)) then
			if (count < (I2C_COUNTER_MAX*4)-1) then
				clock <= '0';
				count := count + 1;
			else
				clock <= '1';
				count := 0;
			end if;
		end if;
	end process i2c_clock_process;

	i2c_send_sequence_fsm : process (clock,i_reset) is
	begin
		if (i_reset = '1') then
			n_state <= sda_start;
			n_cmode <= c0;
		elsif (rising_edge(clock)) then
			c_state <= n_state;
			c_cmode <= n_cmode;
			case c_cmode is
				when c0 =>
					n_cmode <= c1;
				when c1 =>
					n_cmode <= c2;
				when c2 =>
					n_cmode <= c3;
				when c3 =>
					n_cmode <= c0;
				when others => n_cmode <= c1;
			end case;
			case c_state is
				when sda_start =>
					instruction_index <= (others => '0');
					temp_sck <= '1';
					temp_sda <= '1';
					n_state <= start;
				when start =>
					temp_sda <= '1';
					n_state <= slave_address;
				when slave_address =>
					if (c_cmode /= c1 and c_cmode /= c2 and (c_cmode = c0 or c_cmode = c3)) then
						temp_sck <= '0';
					end if;
					if ((c_cmode = c1 or c_cmode = c2) and c_cmode /= c0 and c_cmode /= c3) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c2 and slave_index = 0) then
						temp_sda <= '0';
					end if;
					if (slave_index < SLAVE_INDEX_MAX-1) then
						if (c_cmode = c0) then
							temp_sda <= i_slave_address(slave_index);
							if (sda_width < SDA_WIDTH_MAX-1) then
								sda_width <= sda_width + 1;
								n_state <= slave_address;
							else
								slave_index <= slave_index + 1;
								sda_width <= 0;
								n_state <= slave_address;
							end if;
						end if;
					else
						n_state <= slave_address_lastbit;
						sda_width <= 0;
					end if;
				when slave_address_lastbit =>
					if (c_cmode /= c1 and c_cmode /= c2 and (c_cmode = c0 or c_cmode = c3)) then
						temp_sck <= '0';
					end if;
					if ((c_cmode = c1 or c_cmode = c2) and c_cmode /= c0 and c_cmode /= c3) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						temp_sda <= i_slave_address(SLAVE_INDEX_MAX-1);
						if (sda_width < SDA_WIDTH_MAX-1) then
							sda_width <= sda_width + 1;
							n_state <= slave_address_lastbit;
						else
							sda_width <= 0;
							n_state <= slave_rw;
						end if;
					end if;
				when slave_rw =>
					if (c_cmode /= c1 and c_cmode /= c2 and (c_cmode = c0 or c_cmode = c3)) then
						temp_sck <= '0';
					end if;
					if ((c_cmode = c1 or c_cmode = c2) and c_cmode /= c0 and c_cmode /= c3) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						temp_sda <= '0';
						if (sda_width < SDA_WIDTH_MAX-1) then
							sda_width <= sda_width + 1;
							n_state <= slave_rw;
						else
							sda_width <= 0;
							n_state <= slave_ack;
						end if;
					end if;
				when slave_ack =>
					if (c_cmode /= c1 and c_cmode /= c2 and (c_cmode = c0 or c_cmode = c3)) then
						temp_sck <= '0';
					end if;
					if ((c_cmode = c1 or c_cmode = c2) and c_cmode /= c0 and c_cmode /= c3) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						temp_sda <= '1';
						if (sda_width < SDA_WIDTH_MAX-1) then
							sda_width <= sda_width + 1;
							n_state <= slave_ack;
						else
							sda_width <= 0;
							n_state <= data;
						end if;
					end if;
				when get_instruction =>
					if (to_integer(unsigned(instruction_index)) < ARRAY_BYTE_SEQUENCE'length-1) then
						n_state <= data;
					else
						n_state <= stop;
					end if;
				when data =>
					if (c_cmode /= c1 and c_cmode /= c2 and (c_cmode = c0 or c_cmode = c3)) then
						temp_sck <= '0';
					end if;
					if ((c_cmode = c1 or c_cmode = c2) and c_cmode /= c0 and c_cmode /= c3) then
						temp_sck <= '1';
					end if;
					if (data_index < G_BYTE_SIZE-1) then
						if (c_cmode = c0) then
							temp_sda <= i_bytes_to_send(to_integer(unsigned(instruction_index)))(data_index);
							if (sda_width < SDA_WIDTH_MAX-1) then
								sda_width <= sda_width + 1;
								n_state <= data;
							else
								data_index <= data_index + 1;
								sda_width <= 0;
								n_state <= data;
							end if;
						end if;
					else
						sda_width <= 0;
						n_state <= data_lastbit;
					end if;
				when data_lastbit =>
					if (c_cmode /= c1 and c_cmode /= c2 and (c_cmode = c0 or c_cmode = c3)) then
						temp_sck <= '0';
					end if;
					if ((c_cmode = c1 or c_cmode = c2) and c_cmode /= c0 and c_cmode /= c3) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						temp_sda <= i_bytes_to_send(to_integer(unsigned(instruction_index)))(G_BYTE_SIZE-1);
						if (sda_width < SDA_WIDTH_MAX-1) then
							sda_width <= sda_width + 1;
							n_state <= data_lastbit;
						else
							sda_width <= 0;
							n_state <= data_ack;
						end if;
					end if;
				when data_ack =>
					if (c_cmode /= c1 and c_cmode /= c2 and (c_cmode = c0 or c_cmode = c3)) then
						temp_sck <= '0';
					end if;
					if ((c_cmode = c1 or c_cmode = c2) and c_cmode /= c0 and c_cmode /= c3) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						temp_sda <= '1';
						if (sda_width < SDA_WIDTH_MAX-1) then
							sda_width <= sda_width + 1;
							n_state <= data_ack;
						else
							instruction_index <= std_logic_vector(to_unsigned(to_integer(unsigned(instruction_index) + 1),5));
							sda_width <= 0;
							n_state <= get_instruction;
							data_index <= 0;
						end if;
					end if;
				when stop =>
					if (c_cmode /= c1 and c_cmode /= c2 and (c_cmode = c0 or c_cmode = c3)) then
						temp_sck <= '0';
					end if;
					if ((c_cmode = c1 or c_cmode = c2) and c_cmode /= c0 and c_cmode /= c3) then
						temp_sck <= '1';
					end if;
					if (c_cmode = c0) then
						temp_sda <= '0';
						if (sda_width < SDA_WIDTH_MAX-1) then
							sda_width <= sda_width + 1;
							n_state <= stop;
						else
							sda_width <= 0;
							n_state <= sda_stop;
						end if;
					end if;
				when sda_stop =>
					temp_sck <= '1';
					temp_sda <= '1';
					data_index <= 0;
					slave_index <= 0;
					sda_width <= 0;
					n_state <= sda_stop;
				when others => n_state <= sda_stop;
			end case;
		end if;
	end process i2c_send_sequence_fsm;

	o_sda <= '0' when temp_sda = '0' else 'Z';
	o_scl <= '0' when temp_sck = '0' else 'Z';

end architecture Behavioral;
