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
	
	with state select
		pwm <= '1' when pwm_1,
		--'0' when pwm_0,
		'0' when others;
	
	p0 : process (i_clock,i_reset) is
		constant v_pwm_count : integer range 0 to 2**PWM_WIDTH-1 := 2**PWM_WIDTH-1;
		variable v_pwm_index : integer range 0 to 2**PWM_WIDTH-1;
		variable v_pwm : std_logic;
	begin
		if (i_reset = '1') then
			state <= idle;
		elsif (rising_edge(i_clock)) then
			case (state) is
				when idle =>
					state <= pwm_1;
					v_pwm_index := 0;
					pwm <= '0';
				when pwm_1 =>
					if (v_pwm_index < data) then
						v_pwm_index := v_pwm_index + 1;
						if (v_pwm_index = 0 or data = 0) then
							pwm <= '0';
						else
							pwm <= '1';
						end if;
					else
						state <= pwm_0;
						v_pwm_index := 0;
					end if;
				when pwm_0 =>
					if (v_pwm_index < v_pwm_count - data) then
						v_pwm_index := v_pwm_index + 1;
						pwm <= '0';
					else
						state <= pwm_1;
						v_pwm_index := 0;
					end if;
				when others =>
					pwm <= '0';
			end case;
		end if;
	end process p0;
	
end Behavioral;

