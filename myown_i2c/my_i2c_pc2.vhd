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
	constant clock_all0_constant : std_logic_vector(N-1 downto 0) := (others => '0');
	constant clock_all1_constant : std_logic_vector(N-1 downto 0) := (others => '1');

	signal data : std_logic;

	constant sda_condition_count : integer := N;
	constant sda_condition_bits : integer := 4;
	signal sda_start : std_logic_vector(sda_condition_bits-1 downto 0);
	signal sda_stop : std_logic_vector(sda_condition_bits-1 downto 0);
	signal sda_condition_stop_flag : std_logic;
	constant sda_condition_stop_constant : std_logic_vector(sda_condition_bits-1 downto 0) := std_logic_vector(to_unsigned(sda_condition_count-1,sda_condition_bits));

	signal reset_or,reset_counter : std_logic;
	signal sda_start_ldcpe,sda_stop_ldcpe : std_logic;
	signal ffjkq1,ffjkq2 : std_logic_vector(7 downto 0);
	signal t1,t2,t3,t4 : std_logic;
	signal rc_start : std_logic_vector(7 downto 0) := "00000000";
	signal rc_start_1 : std_logic_vector(7 downto 0);
	signal rc_start_mux : std_logic_vector(7 downto 0);
	signal mux81_rc_start_select : std_logic_vector(2 downto 0) := "000";
	type ta is array(integer range <>) of std_logic_vector(sda_condition_bits-1 downto 0);
	signal rc_q : ta(0 to 7);
	constant RC_MAIN_BITS : integer := 6;
	signal rc_main : std_logic_vector(RC_MAIN_BITS-1 downto 0);
	signal tick : std_logic_vector(7 downto 0);
	signal tick_clock_all0 : std_logic;
	signal tick_clock_all1 : std_logic;
	signal a1 : std_logic;
	signal reset_a1 : std_logic;
	signal omit_first_reset : std_logic;

begin

	p0 : process (i_clock,i_reset) is
		constant C_W : integer := N-1;
		variable vw : integer range 0 to C_W;
		type states is (a,b,c);
		variable state : states;
	begin
		if (i_reset = '1') then
			state := a;
			vw := 0;
		elsif (rising_edge(i_clock)) then
			case (state) is
				when a =>
					rc_start <= "00000001";
					if (vw = C_W) then
						state := b;
						vw := 0;
					else
						state := a;
						vw := vw + 1;
					end if;
				when b =>
					rc_start <= "00000010";
					if (vw = C_W) then
						state := c;
						vw := 0;
					else
						state := b;
						vw := vw + 1;
					end if;
				when c =>
					rc_start <= "00000100";
					if (vw = C_W) then
						state := a;
						vw := 0;
					else
						state := c;
						vw := vw + 1;
					end if;
			end case;
		end if;
	end process p0;

	or_reset_conter_inst : GATE_OR
	port map (A => i_reset, B => reset_counter, C => reset_or);

	generate_mux21_rc_mrb : for i in 0 to 7 generate
		mux21_rc_mrb : MUX_21
		port map (S => rc_start(i), A => '1', B => '0', C => rc_start_1(i));
	end generate generate_mux21_rc_mrb;

	t1 <= i_reset or reset_a1;
	ripple_counter_main : ripple_counter
	generic map (N => RC_MAIN_BITS,MAX => N*2)
	port map (i_clock => i_clock,i_cpb => '1',i_mrb => t1,i_ud => '1',o_q => rc_main);

	qwe : a1 <= '1' when rc_main = std_logic_vector(to_unsigned(N/2,RC_MAIN_BITS)) else '0';
	reset_a1 <= '1' when rc_main = std_logic_vector(to_unsigned(N*2,RC_MAIN_BITS)) else '0';

	sda_start_ldcpe_inst  : LDCPE generic map (INIT => '1')
	port map (Q => sda_start_ldcpe, D => '0', CLR => '0', G => a1, GE => not a1, PRE => '0');
	sda_stop_ldcpe_inst_prev : LDCPE generic map (INIT => '0')
	port map (Q => omit_first_reset, D => '1', CLR => a1, G => a1, GE => a1, PRE => reset_a1);
	t2 <= reset_a1 and omit_first_reset;
	t3 <= a1 and not reset_a1 and omit_first_reset;
	sda_stop_ldcpe_inst : LDCPE generic map (INIT => '0')
	port map (Q => sda_stop_ldcpe, D => t2, CLR => '0', G => a1, GE => not a1, PRE => t3);
	
	sda_start_counter : ripple_counter
	generic map (N => sda_condition_bits,MAX => 2**sda_condition_bits-1)
	port map (i_clock => i_clock,i_cpb => not tick_clock_all0,i_mrb => rc_start_1(0),i_ud => '1',o_q => rc_q(0));

	t4 <= '1' and not reset_or;
	sda_stop_counter : ripple_counter
	generic map (N => sda_condition_bits,MAX => 1)
	port map (i_clock => i_clock,i_cpb => t4,i_mrb => rc_start_1(1),i_ud => '0',o_q => rc_q(1));

	rc0 : ripple_counter
	generic map (N => sda_condition_bits,MAX => 2**sda_condition_bits-1)
	port map (i_clock => i_clock,i_cpb => '1',i_mrb => rc_start_1(2),i_ud => '1',o_q => rc_q(2));

	g1 : for i in 0 to 7 generate
		tick(i) <= '1' when rc_q(i) = sda_condition_stop_constant else '0';
	end generate g1;

	g0 : for i in 0 to 7 generate
		ffjk : FF_JK
		port map (i_r => i_reset, J => '1', K => '1', C => tick(i), Q1 => ffjkq1(i), Q2 => ffjkq2(i));
	end generate g0;

	generate_clock_chain : for i in 0 to N-1 generate
		clock_chain_first : if (i=0) generate
			clock_chain_f : LDCPE
			port map (Q => clock_chain(i), D => clock, CLR => i_reset, G => i_clock, GE => not i_clock, PRE => '0');
		end generate clock_chain_first;
		clock_chain_rest : if (i>0) generate
			clock_chain_r : LDCPE
			port map (Q => clock_chain(i), D => clock_chain(i-1), CLR => '0', G => i_clock, GE => not i_clock, PRE => '0');
		end generate clock_chain_rest;
	end generate generate_clock_chain;

	mux21_clock_chain_tick : MUXCY
	port map (O => clock, CI => '0', DI => '1', S => clock_chain(N-1));

	OBUFT_scl_clock_inst : OBUFT
	port map (O => o_scl, I => clock, T => clock);

	m81_main_inst : MUX_81
	port map (S0 => '1', S1 => '0', S2 => '0', in0 => sda_start_ldcpe, in1 => sda_stop_ldcpe, in2 => '0', in3 => '0', in4 => '0', in5 => '0', in6 => '0', in7 => '0', o => data);

	OBUFT_sda_data_inst : OBUFT
	port map (O => o_sda, I => data, T => data);

	tick_clock_all0 <= '1' when clock_chain = clock_all0_constant else '0';
	tick_clock_all1 <= '1' when clock_chain = clock_all1_constant else '0';
	reset_counter <= '1' when rc_q(0) = sda_condition_stop_constant else '0';
--	mux21_sda_start_counter_stop : MUX_21
--	port map (S => reset_or, A => '1', B => '0', C => sda_start_counter_stop_flag);

--	mux81_rc_start_inst : MUX_81
--	port map (S0 => mux81_rc_start_select(0), S1 => mux81_rc_start_select(1), S2 => mux81_rc_start_select(2), in0 => rc_start_1(0), in1 => rc_start_1(1), in2 => rc_start_1(2), in3 => rc_start_1(3), in4 => rc_start_1(4), in5 => rc_start_1(5), in6 => rc_start_1(6), in7 => rc_start_1(7), o => rc_start_mux(i));

end architecture Behavioral;
