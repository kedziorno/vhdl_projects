----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:31:58 03/19/2021 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Generic (
	G_BOARD_CLOCK : integer := G_BOARD_CLOCK;
	G_BAUD_RATE : integer := G_BAUD_RATE
);
Port (
	i_clock : in  STD_LOGIC;
	i_reset : in  STD_LOGIC;
	o_RsTX : out  STD_LOGIC;
	i_RsRX : in  STD_LOGIC
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
		byte_to_send : in  STD_LOGIC_VECTOR (8 downto 0);
		byte_received : out  STD_LOGIC_VECTOR (7 downto 0);
		parity_tx : out  STD_LOGIC;
		parity_rx : out  STD_LOGIC;
		busy : out  STD_LOGIC;
		ready : out  STD_LOGIC;
		is_byte_received : out STD_LOGIC;
		RsTx : out  STD_LOGIC;
		RsRx : in  STD_LOGIC
	);
	END COMPONENT rs232;

	signal enable_tx,enable_rx,busy,ready,is_byte_received,parity_tx,parity_rx : std_logic;
	signal byte_to_send : std_logic_vector(8 downto 0);
	signal byte_received : std_logic_vector(7 downto 0);

	type state_type is (
		idle,
		st_enable_rx,
		st_rs_rx,
		st_disable_rx,
		st_enable_tx,
		st_rs232_ready,
		st_rs232_send,
		st_rs232_waiting,
		st_disable_tx
	);
	signal state : state_type;

begin

	c_rs232 : rs232
	GENERIC MAP (
		G_BOARD_CLOCK => G_BOARD_CLOCK,
		G_BAUD_RATE => G_BAUD_RATE
	)
	PORT MAP (
		clk => i_clock,
		rst => i_reset,
		enable_tx => enable_tx,
		enable_rx => enable_rx,
		byte_to_send => byte_to_send,
		byte_received => byte_received,
		parity_tx => parity_tx,
		parity_rx => parity_rx,
		busy => busy,
		ready => ready,
		is_byte_received => is_byte_received,
		RsTx => o_RsTX,
		RsRx => i_RsRX
	);

	p0 : process (i_clock,i_reset) is
	begin
		if (i_reset = '1') then
			state <= idle;
			enable_tx <= '0';
			enable_rx <= '0';
		elsif (rising_edge(i_clock)) then
			case (state) is
				when idle =>
					if (ready = '1') then
						state <= st_enable_rx;
					else
						state <= idle;
					end if;
				when st_enable_rx =>
					state <= st_rs_rx;
					enable_rx <= '1';
				when st_rs_rx =>
					if (is_byte_received = '1') then
						state <= st_disable_rx;
						byte_to_send <= parity_rx & byte_received;
					else
						state <= st_rs_rx;
					end if;
				when st_disable_rx =>
					state <= st_enable_tx;
					enable_rx <= '0';
				when st_enable_tx =>
					state <= st_rs232_ready;
					enable_tx <= '1';
				when st_rs232_ready =>
					if (ready = '1') then
						state <= st_rs232_send;
					else
						state <= st_rs232_ready;
					end if;
				when st_rs232_send =>
					if (ready = '0') then
						state <= st_rs232_waiting;
					else
						state <= st_rs232_send;
					end if;
				when st_rs232_waiting =>
					if (busy = '1') then
						state <= st_rs232_waiting;
					else
						state <= st_disable_tx;
					end if;
				when st_disable_tx =>
					state <= idle;
					enable_tx <= '0';
			end case;
		end if;
	end process p0;

end Behavioral;
