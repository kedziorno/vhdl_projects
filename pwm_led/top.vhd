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
Generic (BOARD_CLOCK : integer := 50_000_000; LEDS : integer := 8; PWM_WIDTH : integer := 8);
Port (
	clk : in  STD_LOGIC;
	btn0 : in  STD_LOGIC;
	sw : in  STD_LOGIC_VECTOR (7 downto 0);
	led : out  STD_LOGIC_VECTOR (LEDS-1 downto 0)
);
end top;

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

	constant PWM_RES : integer := PWM_WIDTH;
	constant L_DATA	: integer range 0 to LEDS-1 := LEDS-1;
	type A_DATA is array(0 to L_DATA) of INTEGER RANGE 0 TO 2**PWM_RES-1;
	signal data : A_DATA;
	signal o_pwm : std_logic_vector(PWM_RES-1 downto 0);
	signal ld : std_logic_vector(LEDS-1 downto 0);
	constant T_WAIT0 : integer := (2**PWM_RES)-1;
	
begin

	c0to7 : FOR i IN 0 to LEDS-1 GENERATE
	pwm0to7 : PWM_NEW
	GENERIC MAP (PWM_WIDTH => PWM_RES) -- 0 to 255
	PORT MAP (
		i_clock => clk,
		i_reset => btn0,
		i_load => ld(i),
		i_data => data(i),
		o_pwm => o_pwm(i)
	);
	END GENERATE c0to7;

	p0 : process (clk,btn0) is
		type A_NUM_GAMMA is array(0 to LEDS-1) of integer range 0 to NUMBER_GAMMA_CORRECTION_GREEN;
		variable index : A_NUM_GAMMA;
		variable v_wait0 : integer range 0 to T_WAIT0 := 0;
		variable direction : std_logic := '0';
	begin
		if (btn0 = '1') then
			state <= start;
		elsif (rising_edge(clk)) then
			case (state) is
				when start =>
					state <= wait0;
					if (std_match(sw,"-------1")) then
						ld(0) <= '1';
						data(0) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(index(0))));
					end if;
					if (std_match(sw,"------1-")) then
						ld(1) <= '1';
						data(1) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(index(1))));
					end if;
					if (std_match(sw,"-----1--")) then
						ld(2) <= '1';
						data(2) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(index(2))));
					end if;
					if (std_match(sw,"----1---")) then
						ld(3) <= '1';
						data(3) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(index(3))));
					end if;
					if (std_match(sw,"---1----")) then
						ld(4) <= '1';
						data(4) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(index(4))));
					end if;
					if (std_match(sw,"--1-----")) then
						ld(5) <= '1';
						data(5) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(index(5))));
					end if;
					if (std_match(sw,"-1------")) then
						ld(6) <= '1';
						data(6) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(index(6))));
					end if;
					if (std_match(sw,"1-------")) then
						ld(7) <= '1';
						data(7) <= to_integer(unsigned(C_GAMMA_CORRECTION_GREEN(index(7))));
					end if;
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
					else
						state <= stop;
						v_wait0 := 0;
					end if;
				when stop =>
					state <= start;
					if (std_match(sw,"-------1")) then
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
					end if;
					if (std_match(sw,"------1-")) then
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
					end if;
					if (std_match(sw,"-----1--")) then
						if (direction = '0') then
							if (index(2) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
								index(2) := index(2) + 1;
							else
								index(2) := NUMBER_GAMMA_CORRECTION_GREEN-1;
								direction := '1';
							end if;
						end if;
						if (direction = '1') then
							if (index(2) > 0) then
								index(2) := index(2) - 1;
							else
								index(2) := 0;
								direction := '0';
							end if;
						end if;
					end if;
					if (std_match(sw,"----1---")) then
						if (direction = '0') then
							if (index(3) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
								index(3) := index(3) + 1;
							else
								index(3) := NUMBER_GAMMA_CORRECTION_GREEN-1;
								direction := '1';
							end if;
						end if;
						if (direction = '1') then
							if (index(3) > 0) then
								index(3) := index(3) - 1;
							else
								index(3) := 0;
								direction := '0';
							end if;
						end if;
					end if;
					if (std_match(sw,"---1----")) then
						if (direction = '0') then
							if (index(4) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
								index(4) := index(4) + 1;
							else
								index(4) := NUMBER_GAMMA_CORRECTION_GREEN-1;
								direction := '1';
							end if;
						end if;
						if (direction = '1') then
							if (index(4) > 0) then
								index(4) := index(4) - 1;
							else
								index(4) := 0;
								direction := '0';
							end if;
						end if;
					end if;
					if (std_match(sw,"--1-----")) then
						if (direction = '0') then
							if (index(5) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
								index(5) := index(5) + 1;
							else
								index(5) := NUMBER_GAMMA_CORRECTION_GREEN-1;
								direction := '1';
							end if;
						end if;
						if (direction = '1') then
							if (index(5) > 0) then
								index(5) := index(5) - 1;
							else
								index(5) := 0;
								direction := '0';
							end if;
						end if;
					end if;
					if (std_match(sw,"-1------")) then
						if (direction = '0') then
							if (index(6) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
								index(6) := index(6) + 1;
							else
								index(6) := NUMBER_GAMMA_CORRECTION_GREEN-1;
								direction := '1';
							end if;
						end if;
						if (direction = '1') then
							if (index(6) > 0) then
								index(6) := index(6) - 1;
							else
								index(6) := 0;
								direction := '0';
							end if;
						end if;
					end if;
					if (std_match(sw,"1-------")) then
						if (direction = '0') then
							if (index(7) < NUMBER_GAMMA_CORRECTION_GREEN-1) then
								index(7) := index(7) + 1;
							else
								index(7) := NUMBER_GAMMA_CORRECTION_GREEN-1;
								direction := '1';
							end if;
						end if;
						if (direction = '1') then
							if (index(7) > 0) then
								index(7) := index(7) - 1;
							else
								index(7) := 0;
								direction := '0';
							end if;
						end if;
					end if;
				when others => null;
			end case;
		end if;	
	end process p0;
	led(led'range) <= o_pwm(o_pwm'range);
end Behavioral;
