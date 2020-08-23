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

entity power_on is 
--port (clk : in std_logic; sda,sck : out std_logic);
end power_on;

architecture Behavioral of power_on is
	shared variable i2c_clk : INTEGER := 50_000_000 / 400_000;
	shared variable count : INTEGER := 0;
	shared variable s_idx,c_idx,d_idx : integer := 0;

	signal clock : std_logic := '0';

	type state is (state0,state1,state2,state3,state4,state5,state6,state7);
	signal c_state,n_state : state := state0;

	constant AMNT_INSTRS: natural := 25;
	type IAR is array (0 to AMNT_INSTRS-1) of std_logic_vector(7 downto 0);
	signal Instrs : IAR := (x"ae",x"00",x"10",x"40",x"b0",x"81",x"ff",x"a1",x"a6",x"c9",x"a8",x"3f",x"d3",x"00",x"d5",x"80",x"d9",x"f1",x"da",x"12",x"db",x"40",x"8d",x"14",x"af");

	signal slave : std_logic_vector(0 to 7) := "01111010";
	signal control : std_logic_vector(0 to 7) := "00000000";
	
	signal clk,sda,sck : std_logic;
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

begin

	clk_gen(clk,20 ns,20 ns,20 ns);
	
	p0 : process(clk) is
	begin
		if (rising_edge(clk)) then
			count := count + 1;
			if (count = i2c_clk) then
				count := 0;
				clock <= not clock;
			end if;
			if (rising_edge(clock)) then
				c_state <= n_state;
			end if;
		end if;
	end process p0;
	
	p1 : process(c_state,clock) is
		variable temp_data : std_logic_vector(7 downto 0);
		variable idx_i,d_idx : integer := 0;
	begin
		case c_state is
			when state0 => -- start condition
				sda <= '1';
				sck <= '1';
				n_state <= state1;
			when state1 => -- slave address byte
				sck <= '1';
				if (s_idx < 8) then
					sda <= slave(s_idx);
					s_idx := s_idx + 1;
					n_state <= state1;
				else
					n_state <= state2;
				end if;
			when state2 => -- ack
				n_state <= state3;
			when state3 => -- control byte
				if (c_idx < 8) then
					sda <= control(c_idx);
					c_idx := c_idx + 1;
					n_state <= state3;
				else
					n_state <= state4;
				end if;
			when state4 => -- ack
				n_state <= state5;
			when state5 => -- data byte
				if(idx_i < AMNT_INSTRS) then
					temp_data := Instrs(idx_i); -- command
					idx_i := idx_i + 1;
					if (d_idx < 8) then
						sda <= temp_data(d_idx);
						d_idx := d_idx + 1;
					end if;
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
	end process p1;
end Behavioral;

