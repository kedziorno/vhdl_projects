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
	generic (delay_and : time := delay_and; delay_nand : time := delay_nand; delay_nand3 : time := delay_nand3; delay_nand4 : time := delay_nand4; delay_not : time := delay_not);
	port (i_r : in STD_LOGIC; J,K,C : in STD_LOGIC; Q1 : out STD_LOGIC; Q2 : out STD_LOGIC);
	end component FF_JK;
	for all : FF_JK use entity WORK.FF_JK(LUT);

	component ripple_counter is
	generic (N : integer := 32; MAX : integer := 1; delay_and : time := delay_and; delay_nand : time := delay_nand; delay_nand3 : time := delay_nand3; delay_nand4 : time := delay_nand4; delay_not : time := delay_not; delay_or : time := delay_or; delay_mr : time := delay_mr);
	port (i_clock : in std_logic; i_cpb : in std_logic; i_mrb : in std_logic; i_ud : in std_logic; o_q : inout std_logic_vector(N-1 downto 0));
	end component ripple_counter;
	for all : ripple_counter use entity WORK.ripple_counter(Behavioral);

	component GATE_NOT is
	generic (delay_not : TIME := delay_not);
	port (A : in STD_LOGIC; B : out STD_LOGIC);
	end component GATE_NOT;
--	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_BEHAVIORAL_1);
	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);

	component GATE_OR is
	generic (delay_or : TIME := delay_or);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GATE_OR;
--	for all : GATE_OR use entity WORK.GATE_OR(GATE_OR_BEHAVIORAL_1);
	for all : GATE_OR use entity WORK.GATE_OR(GATE_OR_LUT);

	component GATE_AND is
	generic (delay_and : TIME := delay_and);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GATE_AND;
--	for all : GATE_AND use entity WORK.GATE_AND(GATE_AND_BEHAVIORAL_1);
	for all : GATE_AND use entity WORK.GATE_AND(GATE_AND_LUT);

	component GATE_NAND is
	generic (delay_nand : TIME := delay_nand);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GATE_NAND;
--	for all : GATE_NAND use entity WORK.GATE_NAND(GATE_NAND_BEHAVIORAL_1);
	for all : GATE_NAND use entity WORK.GATE_NAND(GATE_NAND_LUT);

	component GATE_NOR2 is
	generic (delay_nor2 : TIME := delay_nor2);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GATE_NOR2;
--	for all : GATE_NOR2 use entity WORK.GATE_NOR2(GATE_NOR2_BEHAVIORAL_1);
	for all : GATE_NOR2 use entity WORK.GATE_NOR2(GATE_NOR2_LUT);

	component MUX_21 is
	generic (delay_and : TIME := delay_and; delay_or : TIME := delay_or; delay_not : TIME := delay_not);
	port (S,A,B:in STD_LOGIC; C:out STD_LOGIC);
	end component MUX_21;
	for all : MUX_21 use entity WORK.MUX_21(MUX_21_LUT_1);

	component MUX_41 is
	generic (delay_and : TIME := delay_and; delay_or : TIME := delay_or; delay_not : TIME := delay_not);
	port (S1,S2,A,B,C,D:in STD_LOGIC; E:out STD_LOGIC);
	end component MUX_41;
	for all : MUX_41 use entity WORK.MUX_41(Behavioral);

	component MUX_81 is
	generic (delay_and : TIME := delay_and; delay_or : TIME := delay_or; delay_not : TIME := delay_not);
	port (in0,in1,in2,in3,in4,in5,in6,in7 : in std_logic; s0,s1,s2 : in std_logic; o : out std_logic);
	end component MUX_81;
	for all : MUX_81 use entity WORK.MUX_81(Behavioral);

	signal clock : std_logic;
	signal clock_chain : std_logic_vector(N-1 downto 0);

	signal data : std_logic;

	constant start_condition_count : integer := N/2;
	constant start_condition_bits : integer := 3;
	signal start_condition : std_logic_vector(start_condition_bits-1 downto 0);
	signal sda_start_counter_stop_flag : std_logic;
	constant sda_start_counter_stop_constant : std_logic_vector(start_condition_bits-1 downto 0) := std_logic_vector(to_unsigned(start_condition_count,start_condition_bits));

	signal reset_or,reset_counter : std_logic;
	signal sda_start_ldcpe,sda_stop_ldcpe : std_logic;
	signal ffjkq1,ffjkq2 : std_logic;
	signal t1,t2 : std_logic;

begin

	or_reset_conter_inst : GATE_OR
	port map (A => i_reset, B => reset_counter, C => reset_or);

	sda_start_counter : ripple_counter
	generic map (N => start_condition_bits,MAX => start_condition_count,delay_mr => delay_mr)
	port map (i_clock => i_clock,i_cpb => ffjkq2,i_mrb => reset_or,i_ud => sda_start_counter_stop_flag,o_q => start_condition);

	reset_counter <= '1' when start_condition = sda_start_counter_stop_constant else '0';
	mux21_sda_start_counter_stop : MUX_21
	port map (S => reset_or, A => '1', B => '0', C => sda_start_counter_stop_flag);

	ffjk1 : FF_JK
	port map (i_r => reset_or, J => '1', K => '1', C => clock_chain(0), Q1 => ffjkq1, Q2 => ffjkq2);

	t1 <= clock_chain(N-1) and sda_start_counter_stop_flag;
	sda_start_ldcpe_inst : LDCPE
	port map (Q => sda_start_ldcpe, D => t1, CLR => '0', G => reset_or, GE => not reset_or, PRE => '0');
	t2 <= clock_chain(0) and sda_start_counter_stop_flag;
	sda_stop_ldcpe_inst : LDCPE
	port map (Q => sda_stop_ldcpe, D => t2, CLR => '0', G => reset_or, GE => not reset_or, PRE => '0');

	generate_clock_chain : for i in 0 to N-1 generate
		clock_chain_first : if (i=0) generate
			clock_chain_f : LDCPE
			port map (Q => clock_chain(i), D => clock, CLR => i_reset, G => i_clock, GE => not i_clock, PRE => '0');
		end generate clock_chain_first;
		clock_chain_rest : if (i>0) generate
			clock_chain_r : LDCPE
			port map (Q => clock_chain(i), D => clock_chain(i-1), CLR => i_reset, G => i_clock, GE => not i_clock, PRE => '0');
		end generate clock_chain_rest;
	end generate generate_clock_chain;

	mux21_clock_chain_tick : MUXCY
	port map (O => clock, CI => '0', DI => '1', S => clock_chain(N-1));

	OBUFT_scl_clock_inst : OBUFT
	port map (O => o_scl, I => clock, T => clock);

	m81_main_inst : MUX_81
	port map (S0 => '0', S1 => '0', S2 => '0', in0 => not sda_stop_ldcpe, in1 => not sda_start_ldcpe, in2 => '0', in3 => '0', in4 => '0', in5 => '0', in6 => '0', in7 => '0', o => data);

	OBUFT_sda_data_inst : OBUFT
	port map (O => o_sda, I => data, T => data);

end architecture Behavioral;
