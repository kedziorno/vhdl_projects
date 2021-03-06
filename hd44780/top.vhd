----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:33:57 03/25/2021 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port (
	i_clock : in  STD_LOGIC;
	i_reset : in  STD_LOGIC;
	o_rs : out  STD_LOGIC;
	o_rw : out  STD_LOGIC;
	o_e : out  STD_LOGIC;
	o_db : inout  STD_LOGIC_VECTOR (7 downto 0)
);
end top;

architecture Behavioral of top is

	COMPONENT hd44780 IS
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
	END COMPONENT hd44780;

	signal data : std_logic_vector(7 downto 0);
	signal enable,data_type,busy : std_logic;

	constant C_LEN_LCD_PATTERN : integer := 11;
	type A_LCD_PATTERN_TYPE is array(0 to C_LEN_LCD_PATTERN-1) of std_logic;
	type A_LCD_PATTERN_DATA is array(0 to C_LEN_LCD_PATTERN-1) of std_logic_vector(7 downto 0);
	signal LCD_PATTERN_TYPE : A_LCD_PATTERN_TYPE := ('0','0','0','0','0','0','0','1','1','1','1');
	signal LCD_PATTERN_DATA : A_LCD_PATTERN_DATA := (x"38",x"38",x"38",x"38",x"0F",x"01",x"06",x"41",x"42",x"43",x"44");
	signal index : integer;

	type state_type is (
		idle,send,st_busy,st_wait,increment,stop
	);
	signal state : state_type;

	constant C_WAIT_MS : integer := 1_000_000;
	signal t_wait_ms : integer;

begin

	p0 : process (i_clock,i_reset) is
	begin
		if (i_reset = '1') then
			state <= idle;
			index <= 0;
			t_wait_ms <= 0;
		elsif (rising_edge(i_clock)) then
			case (state) is
				when idle =>
					--if (t_wait_ms = 4*C_WAIT_MS-1) then
						state <= send;
						enable <= '1';
						--t_wait_ms <= 0;
					--else
						--t_wait_ms <= t_wait_ms + 1;
					--end if;
				when send =>
					state <= st_busy;
					data_type <= LCD_PATTERN_TYPE(index);
					data <= LCD_PATTERN_DATA(index);
				when st_busy =>
					if (busy = '1') then
						state <= st_busy;
					else
						state <= st_wait;
						enable <= '0';
						data <= x"00";
					end if;
				when st_wait =>
					if (t_wait_ms = 4*C_WAIT_MS-1) then
						state <= increment;
						t_wait_ms <= 0;
					else
						t_wait_ms <= t_wait_ms + 1;
					end if;
				when increment =>
					if (index = C_LEN_LCD_PATTERN-1) then
						state <= stop;
						index <= 0;
					else
						state <= idle;
						enable <= '0';
						index <= index + 1;
					end if;
				when stop =>
					state <= stop;
			end case;
		end if;
	end process p0;

	m_hd44780 : hd44780
	PORT MAP (
		i_clock => i_clock,
		i_reset => i_reset,
		i_enable => enable,
		i_data_type => data_type,
		i_data => data,
		o_busy => busy,
		o_rs => o_rs,
		o_rw => o_rw,
		o_e => o_e,
		o_db => o_db
	);


end Behavioral;
