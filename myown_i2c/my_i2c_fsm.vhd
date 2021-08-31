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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity my_i2c_fsm is
generic(
BOARD_CLOCK : INTEGER := G_BOARD_CLOCK;
BUS_CLOCK : INTEGER := G_BUS_CLOCK
);
port(
i_clock : in std_logic;
i_reset : in std_logic;
i_slave_address : in std_logic_vector(0 to G_SLAVE_ADDRESS_SIZE-1);
i_bytes_to_send : in std_logic_vector(0 to G_BYTE_SIZE-1);
i_enable : in std_logic;
o_busy : out std_logic;
o_sda : out std_logic;
o_scl : out std_logic
);
end my_i2c_fsm;

architecture Behavioral of my_i2c_fsm is

	signal clock : std_logic;
	signal temp_sda : std_logic;
	signal temp_sck : std_logic;

	type state is (
	idle,
	sda_start,
	start,
	slave_address,
	slave_address_lastbit,
	slave_rw,
	slave_ack,
	data,
	data_ack,
	stop,
	sda_stop
	);
	signal c_state,n_state : state;

	type clock_mode is (c0,c1,c2,c3);
	signal c_cmode0,n_cmode0 : clock_mode;
	signal c_cmode0_rc1 : std_logic;

	component ripple_counter is
	Generic (
	N : integer := 32;
	MAX : integer := 1
	);
	Port (
	i_clock : in std_logic;
	i_cpb : in std_logic;
	i_mrb : in std_logic;
	i_ud : in std_logic;
	o_q : inout std_logic_vector(N-1 downto 0);
	o_ping : out std_logic
	);
	end component ripple_counter;
	constant RC_N : integer := 4;
	constant RC_MAX : integer := G_BYTE_SIZE;
	signal rc1_cpb,rc1_mrb : std_logic;
	signal rc1_q : std_logic_vector(RC_N-1 downto 0);
	signal rc1_ping : std_logic;

begin

	entity_rc1 : ripple_counter
	Generic map (N => RC_N, MAX => RC_MAX)
	Port map (
	i_clock => c_cmode0_rc1,
	i_cpb => rc1_cpb,
	i_mrb => rc1_mrb,
	i_ud => '1',
	o_q => rc1_q,
	o_ping => rc1_ping
	);

	i2c_clock_process : process (i_clock,i_reset) is
		constant I2C_COUNTER_MAX : integer := (BOARD_CLOCK / BUS_CLOCK) / 4;
		variable count : integer range 0 to (I2C_COUNTER_MAX*4)-1;
	begin
		if (i_reset = '1') then
			clock <= '0';
			count := 0;
		elsif (rising_edge(i_clock)) then
			if (count = (I2C_COUNTER_MAX*4)-1) then
				clock <= '1';
				count := 0;
			else
				clock <= '0';
				count := count + 1;
			end if;
		end if;
	end process i2c_clock_process;

	clock_mode_0_seq : process (clock,i_reset) is
	begin
		if (i_reset = '1') then
			c_cmode0 <= c0;
		elsif (rising_edge(clock)) then
			c_cmode0 <= n_cmode0;
		end if;
	end process clock_mode_0_seq;

	clock_mode_0_com : process (c_cmode0) is
	begin
		n_cmode0 <= c_cmode0;
		case c_cmode0 is
			when c0 =>
				n_cmode0 <= c1;
				c_cmode0_rc1 <= '1';
			when c1 =>
				n_cmode0 <= c2;
				c_cmode0_rc1 <= '0';
			when c2 =>
				n_cmode0 <= c3;
				c_cmode0_rc1 <= '0';
			when c3 =>
				n_cmode0 <= c0;
				c_cmode0_rc1 <= '0';
		end case;
	end process clock_mode_0_com;

	p2 : process (clock,i_reset) is
	begin
		if (i_reset = '1') then
			c_state <= idle;
		elsif (rising_edge(clock)) then
			c_state <= n_state;
		end if;
	end process p2;
	
	i2c_send_sequence_fsm : process (c_state,c_cmode0,i_enable,i_slave_address,i_bytes_to_send) is
		constant SLAVE_INDEX_MAX : integer := G_SLAVE_ADDRESS_SIZE;
		constant SDA_WIDTH_MAX : integer := 2;
		variable data_index : std_logic_vector(G_BYTE_SIZE-1 downto 0);
		variable slave_index : integer range 0 to SLAVE_INDEX_MAX-1;
		variable sda_width: integer range 0 to SDA_WIDTH_MAX-1;
		variable vtemp_sda,vtemp_sck : std_logic;
	begin
		n_state <= c_state;
		vtemp_sda := vtemp_sda;
		vtemp_sck := vtemp_sck;
		case c_state is
			when idle =>
				rc1_mrb <= '1';
				rc1_cpb <= '0';
				o_busy <= '0';
				sda_width := 0;
				vtemp_sda := '1';
				vtemp_sck := '1';
				if (i_enable = '1') then
					n_state <= sda_start;
				else
					n_state <= idle;
				end if;
			when sda_start =>
				rc1_mrb <= '0';
				sda_width := 0;
				if (c_cmode0 = c0) then
					vtemp_sck := '1';
					vtemp_sda := '1';
					n_state <= start;
				end if;
				o_busy <= '1';
			when start =>
				sda_width := 0;
				if (c_cmode0 = c0) then
					vtemp_sda := '0';
					vtemp_sck := '1';
					n_state <= slave_address;
				end if;
				o_busy <= '1';
				vtemp_sda := vtemp_sda;
				vtemp_sck := vtemp_sck;
			when slave_address =>
				o_busy <= '1';
				sda_width := 0;
				if (c_cmode0 /= c1 and c_cmode0 /= c2 and (c_cmode0 = c0 or c_cmode0 = c3)) then
					vtemp_sck := '0';
				end if;
				if ((c_cmode0 = c1 or c_cmode0 = c2) and c_cmode0 /= c0 and c_cmode0 /= c3) then
					vtemp_sck := '1';
				end if;
				if (slave_index /= SLAVE_INDEX_MAX-1) then
					if (c_cmode0 = c0) then
						vtemp_sda := i_slave_address(slave_index);
						slave_index := slave_index + 1;
						n_state <= slave_address;
					end if;
				else
					n_state <= slave_address_lastbit;
				end if;
			when slave_address_lastbit =>
				o_busy <= '1';
				sda_width := 0;
				if (c_cmode0 /= c1 and c_cmode0 /= c2 and (c_cmode0 = c0 or c_cmode0 = c3)) then
					vtemp_sck := '0';
				end if;
				if ((c_cmode0 = c1 or c_cmode0 = c2) and c_cmode0 /= c0 and c_cmode0 /= c3) then
					vtemp_sck := '1';
				end if;
				if (c_cmode0 = c0) then
					vtemp_sda := i_slave_address(SLAVE_INDEX_MAX-1);
					n_state <= slave_rw;
				end if;
			when slave_rw =>
				o_busy <= '1';
				sda_width := 0;
				if (c_cmode0 /= c1 and c_cmode0 /= c2 and (c_cmode0 = c0 or c_cmode0 = c3)) then
					vtemp_sck := '0';
				end if;
				if ((c_cmode0 = c1 or c_cmode0 = c2) and c_cmode0 /= c0 and c_cmode0 /= c3) then
					vtemp_sck := '1';
				end if;
				if (c_cmode0 = c0) then
					vtemp_sda := '0';
					n_state <= slave_ack;
				end if;
			when slave_ack =>
				o_busy <= '1';
				sda_width := 0;
				if (c_cmode0 /= c1 and c_cmode0 /= c2 and (c_cmode0 = c0 or c_cmode0 = c3)) then
					vtemp_sck := '0';
				end if;
				if ((c_cmode0 = c1 or c_cmode0 = c2) and c_cmode0 /= c0 and c_cmode0 /= c3) then
					vtemp_sck := '1';
				end if;
				if (c_cmode0 = c0) then
					vtemp_sda := '1';
					n_state <= data;
				end if;
				vtemp_sda := vtemp_sda;
				vtemp_sck := vtemp_sck;
			when data =>
				sda_width := 0;
				rc1_cpb <= '1';			
				o_busy <= '1';
				if (c_cmode0 /= c1 and c_cmode0 /= c2 and (c_cmode0 = c0 or c_cmode0 = c3)) then
					vtemp_sck := '0';
				end if;
				if ((c_cmode0 = c1 or c_cmode0 = c2) and c_cmode0 /= c0 and c_cmode0 /= c3) then
					vtemp_sck := '1';
				end if;
				if (c_cmode0 = c0) then
					vtemp_sda := i_bytes_to_send(to_integer(unsigned(rc1_q)));
					if (to_integer(unsigned(rc1_q)) = G_BYTE_SIZE-1) then
						n_state <= data_ack;
					else
						n_state <= data;
					end if;
				end if;
			when data_ack =>
				o_busy <= '1';
				if (c_cmode0 /= c1 and c_cmode0 /= c2 and (c_cmode0 = c0 or c_cmode0 = c3)) then
					vtemp_sck := '0';
				end if;
				if ((c_cmode0 = c1 or c_cmode0 = c2) and c_cmode0 /= c0 and c_cmode0 /= c3) then
					vtemp_sck := '1';
				end if;
				if (c_cmode0 = c0) then
					vtemp_sda := '0';
					if (sda_width = SDA_WIDTH_MAX-1) then -- XXX latch
						sda_width := 0;
						if (i_enable = '1') then
							n_state <= data;
							sda_width := 0;
						else
							n_state <= stop;
							sda_width := 0;
						end if;
					else
						sda_width := sda_width + 1;
						n_state <= data_ack;
					end if;
					sda_width := sda_width;
				end if;
				vtemp_sda := vtemp_sda;
				vtemp_sck := vtemp_sck;
			when stop =>
				o_busy <= '1';
				sda_width := 0;
				if (c_cmode0 /= c1 and c_cmode0 /= c2 and (c_cmode0 = c0 or c_cmode0 = c3)) then
					vtemp_sck := '0';
				end if;
				if ((c_cmode0 = c1 or c_cmode0 = c2) and c_cmode0 /= c0 and c_cmode0 /= c3) then
					vtemp_sck := '1';
				end if;
				vtemp_sda := '0';
				n_state <= sda_stop;
			when sda_stop =>
				sda_width := 0;
				if (c_cmode0 = c0) then
					n_state <= idle;
				else
					n_state <= sda_stop;
					vtemp_sck := '1';
					vtemp_sda := '1';
				end if;
				slave_index := 0;
				o_busy <= '1';
			when others =>
				vtemp_sda := vtemp_sda;
				vtemp_sck := vtemp_sck;
		end case;
		temp_sda <= vtemp_sda;
		temp_sck <= vtemp_sck;
	end process i2c_send_sequence_fsm;

	o_sda <= '0' when temp_sda = '0' else 'Z';
	o_scl <= '0' when temp_sck = '0' else 'Z';

end architecture Behavioral;
