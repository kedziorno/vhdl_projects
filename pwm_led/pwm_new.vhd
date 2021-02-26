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
	i_data : in  INTEGER RANGE 0 TO 2**PWM_WIDTH;
	o_pwm : out  STD_LOGIC
);
end entity PWM_NEW;

architecture Behavioral of PWM_NEW is

	signal pwm_count : integer range 0 to 2**PWM_WIDTH;
	signal pwm_index : integer range 0 to 2**PWM_WIDTH;
	signal pwm_logic_1 : integer range 0 to 2**PWM_WIDTH;
	signal pwm_logic_0 : integer range 0 to 2**PWM_WIDTH;
	signal data : integer range 0 to 2**PWM_WIDTH;
	signal pwm : std_logic;

begin

	data <= i_data;
	o_pwm <= pwm;
	
	p0 : process (i_clock,i_reset) is
		variable v_pwm_count : integer := 2**PWM_WIDTH;
		variable v_pwm_index : integer := 0;
		variable v_pwm_logic_1 : integer := v_pwm_count - data;
		variable v_pwm_logic_0 : integer := v_pwm_count - v_pwm_logic_1;
		variable v_pwm : std_logic;
	begin
		if (i_reset = '1') then
			v_pwm_index := 0;
		elsif (rising_edge(i_clock)) then
			if (v_pwm_index < v_pwm_logic_1) then
				v_pwm := '1';
			end if;
			if (v_pwm_index < v_pwm_logic_0) then
				v_pwm := '0';
			end if;
			if (v_pwm_index < v_pwm_count) then
				v_pwm_index := v_pwm_index + 1;
			else
				v_pwm_index := 0;
			end if;
		end if;
		pwm_count <= v_pwm_count;
		pwm_index <= v_pwm_index;
		pwm_logic_1 <= v_pwm_logic_1;
		pwm_logic_0 <= v_pwm_logic_0;
		pwm <= v_pwm;
	end process p0;
	
end Behavioral;

