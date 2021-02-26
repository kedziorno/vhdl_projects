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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port (
	clk : in  STD_LOGIC;
	rst : in  STD_LOGIC;
	sw : in  STD_LOGIC_VECTOR (7 downto 0);
	led : out  STD_LOGIC_VECTOR (7 downto 0)
);
end top;

architecture Behavioral of top is
	-- GAMMA CORRECTION GREEN = 0.4
	constant NUMBER_GAMMA_CORRECTION_GREEN : natural := 255;
	type ARRAY_GAMMA_CORRECTION_GREEN is array (0 to NUMBER_GAMMA_CORRECTION_GREEN-1) of std_logic_vector(7 downto 0);
	signal GAMMA_CORRECTION_GREEN : ARRAY_GAMMA_CORRECTION_GREEN :=
	(
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"01",x"01",x"01",x"01",x"01",x"01",x"01",x"01",x"01",x"02",x"02",x"02",x"02",x"02",x"02",x"02",x"03",x"03",x"03",x"03",x"03",x"04",x"04",x"04",x"04",x"04",x"05",x"05",x"05",x"05",x"06",x"06",x"06",x"07",x"07",x"07",x"08",x"08",x"08",x"08",x"09",x"09",x"0A",x"0A",x"0A",x"0B",x"0B",x"0B",x"0C",x"0C",x"0D",x"0D",x"0D",x"0E",x"0E",x"0F",x"0F",x"10",x"10",x"11",x"11",x"12",x"12",x"13",x"13",x"14",x"14",x"15",x"16",x"16",x"17",x"17",x"18",x"19",x"19",x"1A",x"1A",x"1B",x"1C",x"1C",x"1D",x"1E",x"1E",x"1F",x"20",x"21",x"21",x"22",x"23",x"24",x"24",x"25",x"26",x"27",x"28",x"28",x"29",x"2A",x"2B",x"2C",x"2D",x"2E",x"2F",x"2F",x"30",x"31",x"32",x"33",x"34",x"35",x"36",x"37",x"38",x"39",x"3A",x"3B",x"3C",x"3D",x"3E",x"3F",x"41",x"42",x"43",x"44",x"45",x"46",x"47",x"49",x"4A",x"4B",x"4C",x"4D",x"4F",x"50",x"51",x"52",x"54",x"55",x"56",x"57",x"59",x"5A",x"5B",x"5D",x"5E",x"60",x"61",x"62",x"64",x"65",x"67",x"68",x"6A",x"6B",x"6D",x"6E",x"70",x"71",x"73",x"74",x"76",x"77",x"79",x"7B",x"7C",x"7E",x"7F",x"81",x"83",x"84",x"86",x"88",x"8A",x"8B",x"8D",x"8F",x"91",x"92",x"94",x"96",x"98",x"9A",x"9C",x"9D",x"9F",x"A1",x"A3",x"A5",x"A7",x"A9",x"AB",x"AD",x"AF",x"B1",x"B3",x"B5",x"B7",x"B9",x"BB",x"BD",x"BF",x"C1",x"C3",x"C6",x"C8",x"CA",x"CC",x"CE",x"D0",x"D3",x"D5",x"D7",x"D9",x"DC",x"DE",x"E0",x"E3",x"E5",x"E7",x"EA",x"EC",x"EE",x"F1",x"F3",x"F6",x"F8",x"FB"
	);
	
	type state_type is (start,wait0,stop);
	signal state : state_type;

	COMPONENT PWM is
	Generic (PWM_RES : integer);
	Port (
		clk : in  STD_LOGIC;
		res : in  STD_LOGIC;
		ld : in  STD_LOGIC;
		data : in  STD_LOGIC_VECTOR (PWM_RES-1 downto 0);
		pwm : out  STD_LOGIC
	);
	END COMPONENT PWM;

	constant T_WAIT0 : integer := 2**20;
	constant PWM_RES : integer := 8;
	signal ld : std_logic;
	signal data : std_logic_vector(PWM_RES-1 downto 0);
	signal o_pwm : std_logic;
	
begin

	c0: PWM
	GENERIC MAP (PWM_RES => PWM_RES) -- 0 to 255
	PORT MAP (
		clk => clk,
		res => rst,
		ld => ld,
		data => data,
		pwm => o_pwm
	);

	p0 : process (clk,rst) is
		variable index : integer range 0 to NUMBER_GAMMA_CORRECTION_GREEN := 0;
		variable v_wait0 : integer range 0 to T_WAIT0 := 0;
		variable direction : std_logic := '0';
	begin
		if (rst = '1') then
			state <= start;
		elsif (rising_edge(clk)) then
			case (state) is
				when start =>
					state <= wait0;
					ld <= '1';
					data <= GAMMA_CORRECTION_GREEN(index);
				when wait0 =>
					if (v_wait0 < T_WAIT0) then
						state <= wait0;
						v_wait0 := v_wait0 + 1;
						ld <= '0';
					else
						state <= stop;
						v_wait0 := 0;
					end if;
				when stop =>
					state <= start;
					if (direction = '0') then
						if (index < NUMBER_GAMMA_CORRECTION_GREEN-1) then
							index := index + 1;
						else
							index := NUMBER_GAMMA_CORRECTION_GREEN-1;
							direction := '1';
						end if;
					end if;
					if (direction = '1') then
						if (index > 0) then
							index := index - 1;
						else
							index := 0;
							direction := '0';
						end if;
					end if;
				when others => null;
			end case;
		end if;
	end process p0;

	led(0) <= o_pwm;
	led(1) <= o_pwm;
	led(2) <= o_pwm;
	led(3) <= o_pwm;
	led(4) <= o_pwm;
	led(5) <= o_pwm;
	led(6) <= o_pwm;
	led(7) <= o_pwm;

end Behavioral;
