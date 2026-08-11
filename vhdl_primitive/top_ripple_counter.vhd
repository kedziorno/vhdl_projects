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
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_ripple_counter is
port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	o_led : out std_logic
);
end top_ripple_counter;

architecture Behavioral of top_ripple_counter is

---- XXX log2(MAX)-1/+1? for syn
	-- XXX for this settings see like led toogle after 1s
--	constant N : integer := 26; -- XXX 0-25 ff jk regs
--	constant MAX : integer := 49_999_999; -- XXX for this on 0-50*10^6-1 hz

---- XXX log2(MAX)-1/+1? for sim
	constant N : integer := 8;
	constant MAX : integer := 130;

	component ripple_counter is
	Generic (
		N : integer := 12;
		MAX : integer := 571
	);
	Port (
		i_clock : in std_logic;
		i_cpb : in std_logic;
		i_mrb : in std_logic;
		i_ud : in std_logic;
		o_q : inout std_logic_vector(N-1 downto 0);
		o_ping : out std_logic
	);
	end component ripple_counter;

	signal i_cpb : std_logic;
	signal i_mrb : std_logic;
	signal o_q : std_logic_vector(N-1 downto 0);
	signal o_ping : std_logic;
	signal led : std_logic;

	type states is (idle,start);
	signal state : states;

	component FF_JK is
	port (
		i_r:in STD_LOGIC;
		J,K,C:in STD_LOGIC;
		Q1:inout STD_LOGIC;
		Q2:inout STD_LOGIC
	);
	end component FF_JK;

begin

	o_led <= led;

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

	u1 : FF_JK
	port map (
		i_r => i_mrb,
		J => o_ping,
		K => o_ping,
		C => not i_clock,
		Q1 => led,
		Q2 => open
	);

	u0 : ripple_counter
	generic map (
		N => N,
		MAX => MAX
	)
	port map (
		i_clock => i_clock,
		i_cpb => i_cpb,
		i_mrb => i_mrb,
		i_ud => '1',
		o_q => o_q,
		o_ping => o_ping
	);

end Behavioral;

