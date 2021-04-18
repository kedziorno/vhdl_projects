----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:57:51 04/18/2021 
-- Design Name: 
-- Module Name:    PWM_generator - Behavioral 
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

entity PWM_generator is
Generic (
N : integer := 4
);
Port (
i_clock : in std_logic;
i_reset : in std_logic;
i_data  : in std_logic_vector(N-1 downto 0);
o_pwm   : out std_logic
);
end PWM_generator;

architecture Behavioral of PWM_generator is

	COMPONENT CB2CE IS
	PORT (
		CEO  : out STD_LOGIC;
		Q0   : out STD_LOGIC;
		Q1   : out STD_LOGIC;
		TC   : out STD_LOGIC;
		C    : in STD_LOGIC;
		CE   : in STD_LOGIC;
		CLR  : in STD_LOGIC
	);
	END COMPONENT CB2CE;

	constant C_NUM_COUNTERS : integer := N/2; -- 2 bit
	signal counter_output : std_logic_vector(N-1 downto 0);
	signal counter_enable : std_logic;
	signal counter_ceo : std_logic_vector(C_NUM_COUNTERS-1 downto 0);
	signal counter_tc : std_logic_vector(C_NUM_COUNTERS-1 downto 0);
begin

COUNTER_g : for i in 0 to C_NUM_COUNTERS-1 generate
	COUNTER_first : if (i=0) generate
		CB2CE_inst : CB2CE
		port map (
			CE => counter_enable,
			C => i_clock,
			CLR => i_reset,
			Q0 => counter_output(0),
			Q1 => counter_output(1),
			CEO => counter_ceo(0),
			TC => counter_tc(0)
		);
	end generate COUNTER_first;
	COUNTER_rest : if (0<i) generate
		CB2CE_inst : CB2CE
		port map (
			CE => counter_ceo(i-1),
			C => i_clock,
			CLR => i_reset,
			Q0 => counter_output(2*i+0),
			Q1 => counter_output(2*i+1),
			CEO => counter_ceo(i),
			TC => counter_tc(i)
		);
	end generate COUNTER_rest;
end generate COUNTER_g;


end Behavioral;

