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

constant TEXT_LENGTH : integer := 8;
signal text : array1(0 to TEXT_LENGTH-1) := (x"30",x"30",x"3A",x"30",x"30",x"3A",x"30",x"30");

signal second1 : std_logic;

type state is (update_second,update_minutes,update_hours,show_timer);
signal p_state,n_state : state := show_timer;

signal second_a,second_b,minute_a,minute_b,hour_a,hour_b : integer := 0;

begin

c0 : test_oled
port map
(
	i_clk => clk,
	i_rst => btn_1,
	i_refresh => second1,
	i_char => text,
	io_sda => sda,
	io_scl => scl
);

p0 : process (clk) is
	variable ONE_SECOND : integer := 50_000_000;
	variable TICK : integer := 0;
begin
	if (btn_1 = '1') then
		second_a <= 0;
		second_b <= 0;
		minute_a <= 0;
		minute_b <= 0;
		hour_a <= 0;
		hour_b <= 0;
	elsif (rising_edge(clk)) then
		if (TICK < ONE_SECOND-1) then
			second1 <= '0';
			TICK := TICK + 1;
		else
			second1 <= '1';
			TICK := 0;
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
end process p0;

p1 : process (second1) is
begin
	if (rising_edge(second1)) then
		p_state <= n_state;
	end if;
	case p_state is
		when show_timer =>
			text(7) <= std_logic_vector(to_unsigned(to_integer(unsigned'(x"30"))+second_a,8));
			text(6) <= std_logic_vector(to_unsigned(to_integer(unsigned'(x"30"))+second_b,8));
			text(4) <= std_logic_vector(to_unsigned(to_integer(unsigned'(x"30"))+minute_a,8));
			text(3) <= std_logic_vector(to_unsigned(to_integer(unsigned'(x"30"))+minute_b,8));
			text(1) <= std_logic_vector(to_unsigned(to_integer(unsigned'(x"30"))+hour_a,8));
			text(0) <= std_logic_vector(to_unsigned(to_integer(unsigned'(x"30"))+hour_b,8));
			n_state <= show_timer;
		when others => null;
	end case;
end process p1;

end Behavioral;