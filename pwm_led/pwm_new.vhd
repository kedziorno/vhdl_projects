----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:39:35 02/26/2021 
-- Design Name: 
-- Module Name:    pwm - Behavioral 
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

entity PWM_NEW is
Generic (
	PWM_WIDTH : integer := 8
);
Port (
	i_clock : in  STD_LOGIC;
	i_reset : in  STD_LOGIC;
	i_load : in  STD_LOGIC;
	i_data : in  INTEGER RANGE 0 TO 2**PWM_WIDTH-1;
	o_pwm : out  STD_LOGIC
);
end entity PWM_NEW;

architecture Behavioral of PWM_NEW is

	signal pwm_count : std_logic_vector(PWM_WIDTH-1 downto 0);
	signal pwm_index : std_logic_vector(PWM_WIDTH-1 downto 0);
	signal pwm_logic_1 : std_logic_vector(PWM_WIDTH-1 downto 0);
	signal pwm_logic_0 : std_logic_vector(PWM_WIDTH-1 downto 0);
	signal data : integer range 0 to 2**PWM_WIDTH-1;
	signal pwm : std_logic;

	type state_type is (idle,pwm_1,pwm_0);
	signal state : state_type;

begin

	pa : process (i_clock) is
	begin
		if (rising_edge(i_clock)) then
			if (i_load = '1') then
				data <= i_data;
			end if;
		end if;
	end process pa;

	o_pwm <= '1' when (state=pwm_1 and pwm_index /= std_logic_vector(to_unsigned(0,PWM_WIDTH))) else
	'0' when (state=pwm_0 or state=idle);
	
	p0 : process (i_clock,i_reset) is
		constant v_pwm_count : integer range 0 to 2**PWM_WIDTH-1 := 2**PWM_WIDTH-1;
		variable v_pwm_index : integer range 0 to 2**PWM_WIDTH-1;
		variable v_pwm_logic_1 : integer range 0 to 2**PWM_WIDTH-1;
		variable v_pwm_logic_0 : integer range 0 to 2**PWM_WIDTH-1;
		variable v_pwm : std_logic;
	begin
		if (i_reset = '1') then
			state <= idle;
		elsif (rising_edge(i_clock)) then
			case (state) is
				when idle =>
					state <= pwm_1;
					v_pwm_index := 0;
				when pwm_1 =>
					if (v_pwm_index < data) then
						v_pwm_index := v_pwm_index + 1;
					else
						state <= pwm_0;
						v_pwm_index := 0;
					end if;
				when pwm_0 =>
					if (v_pwm_index < v_pwm_count - data - 1) then
						v_pwm_index := v_pwm_index + 1;
					else
						state <= pwm_1;
						v_pwm_index := 0;
					end if;
				when others => null;
			end case;
		end if;
		pwm_count <= std_logic_vector(to_unsigned(v_pwm_count,PWM_WIDTH));
		pwm_index <= std_logic_vector(to_unsigned(v_pwm_index,PWM_WIDTH));
		pwm_logic_1 <= std_logic_vector(to_unsigned(v_pwm_logic_1,PWM_WIDTH));
		pwm_logic_0 <= std_logic_vector(to_unsigned(v_pwm_logic_0,PWM_WIDTH));
	end process p0;
	
end Behavioral;

