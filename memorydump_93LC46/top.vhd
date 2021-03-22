----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:40:48 03/18/2021 
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
use WORK.p_constants.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Generic (
	G_BOARD_CLOCK : integer := G_BOARD_CLOCK_HARDWARE;
	G_BAUD_RATE : integer := G_BAUD_RATE
);
Port (
	i_clock : in  STD_LOGIC;
	i_reset : in  STD_LOGIC;
	o_cs : out  STD_LOGIC;
	o_sk : out  STD_LOGIC;
	o_di : out  STD_LOGIC;
	i_do : in  STD_LOGIC;
	o_RsTx : out  STD_LOGIC
);
end top;

architecture Behavioral of top is

	COMPONENT rs232 IS
	Generic (
		G_BOARD_CLOCK : integer := G_BOARD_CLOCK;
		G_BAUD_RATE : integer := G_BAUD_RATE
	);
	Port(
		clk : in  STD_LOGIC;
		rst : in  STD_LOGIC;
		enable : in  STD_LOGIC;
		byte_to_send : in  STD_LOGIC_VECTOR (G_MemoryData-1 downto 0);
		busy : out  STD_LOGIC;
		ready : out  STD_LOGIC;
		RsTx : out  STD_LOGIC
	);
	END COMPONENT rs232;

	COMPONENT clock_divider_count IS
	Generic (
		g_board_clock : integer := G_BOARD_CLOCK;
		g_divider : integer := 1
	);
	Port (
		i_reset : in STD_LOGIC;
		i_clock : in STD_LOGIC;
		o_clock : out STD_LOGIC
	);
	END COMPONENT clock_divider_count;

	type state_type is
	(start,
	di0,di1,di2,
	di_address,
	do_data,
	st_rs232_ready,
	st_rs232_send,
	st_rs232_waiting,
	di_address_increment,
	stop);
	signal state : state_type;

	signal rs232_enable,rs232_busy,rs232_ready : std_logic;
	signal rs232_byte_to_send : MemoryDataByte;
	signal cd_o_clock,cd_o_clock_prev : std_logic;
	signal cs,sk,di,do : std_logic;
	signal memory_address : MemoryAddress;
	signal memory_address_index : integer range 0 to G_MemoryAddress-1;
	signal memory_data : MemoryDataByte;
	signal memory_data_index : integer range 0 to G_MemoryData-1;

begin

	c_rs232 : rs232
	GENERIC MAP (
		G_BOARD_CLOCK => G_BOARD_CLOCK,
		G_BAUD_RATE => G_BAUD_RATE
	)
	PORT MAP (
		clk => i_clock,
		rst => i_reset,
		enable => rs232_enable,
		byte_to_send => rs232_byte_to_send,
		busy => rs232_busy,
		ready => rs232_ready,
		RsTx => o_RsTx
	);

	c_cd_div1 : clock_divider_count -- XXX SPI 1 MHZ
	GENERIC MAP (
		g_board_clock => G_BOARD_CLOCK,
		g_divider => G_BOARD_CLOCK/G_CLOCK_DIV1
	)
	PORT MAP (
		i_reset => i_reset,
		i_clock => i_clock,
		o_clock => cd_o_clock
	);

	o_cs <= cs;
	o_sk <= sk;
	o_di <= di;

	p0 : process (i_clock,i_reset) is
	begin
		if (i_reset = '1') then
			state <= start;
			cs <= '0';
			di <= '0';
			do <= '0';
			memory_address <= (others => '0');
			memory_address_index <= 0;
			memory_data <= (others => '0');
		elsif (rising_edge(i_clock)) then
			cd_o_clock_prev <= cd_o_clock; -- wait for clock transition
			sk <= cd_o_clock;
			case (state) is
				when start =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= di0;
						cs <= '1';
					else
						state <= start;
					end if;
				when di0 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= di1;
						di <= '1';
					else
						state <= di0;
					end if;
				when di1 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= di2;
						di <= '1';
					else
						state <= di1;
					end if;
				when di2 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= di_address;
						di <= '0';
					else
						state <= di2;
					end if;
				when di_address =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						if (memory_address_index = G_MemoryAddress - 1) then
							state <= do_data;
							di <= '0';
							memory_address_index <= 0;
						else
							state <= di_address;
							di <= memory_address(memory_address_index);
							memory_address_index <= memory_address_index + 1;
						end if;
					else
						state <= di_address;
					end if;
				when do_data =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						if (memory_data_index = G_MemoryData - 1) then
							state <= st_rs232_ready;
							memory_data_index <= 0;
						else
							memory_data(G_MemoryData-1 downto 0) <= memory_data(G_MemoryData-2 downto 0) & i_do;
							memory_data_index <= memory_data_index + 1;
						end if;
					else
						state <= do_data;
					end if;
				when st_rs232_ready =>
					rs232_enable <= '1';
					if (rs232_ready = '1') then
						state <= st_rs232_send;
						--rs232_byte_to_send <= not ('0' & memory_address);
						rs232_byte_to_send <= not memory_data;
					else
						state <= st_rs232_ready;
					end if;
				when st_rs232_send =>
					if (rs232_ready = '0') then
						state <= st_rs232_waiting;
					else
						state <= st_rs232_send;
					end if;
				when st_rs232_waiting =>
					if (rs232_busy = '1') then
						state <= st_rs232_waiting;
						rs232_enable <= '0';
					else
						state <= di_address_increment;
					end if;
				when di_address_increment =>						
					if (memory_address = std_logic_vector(to_unsigned(to_integer(unsigned(MemoryAddressMAX)),G_MemoryAddress))) then
						state <= stop;
					else
						memory_address <= std_logic_vector(to_unsigned(to_integer(unsigned(memory_address) + 1),G_MemoryAddress));
						state <= start;
					end if;
				when stop =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						cs <= '0';
						di <= '0';
					end if;
			end case;
		end if;
	end process p0;

end Behavioral;
