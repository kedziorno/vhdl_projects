----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:54:25 09/08/2020 
-- Design Name: 
-- Module Name:    module_1 - Behavioral 
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

entity rs232 is
Generic (
	G_BOARD_CLOCK : integer := G_BOARD_CLOCK_HARDWARE;
	G_BAUD_RATE : integer := G_BAUD_RATE
);
Port(
	clk : in  STD_LOGIC;
	rst : in  STD_LOGIC;
	enable_tx : in  STD_LOGIC;
	enable_rx : in  STD_LOGIC;
	byte_to_send : in  STD_LOGIC_VECTOR (7 downto 0);
	byte_received : out  STD_LOGIC_VECTOR (7 downto 0);
	busy : out  STD_LOGIC;
	ready : out  STD_LOGIC;
	is_byte_received : out STD_LOGIC;
	RsTx : out  STD_LOGIC;
	RsRx : in  STD_LOGIC
);
end rs232;

architecture Behavioral of rs232 is

	constant recv_bits : integer := 10;
	constant a : integer := (G_BOARD_CLOCK/G_BAUD_RATE);

	signal v_i : std_logic_vector(31 downto 0);
	signal v_w : std_logic_vector(31 downto 0);
	signal t_w : std_logic_vector(31 downto 0);
	signal temp : std_logic_vector(recv_bits - 1 downto 0);

	type state is (
	idle,
	start,wstart,
	b1,wb1,b2,wb2,b3,wb3,b4,wb4,b5,wb5,b6,wb6,b7,wb7,b8,wb8,
	parity,wparity,
	stop,wstop
	);
	signal c_state : state;

	type s_recv is (
		idle,
		start,
		recv,
		wait0,
		increment,
		stop
	);
	signal r_state : s_recv;

begin

	p0 : process (clk,rst) is
	begin
		if (rst = '1') then
			r_state <= idle;
			v_i <= (others => '0');
			v_w <= (others => '0');
			temp <= (others => '0');
		elsif (rising_edge(clk)) then
			case (r_state) is
				when idle =>
					if (enable_rx = '1') then
						r_state <= start;
						v_i <= (others => '0');
						v_w <= (others => '0');
						is_byte_received <= '0';
					elsif (enable_rx = '0') then
						r_state <= idle;
					end if;
				when start =>
					if (RsRx = '1') then
						if (to_integer(unsigned(v_i)) = a-1) then
							r_state <= recv;
							v_i <= x"00000001"; -- we receive first bit
							temp(0) <= RsRx;
						else
							r_state <= start;
							v_i <= std_logic_vector(to_unsigned(to_integer(unsigned(v_i)) + 1,32));
						end if;
					elsif (RsRx = '0') then
						r_state <= start;
						v_i <= (others => '0');
					end if;
				when recv =>
					r_state <= wait0;
					temp(to_integer(unsigned(v_i))) <= RsRx;
				when wait0 =>
					if (to_integer(unsigned(v_w)) = a-1) then
						r_state <= increment;
						v_w <= (others => '0');
					else
						v_w <= std_logic_vector(to_unsigned(to_integer(unsigned(v_w)) + 1,32));
						r_state <= wait0;
					end if;
				when increment =>
					if (to_integer(unsigned(v_i)) = recv_bits-1) then
						r_state <= stop;
						v_i <= (others => '0');
					else
						v_i <= std_logic_vector(to_unsigned(to_integer(unsigned(v_i)) + 1,32));
						r_state <= recv;
					end if;
				when stop =>
					r_state <= idle;
					byte_received <= temp(recv_bits-2 downto 1);
					is_byte_received <= '1';
			end case;
		end if;
	end process p0;

	p1 : process (clk,rst) is
	begin
		if (rst = '1') then
			c_state <= start;
			busy <= '0';
			ready <= '1';
			RsTx <= '0';
			t_w <= (others => '0');
		elsif (rising_edge(clk)) then
			case c_state is
				when idle =>
					if (enable_tx = '1') then
						c_state <= start;
					end if;
				when start =>
					c_state <= wstart;
					busy <= '1';
					ready <= '0';
					RsTx <= '1';
				when wstart =>
					if (to_integer(unsigned(t_w)) = a-1) then
						c_state <= b1;
						t_w <= (others => '0');
					else
						c_state <= wstart;
						t_w <= std_logic_vector(to_unsigned(to_integer(unsigned(t_w)) + 1,32));
					end if;
				when b1 =>
					c_state <= wb1;
					RsTx <= byte_to_send(0);
				when wb1 =>
					if (to_integer(unsigned(t_w)) = a-1) then
						c_state <= b2;
						t_w <= (others => '0');
					else
						c_state <= wb1;
						t_w <= std_logic_vector(to_unsigned(to_integer(unsigned(t_w)) + 1,32));
					end if;
				when b2 =>
					c_state <= wb2;
					RsTx <= byte_to_send(1);
				when wb2 =>
					if (to_integer(unsigned(t_w)) = a-1) then
						c_state <= b3;
						t_w <= (others => '0');
					else
						c_state <= wb2;
						t_w <= std_logic_vector(to_unsigned(to_integer(unsigned(t_w)) + 1,32));
					end if;
				when b3 =>
					c_state <= wb3;
					RsTx <= byte_to_send(2);
				when wb3 =>
					if (to_integer(unsigned(t_w)) = a-1) then
						c_state <= b4;
						t_w <= (others => '0');
					else
						c_state <= wb3;
						t_w <= std_logic_vector(to_unsigned(to_integer(unsigned(t_w)) + 1,32));
					end if;
				when b4 =>
					c_state <= wb4;
					RsTx <= byte_to_send(3);
				when wb4 =>
					if (to_integer(unsigned(t_w)) = a-1) then
						c_state <= b5;
						t_w <= (others => '0');
					else
						c_state <= wb4;
						t_w <= std_logic_vector(to_unsigned(to_integer(unsigned(t_w)) + 1,32));
					end if;
				when b5 =>
					c_state <= wb5;
					RsTx <= byte_to_send(4);
				when wb5 =>
					if (to_integer(unsigned(t_w)) = a-1) then
						c_state <= b6;
						t_w <= (others => '0');
					else
						c_state <= wb5;
						t_w <= std_logic_vector(to_unsigned(to_integer(unsigned(t_w)) + 1,32));
					end if;
				when b6 =>
					c_state <= wb6;
					RsTx <= byte_to_send(5);
				when wb6 =>
					if (to_integer(unsigned(t_w)) = a-1) then
						c_state <= b7;
						t_w <= (others => '0');
					else
						c_state <= wb6;
						t_w <= std_logic_vector(to_unsigned(to_integer(unsigned(t_w)) + 1,32));
					end if;
				when b7 =>
					c_state <= wb7;
					RsTx <= byte_to_send(6);
				when wb7 =>
					if (to_integer(unsigned(t_w)) = a-1) then
						c_state <= b8;
						t_w <= (others => '0');
					else
						c_state <= wb7;
						t_w <= std_logic_vector(to_unsigned(to_integer(unsigned(t_w)) + 1,32));
					end if;
				when b8 =>
					c_state <= wb8;
					RsTx <= byte_to_send(7);
				when wb8 =>
					if (to_integer(unsigned(t_w)) = a-1) then
						c_state <= parity;
						t_w <= (others => '0');
					else
						c_state <= wb8;
						t_w <= std_logic_vector(to_unsigned(to_integer(unsigned(t_w)) + 1,32));
					end if;
				when parity =>
					c_state <= wparity;
					RsTx <= byte_to_send(0) xor byte_to_send(1) xor byte_to_send(2) xor byte_to_send(3) xor byte_to_send(4) xor byte_to_send(5) xor byte_to_send(6) xor byte_to_send(7);
				when wparity =>
					if (to_integer(unsigned(t_w)) = a-1) then
						c_state <= stop;
						t_w <= (others => '0');
					else
						c_state <= wparity;
						t_w <= std_logic_vector(to_unsigned(to_integer(unsigned(t_w)) + 1,32));
					end if;
				when stop =>
					RsTx <= '0';
					c_state <= wstop;
					busy <= '0';
					ready <= '1';
				when wstop =>
					if (to_integer(unsigned(t_w)) = a-1) then
						c_state <= idle;
						t_w <= (others => '0');
					else
						c_state <= wstop;
						t_w <= std_logic_vector(to_unsigned(to_integer(unsigned(t_w)) + 1,32));
					end if;
				when others => null;
			end case;
		end if;
	end process p1;

end Behavioral;
