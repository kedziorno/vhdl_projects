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
port (clk : in std_logic; sda,sck : out std_logic);
end power_on;

architecture Behavioral of power_on is

	shared variable i2c_clk : INTEGER := 50_000_000 / 100_000;

	shared variable count : INTEGER := 0;

	signal clock : std_logic := '1';

	type state is (sda_start,start,pause,s_address,s_rw,s_ack,get_instruction,data,data_ack,stop,sda_stop);
	signal c_state,n_state : state := sda_start;

	constant AMNT_INSTRS: natural := 25;
	type IAR is array (0 to AMNT_INSTRS-1) of std_logic_vector(7 downto 0);
	signal Instrs : IAR := (x"ae",x"00",x"10",x"40",x"b0",x"81",x"ff",x"a1",x"a6",x"c9",x"a8",x"3f",x"d3",x"00",x"d5",x"80",x"d9",x"f1",x"da",x"12",x"db",x"40",x"8d",x"14",x"af");
	signal i_idx : std_logic_vector(7 downto 0) := x"00";

begin
	
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
		variable d_idx : integer := 8;
		variable s_idx : integer := 7;
		variable w : integer := 0;
		variable slave : std_logic_vector(6 downto 0) := "0111100";
	begin
		case c_state is
			when sda_start =>
				sda <= '1';
				sck <= '1';
				n_state <= start;
			when start =>
				sda <= '0';
				sck <= '1';
				n_state <= s_address;
			when s_address =>
				if(s_idx=1) then
					n_state <= s_rw;
				else
					sda <= slave(s_idx-1);
					if(w<1) then
						w := w + 1;
					else
						s_idx := s_idx - 1;
						w := 0;
					end if;
					n_state <= s_address;
				end if;
				sck <= not clock;
			when s_rw =>
				sck <= not clock;
				n_state <= s_ack;
			when s_ack =>
				sda <= '0';
				sck <= not clock;
				n_state <= get_instruction;
			when get_instruction =>
				sda <= '0';
				if(rising_edge(clock)) then
					i_idx <= std_logic_vector(to_unsigned(to_integer(unsigned(i_idx))+1,8));
				end if;
				d_idx := 8;
				n_state <= data;
				sck <= not clock;
			when data =>
				if (d_idx=1) then
					n_state <= data_ack;
				else
					sda <= Instrs(to_integer(unsigned(i_idx)))(d_idx-1); -- command
					if(w<1) then
						w := w + 1;
					else
						d_idx := d_idx - 1;
						w := 0;
					end if;
					n_state <= data;
				end if;
				sck <= not clock;
			when data_ack =>
				sda <= '0';
				sck <= not clock;
				if(unsigned(i_idx)<AMNT_INSTRS-1) then
					n_state <= get_instruction;
				else
					n_state <= stop;
				end if;
			when stop =>
				sda <= '0';
				sck <= not clock;
				n_state <= sda_stop;
			when sda_stop =>
				sda <= '1';
				sck <= '1';
			when others => null;
		end case;
	end process p2;
end Behavioral;
