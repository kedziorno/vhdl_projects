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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rs232 is
Generic (
	G_BOARD_CLOCK : integer := 50_000_000;
	G_BAUD_RATE : integer := 9_600
);
Port(
	clk : in  STD_LOGIC;
	rst : in  STD_LOGIC;
	enable : in  STD_LOGIC;
	byte_to_send : in  STD_LOGIC_VECTOR (7 downto 0);
	busy : out  STD_LOGIC;
	ready : out  STD_LOGIC;
	RsTx : out  STD_LOGIC;
	RsRx : in  STD_LOGIC
);
end rs232;

architecture Behavioral of rs232 is

	signal clk_div1 : std_logic;
	
	type state is (idle,start,b1,b2,b3,b4,b5,b6,b7,b8,stop);
	signal c_state : state := start;

begin

	p_dv : process (clk,rst) is
		variable COUNTER_BAUD_RATE_MAX : integer := (G_BOARD_CLOCK/G_BAUD_RATE);
		variable counter_baud_rate : integer := 0;
	begin
		if (rst = '1') then
			counter_baud_rate := 0;
		elsif (rising_edge(clk)) then
			if (counter_baud_rate = COUNTER_BAUD_RATE_MAX-1) then
				clk_div1 <= '1';
				counter_baud_rate := 0;
			else
				clk_div1 <= '0';
				counter_baud_rate := counter_baud_rate + 1;
			end if;
		end if;
	end process p_dv;

	p0 : process (clk,clk_div1,rst) is
	begin
		if (rst = '1') then
			c_state <= start;
			busy <= '0';
			ready <= '1';
			RsTx <= '1';
		elsif (rising_edge(clk_div1)) then
			case c_state is
				when start =>
					c_state <= b1;
					busy <= '1';
					ready <= '0';
					RsTx <= '0';
				when b1 =>
					c_state <= b2;
					RsTx <= byte_to_send(7);
				when b2 =>
					c_state <= b3;
					RsTx <= byte_to_send(6);
				when b3 =>
					c_state <= b4;
					RsTx <= byte_to_send(5);
				when b4 =>
					c_state <= b5;
					RsTx <= byte_to_send(4);
				when b5 =>
					c_state <= b6;
					RsTx <= byte_to_send(3);
				when b6 =>
					c_state <= b7;
					RsTx <= byte_to_send(2);
				when b7 =>
					c_state <= b8;
					RsTx <= byte_to_send(1);
				when b8 =>
					c_state <= stop;
					RsTx <= byte_to_send(0);
					--RsTx <= byte_to_send(0) xor byte_to_send(1) xor byte_to_send(2) xor byte_to_send(3) xor byte_to_send(4) xor byte_to_send(5) xor byte_to_send(6) xor byte_to_send(7);
				when stop =>
					RsTx <= '1';
					c_state <= start;
					busy <= '0';
					ready <= '1';
				when others => null;
			end case;
		end if;
	end process p0;

end Behavioral;
