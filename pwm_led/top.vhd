----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:46:04 02/26/2021 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Generic (G_BOARD_CLOCK : integer := 500_000; LEDS : integer := 8);
Port (
	clk : in  STD_LOGIC;
	rst : in  STD_LOGIC;
	sw : in  STD_LOGIC_VECTOR (7 downto 0);
	led : out  STD_LOGIC_VECTOR (LEDS-1 downto 0)
);
end top;

architecture Behavioral of top is
	-- GAMMA CORRECTION GREEN = 0.4
	constant NUMBER_GAMMA_CORRECTION_GREEN : natural := 255;
	type ARRAY_GAMMA_CORRECTION_GREEN is array (0 to NUMBER_GAMMA_CORRECTION_GREEN-1) of std_logic_vector(7 downto 0);
	signal GAMMA_CORRECTION_GREEN : ARRAY_GAMMA_CORRECTION_GREEN :=
	(
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",
	x"01",x"01",x"01",x"01",x"01",x"01",x"01",x"01",x"01",x"02",x"02",x"02",x"02",x"02",x"02",x"02",x"03",x"03",x"03",x"03",x"03",x"04",x"04",x"04",x"04",x"04",x"05",x"05",x"05",x"05",x"06",x"06",x"06",x"07",x"07",x"07",x"08",x"08",x"08",x"08",x"09",x"09",x"0A",x"0A",x"0A",x"0B",x"0B",x"0B",x"0C",x"0C",x"0D",x"0D",x"0D",x"0E",x"0E",x"0F",x"0F",x"10",x"10",x"11",x"11",x"12",x"12",x"13",x"13",x"14",x"14",x"15",x"16",x"16",x"17",x"17",x"18",x"19",x"19",x"1A",x"1A",x"1B",x"1C",x"1C",x"1D",x"1E",x"1E",x"1F",x"20",x"21",x"21",x"22",x"23",x"24",x"24",x"25",x"26",x"27",x"28",x"28",x"29",x"2A",x"2B",x"2C",x"2D",x"2E",x"2F",x"2F",x"30",x"31",x"32",x"33",x"34",x"35",x"36",x"37",x"38",x"39",x"3A",x"3B",x"3C",x"3D",x"3E",x"3F",x"41",x"42",x"43",x"44",x"45",x"46",x"47",x"49",x"4A",x"4B",x"4C",x"4D",x"4F",x"50",x"51",x"52",x"54",x"55",x"56",x"57",x"59",x"5A",x"5B",x"5D",x"5E",x"60",x"61",x"62",x"64",x"65",x"67",x"68",x"6A",x"6B",x"6D",x"6E",x"70",x"71",x"73",x"74",x"76",x"77",x"79",x"7B",x"7C",x"7E",x"7F",x"81",x"83",x"84",x"86",x"88",x"8A",x"8B",x"8D",x"8F",x"91",x"92",x"94",x"96",x"98",x"9A",x"9C",x"9D",x"9F",x"A1",x"A3",x"A5",x"A7",x"A9",x"AB",x"AD",x"AF",x"B1",x"B3",x"B5",x"B7",x"B9",x"BB",x"BD",x"BF",x"C1",x"C3",x"C6",x"C8",x"CA",x"CC",x"CE",x"D0",x"D3",x"D5",x"D7",x"D9",x"DC",x"DE",x"E0",x"E3",x"E5",x"E7",x"EA",x"EC",x"EE",x"F1",x"F3",x"F6",x"F8",x"FB"
	);
	
	type state_type is (start,wait0,stop);
	signal state : state_type;

	COMPONENT PWM_NEW is
	Generic (PWM_WIDTH : integer);
	Port (
		i_clock : in  STD_LOGIC;
		i_reset : in  STD_LOGIC;
		i_load : in  STD_LOGIC;
		i_data : in  INTEGER RANGE 0 TO 2**PWM_WIDTH-1;
		o_pwm : out  STD_LOGIC
	);
	END COMPONENT PWM_NEW;

	constant PWM_RES : integer := 8;
	constant L_DATA	: integer range 0 to LEDS-1 := LEDS-1;
--	type A_DATA is array(0 to L_DATA) of std_logic_vector(PWM_RES-1 downto 0);
	type A_DATA is array(0 to L_DATA) of INTEGER RANGE 0 TO 2**PWM_RES-1;
	signal data : A_DATA;
	--signal data : INTEGER RANGE 0 TO 2**PWM_RES-1;
	signal o_pwm : std_logic_vector(PWM_RES-1 downto 0);
	signal ld : std_logic_vector(LEDS-1 downto 0);
	constant T_WAIT0 : integer := G_BOARD_CLOCK/(2**PWM_RES);
	
begin

	c0to7 : FOR i IN 0 to LEDS-1 GENERATE
	pwm0to7 : PWM_NEW
	GENERIC MAP (PWM_WIDTH => PWM_RES) -- 0 to 255
	PORT MAP (
		i_clock => clk,
		i_reset => rst,
		i_load => ld(i),
		i_data => data(i),
		o_pwm => o_pwm(i)
	);
	END GENERATE c0to7;

	p0 : process (clk,rst) is
		type A_NUM_GAMMA is array(0 to LEDS-1) of integer range 0 to NUMBER_GAMMA_CORRECTION_GREEN;
		variable index : A_NUM_GAMMA;
		variable v_wait0 : integer range 0 to T_WAIT0 := 0;
		variable direction : std_logic := '0';
	begin
		if (rst = '1') then
			state <= start;
		elsif (rising_edge(clk)) then
			case (state) is
				when start =>
					state <= wait0;
					case (sw) is
						when "00000001" =>
							ld(0) <= '1';
							data(0) <= to_integer(unsigned(GAMMA_CORRECTION_GREEN(index(0))));
						when "00000010" =>
							ld(1) <= '1';
							data(1) <= to_integer(unsigned(GAMMA_CORRECTION_GREEN(index(1))));
						when "00000100" =>
							ld(2) <= '1';
							data(2) <= to_integer(unsigned(GAMMA_CORRECTION_GREEN(index(2))));
						when "00001000" =>
							ld(3) <= '1';
							data(3) <= to_integer(unsigned(GAMMA_CORRECTION_GREEN(index(3))));
						when "00010000" =>
							ld(4) <= '1';
							data(4) <= to_integer(unsigned(GAMMA_CORRECTION_GREEN(index(4))));
						when "00100000" =>
							ld(5) <= '1';
							data(5) <= to_integer(unsigned(GAMMA_CORRECTION_GREEN(index(5))));
						when "01000000" =>
							ld(6) <= '1';
							data(6) <= to_integer(unsigned(GAMMA_CORRECTION_GREEN(index(6))));
						when "10000000" =>
							ld(7) <= '1';
							data(7) <= to_integer(unsigned(GAMMA_CORRECTION_GREEN(index(7))));
						when others =>
							ld(0) <= '0';
							ld(1) <= '0';
							ld(2) <= '0';
							ld(3) <= '0';
							ld(4) <= '0';
							ld(5) <= '0';
							ld(6) <= '0';
							ld(7) <= '0';
							data(0) <= 0;
							data(1) <= 0;
					end case;					
				when wait0 =>
					if (v_wait0 < T_WAIT0) then
						state <= wait0;
						v_wait0 := v_wait0 + 1;
						ld(0) <= '0';
						ld(1) <= '0';
						ld(2) <= '0';
						ld(3) <= '0';
						ld(4) <= '0';
						ld(5) <= '0';
						ld(6) <= '0';
						ld(7) <= '0';
						data(0) <= 0;
						data(1) <= 0;
					else
						state <= stop;
						v_wait0 := 0;
					end if;
				when stop =>
					state <= start;
					case (sw) is
						when "00000001" =>
							if (direction = '0') then
								if (index(0) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
									index(0) := index(0) + 1;
								else
									index(0) := NUMBER_GAMMA_CORRECTION_GREEN-1;
									direction := '1';
								end if;
							end if;
							if (direction = '1') then
								if (index(0) > 0) then
									index(0) := index(0) - 1;
								else
									index(0) := 0;
									direction := '0';
								end if;
							end if;
						when "00000010" =>
							if (direction = '0') then
								if (index(1) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
									index(1) := index(1) + 1;
								else
									index(1) := NUMBER_GAMMA_CORRECTION_GREEN-1;
									direction := '1';
								end if;
							end if;
							if (direction = '1') then
								if (index(1) > 0) then
									index(1) := index(1) - 1;
								else
									index(1) := 0;
									direction := '0';
								end if;
							end if;
						when others =>
							data(0) <= 0;
							data(1) <= 0;
					end case;
				when others => null;
			end case;
		end if;
					
--		case (sw) is
--			when "00000001" => led(0) <= o_pwm(0);
--			when "00000010" => led(1) <= o_pwm(1);
--			when "00000100" => led(2) <= o_pwm(2);
--			when "00001000" => led(3) <= o_pwm(3);
--			when "00010000" => led(4) <= o_pwm(4);
--			when "00100000" => led(5) <= o_pwm(5);
--			when "01000000" => led(6) <= o_pwm(6);
--			when "10000000" => led(7) <= o_pwm(7);
--			when others => null;
--		end case;

		led(led'range) <= o_pwm(o_pwm'range);
	
	end process p0;

	
	
end Behavioral;
