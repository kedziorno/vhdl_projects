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
use WORK.p_GAMMA_CORRECTION_GREEN.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Generic (
	BOARD_CLOCK : integer := 50_000_000;
	PWM_WIDTH : integer := 8;
	LEDS : integer := 8;
	SWITCHS : integer := 8;
	BUTTONS : integer :=4
);
Port (
	clk : in  STD_LOGIC;
	btn : in  STD_LOGIC_VECTOR(BUTTONS-1 downto 0);
	sw : in  STD_LOGIC_VECTOR (SWITCHS-1 downto 0);
	led : out  STD_LOGIC_VECTOR (LEDS-1 downto 0)
);
end entity top;

architecture Behavioral of top is
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

	COMPONENT debounce IS
	Generic (
		G_BOARD_CLOCK : integer
	);
	Port (
		i_clk : in  STD_LOGIC;
		i_reset : in  STD_LOGIC;
		i_btn : in  STD_LOGIC;
		o_db_btn : out  STD_LOGIC
	);
	END COMPONENT debounce;

	constant PWM_RES : integer := PWM_WIDTH;
	constant L_DATA	: integer range 0 to LEDS-1 := LEDS-1;
	type A_DATA is array(0 to L_DATA) of INTEGER RANGE 0 TO 2**PWM_RES-1;
	signal data : A_DATA;
	signal o_pwm : std_logic_vector(PWM_RES-1 downto 0);
	signal ld : std_logic_vector(LEDS-1 downto 0);
	
	constant S_WAIT0_1 : integer := 1;
	constant S_WAIT0_2 : integer := 2;
	constant S_WAIT0_3 : integer := 3;
	constant S_WAIT0_4 : integer := 4;
	constant S_WAIT0_5 : integer := 5;
	constant S_WAIT0_6 : integer := 6;
	constant S_WAIT0_7 : integer := 7;
	constant S_WAIT0_8 : integer := 8;
	constant S_WAIT0_9 : integer := 9;
	constant S_WAIT0_10 : integer := 10;
	constant S_WAIT0_MIN : integer := 1;
	constant S_WAIT0_MAX : integer := 10;
	constant S_WAIT0_DEFAULT : integer := (BOARD_CLOCK/((2**PWM_RES)*S_WAIT0_MIN))-1;
	signal S_WAIT0_INDEX : integer := 1;
	signal S_WAIT0 : integer;
	
	type A_NUM_GAMMA is array(0 to LEDS-1) of integer range 0 to NUMBER_GAMMA_CORRECTION_GREEN;
	signal v_index : A_NUM_GAMMA;
	signal v_wait0 : integer range 0 to S_WAIT0_DEFAULT;
	signal v_direction : std_logic_vector(LEDS-1 downto 0);

	signal db_btn : std_logic_vector(BUTTONS-1 downto 0);

	COMPONENT PWM is
	Generic (PWM_RES : integer);
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
	type A_DATA is array(0 to L_DATA) of INTEGER RANGE 0 TO 2**PWM_RES-1;
	signal data : A_DATA;
	signal o_pwm : std_logic_vector(PWM_RES-1 downto 0);
	signal ld : std_logic_vector(LEDS-1 downto 0);
	constant T_WAIT0 : integer := (2**PWM_RES)-1;
	
begin

	c0to4 : FOR i in 0 to BUTTONS-1 GENERATE
	btn0to4 : debounce
	GENERIC MAP (G_BOARD_CLOCK => BOARD_CLOCK)
	PORT MAP (
		i_clk => clk,
		i_reset => btn(0),
		i_btn => btn(i),
		o_db_btn => db_btn(i)
	);
	END GENERATE c0to4;

	c0to7 : FOR i IN 0 to LEDS-1 GENERATE
	pwm0to7 : PWM_NEW
	GENERIC MAP (PWM_WIDTH => PWM_RES) -- 0 to 255
	PORT MAP (
		i_clock => clk,
		i_reset => btn(0),
		i_load => ld(i),
		i_data => data(i),
		o_pwm => o_pwm(i)
	);
	END GENERATE c0to7;

	p_a : process (db_btn) is
	begin
		if (db_btn(1)='1') then
			if (S_WAIT0_INDEX < S_WAIT0_10) then
				S_WAIT0_INDEX <= S_WAIT0_INDEX + 1;
			else
				S_WAIT0_INDEX <= S_WAIT0_10;
			end if;
		end if;
		if (db_btn(2)='1') then
			if (S_WAIT0_INDEX > S_WAIT0_1) then
				S_WAIT0_INDEX <= S_WAIT0_INDEX - 1;
			else
				S_WAIT0_INDEX <= S_WAIT0_1;
			end if;
		end if;
	end process p_a;

	S_WAIT0 <= (BOARD_CLOCK/((2**PWM_RES)*S_WAIT0_1))-1 when S_WAIT0_INDEX=1 else
	(BOARD_CLOCK/((2**PWM_RES)*S_WAIT0_2))-1 when S_WAIT0_INDEX=2 else
	(BOARD_CLOCK/((2**PWM_RES)*S_WAIT0_3))-1 when S_WAIT0_INDEX=3 else
	(BOARD_CLOCK/((2**PWM_RES)*S_WAIT0_4))-1 when S_WAIT0_INDEX=4 else
	(BOARD_CLOCK/((2**PWM_RES)*S_WAIT0_5))-1 when S_WAIT0_INDEX=5 else
	(BOARD_CLOCK/((2**PWM_RES)*S_WAIT0_6))-1 when S_WAIT0_INDEX=6 else
	(BOARD_CLOCK/((2**PWM_RES)*S_WAIT0_7))-1 when S_WAIT0_INDEX=7 else
	(BOARD_CLOCK/((2**PWM_RES)*S_WAIT0_8))-1 when S_WAIT0_INDEX=8 else
	(BOARD_CLOCK/((2**PWM_RES)*S_WAIT0_9))-1 when S_WAIT0_INDEX=9 else
	(BOARD_CLOCK/((2**PWM_RES)*S_WAIT0_10))-1 when S_WAIT0_INDEX=10 else
	(BOARD_CLOCK/((2**PWM_RES)*S_WAIT0_1))-1;
		
	p0 : process (clk,btn(0)) is
	begin
		if (btn(0) = '1') then
			state <= start;
			v_direction <= (others => '0');
			v_wait0 <= 0;
			v_index(0) <= 0;
			v_index(1) <= 0;
			v_index(2) <= 0;
			v_index(3) <= 0;
			v_index(4) <= 0;
			v_index(5) <= 0;
			v_index(6) <= 0;
			v_index(7) <= 0;
			ld(0) <= '1';
			data(0) <= 0;
			ld(1) <= '1';
			data(1) <= 0;
			ld(2) <= '1';
			data(2) <= 0;
			ld(3) <= '1';
			data(3) <= 0;
			ld(4) <= '1';
			data(4) <= 0;
			ld(5) <= '1';
			data(5) <= 0;
			ld(6) <= '1';
			data(6) <= 0;
			ld(7) <= '1';
			data(7) <= 0;
		elsif (rising_edge(clk)) then
			case (state) is
				when start =>
					state <= wait0;
					if (std_match(sw,"-------1")) then
						ld(0) <= '1';
						data(0) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(v_index(0))));
					end if;
					if (std_match(sw,"------1-")) then
						ld(1) <= '1';
						data(1) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(v_index(1))));
					end if;
					if (std_match(sw,"-----1--")) then
						ld(2) <= '1';
						data(2) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(v_index(2))));
					end if;
					if (std_match(sw,"----1---")) then
						ld(3) <= '1';
						data(3) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(v_index(3))));
					end if;
					if (std_match(sw,"---1----")) then
						ld(4) <= '1';
						data(4) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(v_index(4))));
					end if;
					if (std_match(sw,"--1-----")) then
						ld(5) <= '1';
						data(5) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(v_index(5))));
					end if;
					if (std_match(sw,"-1------")) then
						ld(6) <= '1';
						data(6) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(v_index(6))));
					end if;
					if (std_match(sw,"1-------")) then
						ld(7) <= '1';
						data(7) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(v_index(7))));
					end if;
				when wait0 =>
					if (v_wait0 < S_WAIT0) then
						state <= wait0;
						v_wait0 <= v_wait0 + 1;
						ld(0) <= '0';
						ld(1) <= '0';
						ld(2) <= '0';
						ld(3) <= '0';
						ld(4) <= '0';
						ld(5) <= '0';
						ld(6) <= '0';
						ld(7) <= '0';
					else
						state <= stop;
						v_wait0 <= 0;
					end if;
				when stop =>
					state <= start;
<<<<<<< HEAD
					if (std_match(sw,"-------1")) then
						if (v_direction(0) = '0') then
							if (v_index(0) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
								v_index(0) <= v_index(0) + 1;
							else
								v_index(0) <= NUMBER_GAMMA_CORRECTION_GREEN-1;
								v_direction(0) <= '1';
							end if;
						end if;
						if (v_direction(0) = '1') then
							if (v_index(0) > 0) then
								v_index(0) <= v_index(0) - 1;
							else
								v_index(0) <= 0;
								v_direction(0) <= '0';
							end if;
						end if;
					end if;
					if (std_match(sw,"------1-")) then
						if (v_direction(1) = '0') then
							if (v_index(1) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
								v_index(1) <= v_index(1) + 1;
							else
								v_index(1) <= NUMBER_GAMMA_CORRECTION_GREEN-1;
								v_direction(1) <= '1';
							end if;
						end if;
						if (v_direction(1) = '1') then
							if (v_index(1) > 0) then
								v_index(1) <= v_index(1) - 1;
							else
								v_index(1) <= 0;
								v_direction(1) <= '0';
							end if;
						end if;
					end if;
					if (std_match(sw,"-----1--")) then
						if (v_direction(2) = '0') then
							if (v_index(2) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
								v_index(2) <= v_index(2) + 1;
							else
								v_index(2) <= NUMBER_GAMMA_CORRECTION_GREEN-1;
								v_direction(2) <= '1';
							end if;
						end if;
						if (v_direction(2) = '1') then
							if (v_index(2) > 0) then
								v_index(2) <= v_index(2) - 1;
							else
								v_index(2) <= 0;
								v_direction(2) <= '0';
							end if;
						end if;
					end if;
					if (std_match(sw,"----1---")) then
						if (v_direction(3) = '0') then
							if (v_index(3) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
								v_index(3) <= v_index(3) + 1;
							else
								v_index(3) <= NUMBER_GAMMA_CORRECTION_GREEN-1;
								v_direction(3) <= '1';
							end if;
						end if;
						if (v_direction(3) = '1') then
							if (v_index(3) > 0) then
								v_index(3) <= v_index(3) - 1;
							else
								v_index(3) <= 0;
								v_direction(3) <= '0';
							end if;
						end if;
					end if;
					if (std_match(sw,"---1----")) then
						if (v_direction(4) = '0') then
							if (v_index(4) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
								v_index(4) <= v_index(4) + 1;
							else
								v_index(4) <= NUMBER_GAMMA_CORRECTION_GREEN-1;
								v_direction(4) <= '1';
							end if;
						end if;
						if (v_direction(4) = '1') then
							if (v_index(4) > 0) then
								v_index(4) <= v_index(4) - 1;
							else
								v_index(4) <= 0;
								v_direction(4) <= '0';
							end if;
						end if;
					end if;
					if (std_match(sw,"--1-----")) then
						if (v_direction(5) = '0') then
							if (v_index(5) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
								v_index(5) <= v_index(5) + 1;
							else
								v_index(5) <= NUMBER_GAMMA_CORRECTION_GREEN-1;
								v_direction(5) <= '1';
							end if;
						end if;
						if (v_direction(5) = '1') then
							if (v_index(5) > 0) then
								v_index(5) <= v_index(5) - 1;
							else
								v_index(5) <= 0;
								v_direction(5) <= '0';
							end if;
						end if;
					end if;
					if (std_match(sw,"-1------")) then
						if (v_direction(6) = '0') then
							if (v_index(6) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
								v_index(6) <= v_index(6) + 1;
							else
								v_index(6) <= NUMBER_GAMMA_CORRECTION_GREEN-1;
								v_direction(6) <= '1';
							end if;
						end if;
						if (v_direction(6) = '1') then
							if (v_index(6) > 0) then
								v_index(6) <= v_index(6) - 1;
							else
								v_index(6) <= 0;
								v_direction(6) <= '0';
							end if;
						end if;
					end if;
					if (std_match(sw,"1-------")) then
						if (v_direction(7) = '0') then
							if (v_index(7) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
								v_index(7) <= v_index(7) + 1;
							else
								v_index(7) <= NUMBER_GAMMA_CORRECTION_GREEN-1;
								v_direction(7) <= '1';
							end if;
						end if;
						if (v_direction(7) = '1') then
							if (v_index(7) > 0) then
								v_index(7) <= v_index(7) - 1;
							else
								v_index(7) <= 0;
								v_direction(7) <= '0';
							end if;
						end if;
					end if;
				when others => null;
			end case;
		end if;
	end process p0;
	led(led'range) <= o_pwm(o_pwm'range);
end Behavioral;
