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
--o_busy : out std_logic;
o_sda : out std_logic;
o_scl : out std_logic
);
end my_i2c_pc2;

architecture Behavioral of my_i2c_pc2 is

	constant N : integer := 10;

	constant delay_and : time := 0 ns;
	constant delay_or : time := 0 ns;
	constant delay_not : time := 0 ns;
	constant delay_nand : time := 0 ns; -- XXX 0 make osc on behav
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

  --
  COMPONENT AND8_gate IS
    PORT( I0,I1,I2,I3,I4,I5,I6,I7: IN std_logic;
          O: OUT std_logic );
  END COMPONENT;
  --
  COMPONENT NAND8_gate IS
    PORT( I0,I1,I2,I3,I4,I5,I6,I7: IN std_logic;
          O: OUT std_logic );
  END COMPONENT;
  --
  COMPONENT OR8_gate IS
    PORT( I0,I1,I2,I3,I4,I5,I6,I7: IN std_logic;
          O: OUT std_logic );
  END COMPONENT;
  --
  COMPONENT NOR8_gate IS
    PORT( I0,I1,I2,I3,I4,I5,I6,I7: IN std_logic;
          O: OUT std_logic );
  END COMPONENT;
  --
  COMPONENT Multiplexer_16_1 IS
    PORT( I0:  IN  std_logic;
          I1:  IN  std_logic;
          I2:  IN  std_logic;
          I3:  IN  std_logic;
          I4:  IN  std_logic;
          I5:  IN  std_logic;
          I6:  IN  std_logic;
          I7:  IN  std_logic;
          I8:  IN  std_logic;
          I9:  IN  std_logic;
          I10: IN  std_logic;
          I11: IN  std_logic;
          I12: IN  std_logic;
          I13: IN  std_logic;
          I14: IN  std_logic;
          I15: IN  std_logic;
          S3: IN  std_logic;
          S2: IN  std_logic;
          S1: IN  std_logic;
          S0: IN  std_logic;
          Q: OUT std_logic );
  END COMPONENT;

  COMPONENT PiPoE8 IS
    PORT( Ck : IN std_logic;
          nCL: IN std_logic;
          E  : IN std_logic;
          P7 : IN std_logic;
          P6 : IN std_logic;
          P5 : IN std_logic;
          P4 : IN std_logic;
          P3 : IN std_logic;
          P2 : IN std_logic;
          P1 : IN std_logic;
          P0 : IN std_logic;
          Q7 : OUT std_logic;
          Q6 : OUT std_logic;
          Q5 : OUT std_logic;
          Q4 : OUT std_logic;
          Q3 : OUT std_logic;
          Q2 : OUT std_logic;
          Q1 : OUT std_logic;
          Q0 : OUT std_logic );
  END COMPONENT;

SIGNAL S001: std_logic;
  SIGNAL S002: std_logic;
  SIGNAL S003: std_logic;
  SIGNAL S004: std_logic;
  SIGNAL S005: std_logic;
  SIGNAL S006: std_logic;
  SIGNAL S007: std_logic;
  SIGNAL S008: std_logic;
  SIGNAL S009: std_logic;
  SIGNAL S010: std_logic;
  SIGNAL S011: std_logic;
  SIGNAL S012: std_logic;
  SIGNAL S013: std_logic;
  SIGNAL S014: std_logic;
  SIGNAL S015: std_logic;
  SIGNAL S016: std_logic;
  SIGNAL S017: std_logic;
  SIGNAL S018: std_logic;
  SIGNAL S019: std_logic;
  SIGNAL S020: std_logic;
  SIGNAL S021: std_logic;
  SIGNAL S022: std_logic;
  SIGNAL S023: std_logic;
  SIGNAL S024: std_logic;
  SIGNAL S025: std_logic;
  SIGNAL S026: std_logic;
  SIGNAL S027: std_logic;
  SIGNAL S028: std_logic;
  SIGNAL S029: std_logic;
  SIGNAL S030: std_logic;
  SIGNAL S031: std_logic;
  SIGNAL S032: std_logic;
  SIGNAL S033: std_logic;
  SIGNAL S034: std_logic;
  SIGNAL S035: std_logic;
  SIGNAL S036: std_logic;
  SIGNAL S037: std_logic;
  SIGNAL S038: std_logic;
  SIGNAL S039: std_logic;
  SIGNAL S040: std_logic;
  SIGNAL S041: std_logic;
  SIGNAL S042: std_logic;
  SIGNAL S043: std_logic;
  SIGNAL S044: std_logic;
  SIGNAL S045: std_logic;
  SIGNAL S046: std_logic;
  SIGNAL S047: std_logic;
  SIGNAL S048: std_logic;
  SIGNAL S049: std_logic;
  SIGNAL S050: std_logic;
  SIGNAL S051: std_logic;
  SIGNAL S052: std_logic;
  SIGNAL S053: std_logic;
  SIGNAL S054: std_logic;
  SIGNAL S055: std_logic;
  SIGNAL S056: std_logic;
  SIGNAL S057: std_logic;
  SIGNAL S058: std_logic;
  SIGNAL S059: std_logic;
  SIGNAL S060: std_logic;
  SIGNAL S061: std_logic;
  SIGNAL S062: std_logic;
  SIGNAL S063: std_logic;
  SIGNAL S064: std_logic;
  SIGNAL S065: std_logic;
  SIGNAL S066: std_logic;
  SIGNAL S067: std_logic;
  SIGNAL S068: std_logic;
  SIGNAL S069: std_logic;
  SIGNAL S070: std_logic;
  SIGNAL S071: std_logic;
  SIGNAL S072: std_logic;
  SIGNAL S073: std_logic;
  SIGNAL S074: std_logic;
  SIGNAL S075: std_logic;
  SIGNAL S076: std_logic;
  SIGNAL S077: std_logic;
  SIGNAL S078: std_logic;
  SIGNAL S079: std_logic;
  SIGNAL S080: std_logic;
  SIGNAL S081: std_logic;
  SIGNAL S082: std_logic;
  SIGNAL S083: std_logic;
  SIGNAL S084: std_logic;
  SIGNAL S085: std_logic;
  SIGNAL S086: std_logic;
  SIGNAL S087: std_logic;
  SIGNAL S088: std_logic;
  SIGNAL S089: std_logic;
  SIGNAL S090: std_logic;
  SIGNAL S091: std_logic;
  SIGNAL S092: std_logic;
  SIGNAL S093: std_logic;

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
  signal sda_start_counter_stop_flag : std_logic;
  
	signal reset_or,reset_counter : std_logic;
	signal sda_start_ldcpe,sda_stop_ldcpe : std_logic;
	signal ffjkq1,ffjkq2 : std_logic_vector(7 downto 0);
	signal t1,t2,t3,t4 : std_logic;
	signal rc_start : std_logic_vector(7 downto 0) := "00000000";
	signal rc_start_1 : std_logic_vector(7 downto 0);
--	signal rc_start_mux : std_logic_vector(7 downto 0);
	signal mux81_rc_start_select : std_logic_vector(2 downto 0) := "000";
	type ta is array(integer range <>) of std_logic_vector(sda_condition_bits-1 downto 0);
	signal rc_q : ta(0 to 7);
	constant RC_MAIN_BITS : integer := 6;
	signal rc_main : std_logic_vector(RC_MAIN_BITS-1 downto 0);
	signal tick : std_logic_vector(7 downto 0);
	signal tick_clock_all0 : std_logic;
	signal tick_clock_all1 : std_logic;
	signal a1 : std_logic;
	signal a2 : std_logic;
	signal reset_a1 : std_logic;
	signal omit_first_reset : std_logic;
  signal mux81_address_slave_select : std_logic_vector (G_SLAVE_ADDRESS_SIZE-1 downto 0);
  signal mux81_address_slave_out : std_logic;
  signal mux81_bytes_to_send_select : std_logic_vector (G_BYTE_SIZE-1 downto 0);
  signal mux81_bytes_to_send_out : std_logic;

  signal mux81_address_slave_select_wait_reset : std_logic_vector (G_SLAVE_ADDRESS_SIZE-1 downto 0);
  signal rc_as_ldcpe : std_logic;

  signal mux81_bytes_to_send_select_wait_reset : std_logic_vector (G_BYTE_SIZE-1 downto 0);
  signal rc_b2s_ldcpe : std_logic;
  
  signal rc_mm : std_logic_vector(8-1 downto 0);
  signal rc_as_b2s_ldcpe : std_logic;

  signal m81_main_s0 : std_logic;
  signal m81_main_s1 : std_logic;
  signal m81_main_s2 : std_logic;

signal flag_start,flag_address,flag_data,flag_ack,flag_stop : std_logic;
--  rc_mm_start <= '1' when rc_mm = x"00" else '0';
--  rc_mm_address <= '1' when rc_mm = x"07" else '0';
--  rc_mm_data <= '1' when rc_mm = x"57" else '0';
--  rc_mm_ack <= '1' when rc_mm = x"a7" else '0';
--  rc_mm_stop <= '1' when rc_mm = x"b4" else '0';

  signal rc_mm_start,rc_mm_address,rc_mm_data,rc_mm_ack,rc_mm_stop : std_logic;

  signal start_temp,address_temp,data_temp,ack_temp,stop_temp : std_logic_vector (7 downto 0);
  signal enable_start,enable_address,enable_data,enable_ack,enable_stop : std_logic;

  signal wait_reset_ldcpe_pre : std_logic;
  
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

	start_stop_flag : a1 <= '1' when rc_main = std_logic_vector(to_unsigned(N/2,RC_MAIN_BITS)) else '0';
	address_data_flag : a2 <= '1' when rc_main = std_logic_vector(to_unsigned(13,RC_MAIN_BITS)) else '0';
	reset_a1 <= '1' when rc_main = std_logic_vector(to_unsigned(N*2,RC_MAIN_BITS)) else '0';
  t1 <= i_reset or reset_a1;
  t2 <= reset_a1 and omit_first_reset;
	t3 <= a1 and not reset_a1 and omit_first_reset;
	t4 <= '1' and not reset_or;

	tick_clock_all0 <= '1' when clock_chain = clock_all0_constant else '0';
	tick_clock_all1 <= '1' when clock_chain = clock_all1_constant else '0';
	reset_counter <= '1' when rc_q(0) = sda_condition_stop_constant else '0';

	or_reset_conter_inst : GATE_OR
	port map (
  A => i_reset,
  B => reset_counter,
  C => reset_or);

	generate_mux21_rc_mrb : for i in 0 to 7 generate
		mux21_rc_mrb : MUX_21
		port map (
    S => rc_start(i),
    A => '1',
    B => '0',
    C => rc_start_1(i));
	end generate generate_mux21_rc_mrb;

	ripple_counter_main : ripple_counter
	generic map (N => RC_MAIN_BITS,MAX => N*2)
	port map (
  i_clock => i_clock,
  i_cpb => '1',
  i_mrb => t1,
  i_ud => '1',
  o_q => rc_main);

	sda_start_ldcpe_inst  : LDCPE generic map (INIT => '1')
	port map (
  Q => sda_start_ldcpe,
  D => '0',
  CLR => '0',
  G => a1,
  GE => a1,
  PRE => '0');
	
  sda_stop_ldcpe_inst_prev : LDCPE generic map (INIT => '0')
	port map (
  Q => omit_first_reset,
  D => '1',
  CLR => a1,
  G => a1,
  GE => a1,
  PRE => reset_a1);
  
  sda_stop_ldcpe_inst : LDCPE generic map (INIT => '0')
	port map (
  Q => sda_stop_ldcpe,
  D => t2,
  CLR => '0',
  G => a1,
  GE => not a1,
  PRE => t3);
	
	sda_start_counter : ripple_counter
	generic map (N => sda_condition_bits,MAX => 2**sda_condition_bits-1)
	port map (
  i_clock => i_clock,
  i_cpb => not tick_clock_all0,
  i_mrb => rc_start_1(0),
  i_ud => '1',
  o_q => rc_q(0));
  
	sda_stop_counter : ripple_counter
	generic map (N => sda_condition_bits,MAX => 2**sda_condition_bits-1)
	port map (
  i_clock => i_clock,
  i_cpb => t4,
  i_mrb => rc_start_1(1),
  i_ud => '1',
  o_q => rc_q(1));

	rc0 : ripple_counter
	generic map (N => sda_condition_bits,MAX => 2**sda_condition_bits-1)
	port map (
  i_clock => i_clock,
  i_cpb => '1',
  i_mrb => rc_start_1(2),
  i_ud => '1',
  o_q => rc_q(2));

	g1 : for i in 0 to 7 generate
		tick(i) <= '1' when rc_q(i) = sda_condition_stop_constant else '0';
	end generate g1;

	g0 : for i in 0 to 7 generate
		ffjk : FF_JK
		port map (
    i_r => i_reset,
    J => '1',
    K => '1',
    C => tick(i),
    Q1 => ffjkq1(i),
    Q2 => ffjkq2(i));
	end generate g0;

	generate_clock_chain : for i in 0 to N-1 generate
		clock_chain_first : if (i=0) generate
			clock_chain_f : LDCPE
			port map (
      Q => clock_chain(i),
      D => clock,
      CLR => i_reset,
      G => i_clock,
      GE => not i_clock,
      PRE => '0');
		end generate clock_chain_first;
		clock_chain_rest : if (i>0) generate
			clock_chain_r : LDCPE
			port map (
      Q => clock_chain(i),
      D => clock_chain(i-1),
      CLR => '0',
      G => i_clock,
      GE => not i_clock,
      PRE => '0');
		end generate clock_chain_rest;
	end generate generate_clock_chain;

	mux21_clock_chain_tick : MUXCY
	port map (
  O => clock,
  CI => '0',
  DI => '1',
  S => clock_chain(N-1));

	OBUFT_scl_clock_inst : OBUFT -- output clock line, works
	port map (
  O => o_scl,
  I => clock,
  T => clock);

	OBUFT_sda_data_inst : OBUFT -- output sda line
	port map (
  O => o_sda,
  I => data,
  T => data);
	
  mux21_sda_start_counter_stop : MUX_21
	port map (
  S => reset_or,
  A => '1',
  B => '0',
  C => sda_start_counter_stop_flag);  

	rc_address_slave_bytes_to_send_wait_reset : ripple_counter
	generic map (N => 8,MAX => 2**8-1)
	port map (
  i_clock => rc_main(0),
  i_cpb => '1',
  i_mrb => i_reset,
  i_ud => '1',
  o_q => rc_mm);

  wait_reset_ldcpe_pre <= not rc_mm(0) and
          not rc_mm(1) and
          not rc_mm(2) and
          not rc_mm(3) and
          rc_mm(4) and
          not rc_mm(5) and
          not rc_mm(6) and
          not rc_mm(7);

  rc_address_slave_bytes_to_send_wait_reset_ldcpe : LDCPE generic map (INIT => '0')
	port map (
  Q => rc_as_b2s_ldcpe,
  D => '1',
  CLR => '0',
  G => '0',
  GE => '0',
  PRE => wait_reset_ldcpe_pre);

	ripple_counter_mux81_address_slave : ripple_counter
	generic map (N => G_SLAVE_ADDRESS_SIZE,MAX => 2**G_SLAVE_ADDRESS_SIZE-1)
	port map (
  i_clock => a2,
  i_cpb => '1',
  i_mrb => not rc_as_b2s_ldcpe,
  i_ud => '1',
  o_q => mux81_address_slave_select);

  ripple_counter_mux81_bytes_to_send : ripple_counter
	generic map (N => G_BYTE_SIZE,MAX => 2**G_BYTE_SIZE-1)
	port map (
  i_clock => a2,
  i_cpb => '1',
  i_mrb => not rc_as_b2s_ldcpe,
  i_ud => '1',
  o_q => mux81_bytes_to_send_select);

	mux81_address_slave : MUX_81
	port map (
  S0 => mux81_address_slave_select(0),
  S1 => mux81_address_slave_select(1),
  S2 => mux81_address_slave_select(2),
  in0 => i_slave_address(0),
  in1 => i_slave_address(1),
  in2 => i_slave_address(2),
  in3 => i_slave_address(3),
  in4 => i_slave_address(4),
  in5 => i_slave_address(5),
  in6 => i_slave_address(6),
  in7 => i_slave_rw,
  o => mux81_address_slave_out);

	mux81_bytes_to_send : MUX_81
	port map (
  S0 => mux81_bytes_to_send_select(0),
  S1 => mux81_bytes_to_send_select(1),
  S2 => mux81_bytes_to_send_select(2),
  in0 => i_bytes_to_send(0),
  in1 => i_bytes_to_send(1),
  in2 => i_bytes_to_send(2),
  in3 => i_bytes_to_send(3),
  in4 => i_bytes_to_send(4),
  in5 => i_bytes_to_send(5),
  in6 => i_bytes_to_send(6),
  in7 => i_bytes_to_send(7),
  o => mux81_bytes_to_send_out);

  
  C262_start: PiPoE8 PORT MAP ( i_clock, not i_reset, enable_start,
  rc_mm(7), rc_mm(6), rc_mm(5), rc_mm(4), rc_mm(3), rc_mm(2), rc_mm(1), rc_mm(0),
  start_temp(7), start_temp(6), start_temp(5), start_temp(4), start_temp(3), start_temp(2), start_temp(1), start_temp(0) );
  C2379: NOR8_gate PORT MAP ( 
  rc_mm(0), rc_mm(1), rc_mm(2), rc_mm(3), rc_mm(4), rc_mm(5), rc_mm(6), rc_mm(7), enable_start);
  C2380: NAND8_gate PORT MAP ( 
  start_temp(7), start_temp(6), start_temp(5), start_temp(4), start_temp(3), start_temp(2), start_temp(1), start_temp(0), flag_start );

  C268_address: PiPoE8 PORT MAP ( i_clock, not i_reset, enable_address,
  rc_mm(7), rc_mm(6), rc_mm(5), rc_mm(4), rc_mm(3), rc_mm(2), rc_mm(1), rc_mm(0),
  address_temp(7), address_temp(6), address_temp(5), address_temp(4), address_temp(3), address_temp(2), address_temp(1), address_temp(0) );
  C887: AND8_gate PORT MAP (
  rc_mm(0), rc_mm(1), rc_mm(2), not rc_mm(3), not rc_mm(4), not rc_mm(5), not rc_mm(6), not rc_mm(7), enable_address );
  C1163: OR8_gate PORT MAP (
  address_temp(0), address_temp(1), address_temp(2), address_temp(3), address_temp(4), address_temp(5), address_temp(6), address_temp(7), flag_address);

  C893_data: PiPoE8 PORT MAP ( i_clock, not i_reset, enable_data,
  rc_mm(7), rc_mm(6), rc_mm(5), rc_mm(4), rc_mm(3), rc_mm(2), rc_mm(1), rc_mm(0),
  data_temp(7), data_temp(6), data_temp(5), data_temp(4), data_temp(3), data_temp(2), data_temp(1), data_temp(0) );
  C614: AND8_gate PORT MAP (
  rc_mm(0), rc_mm(1), rc_mm(2), not rc_mm(3), rc_mm(4), not rc_mm(5), rc_mm(6), not rc_mm(7), enable_data );
  C1182: OR8_gate PORT MAP (
  data_temp(0), data_temp(1), data_temp(2), data_temp(3), data_temp(4), data_temp(5), data_temp(6), data_temp(7), flag_data );

  C1310_ack: PiPoE8 PORT MAP ( i_clock, not i_reset, enable_ack,
  rc_mm(7), rc_mm(6), rc_mm(5), rc_mm(4), rc_mm(3), rc_mm(2), rc_mm(1), rc_mm(0),
  ack_temp(7), ack_temp(6), ack_temp(5), ack_temp(4), ack_temp(3), ack_temp(2), ack_temp(1), ack_temp(0) );
  C548: AND8_gate PORT MAP (
  rc_mm(0), rc_mm(1), rc_mm(2), not rc_mm(3), not rc_mm(4), rc_mm(5), not rc_mm(6), rc_mm(7), enable_ack);
  C1198: OR8_gate PORT MAP (
  ack_temp(0), ack_temp(1), ack_temp(2), ack_temp(3), ack_temp(4), ack_temp(5), ack_temp(6), ack_temp(7), flag_ack );

  C1628_stop: PiPoE8 PORT MAP ( i_clock, not i_reset, enable_stop,
  rc_mm(7), rc_mm(6), rc_mm(5), rc_mm(4), rc_mm(3), rc_mm(2), rc_mm(1), rc_mm(0),
  stop_temp(7), stop_temp(6), stop_temp(5), stop_temp(4), stop_temp(3), stop_temp(2), stop_temp(1), stop_temp(0) );
  C1629: OR8_gate PORT MAP (
  not rc_mm(0), not rc_mm(1), rc_mm(2), not rc_mm(3), rc_mm(4), rc_mm(5), not rc_mm(6), rc_mm(7), enable_stop );
  C1741: AND8_gate PORT MAP (
  stop_temp(0), stop_temp(1), stop_temp(2), stop_temp(3), stop_temp(4), stop_temp(5), stop_temp(6), stop_temp(7), flag_stop );
  
--	m81_main_inst : MUX_81 -- main multiplexing
--	port map (
--  S0 => m81_main_s0,
--  S1 => m81_main_s1,
--  S2 => m81_main_s2,
--  in0 => sda_start_ldcpe, -- start condition
--  in1 => mux81_address_slave_out, -- address 7b
--  in2 => mux81_bytes_to_send_out, -- data 8b
--  in3 => '1', -- wait for ack/nack - Z on sda
--  in4 => sda_stop_ldcpe, -- stop condition
--  in5 => '0', -- not used
--  in6 => '0', -- not used
--  in7 => '0', -- not used
--  o => data); -- out to OBUFT_sda_data_inst
  
  C2497: Multiplexer_16_1 PORT MAP (
  sda_start_ldcpe,
  mux81_address_slave_out, 
  '0',
  mux81_bytes_to_send_out, 
  '0',
  '0', 
  '0',
  '1', -- acl 
  '0',
  '0', 
  '0',
  '0', 
  '0',
  '0', 
  '0',
  sda_stop_ldcpe, 
  flag_stop,
  flag_ack,
  flag_data,
  flag_address, 
  data );

end architecture Behavioral;

------------------------------------------------------------
-- Deeds (Digital Electronics Education and Design Suite)
-- VHDL Code generated on (20.03.2024, 17:15:41)
--      by Deeds (Digital Circuit Simulator)(Deeds-DcS)
--      Ver. 2.50.200 (Feb 18, 2022)
-- Copyright (c) 2002-2022 University of Genoa, Italy
--      Web Site:  https://www.digitalelectronicsdeeds.com
------------------------------------------------------------

--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

ENTITY AND8_gate IS
  PORT( I0,I1,I2,I3,I4,I5,I6,I7: IN std_logic;
        O: OUT std_logic );
END AND8_gate;

--------------------------------------------------------------------
ARCHITECTURE behavioral OF AND8_gate IS
BEGIN
  O <= (I0 and I1 and I2 and I3 and I4 and I5 and I6 and I7);
END behavioral;


--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

ENTITY NAND8_gate IS
  PORT( I0,I1,I2,I3,I4,I5,I6,I7: IN std_logic;
        O: OUT std_logic );
END NAND8_gate;

--------------------------------------------------------------------
ARCHITECTURE behavioral OF NAND8_gate IS
BEGIN
  O <= (not (I0 and I1 and I2 and I3 and I4 and I5 and I6 and I7));
END behavioral;


--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

ENTITY OR8_gate IS
  PORT( I0,I1,I2,I3,I4,I5,I6,I7: IN std_logic;
        O: OUT std_logic );
END OR8_gate;

--------------------------------------------------------------------
ARCHITECTURE behavioral OF OR8_gate IS
BEGIN
  O <= (I0 or I1 or I2 or I3 or I4 or I5 or I6 or I7);
END behavioral;


--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

ENTITY NOR8_gate IS
  PORT( I0,I1,I2,I3,I4,I5,I6,I7: IN std_logic;
        O: OUT std_logic );
END NOR8_gate;

--------------------------------------------------------------------
ARCHITECTURE behavioral OF NOR8_gate IS
BEGIN
  O <= (not (I0 or I1 or I2 or I3 or I4 or I5 or I6 or I7));
END behavioral;


--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

ENTITY Multiplexer_16_1 IS

  PORT( I0:  IN  std_logic;
        I1:  IN  std_logic;
        I2:  IN  std_logic;
        I3:  IN  std_logic;
        I4:  IN  std_logic;
        I5:  IN  std_logic;
        I6:  IN  std_logic;
        I7:  IN  std_logic;
        I8:  IN  std_logic;
        I9:  IN  std_logic;
        I10: IN  std_logic;
        I11: IN  std_logic;
        I12: IN  std_logic;
        I13: IN  std_logic;
        I14: IN  std_logic;
        I15: IN  std_logic;
        S3: IN  std_logic;
        S2: IN  std_logic;
        S1: IN  std_logic;
        S0: IN  std_logic;
         Q: OUT std_logic );
END Multiplexer_16_1;

--------------------------------------------------------------------
ARCHITECTURE behavioral OF Multiplexer_16_1 IS
BEGIN
  Q <= I0  when ((S3 = '0') and (S2 = '0') and (S1 = '0') and (S0 = '0')) else
       I1  when ((S3 = '0') and (S2 = '0') and (S1 = '0') and (S0 = '1')) else
       I2  when ((S3 = '0') and (S2 = '0') and (S1 = '1') and (S0 = '0')) else
       I3  when ((S3 = '0') and (S2 = '0') and (S1 = '1') and (S0 = '1')) else
       I4  when ((S3 = '0') and (S2 = '1') and (S1 = '0') and (S0 = '0')) else
       I5  when ((S3 = '0') and (S2 = '1') and (S1 = '0') and (S0 = '1')) else
       I6  when ((S3 = '0') and (S2 = '1') and (S1 = '1') and (S0 = '0')) else
       I7  when ((S3 = '0') and (S2 = '1') and (S1 = '1') and (S0 = '1')) else
       I8  when ((S3 = '1') and (S2 = '0') and (S1 = '0') and (S0 = '0')) else
       I9  when ((S3 = '1') and (S2 = '0') and (S1 = '0') and (S0 = '1')) else
       I10 when ((S3 = '1') and (S2 = '0') and (S1 = '1') and (S0 = '0')) else
       I11 when ((S3 = '1') and (S2 = '0') and (S1 = '1') and (S0 = '1')) else
       I12 when ((S3 = '1') and (S2 = '1') and (S1 = '0') and (S0 = '0')) else
       I13 when ((S3 = '1') and (S2 = '1') and (S1 = '0') and (S0 = '1')) else
       I14 when ((S3 = '1') and (S2 = '1') and (S1 = '1') and (S0 = '0')) else
       I15 when ((S3 = '1') and (S2 = '1') and (S1 = '1') and (S0 = '1')) else 'X';
END behavioral;

--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

ENTITY Decoder_4_16 IS

  PORT( A3: IN  std_logic;
        A2: IN  std_logic;
        A1: IN  std_logic;
        A0: IN  std_logic;
        EN: IN  std_logic;
        Y0 : OUT std_logic;
        Y1 : OUT std_logic;
        Y2 : OUT std_logic;
        Y3 : OUT std_logic;
        Y4 : OUT std_logic;
        Y5 : OUT std_logic;
        Y6 : OUT std_logic;
        Y7 : OUT std_logic;
        Y8 : OUT std_logic;
        Y9 : OUT std_logic;
        Y10: OUT std_logic;
        Y11: OUT std_logic;
        Y12: OUT std_logic;
        Y13: OUT std_logic;
        Y14: OUT std_logic;
        Y15: OUT std_logic );
END Decoder_4_16;

--------------------------------------------------------------------
ARCHITECTURE behavioral OF Decoder_4_16 IS
  SIGNAL aNumber: std_logic_vector( 4 downto 0 );
BEGIN
  aNumber <= EN & A3 & A2 & A1 & A0;
  with aNumber select
    Y0 <= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '1' when "10000", '0' when "10001", '0' when "10010", '0' when "10011",
          '0' when "10100", '0' when "10101", '0' when "10110", '0' when "10111",
          '0' when "11000", '0' when "11001", '0' when "11010", '0' when "11011",
          '0' when "11100", '0' when "11101", '0' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y1 <= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '1' when "10001", '0' when "10010", '0' when "10011",
          '0' when "10100", '0' when "10101", '0' when "10110", '0' when "10111",
          '0' when "11000", '0' when "11001", '0' when "11010", '0' when "11011",
          '0' when "11100", '0' when "11101", '0' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y2 <= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '0' when "10001", '1' when "10010", '0' when "10011",
          '0' when "10100", '0' when "10101", '0' when "10110", '0' when "10111",
          '0' when "11000", '0' when "11001", '0' when "11010", '0' when "11011",
          '0' when "11100", '0' when "11101", '0' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y3 <= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '0' when "10001", '0' when "10010", '1' when "10011",
          '0' when "10100", '0' when "10101", '0' when "10110", '0' when "10111",
          '0' when "11000", '0' when "11001", '0' when "11010", '0' when "11011",
          '0' when "11100", '0' when "11101", '0' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y4 <= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '0' when "10001", '0' when "10010", '0' when "10011",
          '1' when "10100", '0' when "10101", '0' when "10110", '0' when "10111",
          '0' when "11000", '0' when "11001", '0' when "11010", '0' when "11011",
          '0' when "11100", '0' when "11101", '0' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y5 <= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '0' when "10001", '0' when "10010", '0' when "10011",
          '0' when "10100", '1' when "10101", '0' when "10110", '0' when "10111",
          '0' when "11000", '0' when "11001", '0' when "11010", '0' when "11011",
          '0' when "11100", '0' when "11101", '0' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y6 <= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '0' when "10001", '0' when "10010", '0' when "10011",
          '0' when "10100", '0' when "10101", '1' when "10110", '0' when "10111",
          '0' when "11000", '0' when "11001", '0' when "11010", '0' when "11011",
          '0' when "11100", '0' when "11101", '0' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y7 <= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '0' when "10001", '0' when "10010", '0' when "10011",
          '0' when "10100", '0' when "10101", '0' when "10110", '1' when "10111",
          '0' when "11000", '0' when "11001", '0' when "11010", '0' when "11011",
          '0' when "11100", '0' when "11101", '0' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y8 <= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '0' when "10001", '0' when "10010", '0' when "10011",
          '0' when "10100", '0' when "10101", '0' when "10110", '0' when "10111",
          '1' when "11000", '0' when "11001", '0' when "11010", '0' when "11011",
          '0' when "11100", '0' when "11101", '0' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y9 <= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '0' when "10001", '0' when "10010", '0' when "10011",
          '0' when "10100", '0' when "10101", '0' when "10110", '0' when "10111",
          '0' when "11000", '1' when "11001", '0' when "11010", '0' when "11011",
          '0' when "11100", '0' when "11101", '0' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y10<= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '0' when "10001", '0' when "10010", '0' when "10011",
          '0' when "10100", '0' when "10101", '0' when "10110", '0' when "10111",
          '0' when "11000", '0' when "11001", '1' when "11010", '0' when "11011",
          '0' when "11100", '0' when "11101", '0' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y11<= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '0' when "10001", '0' when "10010", '0' when "10011",
          '0' when "10100", '0' when "10101", '0' when "10110", '0' when "10111",
          '0' when "11000", '0' when "11001", '0' when "11010", '1' when "11011",
          '0' when "11100", '0' when "11101", '0' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y12<= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '0' when "10001", '0' when "10010", '0' when "10011",
          '0' when "10100", '0' when "10101", '0' when "10110", '0' when "10111",
          '0' when "11000", '0' when "11001", '0' when "11010", '0' when "11011",
          '1' when "11100", '0' when "11101", '0' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y13<= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '0' when "10001", '0' when "10010", '0' when "10011",
          '0' when "10100", '0' when "10101", '0' when "10110", '0' when "10111",
          '0' when "11000", '0' when "11001", '0' when "11010", '0' when "11011",
          '0' when "11100", '1' when "11101", '0' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y14<= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '0' when "10001", '0' when "10010", '0' when "10011",
          '0' when "10100", '0' when "10101", '0' when "10110", '0' when "10111",
          '0' when "11000", '0' when "11001", '0' when "11010", '0' when "11011",
          '0' when "11100", '0' when "11101", '1' when "11110", '0' when "11111",
          'X' when others;
  with aNumber select
    Y15<= '0' when "00000", '0' when "00001", '0' when "00010", '0' when "00011",
          '0' when "00100", '0' when "00101", '0' when "00110", '0' when "00111",
          '0' when "01000", '0' when "01001", '0' when "01010", '0' when "01011",
          '0' when "01100", '0' when "01101", '0' when "01110", '0' when "01111",
          '0' when "10000", '0' when "10001", '0' when "10010", '0' when "10011",
          '0' when "10100", '0' when "10101", '0' when "10110", '0' when "10111",
          '0' when "11000", '0' when "11001", '0' when "11010", '0' when "11011",
          '0' when "11100", '0' when "11101", '0' when "11110", '1' when "11111",
          'X' when others;
END behavioral;

--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY CounterUDE8 IS
  PORT( Ck : IN std_logic;
        nCL: IN std_logic;
        ENP: IN std_logic;
        UD : IN std_logic;		  
        Q7 : OUT std_logic;
        Q6 : OUT std_logic;
        Q5 : OUT std_logic;
        Q4 : OUT std_logic;
        Q3 : OUT std_logic;
        Q2 : OUT std_logic;
        Q1 : OUT std_logic;
        Q0 : OUT std_logic;		  
        Tc : OUT std_logic );
END CounterUDE8;

--------------------------------------------------------------------
ARCHITECTURE behavioral OF CounterUDE8 IS
BEGIN
  CountUDE8: PROCESS( Ck, nCL, ENP, UD )
  variable aCnt: unsigned( 7 downto 0 );
  BEGIN
    if    (nCL = '0') then          		aCnt := (others =>'0');
    elsif (nCL = '1') then
      if (Ck'event) AND (Ck='1') then
        if  (ENP = '1') then
          if    (UD = '1') then
            if (aCnt < "11111111") then	aCnt := aCnt + 1;
            else                    		aCnt := (others =>'0');
            end if;
          elsif (UD = '0') then
            if (aCnt > "00000000") then 	aCnt := aCnt - 1;
            else                    		aCnt := (others =>'1');
            end if;
          else                     	 		aCnt := (others =>'X'); -- (UD: Unknown)
          END IF;
        elsif not(ENP ='0') then    		aCnt := (others =>'X'); -- (ENP: Unknown)
        END IF;
      END IF;
    else                            		aCnt := (others =>'X'); -- (nCL: Unknown)
    END IF;
    --
	 Tc <=     (aCnt(7) and aCnt(6) and aCnt(5) and aCnt(4) and aCnt(3) and aCnt(2) and aCnt(1) and aCnt(0) and UD) or
          (not(aCnt(7) or  aCnt(6) or  aCnt(5) or  aCnt(4) or  aCnt(3) or  aCnt(2) or  aCnt(1) or  aCnt(0) or  UD));
    --
    Q7 <= aCnt(7);
    Q6 <= aCnt(6);
    Q5 <= aCnt(5);
    Q4 <= aCnt(4);
    Q3 <= aCnt(3);
    Q2 <= aCnt(2);
    Q1 <= aCnt(1);
    Q0 <= aCnt(0);
    --
  END PROCESS;
END behavioral;

--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

ENTITY PiPoE8 IS
  PORT( Ck : IN std_logic;
        nCL: IN std_logic;
        E  : IN std_logic;
        P7 : IN std_logic;
        P6 : IN std_logic;
        P5 : IN std_logic;
        P4 : IN std_logic;
        P3 : IN std_logic;
        P2 : IN std_logic;
        P1 : IN std_logic;
        P0 : IN std_logic;
        Q7 : OUT std_logic;
        Q6 : OUT std_logic;
        Q5 : OUT std_logic;
        Q4 : OUT std_logic;
        Q3 : OUT std_logic;
        Q2 : OUT std_logic;
        Q1 : OUT std_logic;
        Q0 : OUT std_logic );
END PiPoE8;


--------------------------------------------------------------------
ARCHITECTURE behavioral OF PiPoE8 IS
BEGIN
  RegPiPoE8: PROCESS( Ck, nCL )
    variable aReg: std_logic_vector( 7 downto 0 );
  BEGIN
    if    (nCL = '0') then    aReg := (others =>'0');
    elsif (nCL = '1') then
      if (Ck'event) AND (Ck='1') THEN -- Positive Edge -----------
        if (E = '1') then
                aReg := (P7 & P6 & P5 & P4 & P3 & P2 & P1 & P0);
        elsif not(E = '0') then
                aReg := (others =>'X');
        END IF;
      END IF;
    else        aReg := (others =>'X');
    END IF;

    Q7 <= aReg(7);
    Q6 <= aReg(6);
    Q5 <= aReg(5);
    Q4 <= aReg(4);
    Q3 <= aReg(3);
    Q2 <= aReg(2);
    Q1 <= aReg(1);
    Q0 <= aReg(0);

  END PROCESS;
END behavioral;
