----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:11:54 09/04/2020 
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
use WORK.p_pkg1.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
port(
signal clk : in std_logic;
signal btn_1 : in std_logic;
signal btn_2 : in std_logic;
signal btn_3 : in std_logic;
signal btn_4 : in std_logic;
signal sda,scl : inout std_logic
);
end top;

architecture Behavioral of top is

component test_oled is 
port
(
signal i_clk : in std_logic;
signal i_rst : in std_logic;
signal i_refresh : in std_logic;
signal i_char : in array1;
signal io_sda,io_scl : inout std_logic
);
end component test_oled;
for all : test_oled use entity WORK.test_oled(Behavioral);

component debounce_button is
Port
(
i_button : in  STD_LOGIC;
i_clk : in  STD_LOGIC;
o_stable : out  STD_LOGIC
);
end component debounce_button;
for all : debounce_button use entity WORK.debounce_button(Behavioral);

constant TEXT_LENGTH : integer := 8;
signal text : array1(0 to TEXT_LENGTH-1) := (x"30",x"30",x"3A",x"30",x"30",x"3A",x"30",x"30");

signal second1 : std_logic;

signal second_a,second_b,minute_a,minute_b,hour_a,hour_b : integer := 0;

signal refresh_screen : std_logic := '1';
signal prev_stop_timer,stop_timer : std_logic := '0';

signal o_stable_btn1,o_stable_btn2,o_stable_btn3,o_stable_btn4 : std_logic;

constant BOARD_FREQUENCY_NORMAL : integer := 50_000_000;
constant BOARD_FREQUENCY_DIV10 : integer := BOARD_FREQUENCY_NORMAL/10;

signal ONE_SECOND : integer := BOARD_FREQUENCY_NORMAL;

begin

c0 : test_oled
port map
(
	i_clk => clk,
	i_rst => o_stable_btn1,
	i_refresh => refresh_screen,
	i_char => text,
	io_sda => sda,
	io_scl => scl
);

c1 : debounce_button
port map
(
	i_button => btn_1,
	i_clk => clk,
	o_stable => o_stable_btn1
);

c2 : debounce_button
port map
(
	i_button => btn_2,
	i_clk => clk,
	o_stable => o_stable_btn2
);

c3 : debounce_button
port map
(
	i_button => btn_3,
	i_clk => clk,
	o_stable => o_stable_btn3
);

c4 : debounce_button
port map
(
	i_button => btn_4,
	i_clk => clk,
	o_stable => o_stable_btn4
);

p0 : process (clk) is
	variable TICK : integer := 0;
begin
	if (rising_edge(clk)) then
		if (o_stable_btn1 = '1') then -- reset timer
			second_a <= 0;
			second_b <= 0;
			minute_a <= 0;
			minute_b <= 0;
			hour_a <= 0;
			hour_b <= 0;
		elsif (o_stable_btn2 = '1') then -- stop timer
			stop_timer <= not stop_timer;
		elsif (o_stable_btn3 = '1') then -- set minute
			if (stop_timer = '1') then
				if (minute_b*10+minute_a+1 < 60) then
					if (minute_a < 9) then
						minute_a <= minute_a + 1;
					else
						minute_b <= minute_b + 1;
						minute_a <= 0;
					end if;
				else
					minute_a <= 0;
					minute_b <= 0;
				end if;
			end if;
		elsif (o_stable_btn4 = '1') then -- set hour
			if (stop_timer = '1') then
				if (not (hour_b = 2 and hour_a = 3)) then
					if (hour_a < 9) then
						hour_a <= hour_a + 1;
					else
						hour_b <= hour_b + 1;
						hour_a <= 0;
					end if;
				else
					hour_a <= 0;
					hour_b <= 0;
				end if;
			end if;
		end if;
		if (stop_timer = '1') then
			ONE_SECOND <= BOARD_FREQUENCY_DIV10;
		elsif (stop_timer = '0') then
			ONE_SECOND <= BOARD_FREQUENCY_NORMAL;
		end if;
		if (TICK < ONE_SECOND-1) then
			second1 <= '0';
			TICK := TICK + 1;
			refresh_screen <= '0';
		else
			second1 <= '1';
			TICK := 0;
			refresh_screen <= '1';
			if (stop_timer = '0') then
				if (second_a < 9) then
					second_a <= second_a + 1;
				else
					second_b <= second_b + 1;
					second_a <= 0;
					if (second_b*10+second_a+1 > 59) then
						minute_a <= minute_a + 1;
						if (minute_a < 9) then
							minute_a <= minute_a + 1;
							second_a <= 0;
							second_b <= 0;
						else
							minute_b <= minute_b + 1;
							minute_a <= 0;
							second_a <= 0;
							second_b <= 0;
							if (minute_b*10+minute_a+1 > 59) then
								hour_a <= hour_a + 1;
								if (hour_a < 9) then
									hour_a <= hour_a + 1;
									second_a <= 0;
									second_b <= 0;
									minute_a <= 0;
									minute_b <= 0;
								else
									hour_b <= hour_b + 1;
									hour_a <= 0;
									second_a <= 0;
									second_b <= 0;
									minute_a <= 0;
									minute_b <= 0;
								end if;
							end if;
						end if;
					end if;
				end if;
				if (hour_b = 2 and hour_a = 3 and minute_b = 5 and minute_a = 9 and second_b = 5 and second_a = 9) then
					second_a <= 0;
					second_b <= 0;
					minute_a <= 0;
					minute_b <= 0;
					hour_a <= 0;
					hour_b <= 0;
				end if;
			end if;
		end if;
	end if;
end process p0;

text(7) <= std_logic_vector(to_unsigned(to_integer(unsigned'(x"30"))+second_a,8));
text(6) <= std_logic_vector(to_unsigned(to_integer(unsigned'(x"30"))+second_b,8));
text(4) <= std_logic_vector(to_unsigned(to_integer(unsigned'(x"30"))+minute_a,8));
text(3) <= std_logic_vector(to_unsigned(to_integer(unsigned'(x"30"))+minute_b,8));
text(1) <= std_logic_vector(to_unsigned(to_integer(unsigned'(x"30"))+hour_a,8));
text(0) <= std_logic_vector(to_unsigned(to_integer(unsigned'(x"30"))+hour_b,8));

end Behavioral;
