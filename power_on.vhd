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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity power_on is 
port (reset,clk : in std_logic; sda,sck : inout std_logic);
end power_on;

architecture Behavioral of power_on is

	signal clock : std_logic := '0';
	signal clock_strength : std_logic := '0';

	--type state is (sda_start,start,pause,s_address,s_rw,s_ack,data,data_last_bit,data_ack,stop,sda_stop);
	type state is (sda_start,start,slave_address,slave_address_lastbit,slave_rw,slave_ack,data,data_lastbit,data_ack,stop,sda_stop);
	signal c_state,n_state : state := sda_start;

	constant AMNT_INSTRS : natural range 0 to 26 := 26;
	type IAR is array (0 to AMNT_INSTRS-1) of std_logic_vector(7 downto 0);
	signal Instrs : IAR := (x"AE",x"D5",x"F0",x"A8",x"1F",x"D3",x"00",x"40",x"8D",x"14",x"20",x"00",x"A1",x"C8",x"DA",x"02",x"81",x"8F",x"D9",x"F1",x"DB",x"40",x"A4",x"A6",x"2E",x"AF");

	type clock_mode is (c0,c1,c2,c3);
	signal c_cmode,n_cmode : clock_mode := c0;

	signal temp_sda : std_logic := 'Z';
	signal temp_sck : std_logic := 'Z';

begin

	-- clk divider - clock = ~9.96us , _|_|_ and not __+-+__+-+__
	-- clock_strength = ~19.96us

	p0 : process(clk) is

		constant I2C_COUNTER_MAX : integer := 50_000_000 / 100_000 / 4;
		variable count : integer range 0 to I2C_COUNTER_MAX := 0;

	begin

		if (rising_edge(clk)) then
			if (count = I2C_COUNTER_MAX) then
				count := 0;
				clock <= '1';
			else
				clock <= '0';
				count := count + 1;
			end if;
		end if;

	end process p0;

	p1 : process(clock,reset) is

		constant DATA_INDEX_MAX : integer := 8;
		variable data_index : integer range 0 to DATA_INDEX_MAX := 0;

		constant SLAVE_INDEX_MAX : integer := 7;
		variable slave_index : integer range 0 to SLAVE_INDEX_MAX := 0;

		constant SDA_WIDTH_MAX : integer := 1;
		variable sda_width: integer range 0 to SDA_WIDTH_MAX := SDA_WIDTH_MAX;

--		constant slave : std_logic_vector(SLAVE_INDEX_MAX-1 downto 0) := "1010101";
--		constant slave : std_logic_vector(SLAVE_INDEX_MAX-1 downto 0) := "0101010";
		constant slave : std_logic_vector(SLAVE_INDEX_MAX-1 downto 0) := "0111100";

		variable instruction_index : integer range 0 to AMNT_INSTRS := 0;
	begin

		if (reset = '1') then
			c_state <= sda_start;
			c_cmode <= c0;
		elsif (rising_edge(clock)) then
			c_state <= n_state;
			c_cmode <= n_cmode;
		end if;
		case c_cmode is
			when c0 =>
				clock_strength <= '0';
				n_cmode <= c1;
			when c1 =>
				clock_strength <= '0';
				n_cmode <= c2;
			when c2 =>
				clock_strength <= '1';
				n_cmode <= c3;
			when c3 =>
				clock_strength <= '1';
				n_cmode <= c0;
			when others => null;
		end case;
		case c_state is
			when sda_start =>
				temp_sck <= '1';
				temp_sda <= '1';
				n_state <= start;
			when start =>
				if (rising_edge(clock)) then
					temp_sck <= clock_strength;
				end if;
				temp_sda <= '0';
				n_state <= slave_address;
			when slave_address =>
				if (rising_edge(clock)) then
					temp_sck <= not clock_strength;
				end if;
				if (slave_index < SLAVE_INDEX_MAX-1) then
					if (c_cmode = c0) then
						temp_sda <= slave(SLAVE_INDEX_MAX-1-slave_index);
						if (sda_width > 0) then
							sda_width := sda_width - 1;
							n_state <= slave_address;
						else
							slave_index := slave_index + 1;
							sda_width := SDA_WIDTH_MAX;
							n_state <= slave_address;
						end if;
					end if;
				else
					n_state <= slave_address_lastbit;
					sda_width := SDA_WIDTH_MAX;
				end if;
			when slave_address_lastbit =>
				if (rising_edge(clock)) then
					temp_sck <= not clock_strength;
				end if;
				if (c_cmode = c0) then
					temp_sda <= slave(0);
					if (sda_width > 0) then
						sda_width := sda_width - 1;
						n_state <= slave_address_lastbit;
					else
						sda_width := SDA_WIDTH_MAX;
						n_state <= slave_rw;
					end if;
				end if;
			when slave_rw =>
				if (rising_edge(clock)) then
					temp_sck <= not clock_strength;
				end if;
				if (c_cmode = c0) then
					temp_sda <= '0'; -- rw
					if (sda_width > 0) then
						sda_width := sda_width - 1;
						n_state <= slave_rw;
					else
						sda_width := SDA_WIDTH_MAX;
						n_state <= slave_ack;
					end if;
				end if;
			when slave_ack =>
				if (rising_edge(clock)) then
					temp_sck <= not clock_strength;
				end if;
				if (c_cmode = c0) then
					temp_sda <= '1'; -- ack
					if (sda_width > 0) then
						sda_width := sda_width - 1;
						n_state <= slave_ack;
					else
						sda_width := SDA_WIDTH_MAX;
						n_state <= data;
					end if;
				end if;
			when data =>
				if (rising_edge(clock)) then
					temp_sck <= not clock_strength;
				end if;
				if (data_index < DATA_INDEX_MAX-1) then
					if (c_cmode = c0) then
						temp_sda <= Instrs(instruction_index)(DATA_INDEX_MAX-1-data_index);
						if (sda_width > 0) then
							sda_width := sda_width - 1;
							n_state <= data;
						else
							data_index := data_index + 1;
							sda_width := SDA_WIDTH_MAX;
							n_state <= data;
						end if;
					end if;
				else
					n_state <= data_lastbit;
					sda_width := SDA_WIDTH_MAX;
				end if;
			when data_lastbit =>
				if (rising_edge(clock)) then
					temp_sck <= not clock_strength;
				end if;
				if (c_cmode = c0) then
					temp_sda <= Instrs(instruction_index)(0);
					if (sda_width > 0) then
						sda_width := sda_width - 1;
						n_state <= data_lastbit;
					else
						sda_width := SDA_WIDTH_MAX;
						n_state <= data_ack;
					end if;
				end if;
			when data_ack =>
				if (rising_edge(clock)) then
					temp_sck <= not clock_strength;
				end if;
				if (c_cmode = c0) then
					temp_sda <= '1'; -- ack
					if (sda_width > 0) then
						sda_width := sda_width - 1;
						n_state <= data_ack;
					else
						if (instruction_index < AMNT_INSTRS-1) then
							instruction_index := instruction_index + 1;
							n_state <= data;
						else
							sda_width := SDA_WIDTH_MAX;
							n_state <= stop;
						end if;
					end if;
				end if;
			when stop =>
				if (rising_edge(clock)) then
					temp_sck <= not clock_strength;
				end if;
				if (c_cmode = c0) then
					temp_sda <= '0'; -- stop
					if (sda_width > 0) then
						sda_width := sda_width - 1;
						n_state <= stop;
					else
						sda_width := SDA_WIDTH_MAX;
						n_state <= sda_stop;
					end if;
				end if;
			when sda_stop =>
				temp_sck <= '1';
				temp_sda <= '1';
				n_state <= sda_stop;
			when others => null;
		end case;
	end process p1;

	sda <= '0' when temp_sda = '0' else 'Z';
	sck <= '0' when temp_sck = '0' else 'Z';

end Behavioral;
