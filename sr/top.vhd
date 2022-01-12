library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity top is
port (
	signal i_clock : in std_logic;
	signal i_reset : in std_logic;
	signal i_push : in std_logic;
	signal i_phase1 : in std_logic;
	signal i_phase2 : in std_logic;
	signal o_cycles : out std_logic_vector(15 downto 0)
);
end top;

architecture Behavioral of top is

signal counter : integer range 0 to 2**16-1;
signal enable : std_logic;
signal tick1,tick2 : std_logic;
type states is (a,b,c,d);
signal state : states;

begin

-- phase detector
--FDCPE_inst1 : FDCPE generic map (INIT => '0')
--port map (Q => fd1q, C => i_phase1, CE => '1', CLR => ando2, D => '1', PRE => '0');
--FDCPE_inst2 : FDCPE generic map (INIT => '0')
--port map (Q => fd2q, C => i_phase2, CE => '1', CLR => ando2, D => '1', PRE => '0');
--MULT_AND_inst : MULT_AND
--port map (LO => ando1, I0 => fd1q, I1 => fd2q);
--ando2 <= ando1 after 1 ns;
--o_cycles <= fd1q;

pre1 : process (i_clock,i_reset,i_phase1) is
	type states is (a,b,c);
	variable state : states;
begin
	if (i_reset = '1') then
		tick1 <= '0';
		state := a;
	elsif (rising_edge(i_clock)) then
		case (state) is
			when a =>
				if (i_phase1 = '1') then
					state := b;
					tick1 <= '1';
				else
					state := a;
					tick1 <= '0';
				end if;
			when b =>
				state := b;
				tick1 <= '0';
			when others =>
				state := a;
				tick1 <= '0';
		end case;		
	end if;
end process pre1;

pre2 : process (i_clock,i_reset,i_phase2) is
	type states is (a,b,c);
	variable state : states;
begin
	if (i_reset = '1') then
		tick2 <= '0';
		state := a;
	elsif (rising_edge(i_clock)) then
		case (state) is
			when a =>
				if (i_phase2 = '1') then
					state := b;
					tick2 <= '1';
				else
					state := a;
					tick2 <= '0';
				end if;
			when b =>
				state := b;
				tick2 <= '0';
			when others =>
				state := a;
				tick2 <= '0';
		end case;		
	end if;
end process pre2;

pcnt : process (i_clock,i_reset,enable) is
begin
	if (i_reset = '1') then
		counter <= 0;
	elsif (rising_edge(i_clock)) then
		if (enable = '1') then
			counter <= counter + 1;
		else
			counter <= counter;
		end if;
	end if;
end process pcnt;

p0 : process (i_clock,i_reset,tick1,tick2) is
begin
	if (i_reset = '1') then
		state <= a;
		enable <= '0';
		o_cycles <= (others => '0');
	elsif(rising_edge(i_clock)) then
		case (state) is
			when a =>
				if (i_push = '1') then
					state <= b;
				else
					state <= a;
				end if;
			when b =>
				if (tick1 = '1') then
					enable <= '1';
					state <= c;
				else
					enable <= '0';
					state <= b;
				end if;
			when c =>
				if (tick2 = '1') then
					enable <= '0';
					state <= d;
				else
					enable <= '1';
					state <= c;
				end if;
			when d =>
				o_cycles <= std_logic_vector(to_unsigned(counter,16));
				state <= a;
		end case;
	end if;
end process p0;

end Behavioral;

