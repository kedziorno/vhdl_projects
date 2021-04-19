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

	constant C_NUM_COUNTERS : integer := N/2; -- 2 bit
	signal counter_output : std_logic_vector(N-1 downto 0);
	signal counter_enable : std_logic := '1';
	signal counter_ceo : std_logic_vector(C_NUM_COUNTERS-1 downto 0);
	signal counter_tc : std_logic_vector(C_NUM_COUNTERS-1 downto 0);

	signal or_n_input : std_logic_vector(N-1 downto 0);
	signal or_n_output : std_logic;
	signal and_n_input : std_logic_vector(N-1 downto 0);
	signal and_n_output : std_logic;

	signal q_data_input : std_logic_vector(N-1 downto 0);
	signal data_input_clock,pwm_out_clear : std_logic;

	attribute KEEP : string;
	attribute KEEP of counter_output : signal is "TRUE";
	attribute KEEP of counter_enable : signal is "TRUE";
	attribute KEEP of counter_ceo : signal is "TRUE";
	attribute KEEP of counter_tc : signal is "TRUE";

begin

PULLUP_inst : PULLUP
	port map (O=>pull_up);

data_input_FDCPE_generate : for i in 0 to N-1 generate
	FDCPE_inst : FDCPE
	generic map (INIT => '0')
	port map (Q=>q_data_input(i),C=>data_input_clock,CE=>'1',CLR=>pull_up,D=>i_data(i),PRE=>pull_up);
end generate data_input_FDCPE_generate;

CB2CE_first : CB2CE
port map (
	CE => counter_enable,
	C => i_clock,
	CLR => i_reset,
	Q0 => counter_output(0),
	Q1 => counter_output(1),
	CEO => counter_ceo(0),
	TC => counter_tc(0)
);

COUNTER_g : for i in 0 to C_NUM_COUNTERS-1 generate
	COUNTER_rest : if (i>0) generate
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

x3_nand_x1_nor_generate : for i in 0 to N-1 generate
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
port map (Q=>data_input_clock,QB=>pwm_out_clear,C=>i_clock,CE=>'1',CLR=>i_reset,D=>and_n_output,PRE=>pull_up);

FTRSE_pwm : FTRSE
port map (Q=>o_pwm,C=>or_n_output,CE=>'1',R=>pwm_out_clear,T=>pull_up,S=>pull_up);

end Behavioral;

