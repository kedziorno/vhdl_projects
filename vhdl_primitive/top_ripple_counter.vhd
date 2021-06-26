----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:12:43 06/25/2021 
-- Design Name: 
-- Module Name:    top_ripple_counter - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity top_ripple_counter is
port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	o_led : out std_logic
);
end top_ripple_counter;

architecture Behavioral of top_ripple_counter is

	constant N : integer := 32;
	constant MAX : integer := 1_000_000;

	component ripple_counter is
	Generic (
		N : integer := 12;
		MAX : integer := 571
	);
	Port (
		i_clock : in std_logic;
		i_cpb : in std_logic;
		i_mrb : in std_logic;
		o_q : inout std_logic_vector(N-1 downto 0);
		o_ping : out std_logic
	);
	end component ripple_counter;

	signal i_cpb : std_logic;
	signal i_mrb : std_logic;
	signal o_q : std_logic_vector(N-1 downto 0);
	signal o_ping : std_logic;
	signal led,led1,not_led,d1,d2 : std_logic;

	type states is (idle,start);
	signal state : states;

	component MUX_21 is
	port (S,A,B:in STD_LOGIC;C:out STD_LOGIC);
	end component MUX_21;

begin

	p0 : process (i_clock,i_reset) is
	begin
		if (i_reset = '1') then
			state <= idle;
		elsif (rising_edge(i_clock)) then
			case state is
				when idle =>
					state <= start;
					i_mrb <= '1';
					i_cpb <= '0';
				when start =>
					state <= start;
					i_mrb <= '0';
					i_cpb <= '1';
			end case;
		end if;
	end process p0;

	p1 : process (led) is
		variable led1 : std_logic := '0';
	begin
		o_led <= led1;
		if (led = '1') then
			led1 := not led1;
		else
			led1 := led1;
		end if;
	end process p1;

	u1 : MUX_21
	port map (
		S => o_ping,
		A => '1',
		B => '0',
		C => d1
	);

	FDCPE_inst1 : FDCPE
	generic map (INIT => '0')
	port map (Q=>d2,C=>i_clock,CE=>'1',CLR=>'0',D=>d1,PRE=>o_ping);

	FDCPE_inst2 : FDCPE
	generic map (INIT => '0')
	port map (Q=>led,C=>not i_clock,CE=>'1',CLR=>'0',D=>d2,PRE=>'0');

	u0 : ripple_counter
	generic map (
		N => N,
		MAX => MAX
	)
	port map (
		i_clock => i_clock,
		i_cpb => i_cpb,
		i_mrb => i_mrb,
		o_q => o_q,
		o_ping => o_ping
	);

end Behavioral;

