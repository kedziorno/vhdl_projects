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

	COMPONENT counter_n IS
	Generic (
		N : integer
	);
	Port (
		i_clock : in  STD_LOGIC;
		i_reset : in  STD_LOGIC;
		o_count : out  STD_LOGIC_VECTOR (N-1 downto 0)
	);
	END COMPONENT counter_n;

	COMPONENT FTRSE IS
	GENERIC (
		INIT : bit := '0'
	);
	PORT (
		Q   : out STD_LOGIC;
		C   : in STD_LOGIC;
		CE  : in STD_LOGIC;
		R   : in STD_LOGIC;
		S   : in STD_LOGIC;
		T   : in STD_LOGIC
	);
	END COMPONENT FTRSE;

	COMPONENT x3_nand_x1_nor IS
	PORT (
		A : in  STD_LOGIC;
		B : in  STD_LOGIC;
		Q : out  STD_LOGIC
	);
	END COMPONENT x3_nand_x1_nor;

	COMPONENT OR_N_GATE IS
	Generic (
		N : integer
	);
	Port (
		input : in  STD_LOGIC_VECTOR (N-1 downto 0);
		output : out  STD_LOGIC
	);
	END COMPONENT OR_N_GATE;

	COMPONENT AND_N_GATE IS
	Generic (
		N : integer
	);
	Port (
		input : in  STD_LOGIC_VECTOR (N-1 downto 0);
		output : out  STD_LOGIC
	);
	END COMPONENT AND_N_GATE;

	COMPONENT FDCPE_Q_QB IS
	Generic (
		INIT : BIT := '0'
	);
	Port (
		Q : out  STD_LOGIC;
		QB : out  STD_LOGIC;
		C : in  STD_LOGIC;
		CE : in  STD_LOGIC;
		CLR : in  STD_LOGIC;
		D : in  STD_LOGIC;
		PRE : in  STD_LOGIC
	);
	END COMPONENT FDCPE_Q_QB;

	signal pull_up : std_logic;

	signal counter_output : std_logic_vector(N-1 downto 0);
	signal c_enable : std_logic := '1';

	signal or_n_input : std_logic_vector(N-1 downto 0);
	signal or_n_output : std_logic;
	signal and_n_input : std_logic_vector(N-1 downto 0);
	signal and_n_output : std_logic;

	signal q_data_input : std_logic_vector(N-1 downto 0);
	signal data_input_clock,pwm_out_clear : std_logic;

begin

PULLUP_inst : PULLUP
	port map (O=>pull_up);

data_input_FDCPE_generate : for i in N-1 downto 0 generate
	FDCPE_inst : FDCPE
	generic map (INIT => '0')
	port map (Q=>q_data_input(i),C=>data_input_clock,CE=>c_enable,CLR=>not pull_up,D=>i_data(i),PRE=>not pull_up);
end generate data_input_FDCPE_generate;

counter_entity : counter_n
Generic map (
	N => N
)
Port map (
	i_clock => i_clock,
	i_reset => i_reset,
	o_count => counter_output
);
	
x3_nand_x1_nor_generate : for i in N-1 downto 0 generate
	x3_nand_x1_nor_inst : x3_nand_x1_nor
	PORT MAP (
		A => q_data_input(i),
		B => counter_output(i),
		Q => or_n_input(i)
	);
end generate x3_nand_x1_nor_generate;

OR_N_GATE_entity : OR_N_GATE
Generic map (
	N => N
)
Port map (
	input => or_n_input,
	output => or_n_output
);

and_n_input <= counter_output;
AND_N_GATE_entity : AND_N_GATE
Generic map (
	N => N
)
Port map (
	input => and_n_input,
	output => and_n_output
);

FDCPE_Q_QB_clock : FDCPE_Q_QB
generic map (INIT => '0')
port map (Q=>data_input_clock,QB=>pwm_out_clear,C=>i_clock,CE=>c_enable,CLR=>i_reset,D=>and_n_output,PRE=>'0');

FDCPE_pwm : FDCPE
generic map (INIT => '1')
port map (Q=>o_pwm,C=>not or_n_output,CE=>c_enable,CLR=>not pwm_out_clear,D=>pull_up,PRE=>not pull_up);
	
end Behavioral;

