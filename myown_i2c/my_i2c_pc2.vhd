----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    
-- Design Name: 
-- Module Name:    
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
use WORK.p_constants1.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity my_i2c_pc2 is
port(
i_clock : in std_logic;
i_reset : in std_logic;
i_slave_address : in std_logic_vector(0 to G_SLAVE_ADDRESS_SIZE-1);
i_slave_rw : in std_logic;
i_bytes_to_send : in std_logic_vector(0 to G_BYTE_SIZE-1);
i_enable : in std_logic;
o_busy : out std_logic;
o_sda : out std_logic;
o_scl : out std_logic
);
end my_i2c_pc2;

architecture Behavioral of my_i2c_pc2 is

	constant N : integer := 10;

	constant delay_and : time := 0 ns;
	constant delay_or : time := 0 ns;
	constant delay_not : time := 0 ns;
	constant delay_nand : time := 0 ns;
	constant delay_nor2 : time := 0 ns;
	constant delay_nand2 : time := 0 ns;
	constant delay_nand3 : time := 0 ns;
	constant delay_nand4 : time := 0 ns;
	constant delay_and3 : time := 0 ns;
	constant delay_mr : time := 0 ns;
	constant ADDRESS_SIZE : integer := 7;
	constant BYTE_SIZE : integer := 8;
	constant ADDRESS_SIZE_RW_ACK : integer := ADDRESS_SIZE + 1 + 1;
	constant BYTE_SIZE_ACK : integer := BYTE_SIZE + 1;

	component FF_JK is
	generic (
		delay_and : time := 0 ns;
		delay_nand : time := 0 ns;
		delay_nand3 : time := 0 ns;
		delay_nand4 : time := 0 ns;
		delay_not : time := 0 ns
	);
	port (
		i_r : in STD_LOGIC;
		J,K,C : in STD_LOGIC;
		Q1 : inout STD_LOGIC;
		Q2 : inout STD_LOGIC
	);
	end component FF_JK;
	for all : FF_JK use entity WORK.FF_JK(LUT);

	component ripple_counter is
	Generic (
	N : integer := 32;
	MAX : integer := 1;
	delay_and : time := 0 ns;
	delay_nand : time := 0 ns;
	delay_nand3 : time := 0 ns;
	delay_nand4 : time := 0 ns;
	delay_not : time := 0 ns;
	delay_or : time := 0 ns;
	delay_mr : time := 0 ns
	);
	Port (
	i_clock : in std_logic;
	i_cpb : in std_logic;
	i_mrb : in std_logic;
	i_ud : in std_logic;
	o_q : inout std_logic_vector(N-1 downto 0)
	);
	end component ripple_counter;
	for all : ripple_counter use entity WORK.ripple_counter(Behavioral);

	component GATE_NOT is
	generic (delay_not : TIME := 0 ns);
	port (A : in STD_LOGIC; B : out STD_LOGIC);
	end component GATE_NOT;
--	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);

	component GATE_OR is
	generic (delay_or : TIME := 0 ns);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GATE_OR;
--	for all : GATE_OR use entity WORK.GATE_OR(GATE_OR_BEHAVIORAL_1);
	for all : GATE_OR use entity WORK.GATE_OR(GATE_OR_LUT);

	component GATE_AND is
	generic (delay_and : TIME := 0 ns);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GATE_AND;
--	for all : GATE_AND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
	for all : GATE_AND use entity WORK.GATE_AND(GATE_AND_LUT);

	component GATE_NAND is
	generic (delay_nand : TIME := 0 ns);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GATE_NAND;
--	for all : GATE_NAND use entity WORK.GATE_NAND(GATE_NAND_BEHAVIORAL_1);
	for all : GATE_NAND use entity WORK.GATE_NAND(GATE_NAND_LUT);

	component GATE_NOR2 is
	generic (delay_nor2 : TIME := 0 ns);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GATE_NOR2;
--	for all : GATE_NOR2 use entity WORK.GATE_NOR2(GATE_NOR2_BEHAVIORAL_1);
	for all : GATE_NOR2 use entity WORK.GATE_NOR2(GATE_NOR2_LUT);

	component MUX_21 is
	generic (delay_and : TIME := 0 ns; delay_or : TIME := 0 ns; delay_not : TIME := 0 ns);
	port (S,A,B:in STD_LOGIC; C:out STD_LOGIC);
	end component MUX_21;
	for all : MUX_21 use entity WORK.MUX_21(MUX_21_LUT_1);

	component MUX_41 is
	generic (delay_and : TIME := 0 ns; delay_or : TIME := 0 ns; delay_not : TIME := 0 ns);
	port (S1,S2,A,B,C,D:in STD_LOGIC; E:out STD_LOGIC);
	end component MUX_41;
	for all : MUX_41 use entity WORK.MUX_41(Behavioral);

	component MUX_81 is
	generic (delay_and : TIME := 0 ns; delay_or : TIME := 0 ns; delay_not : TIME := 0 ns);
	port (in0,in1,in2,in3,in4,in5,in6,in7 : in std_logic; s0,s1,s2 : in std_logic; o : out std_logic);
	end component MUX_81;
	for all : MUX_81 use entity WORK.MUX_81(Behavioral);

	signal clock : std_logic;
	signal clock_chain : std_logic_vector(N-1 downto 0);

	signal data : std_logic;

	constant start_condition_count : integer := N/2+1;
	constant start_condition_bits : integer := 3;
	signal t1	: std_logic;
	signal start_condition : std_logic_vector(start_condition_bits-1 downto 0);
	signal sda_start_counter_stop_flag : std_logic;
	constant sda_start_counter_stop_constant : std_logic_vector(start_condition_bits-1 downto 0) := std_logic_vector(to_unsigned(start_condition_count-1,start_condition_bits));

begin

	sda_start_counter : ripple_counter
	Generic map (
	N => start_condition_bits,
	MAX => start_condition_count,
	delay_and => delay_and,
	delay_nand => delay_nand,
	delay_nand3 => delay_nand3,
	delay_nand4 => delay_nand4,
	delay_not => delay_not,
	delay_or => delay_or,
	delay_mr => delay_mr
	)
	Port map (
	i_clock => i_clock,
	i_cpb => sda_start_counter_stop_flag,
	i_mrb => i_reset,
	i_ud => '1',
	o_q => start_condition
	);

	t1 <= '0' when start_condition = sda_start_counter_stop_constant else '1';
	mux21_sda_start_counter_stop : MUX_21 generic map (delay_and => delay_and, delay_or => delay_or, delay_not => delay_not) port map (S => t1, A => '0', B => '1', C => sda_start_counter_stop_flag);

	generate_clock_chain : for i in 0 to N-1 generate
		clock_chain_first : if (i=0) generate
			clock_chain_f : LDCPE generic map (INIT => '0') port map (Q => clock_chain(i), D => clock, CLR => i_reset, G => i_clock, GE => not i_clock, PRE => '0');
		end generate clock_chain_first;
		clock_chain_rest : if (i>0) generate
			clock_chain_r : LDCPE generic map (INIT => '0') port map (Q => clock_chain(i), D => clock_chain(i-1), CLR => i_reset, G => i_clock, GE => not i_clock, PRE => '0');
		end generate clock_chain_rest;
	end generate generate_clock_chain;

	mux21_clock_chain_tick : MUXCY port map (O => clock, CI => '0', DI => '1', S => clock_chain(N-1));

	OBUFT_scl_clock_inst : OBUFT generic map (DRIVE => 12, IOSTANDARD => "DEFAULT", SLEW => "SLOW") port map (O => o_scl, I => clock, T => clock);

-- in3 - ACK
	m81_main_inst : MUX_81 generic map (delay_and => delay_and, delay_or => delay_or, delay_not => delay_not) port map (S0 => '0', S1 => '0', S2 => '0', in0 => sda_start_counter_stop_flag, in1 => '0', in2 => '0', in3 => '0', in4 => '0', in5 => '0', in6 => '0', in7 => '0', o => data);

	OBUFT_sda_data_inst : OBUFT generic map (DRIVE => 12, IOSTANDARD => "DEFAULT", SLEW => "SLOW") port map (O => o_sda, I => data, T => data);

end architecture Behavioral;
