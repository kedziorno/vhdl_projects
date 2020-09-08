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

entity module_1 is
Port(
	clk : in  STD_LOGIC_VECTOR (0 downto 0);
	RsTx : out  STD_LOGIC_VECTOR (0 downto 0);
	RsRx : in  STD_LOGIC_VECTOR (0 downto 0)
);
end module_1;

architecture Behavioral of module_1 is
	constant CLK_BOARD : integer := 50_000_000;
	constant BAUD_RATE : integer := 38_400;

	signal clk_div1 : std_logic_vector (0 downto 0);
	
	constant NUMBER_BITS : integer := 8;
	signal send_byte_index : std_logic_vector(NUMBER_BITS-1 downto 0) := x"00";

	signal byte_to_send : std_logic_vector (NUMBER_BITS-1 downto 0) := "10101010";
--	signal byte_to_send : std_logic_vector (NUMBER_BITS-1 downto 0) := "01010101";
--	signal byte_to_send : std_logic_vector (NUMBER_BITS-1 downto 0) := "11111111";
--	signal byte_to_send : std_logic_vector (NUMBER_BITS-1 downto 0) := "00000000";
	
	type state is (start,increment_index,send_byte,send_byte_last,stop);
	signal c_state,n_state : state := start;
begin

	p_dv : process (clk) is
		variable COUNTER_BAUD_RATE_MAX : integer := (CLK_BOARD/BAUD_RATE);
		variable counter_baud_rate : integer := 0;
	begin
		if (rising_edge(clk(0))) then
			if (counter_baud_rate < COUNTER_BAUD_RATE_MAX-1) then
				clk_div1 <= std_logic_vector(to_unsigned(0,1));
				counter_baud_rate := counter_baud_rate + 1;
			else
				clk_div1 <= std_logic_vector(to_unsigned(1,1));
				counter_baud_rate := 0;
			end if;
		end if;
	end process p_dv;

	p0 : process (clk_div1,send_byte_index) is
	begin
		if (rising_edge(clk_div1(0))) then
			c_state <= n_state;
			send_byte_index <= std_logic_vector(unsigned(send_byte_index)+1);
		end if;
		case c_state is
			when start =>
				RsTx <= std_logic_vector(to_unsigned(0,1));
				send_byte_index <= x"00";
				n_state <= send_byte;				
			when send_byte =>				
				if (to_integer(unsigned(send_byte_index)) < NUMBER_BITS-1) then
					n_state <= send_byte;
				else
					n_state <= stop;
				end if;
				if (byte_to_send(to_integer(NUMBER_BITS-1-unsigned(send_byte_index))) = '0') then
					RsTx <= std_logic_vector(to_unsigned(0,1));
				elsif (byte_to_send(to_integer(NUMBER_BITS-1-unsigned(send_byte_index))) = '1') then
					RsTx <= std_logic_vector(to_unsigned(1,1));
				end if;
			when stop =>
				RsTx <= std_logic_vector(to_unsigned(1,1));
				send_byte_index <= x"00";
				n_state <= start;
			when others => null;
		end case;
	end process p0;

end Behavioral;
