----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:57:47 03/25/2021 
-- Design Name: 
-- Module Name:    hd44780 - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hd44780 is
Port (
	i_clock : in  STD_LOGIC;
	i_reset : in  STD_LOGIC;
	i_enable : in  STD_LOGIC;
	i_data_type : in  STD_LOGIC;
	i_data : in  STD_LOGIC_VECTOR (7 downto 0);
	o_busy : out  STD_LOGIC;
	o_rs : out  STD_LOGIC;
	o_rw : out  STD_LOGIC;
	o_e : out  STD_LOGIC;
	o_db : inout  STD_LOGIC_VECTOR (7 downto 0)
);
end hd44780;

architecture Behavioral of hd44780 is

	type state_type is (
		idle,
		start,
		wait1,
		send,
		wait2,
		stop
	);
	signal state : state_type;

	signal index : integer;
	signal rs,rw,e : std_logic;
	signal db : std_logic_vector(7 downto 0);

begin

	o_db <= db when (state = wait1 or state = send or state = wait2 or state = stop) else (others => 'Z');
	o_rs <= rs;
	o_rw <= rw;
	o_e <= e;

	p0 : process (i_clock,i_reset) is
	begin
		if (i_reset = '1') then
			state <= idle;
			index <= 0;
			rs <= 'Z';
			rw <= '1';
			e <= '0';
			db <= (others => 'Z');
			o_busy <= '0';
		elsif (rising_edge(i_clock)) then
			case (state) is
				when idle =>
					if (i_enable = '1') then
						state <= start;
					else
						state <= idle;
					end if;
				when start =>
					state <= wait1;
					o_busy <= '1';
					rw <= '0';
					e <= '0';
					if (i_data_type = '0') then -- command
						rs <= '0';
					elsif (i_data_type = '1') then -- data
						rs <= '1';
					else
						rs <= 'Z';
					end if;
				when wait1 => -- 40 ns
					if (index = 2) then
						state <= send;
						index <= 0;
					else
						state <= wait1;
						index <= index + 1;
					end if;
				when send => -- 230 ns
					state <= wait2;
					e <= '1';
				when wait2 => -- 10 ns
					if (index = 12) then
						state <= stop;
						e <= '0';
						index <= 0;
					else
						state <= wait2;
						index <= index + 1;
					end if;
				when stop => -- 10 ns
					if (index = 1) then
						state <= idle;
						index <= 0;
						rs <= 'Z';
						db <= (others => '0');
						rw <= '1';
						o_busy <= '0';
					else
						state <= stop;
						index <= index + 1;
					end if;
			end case;
		end if;
	end process p0;

end Behavioral;

