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
port (reset,clk : in std_logic; sda,sck : inout std_logic);
end power_on;

architecture Behavioral of power_on is

	shared variable i2c_clk : INTEGER := 50_000_000 / 100_000 / 4;

	shared variable count : INTEGER := 0;

	signal clock : std_logic := '0';
	signal clock_strength : std_logic;
	--signal clock_prev : std_logic;
	
	type state is (sda_start,start,pause,s_address,s_rw,s_ack,data,data_last_bit,data_ack,stop,sda_stop);
	signal c_state,n_state : state := sda_start;

	constant AMNT_INSTRS : natural := 26;
	type IAR is array (0 to AMNT_INSTRS-1) of std_logic_vector(7 downto 0);
	signal Instrs : IAR := (x"AE",x"D5",x"F0",x"A8",x"1F",x"D3",x"00",x"40",x"8D",x"14",x"20",x"00",x"A1",x"C8",x"DA",x"02",x"81",x"8F",x"D9",x"F1",x"DB",x"40",x"A4",x"A6",x"2E",x"AF");

	signal i_idx : std_logic_vector(7 downto 0) := x"00";

	type clock_mode is (c0,c1,c2,c3);
	signal c_cmode,n_cmode : clock_mode := c0;

begin

	-- clk divider - clock = ~9.96us
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
		if (reset = '1') then
			c_state <= sda_start;
		elsif (rising_edge(clock) or falling_edge(clock)) then
			c_state <= n_state;
		end if;
	end process p1;

	p2 : process(clock) is
	begin
		if (rising_edge(clock) or falling_edge(clock)) then
			c_cmode <= n_cmode;
		end if;
	end process p2;

	-- clock_strength = ~19.96us
	p3 : process(clock,c_cmode) is
	begin
		case c_cmode is
			when c0 =>
				clock_strength <= '0';
				n_cmode <= c1;
			when c1 =>
				clock_strength <= '0';
				n_cmode <= c2;
			when c2 =>
				clock_strength <= '1';
				n_cmode <= c3;
			when c3 =>
				clock_strength <= '1';
				n_cmode <= c0;
			when others => null;
		end case;
	end process p3;

	p4 : process(c_cmode,c_state,clock,clock_strength) is
		variable d_idx : integer := 8;
		variable slave_idx : integer := 7;
		variable nc: integer := 1;
		variable counter: integer := nc;
		variable w : integer := 0;
		variable slave : std_logic_vector(slave_idx-1 downto 0) := "1010101";
--		variable slave : std_logic_vector(slave_idx-1 downto 0) := "0101010";
	begin
		case c_state is
			when sda_start =>
				if (c_cmode = c0) then
					sda <= '1';
				end if;
				sck <= '1';
				n_state <= start;
			when start =>
				if (c_cmode = c1) then
					sda <= '0';
				end if;
				sck <= '1';
				n_state <= s_address;
			when s_address =>
				sck <= not clock_strength;
				if (c_cmode = c3) then
					if (slave_idx > 0) then
						if (rising_edge(clock) and sck = '0' and clock_strength = '1' and c_cmode = c2) then
							sda <= '0';
						else
--if (slave_idx > 0 and slave_idx <=	 7) then
						sda <= slave(slave_idx - 1);
--					end if;
					end if;
						if (counter > 0) then
							counter := counter - 1;
						else
							slave_idx := slave_idx - 1;
							counter := nc;
						end if;

						n_state <= s_address;
					else
						--sda <= slave(0);
						n_state <= s_rw;
						counter := nc;
					end if;
				end if;
			when s_rw =>
				sck <= not clock_strength;
				if (counter > 0) then
					--if (c_cmode = c1) then
						sda <= '0'; -- rw
					--end if;
					counter := counter - 1;
					n_state <= s_rw;
				else
					n_state <= s_ack;
					counter := nc;
				end if;
			when s_ack =>
				sck <= not clock_strength;
				if (counter > 0) then
					--if (c_cmode = c1) then
						sda <= '1'; -- ack
					--end if;
					counter := counter - 1;
					n_state <= s_ack;
				else
					n_state <= data;
					counter := nc;
				end if;
			when data =>
				sck <= not clock_strength;
				if (d_idx<0) then
					n_state <= data_ack;
				elsif (d_idx=1) then
					n_state <= data_last_bit;
				else
					sda <= Instrs(to_integer(unsigned(i_idx)))(d_idx); -- command
					if(w<1 and d_idx <= 7) then
						w := w + 1;
						n_state <= data;
					else
						d_idx := d_idx - 1;
						w := 0;
					end if;
				end if;
			when data_last_bit =>
				sda <= Instrs(to_integer(unsigned(i_idx)))(0); -- last bit
				sck <= not clock_strength;
				n_state <= data_ack;
			when data_ack =>
				sda <= '0';
				sck <= not clock_strength;
				if(unsigned(i_idx)<AMNT_INSTRS-1) then
					if(rising_edge(clock)) then
						i_idx <= std_logic_vector(to_unsigned(to_integer(unsigned(i_idx))+1,8));
					end if;
					d_idx := 7;
					n_state <= data;
				else
					n_state <= stop;
				end if;
			when stop =>
				sda <= '0';
				sck <= not clock_strength;
				n_state <= sda_stop;
			when sda_stop =>
				sda <= '1';
				sck <= '1';
			when others => null;
		end case;
		--end if;
	end process p4;

end Behavioral;
