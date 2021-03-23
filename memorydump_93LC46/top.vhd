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
	o_RsTx : out  STD_LOGIC;
	i_RsRx : in  STD_LOGIC
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
		enable_tx : in  STD_LOGIC;
		enable_rx : in  STD_LOGIC;
		byte_to_send : in  MemoryDataByte;
		byte_received : out  MemoryDataByte;
		busy : out  STD_LOGIC;
		ready : out  STD_LOGIC;
		is_byte_received : out STD_LOGIC;
		RsTx : out  STD_LOGIC;
		RsRx : in  STD_LOGIC
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

	type state_type is (
		some_wait,
		start,
		
		tw_di0,tw_di1,tw_di2,tw_di3,tw_di4, -- send EWEN
		tw_disable_cs,tw_enable_cs,
		
		tv_di0,tv_di1,tv_di2,tv_di3,tv_di4, -- erase all
		tv_disable_cs,tv_wait1,tv_enable_cs,tv_disable_cs1, -- in tv_wait1 check the READY/bBUSY
		
		tu_di0,tu_di1,tu_di2,tu_di3,tu_di4, -- send EWDS
		tu_disable_cs,tu_enable_cs,tu_enable_cs1,
		
		di0,di1,di2,
		di_address,
		di_set_di1,
		do_data,
		di_set_di2,
		st_rs232_enable_tx,
		st_rs232_ready,
		st_rs232_send,
		st_rs232_waiting,
		st_rs232_disable_tx,
		di_address_increment,
		stop
	);
	signal state : state_type;

	signal rs232_enable_tx,rs232_enable_rx,rs232_busy,rs232_ready,rs232_is_byte_received : std_logic;
	signal rs232_byte_to_send,rs232_byte_received : MemoryDataByte;
	signal cd_o_clock,cd_o_clock_prev : std_logic;
	signal cs,sk,di,do : std_logic;
	signal memory_address : MemoryAddress;
	signal memory_address_index : integer range 0 to G_MemoryAddress-1;
	signal memory_data : MemoryDataByte;
	signal memory_data_index : integer range 0 to G_MemoryData-1;
	constant TW_C_WAIT1 : integer := (4 * 1000); -- XXX 4ms
	signal tw_v_wait1 : std_logic_vector(31 downto 0);
	signal tw_memory_data_1 : MemoryDataByte;
	signal tw_memory_address_1 : MemoryAddress;

	constant SW : integer := 2*G_BOARD_CLOCK;
	signal index : integer;

begin

	c_rs232 : rs232
	GENERIC MAP (
		G_BOARD_CLOCK => G_BOARD_CLOCK,
		G_BAUD_RATE => G_BAUD_RATE
	)
	PORT MAP (
		clk => i_clock,
		rst => i_reset,
		enable_tx => rs232_enable_tx,
		enable_rx => rs232_enable_rx,
		byte_to_send => rs232_byte_to_send,
		byte_received => rs232_byte_received,
		busy => rs232_busy,
		ready => rs232_ready,
		is_byte_received => rs232_is_byte_received,
		RsTx => o_RsTx,
		RsRx => i_RsRx
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
			index <= 0;
			state <= some_wait;
			cs <= '0';
			di <= '0';
			do <= 'Z';
			memory_address <= (others => '0');
			memory_address_index <= 0;
			memory_data <= (others => '0');
			memory_data_index <= 0;
			tw_v_wait1 <= (others => '0');
			tw_memory_data_1 <= x"00";
			tw_memory_address_1 <= "0000000";
		elsif (rising_edge(i_clock)) then
			cd_o_clock_prev <= cd_o_clock; -- wait for clock transition
			sk <= cd_o_clock;
			case (state) is
				when some_wait => -- wait
					if (index = SW-1) then
						state <= start;
						index <= 0;
					else
						state <= some_wait;
						index <= index + 1;
					end if;
				when start => -- start
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tw_di0;
						cs <= '1'; -- XXX CS
					else
						state <= start;
					end if;
					
					
					
					
				when tw_di0 => -- send EWEN
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tw_di1;
						di <= '1';
					else
						state <= tw_di0;
					end if;
				when tw_di1 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tw_di2;
						di <= '0';
					else
						state <= tw_di1;
					end if;
				when tw_di2 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tw_di3;
						di <= '0';
					else
						state <= tw_di2;
					end if;
				when tw_di3 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tw_di4;
						di <= '1';
					else
						state <= tw_di3;
					end if;
				when tw_di4 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tw_disable_cs;
						di <= '1';
					else
						state <= tw_di4;
					end if;
				when tw_disable_cs =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tw_enable_cs;
						cs <= '0'; -- XXX CS
						di <= '0';
					else
						state <= tw_disable_cs;
					end if;
				when tw_enable_cs =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tv_di0;
						cs <= '1'; -- XXX CS
					else
						state <= tw_enable_cs;
					end if;
				
				
				
				
				when tv_di0 =>  -- erase all
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tv_di1;
						di <= '1';
					else
						state <= tv_di0;
					end if;
				when tv_di1 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tv_di2;
						di <= '0';
					else
						state <= tv_di1;
					end if;
				when tv_di2 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tv_di3;
						di <= '0';
					else
						state <= tv_di2;
					end if;
				when tv_di3 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tv_di4;
						di <= '1';
					else
						state <= tv_di3;
					end if;
				when tv_di4 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tv_disable_cs;
						di <= '0';
					else
						state <= tv_di4;
					end if;
				when tv_disable_cs =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tv_enable_cs;
						cs <= '0'; -- XXX CS
						di <= '0';
					else
						state <= tv_disable_cs;
					end if;
				when tv_enable_cs =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tv_wait1;
						cs <= '1'; -- XXX CS
					else
						state <= tv_enable_cs;
					end if;
				when tv_wait1 =>
					if (i_do = '1') then
						state <= tv_disable_cs1;
					elsif (i_do = '0') then
						state <= tv_wait1;
					end if;
--					if (to_integer(unsigned(tw_v_wait1)) = SW-1) then
--						state <= tv_enable_cs; 
--						tw_v_wait1 <= (others => '0');
--					else
--						state <= tv_wait1;
--						tw_v_wait1 <= std_logic_vector(to_unsigned(to_integer(unsigned(tw_v_wait1)) + 1,32));
--					end if;
				when tv_disable_cs1 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tu_enable_cs1;
						cs <= '0'; -- XXX CS
						di <= '0';
					else
						state <= tv_disable_cs1;
					end if;
					
					
					
				when tu_enable_cs1 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tu_di0;
						cs <= '1'; -- XXX CS
					else
						state <= tu_enable_cs1;
					end if;	
				when tu_di0 => -- send EWDS
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tu_di1;
						di <= '1';
					else
						state <= tu_di0;
					end if;
				when tu_di1 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tu_di2;
						di <= '0';
					else
						state <= tu_di1;
					end if;
				when tu_di2 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tu_di3;
						di <= '0';
					else
						state <= tu_di2;
					end if;
				when tu_di3 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tu_di4;
						di <= '0';
					else
						state <= tu_di3;
					end if;
				when tu_di4 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tu_disable_cs;
						di <= '0';
					else
						state <= tu_di4;
					end if;
				when tu_disable_cs =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= tu_enable_cs;
						cs <= '0'; -- XXX CS
						di <= '0';
					else
						state <= tu_disable_cs;
					end if;
				when tu_enable_cs =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= di0;
						cs <= '1'; -- XXX CS
					else
						state <= tu_enable_cs;
					end if;
					
					
					
					
				when di0 => -- read and send
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
							state <= di_set_di1;
							di <= memory_address(G_MemoryAddress - 1);
							memory_address_index <= 0;
						else
							state <= di_address;
							di <= memory_address(memory_address_index);
							memory_address_index <= memory_address_index + 1;
						end if;
					else
						state <= di_address;
					end if;
				when di_set_di1 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= do_data;
						di <= '0';
					else
						state <= di_set_di1;
					end if;
				when do_data =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						if (memory_data_index = G_MemoryData - 1) then
							state <= di_set_di2;
							memory_data(G_MemoryData-1) <= i_do;
							memory_data_index <= 0;
						else
							memory_data(G_MemoryData-1 downto 0) <= memory_data(G_MemoryData-2 downto 0) & i_do;
							memory_data_index <= memory_data_index + 1;
						end if;
					else
						state <= do_data;
					end if;
				when di_set_di2 =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						state <= st_rs232_enable_tx;
						di <= '0';
					else
						state <= di_set_di2;
					end if;
				when st_rs232_enable_tx =>
					state <= st_rs232_ready;
					rs232_enable_tx <= '1';
				when st_rs232_ready =>
					if (rs232_ready = '1') then
						state <= st_rs232_send;
						--rs232_byte_to_send <= not ('0' & memory_address); -- XXX for tb
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
					else
						state <= st_rs232_disable_tx;
					end if;
				when st_rs232_disable_tx =>
					state <= di_address_increment;
					rs232_enable_tx <= '0';
				when di_address_increment =>						
					if (memory_address = std_logic_vector(to_unsigned(to_integer(unsigned(MemoryAddressMAX)),G_MemoryAddress))) then
						state <= stop;
					else
						memory_address <= std_logic_vector(to_unsigned(to_integer(unsigned(memory_address) + 1),G_MemoryAddress));
						state <=  tu_enable_cs; -- XXX tu_disable_cs , di_set_di1 - omit the addresses
					end if;
				when stop =>
					if (cd_o_clock_prev = '0' and cd_o_clock = '1') then
						cs <= '0'; -- XXX CS
						di <= '0';
					end if;
				--when others => null;
			end case;
		end if;
	end process p0;

end Behavioral;
