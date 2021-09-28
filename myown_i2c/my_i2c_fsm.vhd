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
o_byte_sended : out std_logic;
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
	signal c_state_i2c_fsm,n_state_i2c_fsm : state;

	type clock_mode is (c0,c1,c2,c3);
	signal c_cmode0,n_cmode0 : clock_mode;
	signal c_cmode0_rc_clock : std_logic;

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
	o_q : inout std_logic_vector(N-1 downto 0)
	);
	end component ripple_counter;
	constant RC0_N : integer := 4;
	constant RC0_MAX : integer := G_BYTE_SIZE;
	signal rc0_cpb,rc0_mrb : std_logic;
	signal rc0_q : std_logic_vector(RC0_N-1 downto 0);
	signal rc0_ping : std_logic;
	constant RC1_N : integer := 4;
	constant RC1_MAX : integer := G_BYTE_SIZE;
	signal rc1_cpb,rc1_mrb : std_logic;
	signal rc1_q : std_logic_vector(RC1_N-1 downto 0);
	signal rc1_ping : std_logic;
	constant RC2_N : integer := 4;
	constant RC2_MAX : integer := G_BYTE_SIZE;
	signal rc2_cpb,rc2_mrb : std_logic;
	signal rc2_q : std_logic_vector(RC2_N-1 downto 0);
	signal rc2_ping : std_logic;

--	attribute KEEP : string;
--	attribute KEEP of clock : signal is "yes";
--	attribute KEEP of i_clock : signal is "yes";
	attribute CLOCK_SIGNAL : string;
	attribute CLOCK_SIGNAL of clock : signal is "yes"; --{yes | no};
--	attribute CLOCK_SIGNAL of i_clock : signal is "yes"; --{yes | no};
--	attribute CLOCK_SIGNAL of temp_sck : signal is "no"; --{yes | no};
--	attribute CLOCK_SIGNAL of temp_sda : signal is "no"; --{yes | no};
	attribute BUFFER_TYPE : string;
	attribute BUFFER_TYPE of clock : signal is "BUFG"; --" {bufgdll | ibufg | bufgp | ibuf | bufr | none}";
--	attribute BUFFER_TYPE of i_clock : signal is "NONE"; --" {bufgdll | ibufg | bufgp | ibuf | bufr | none}";
--	attribute BUFFER_TYPE of temp_sck : signal is "none"; --" {bufgdll | ibufg | bufgp | ibuf | bufr | none}";
--	attribute BUFFER_TYPE of temp_sda : signal is "none"; --" {bufgdll | ibufg | bufgp | ibuf | bufr | none}";

begin

	entity_rc0 : ripple_counter
	Generic map (N => RC0_N, MAX => RC0_MAX)
	Port map (
	i_clock => c_cmode0_rc_clock,
	i_cpb => rc0_cpb,
	i_mrb => rc0_mrb,
	i_ud => '1',
	o_q => rc0_q
	);

	entity_rc1 : ripple_counter
	Generic map (N => RC1_N, MAX => RC1_MAX)
	Port map (
	i_clock => c_cmode0_rc_clock,
	i_cpb => rc1_cpb,
	i_mrb => rc1_mrb,
	i_ud => '1',
	o_q => rc1_q
	);

	entity_rc2 : ripple_counter
	Generic map (N => RC2_N, MAX => RC2_MAX)
	Port map (
	i_clock => c_cmode0_rc_clock,
	i_cpb => rc2_cpb,
	i_mrb => rc2_mrb,
	i_ud => '1',
	o_q => rc2_q
	);

	i2c_clock_process : process (i_clock) is
		constant I2C_COUNTER_MAX : integer := BOARD_CLOCK / BUS_CLOCK;
		variable count : integer range 0 to I2C_COUNTER_MAX-1;
	begin
		if (rising_edge(i_clock)) then
			if (i_reset = '1') then
				clock <= '0';
				count := 0;
			elsif (count = I2C_COUNTER_MAX-1) then
				clock <= '1';
				count := 0;
			else
				clock <= '0';
				count := count + 1;
			end if;
		end if;
	end process i2c_clock_process;

	clock_mode_0_seq : process (clock) is
	begin
		if (rising_edge(clock)) then
			if (i_reset = '1') then
				c_cmode0 <= c0;
			else
				c_cmode0 <= n_cmode0;
			end if;
		end if;
	end process clock_mode_0_seq;

	clock_mode_0_com : process (c_cmode0) is
	begin
		n_cmode0 <= c_cmode0;
		c_cmode0_rc_clock <= '0';
		case c_cmode0 is
			when c0 =>
				n_cmode0 <= c1;
				c_cmode0_rc_clock <= '1';
			when c1 =>
				n_cmode0 <= c2;
				c_cmode0_rc_clock <= '0';
			when c2 =>
				n_cmode0 <= c3;
				c_cmode0_rc_clock <= '0';
			when c3 =>
				n_cmode0 <= c0;
				c_cmode0_rc_clock <= '0';
			when others =>
				n_cmode0 <= c0;
				c_cmode0_rc_clock <= '0';
		end case;
	end process clock_mode_0_com;

	p2 : process (clock) is
	begin
		if (rising_edge(clock)) then
			if (i_reset = '1') then
				c_state_i2c_fsm <= idle;
			else
				c_state_i2c_fsm <= n_state_i2c_fsm;
			end if;
		end if;
	end process p2;
	
	i2c_send_sequence_fsm : process (c_state_i2c_fsm,c_cmode0,i_enable,i_slave_address,i_bytes_to_send
	,temp_sda,temp_sck) is
		variable vtemp_sda,vtemp_sck : std_logic;
		variable index1,index2 : integer range 0 to 7;
	begin
		n_state_i2c_fsm <= c_state_i2c_fsm;
--		vtemp_sda := temp_sda;
--		vtemp_sck := temp_sck;
		index1 := to_integer(unsigned(rc0_q));
		index2 := to_integer(unsigned(rc1_q));
		case c_state_i2c_fsm is
			when idle =>
				o_byte_sended <= '0';
				rc0_mrb <= '1';
				rc1_mrb <= '1';
				rc2_mrb <= '1';
				rc0_cpb <= '0';
				rc1_cpb <= '0';
				rc2_cpb <= '0';
				o_busy <= '0';
				if (c_cmode0 = c0) then
					vtemp_sda := '1';
					vtemp_sck := '1';
				end if;
				if (c_cmode0 /= c0) then
					vtemp_sda := temp_sda;
					vtemp_sck := temp_sck;
				end if;
				if (i_enable = '1') then
					n_state_i2c_fsm <= sda_start;
				else
					n_state_i2c_fsm <= idle;
				end if;
			when sda_start =>
				o_byte_sended <= '0';
				rc0_mrb <= '0';
				rc1_mrb <= '0';
				rc2_mrb <= '0';
				rc0_cpb <= '0';
				rc1_cpb <= '0';
				rc2_cpb <= '0';
				if (c_cmode0 = c0) then
					vtemp_sck := '1';
					vtemp_sda := '1';
					n_state_i2c_fsm <= start;
				end if;
				if (c_cmode0 /= c0) then
					vtemp_sck := temp_sck;
					vtemp_sda := temp_sda;
					n_state_i2c_fsm <= sda_start;
				end if;
				o_busy <= '1';
			when start =>
				o_byte_sended <= '0';
				rc0_mrb <= '0';
				rc1_mrb <= '0';
				rc2_mrb <= '0';
				rc0_cpb <= '0';
				rc1_cpb <= '0';
				rc2_cpb <= '0';
				if (c_cmode0 = c0) then
					vtemp_sda := '0';
					vtemp_sck := '1';
					n_state_i2c_fsm <= slave_address;
				end if;
				if (c_cmode0 /= c0) then
					vtemp_sda := temp_sda;
					vtemp_sck := temp_sck;
					n_state_i2c_fsm <= start;
				end if;
				o_busy <= '1';
			when slave_address =>
				o_byte_sended <= '0';
				rc0_mrb <= '0';
				rc1_mrb <= '0';
				rc2_mrb <= '0';
				rc0_cpb <= '1';
				rc1_cpb <= '0';
				rc2_cpb <= '0';
				o_busy <= '1';
				if (c_cmode0 /= c1 and c_cmode0 /= c2 and (c_cmode0 = c0 or c_cmode0 = c3)) then
					vtemp_sck := '0';
				end if;
				if ((c_cmode0 = c1 or c_cmode0 = c2) and c_cmode0 /= c0 and c_cmode0 /= c3) then
					vtemp_sck := '1';
				end if;
				if (index1 = G_SLAVE_ADDRESS_SIZE-1) then
					vtemp_sda := temp_sda;
					n_state_i2c_fsm <= slave_address_lastbit;
				else
					if (c_cmode0 = c0) then
						vtemp_sda := i_slave_address(index1);
						n_state_i2c_fsm <= slave_address;
					end if;
					if (c_cmode0 /= c0) then
						vtemp_sda := temp_sda;
						n_state_i2c_fsm <= slave_address;
					end if;
				end if;
			when slave_address_lastbit =>
				o_byte_sended <= '0';
				rc0_mrb <= '0';
				rc1_mrb <= '0';
				rc2_mrb <= '0';
				rc0_cpb <= '0';
				rc1_cpb <= '0';
				rc2_cpb <= '0';
				o_busy <= '1';
				if (c_cmode0 /= c1 and c_cmode0 /= c2 and (c_cmode0 = c0 or c_cmode0 = c3)) then
					vtemp_sck := '0';
				end if;
				if ((c_cmode0 = c1 or c_cmode0 = c2) and c_cmode0 /= c0 and c_cmode0 /= c3) then
					vtemp_sck := '1';
				else
					vtemp_sck := '0';
				end if;
				if (c_cmode0 = c0) then
					vtemp_sda := i_slave_address(G_SLAVE_ADDRESS_SIZE-1);
					n_state_i2c_fsm <= slave_rw;
				end if;
				if (c_cmode0 /= c0) then
					vtemp_sda := temp_sda;
					n_state_i2c_fsm <= slave_address_lastbit;
				end if;
			when slave_rw =>
				o_byte_sended <= '0';
				rc0_mrb <= '0';
				rc1_mrb <= '0';
				rc2_mrb <= '0';
				rc0_cpb <= '0';
				rc1_cpb <= '0';
				rc2_cpb <= '0';
				o_busy <= '1';
				if (c_cmode0 /= c1 and c_cmode0 /= c2 and (c_cmode0 = c0 or c_cmode0 = c3)) then
					vtemp_sck := '0';
				end if;
				if ((c_cmode0 = c1 or c_cmode0 = c2) and c_cmode0 /= c0 and c_cmode0 /= c3) then
					vtemp_sck := '1';
				else
					vtemp_sck := '0';
				end if;
				if (c_cmode0 = c0) then
					vtemp_sda := '0';
					n_state_i2c_fsm <= slave_ack;
				end if;
				if (c_cmode0 /= c0) then
					vtemp_sda := temp_sda;
					n_state_i2c_fsm <= slave_rw;
				end if;
			when slave_ack =>
				o_byte_sended <= '0';
				rc0_mrb <= '0';
				rc1_mrb <= '0';
				rc2_mrb <= '0';
				rc0_cpb <= '0';
				rc1_cpb <= '0';
				rc2_cpb <= '0';
				o_busy <= '1';
				if (c_cmode0 /= c1 and c_cmode0 /= c2 and (c_cmode0 = c0 or c_cmode0 = c3)) then
					vtemp_sck := '0';
				end if;
				if ((c_cmode0 = c1 or c_cmode0 = c2) and c_cmode0 /= c0 and c_cmode0 /= c3) then
					vtemp_sck := '1';
				else
					vtemp_sck := '0';
				end if;
				if (c_cmode0 = c0) then
					vtemp_sda := '1';
					n_state_i2c_fsm <= data;
				end if;
				if (c_cmode0 /= c0) then
					vtemp_sda := '0';
					n_state_i2c_fsm <= slave_ack;
				end if;
			when data =>
				o_byte_sended <= '0';
				rc0_mrb <= '0';
				rc1_mrb <= '0';
				rc2_mrb <= '0';
				rc0_cpb <= '0';
				rc1_cpb <= '1';
				rc2_cpb <= '0';
				o_busy <= '1';
				if (c_cmode0 /= c1 and c_cmode0 /= c2 and (c_cmode0 = c0 or c_cmode0 = c3)) then
					vtemp_sck := '0';
				end if;
				if ((c_cmode0 = c1 or c_cmode0 = c2) and c_cmode0 /= c0 and c_cmode0 /= c3) then
					vtemp_sck := '1';
				else
					vtemp_sck := '0';
				end if;
				if (c_cmode0 = c0) then
					vtemp_sda := i_bytes_to_send(index2);
					if (index2 = G_BYTE_SIZE-1) then
						n_state_i2c_fsm <= data_ack;
					else
						n_state_i2c_fsm <= data;
					end if;
				end if;
				if (c_cmode0 /= c0) then
					vtemp_sda := temp_sda;
				end if;
			when data_ack =>
				rc0_mrb <= '0';
				rc1_mrb <= '0';
				rc2_mrb <= '0';
				rc0_cpb <= '0';
				rc1_cpb <= '0';
				rc2_cpb <= '1';
				if (c_cmode0 /= c1 and c_cmode0 /= c2 and (c_cmode0 = c0 or c_cmode0 = c3)) then
					vtemp_sck := '0';
				end if;
				if ((c_cmode0 = c1 or c_cmode0 = c2) and c_cmode0 /= c0 and c_cmode0 /= c3) then
					vtemp_sck := '1';
				else
					vtemp_sck := '0';
				end if;
				if (c_cmode0 = c0) then
					vtemp_sda := '1';
				end if;
				if (c_cmode0 /= c0) then
					vtemp_sda := temp_sda;
				end if;
				if (i_enable = '1') then
					if (to_integer(unsigned(rc2_q)) = RC2_MAX-7) then
						n_state_i2c_fsm <= data;
						o_busy <= '0';
						o_byte_sended <= '1';
						rc2_mrb <= '1';
					else
						n_state_i2c_fsm <= data_ack;
						o_busy <= '1';
						o_byte_sended <= '0';
						rc2_mrb <= '0';
					end if;
				else
					if (to_integer(unsigned(rc2_q)) = RC2_MAX-7) then
						n_state_i2c_fsm <= stop;
						o_busy <= '1';
						o_byte_sended <= '0';
						rc2_mrb <= '1';
					else
						n_state_i2c_fsm <= data_ack;
						o_busy <= '1';
						o_byte_sended <= '0';
						rc2_mrb <= '0';
					end if;
				end if;
			when stop =>
				o_busy <= '1';
				o_byte_sended <= '0';
				rc0_mrb <= '0';
				rc1_mrb <= '0';
				rc2_mrb <= '0';
				rc0_cpb <= '0';
				rc1_cpb <= '0';
				rc2_cpb <= '0';
				if (c_cmode0 = c0) then
					vtemp_sda := '0';
					vtemp_sck := '1';
					n_state_i2c_fsm <= sda_stop;
				end if;
				if (c_cmode0 /= c0) then
					vtemp_sda := temp_sda;
					vtemp_sck := temp_sck;
					n_state_i2c_fsm <= stop;
				end if;
			when sda_stop =>
				rc0_mrb <= '0';
				rc1_mrb <= '0';
				rc2_mrb <= '0';
				rc0_cpb <= '0';
				rc1_cpb <= '0';
				rc2_cpb <= '0';
				o_byte_sended <= '0';
				if (c_cmode0 = c0) then
					vtemp_sck := '1';
					vtemp_sda := '1';
					n_state_i2c_fsm <= idle;
				end if;
				if (c_cmode0 /= c0) then
					vtemp_sck := temp_sck;
					vtemp_sda := temp_sda;
					n_state_i2c_fsm <= sda_stop;
				end if;
				o_busy <= '1';
			when others =>
				n_state_i2c_fsm <= idle;
				o_byte_sended <= '0';
				rc0_mrb <= '1';
				rc1_mrb <= '1';
				rc2_mrb <= '1';
				rc0_cpb <= '0';
				rc1_cpb <= '0';
				rc2_cpb <= '0';
				o_busy <= '0';
				vtemp_sda := temp_sda;
				vtemp_sck := temp_sck;
		end case;
		temp_sda <= vtemp_sda;
		temp_sck <= vtemp_sck;
	end process i2c_send_sequence_fsm;

	o_sda <= '0' when temp_sda = '0' else 'Z';
	o_scl <= '0' when temp_sck = '0' else 'Z';

end architecture Behavioral;
