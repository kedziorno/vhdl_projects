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

	COMPONENT spi_master IS
		GENERIC(
			slaves  : INTEGER := slaves;  --number of spi slaves
			d_width : INTEGER := d_width); --data bus width
		PORT(
			clock   : IN     STD_LOGIC;                             --system clock
			reset_n : IN     STD_LOGIC;                             --asynchronous reset
			enable  : IN     STD_LOGIC;                             --initiate transaction
			cpol    : IN     STD_LOGIC;                             --spi clock polarity
			cpha    : IN     STD_LOGIC;                             --spi clock phase
			cont    : IN     STD_LOGIC;                             --continuous mode command
			clk_div : IN     INTEGER;                               --system clock cycles per 1/2 period of sclk
			addr    : IN     INTEGER;                               --address of slave
			tx_data : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
			miso    : IN     STD_LOGIC;                             --master in, slave out
			sclk    : BUFFER STD_LOGIC;                             --spi clock
			ss_n    : BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
			mosi    : OUT    STD_LOGIC;                             --master out, slave in
			busy    : OUT    STD_LOGIC;                             --busy / data ready signal
			rx_data : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
	END COMPONENT spi_master;

	type state_type is (
		some_wait,

		w_start,
		w_send1,w_send2,w_send3,w_send4,w_send5,w_send6,w_send7,w_send8,w_send9,
		w_wait1,w_wait2,w_wait3,w_wait4,w_wait5,w_wait6,w_wait7,w_wait8,w_wait9,
		off,off_busy,
		start,
		send1,send2,send3,send4,send5,
		wait1,wait2,wait3,wait4,wait5,
		read_data,
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
	constant TW_C_WAIT1 : integer := (4 * (G_BOARD_CLOCK/1000)); -- XXX 4ms
	signal tw_index : integer;
	signal tw_v_wait1 : std_logic_vector(31 downto 0);
	signal tw_memory_data_1 : std_logic_vector(d_width-1 downto 0);
	signal tw_memory_address_1 : std_logic_vector(d_width-1 downto 0);

	constant SW : integer := 1; --2*G_BOARD_CLOCK;
	signal index : integer;

	signal enable,cpol,cpha,cont,miso,sclk,mosi,busy : std_logic;
	signal addr : integer;
	signal tx_data,rx_data : std_logic_vector(d_width-1 downto 0);
	signal ss_n : std_logic_vector(slaves-1 downto 0);
	
begin

	spim : spi_master
		GENERIC MAP (
			slaves  => slaves,  --number of spi slaves
			d_width => d_width) --data bus width
		PORT MAP (
			clock => i_clock,                             --system clock
			reset_n => i_reset,                             --asynchronous reset
			enable => enable,                             --initiate transaction
			cpol => cpol,                             --spi clock polarity
			cpha => cpha,                             --spi clock phase
			cont => cont,                             --continuous mode command
			clk_div => G_CLOCK_DIV1,                               --system clock cycles per 1/2 period of sclk
			addr => addr,                               --address of slave
			tx_data => tw_memory_data_1,  --data to transmit
			miso => miso,                             --master in, slave out
			sclk => sclk,                             --spi clock
			ss_n => ss_n,   --slave select
			mosi => mosi,                             --master out, slave in
			busy => busy,                             --busy / data ready signal
			rx_data => rx_data); --data received

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

	o_cs <= not ss_n(0);
	o_sk <= sclk;
	o_di <= mosi;
	miso <= i_do;

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
			tw_memory_data_1 <= (others => '0');
			tw_memory_address_1 <= (others => '0');
		elsif (rising_edge(i_clock)) then
			case (state) is
				when some_wait => -- wait
					if (index = SW-1) then
						state <= w_start;
						index <= 0;
					else
						state <= some_wait;
						index <= index + 1;
					end if;
				when w_start =>
					state <= w_send1;
					enable <= '1';
					cpol <= '0';
					cpha <= '0';
					addr <= 0;
					cont <= '1';
				when w_send1 =>
					state <= w_wait1;
					tw_memory_data_1 <= "10";
					enable <= '1';
				when w_wait1 =>
					if (busy = '1') then
						state <= w_wait1;
					else
						state <= w_send2;
						enable <= '0';
					end if;
				when w_send2 =>
					state <= w_wait2;
					tw_memory_data_1 <= "10";
					enable <= '1';
				when w_wait2 =>
					if (busy = '1') then
						state <= w_wait2;
					else
						state <= w_send3;
						enable <= '0';
					end if;					
				when w_send3 =>
					state <= w_wait3;
					tw_memory_data_1 <= "00";
					enable <= '1';
				when w_wait3 =>
					if (busy = '1') then
						state <= w_wait3;
					else
						state <= w_send4;
						enable <= '0';
					end if;
				when w_send4 =>
					state <= w_wait4;
					tw_memory_data_1 <= "00";
					enable <= '1';
				when w_wait4 =>
					if (busy = '1') then
						state <= w_wait4;
					else
						state <= w_send5;
						enable <= '0';
					end if;
				when w_send5 =>
					state <= w_wait5;
					tw_memory_data_1 <= "00";
					enable <= '1';
				when w_wait5 =>
					if (busy = '1') then
						state <= w_wait5;
					else
						state <= w_send6;
						enable <= '0';
					end if;
				when w_send6 =>
					state <= w_wait6;
					tw_memory_data_1 <= "11";
					enable <= '1';
				when w_wait6 =>
					if (busy = '1') then
						state <= w_wait6;
					else
						state <= w_send7;
						enable <= '0';
					end if;
				when w_send7 =>
					state <= w_wait7;
					tw_memory_data_1 <= "11";
					enable <= '1';
				when w_wait7 =>
					if (busy = '1') then
						state <= w_wait7;
					else
						state <= w_send8;
						enable <= '0';
					end if;
				when w_send8 =>
					state <= w_wait8;
					tw_memory_data_1 <= "11";
					enable <= '1';
				when w_wait8 =>
					if (busy = '1') then
						state <= w_wait8;
					else
						state <= w_send9;
						enable <= '0';
					end if;					
				when w_send9 =>
					state <= w_wait9;
					tw_memory_data_1 <= "11";
					enable <= '1';
				when w_wait9 =>
					if (busy = '1') then
						state <= w_wait9;
					else
						state <= off;
					end if;
				when off =>
					state <= off_busy;
					enable <= '0';
					cont <= '0';
				when off_busy =>
					if (busy = '1') then
						state <= off_busy;
					else
						state <= start;
					end if;
				when start => -- start
					state <= send1;
					cpol <= '0';
					cpha <= '0';
					addr <= 0;
					cont <= '1';
				when send1 =>
					state <= wait1;
					tw_memory_data_1 <= "11";
					enable <= '1';
				when wait1 =>
					if (busy = '1') then
						state <= wait1;
					else
						state <= send2;
						enable <= '0';
					end if;
				when send2 =>
					state <= wait2;
					tw_memory_data_1 <= "0" & memory_address(6);
					enable <= '1';
				when wait2 =>
					if (busy = '1') then
						state <= wait2;
					else
						state <= send3;
						enable <= '0';
					end if;
				when send3 =>
					state <= wait3;
					tw_memory_data_1 <= memory_address(5 downto 4);
					enable <= '1';
				when wait3 =>
					if (busy = '1') then
						state <= wait3;
					else
						state <= send4;
						enable <= '0';
					end if;
				when send4 =>
					state <= wait4;
					tw_memory_data_1 <= memory_address(3 downto 2);
					enable <= '1';
				when wait4 =>
					if (busy = '1') then
						state <= wait4;
					else
						state <= send5;
						enable <= '0';
					end if;
				when send5 =>
					state <= wait5;
					tw_memory_data_1 <= memory_address(1 downto 0);
					enable <= '1';
				when wait5 =>
					if (busy = '1') then
						state <= wait5;
					else
						state <= read_data;
						enable <= '0';
						cont <= '0';
						index <= 0;
					end if;
				when read_data =>
					if (index = (G_MemoryData/d_width)-1) then
						state <= st_rs232_enable_tx;
						index <= 0;
					else
						memory_data(G_MemoryData-1 downto 0) <= memory_data(G_MemoryData-d_width-1 downto 0) & rx_data;
						index <= index + 1;
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
						state <= start;
					end if;
				when stop =>
					state <= stop;
				when others => null;
			end case;
		end if;
	end process p0;

end Behavioral;
