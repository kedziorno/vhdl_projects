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

entity power_on is end power_on;

architecture Behavioral of power_on is
	procedure clk_gen(signal clk : out std_logic; constant wait_start : time; constant HT : time; constant LT : time) is
	begin
		clk <= '0';
		wait for wait_start;
		loop
			clk <= '1';
			wait for HT;
			clk <= '0';
			wait for LT;
		end loop;
	end procedure;

	shared variable i2c_clk : INTEGER := 50_000_000 / 100_000;
	shared variable count : INTEGER := 0;

	signal clock : std_logic := '0';
	signal clk : std_logic;
	signal sda : std_logic;
	signal sck : std_logic := '0';

	type state is (state0,state1,state2,state3,state4,state5,state6,state7);
	signal c_state,n_state : state := state0;
	
	signal slave : std_logic_vector(0 to 7) := "01111010";
	signal control : std_logic_vector(0 to 7) := "00000000";
	signal data : std_logic_vector(0 to 7) := "10101110";
begin	
	clk_gen(clk, 0 ns, 20 ns, 20 ns);

	p0 : process(clk) is
	begin
		if (rising_edge(clk)) then
			count := count + 1;
			if (count = i2c_clk) then
				count := 0;
				clock <= not clock;
			end if;
		end if;
	end process p0;

	p1 : process(clock) is
	begin
		if (rising_edge(clock)) then
			c_state <= n_state;
		end if;
	end process p1;

	p2 : process(c_state,clock) is
		variable s_idx,c_idx,d_idx : integer := 0;
	begin
		case c_state is
			when state0 => -- start condition
				sda <= '1';
				sck <= '1';
				n_state <= state1;
			when state1 => -- slave address byte
				if (falling_edge(clock) and s_idx < 8) then
					sda <= slave(s_idx);
					s_idx := s_idx + 1;
					n_state <= state1;
				else
					n_state <= state2;
				end if;
			when state2 => -- ack
				n_state <= state3;
			when state3 => -- control byte
				if (falling_edge(clock) and c_idx < 8) then
					sda <= control(c_idx);
					c_idx := c_idx + 1;
					n_state <= state3;
				else
					n_state <= state4;
				end if;
			when state4 => -- ack
				n_state <= state5;
			when state5 => -- data byte
				if (falling_edge(clock) and d_idx < 8) then
					sda <= data(d_idx);
					d_idx := d_idx + 1;
					n_state <= state5;
				else 
					n_state <= state6;
				end if;
			when state6 => -- ack
				n_state <= state7;
			when state7 => -- stop condition
				sda <= '1';
				sck <= '1';
				n_state <= state7;
		end case p_state;
		sck <= not clock;
	end process p2;
end Behavioral;

