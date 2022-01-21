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

entity my_i2c_pc is
generic(
constant N : integer := 10
);
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
end my_i2c_pc;

architecture Behavioral of my_i2c_pc is

	constant delay_and : time := 0 ns;
	constant delay_or : time := 0 ns;
	constant delay_not : time := 0 ns;
	constant delay_nand : time := 0 ns;
	constant delay_nor2 : time := 0 ns;
	constant delay_nand2 : time := 0 ns;
	constant delay_nand3 : time := 0 ns;
	constant delay_and3 : time := 0 ns;
	constant ADDRESS_SIZE : integer := 7;
	constant BYTE_SIZE : integer := 8;
	constant QMUX_SIZE : integer := N/2;

	component GATE_NOT is
	generic (delay_not : TIME := 0 ns);
	port (A : in STD_LOGIC; B : out STD_LOGIC);
	end component GATE_NOT;
	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);

	component GATE_OR is
	generic (delay_or : TIME := 0 ns);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GATE_OR;
	for all : GATE_OR use entity WORK.GATE_OR(GATE_OR_LUT);

	component GATE_AND is
	generic (delay_and : TIME := 0 ns);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GATE_AND;
	for all : GATE_AND use entity WORK.GATE_AND(GATE_AND_LUT);

	component GATE_NAND is
	generic (delay_nand : TIME := 0 ns);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GATE_NAND;
	for all : GATE_NAND use entity WORK.GATE_NAND(GATE_NAND_LUT);

	component GATE_NOR2 is
	generic (delay_nor2 : TIME := 0 ns);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GATE_NOR2;
	for all : GATE_NOR2 use entity WORK.GATE_NOR2(GATE_NOR2_LUT);

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

	signal a,b,c,d,e : std_logic;
	signal sda_chain : std_logic_vector(N-1 downto 0);
	signal sda_condition_chain_start : std_logic_vector(N-1 downto 0);
	signal sda_condition_chain_stop : std_logic_vector(N-1 downto 0);
	signal sda_start_condition_out : std_logic;
	signal sda_start_condition : std_logic;
	signal sda_stop_condition_out : std_logic;
	signal sda_stop_condition : std_logic;
	signal qmux : std_logic_vector(QMUX_SIZE-1 downto 0);
	signal qnmux : std_logic_vector(QMUX_SIZE-1 downto 0);
	signal encoder_main : std_logic_vector(2 downto 0);
	signal all1_slv : std_logic_vector(N-1 downto 0);
	signal all1 : std_logic;
	signal all0_slv : std_logic_vector(N-1 downto 0);
	signal all0 : std_logic;
	signal left1_slv : std_logic_vector(N-1 downto 0);
	signal left1 : std_logic;
	signal right1_slv : std_logic_vector(N-1 downto 0);
	signal right1 : std_logic;
	signal left0_slv : std_logic_vector(N-1 downto 0);
	signal left0 : std_logic;
	signal right0_slv : std_logic_vector(N-1 downto 0);
	signal right0 : std_logic;
	signal clock : std_logic;
	signal t1,t2 : std_logic;
	signal amux : std_logic_vector(N/2-1 downto 0);
	signal acopy : std_logic_vector(ADDRESS_SIZE-1 downto 0);
	signal encoder_address : std_logic_vector(3 downto 0);
	signal addressmux : std_logic;
	signal dmux : std_logic_vector(BYTE_SIZE downto 0);
	signal dcopy : std_logic_vector(BYTE_SIZE-1 downto 0);
	signal encoder_data : std_logic_vector(3 downto 0);
	signal datamux : std_logic;

begin

	-- all N 1
	all1_generate : for i in 0 to N-1 generate
		all1_first : if (i=0) generate
			all1_f : GATE_AND generic map (delay_and => delay_and) port map (A => sda_chain(i), B => sda_chain(i+1), C => all1_slv(i));
		end generate all1_first;
		all1_middle : if (i>0 and i<N-1) generate
			all1_m : GATE_AND generic map (delay_and => delay_and) port map (A => all1_slv(i-1), B => sda_chain(i), C => all1_slv(i));
		end generate all1_middle;
		all1_last : if (i=N-1) generate
			all1_l : GATE_AND generic map (delay_and => delay_and) port map (A => all1_slv(i-1), B => sda_chain(i), C => all1_slv(i));
			all1 <= all1_slv(i);
		end generate all1_last;
	end generate all1_generate;

	-- all N 0
	all0_generate : for i in 0 to N-1 generate
		all0_first : if (i=0) generate
			all0_f : GATE_NAND generic map (delay_nand => delay_nand) port map (A => not sda_chain(i), B => not sda_chain(i+1), C => all0_slv(i));
		end generate all0_first;
		all0_middle : if (i>0 and i<N-1) generate
			all0_m : GATE_NAND generic map (delay_nand => delay_nand) port map (A => not all0_slv(i-1), B => not sda_chain(i), C => all0_slv(i));
		end generate all0_middle;
		all0_last : if (i=N-1) generate
			all0_l : GATE_AND generic map (delay_and => delay_and) port map (A => not all0_slv(i-1), B => not sda_chain(i), C => all0_slv(i));
			all0 <= all0_slv(i);
		end generate all0_last;
	end generate all0_generate;

	-- N/2 left have 1, N/2 right have 0
	left1_generate : for i in 0 to N-1 generate
		left1_first : if (i=0) generate
			left1_f : GATE_NAND generic map (delay_nand => delay_nand) port map (A => not sda_chain(i), B => not sda_chain(i+1), C => left1_slv(i));
		end generate left1_first;
		left1_first1 : if (i>0 and i<N/2) generate
			left1_f1 : GATE_NAND generic map (delay_nand => delay_nand) port map (A => not left1_slv(i-1), B => not sda_chain(i), C => left1_slv(i));
		end generate left1_first1;
		left1_middle : if (i=N/2) generate
			left1_m1 : GATE_AND generic map (delay_and => delay_and) port map (A => not left1_slv(i-1), B => sda_chain(i), C => left1_slv(i));
		end generate left1_middle;
		left1_last : if (i>N/2 and i<N-1) generate
			left1_l : GATE_AND generic map (delay_and => delay_and) port map (A => left1_slv(i-1), B => sda_chain(i), C => left1_slv(i));
		end generate left1_last;
		left1_last1 : if (i=N-1) generate
			left1_l1 : GATE_AND generic map (delay_and => delay_and) port map (A => left1_slv(i-1), B => sda_chain(i), C => left1_slv(i));
			left1 <= left1_slv(i);
			right0 <= left1_slv(i);
			right0_slv <= left1_slv;
		end generate left1_last1;
	end generate left1_generate;

	-- N/2 right have 1, N/2 left have 0
	right1_generate : for i in 0 to N-1 generate
		right1_first : if (i=0) generate
			right1_f : GATE_AND generic map (delay_and => delay_and) port map (A => sda_chain(i), B => sda_chain(i+1), C => right1_slv(i));
		end generate right1_first;
		right1_first1 : if (i>0 and i<N/2) generate
			right1_f1 : GATE_AND generic map (delay_and => delay_and) port map (A => right1_slv(i-1), B => sda_chain(i), C => right1_slv(i));
		end generate right1_first1;
		right1_middle : if (i=N/2) generate
			right1_m1 : GATE_NAND generic map (delay_nand => delay_nand) port map (A => right1_slv(i-1), B => not sda_chain(i), C => right1_slv(i));
		end generate right1_middle;
		right1_last : if (i>N/2 and i<N-1) generate
			right1_l : GATE_NAND generic map (delay_nand => delay_nand) port map (A => not right1_slv(i-1), B => not sda_chain(i), C => right1_slv(i));
		end generate right1_last;
		right1_last1 : if (i=N-1) generate
			right1_l1 : GATE_NAND generic map (delay_nand => delay_nand) port map (A => not right1_slv(i-1), B => not sda_chain(i), C => right1_slv(i));
			right1 <= not right1_slv(i);
			left0 <= not right1_slv(i);
			left0_slv <= right1_slv;
		end generate right1_last1;
	end generate right1_generate;

-- generate N latch chain
sda_chain_generate : for i in 0 to N-1 generate
	sda_chain_first : if (i=0) generate
		sda_chain_f : LDCPE generic map (INIT => '0') port map (Q => sda_chain(i), D => clock, CLR => i_reset, G => i_clock, GE => not i_clock, PRE => i_reset);
	end generate sda_chain_first;
	sda_chain_middle : if (i>0 and i<N-1) generate
		sda_chain_m : LDCPE generic map (INIT => '0') port map (Q => sda_chain(i), D => sda_chain(i-1), CLR => i_reset, G => i_clock, GE => not i_clock, PRE => i_reset);
	end generate sda_chain_middle;
	sda_chain_last : if (i=N-1) generate
		sda_chain_l : LDCPE generic map (INIT => '0') port map (Q => sda_chain(i), D => sda_chain(i-1), CLR => i_reset, G => i_clock, GE => not i_clock, PRE => i_reset);
	end generate sda_chain_last;
end generate sda_chain_generate;

sda_start_condition <= sda_condition_chain_start(N/2-1);
sda_start_condition_generate : for i in 0 to N-1 generate
	sda_start_condition_first : if (i=N-1) generate
		sda_start_condition_f : GATE_NAND generic map (delay_nand => delay_nand) port map (A =>  not sda_condition_chain_start(i-1), B => sda_chain(i), C => sda_condition_chain_start(i));
	end generate sda_start_condition_first;
	sda_start_condition_middle : if (i>0 and i<N-1) generate
		sda_start_condition_m : GATE_NAND generic map (delay_nand => delay_nand) port map (A =>  not sda_condition_chain_start(i-1), B => sda_chain(i), C => sda_condition_chain_start(i));
	end generate sda_start_condition_middle;
	sda_start_condition_last : if (i=0) generate
		sda_start_condition_l : GATE_NAND generic map (delay_nand => delay_nand) port map (A => '1', B => sda_chain(i), C => sda_condition_chain_start(i));
	end generate sda_start_condition_last;
end generate sda_start_condition_generate;

sda_stop_condition <= sda_condition_chain_stop(N/2-1);
sda_stop_condition_generate : for i in N-1 downto 0 generate
	sda_stop_condition_first : if (i=N-1) generate
		sda_stop_condition_f : GATE_NAND generic map (delay_nand => delay_nand) port map (A =>  sda_condition_chain_stop(i-1), B => not sda_chain(i), C => sda_condition_chain_stop(i));
	end generate sda_stop_condition_first;
	sda_stop_condition_middle : if (i>0 and i<N-1) generate
		sda_stop_condition_m : GATE_AND generic map (delay_and => delay_and) port map (A =>  sda_condition_chain_stop(i-1), B => sda_chain(i), C => sda_condition_chain_stop(i));
	end generate sda_stop_condition_middle;
	sda_stop_condition_last : if (i=0) generate
		sda_stop_condition_l : GATE_NAND generic map (delay_nand => delay_nand) port map (A =>  '0', B => not sda_chain(i), C => sda_condition_chain_stop(i));
	end generate sda_stop_condition_last;
end generate sda_stop_condition_generate;

sda_start_condition_out <= sda_start_condition when clock = '1' else '0';
--sdasc_inst1 : LDCPE generic map (INIT => '1') port map (Q => sda_start_condition_out, D => '1', CLR => not sda_start_condition and i_enable, G => i_clock, GE => not i_clock, PRE =>  sda_start_condition and i_enable);

sda_stop_condition_out <= sda_stop_condition when clock = '1' else '0';
--sdasc_inst2 : LDCPE generic map (INIT => '1') port map (Q => sda_stop_condition_out, D =>  '1', CLR => not sda_stop_condition and i_enable, G => i_clock, GE => not i_clock, PRE => sda_stop_condition and i_enable);

t1 <= sda_chain(N-1) and i_enable;
MUXCY_inst : MUXCY port map (O => clock, CI => '0', DI => '1', S => t1);

-- in3 - ACK
m81_main_inst : MUX_81 generic map (delay_and => delay_and, delay_or => delay_or, delay_not => delay_not) port map (S0 => encoder_main(0), S1 => encoder_main(1), S2 => encoder_main(2), in0 => sda_start_condition_out, in1 => addressmux, in2 => i_slave_rw, in3 => '1', in4 => datamux, in5 => sda_stop_condition_out, in6 => '0', in7 => '1', o => o_sda);

o_scl <= clock;

pencoder_main : process (qmux,amux) is
	constant concat : std_logic_vector(QMUX_SIZE-1 downto 0) := (others => '-');
	variable qa : std_logic_vector(2*QMUX_SIZE-1 downto 0);
begin
	qa := qmux&amux;
	if    (std_match(qa,concat&"0000000000")) then encoder_main <= "000";
	elsif (std_match(qa,concat&"0000000001")) then encoder_main <= "001";
	elsif (std_match(qa,concat&"0000000011")) then encoder_main <= "001";
	elsif (std_match(qa,concat&"0000000111")) then encoder_main <= "001";
	elsif (std_match(qa,concat&"0000001111")) then encoder_main <= "001";
	elsif (std_match(qa,concat&"0000011111")) then encoder_main <= "001";
	elsif (std_match(qa,concat&"0000111111")) then encoder_main <= "001";
	elsif (std_match(qa,concat&"0001111111")) then encoder_main <= "001";
	elsif (std_match(qa,concat&"0011111111")) then encoder_main <= "010";
	elsif (std_match(qa,concat&"0111111111")) then encoder_main <= "011";
	elsif (std_match(qa,concat&"1111111111")) then encoder_main <= "100";
	else
	encoder_main <= "XXX";
	end if;
end process pencoder_main;

t2 <= i_enable and not all1;
mux_chain_generate : for i in 0 to QMUX_SIZE-1 generate
	a : if (i=0) generate
		chaina : LDCPE generic map (INIT => '0') port map (Q => qmux(i), D => '1', CLR => qmux(QMUX_SIZE-1), G => all1, GE => t2, PRE => '0');
	end generate a;
	b : if (i>0 and i<QMUX_SIZE-1) generate
		chainb : LDCPE generic map (INIT => '0') port map (Q => qmux(i), D => qmux(i-1), CLR => qmux(QMUX_SIZE-1), G => all1, GE => t2, PRE => '0');
	end generate b;
	c : if (i=QMUX_SIZE-1) generate
		chainc : LDCPE generic map (INIT => '0') port map (Q => qmux(i), D => qmux(i-1), CLR => qmux(QMUX_SIZE-1), G => all1, GE => t2, PRE => '0');
	end generate c;
end generate mux_chain_generate;

address_chain_generate : for i in 0 to N/2-1 generate
	address_chain_first : if (i=0) generate
		address_chain_f : LDCPE generic map (INIT => '0') port map (Q => amux(i), D => '1', CLR => '0', G => left1, GE => not left1, PRE => '0');
	end generate address_chain_first;
	address_chain_middle : if (i>0 and i<N/2-1) generate
		address_chain_m : LDCPE generic map (INIT => '0') port map (Q => amux(i), D => amux(i-1), CLR => '0', G => left1, GE => not left1, PRE => '0');
	end generate address_chain_middle;
	address_chain_last : if (i=N/2-1) generate
		address_chain_l : LDCPE generic map (INIT => '0') port map (Q => amux(i), D => amux(i-1), CLR => '0', G => left1, GE => not left1, PRE => '0');
	end generate address_chain_last;
end generate address_chain_generate;

pencoder_address : process (amux) is
begin
	if    (amux = "0000000000") then encoder_address <= "0000";
	elsif (amux = "0000000001") then encoder_address <= "0001";
	elsif (amux = "0000000011") then encoder_address <= "0010";
	elsif (amux = "0000000111") then encoder_address <= "0011";
	elsif (amux = "0000001111") then encoder_address <= "0100";
	elsif (amux = "0000011111") then encoder_address <= "0101";
	elsif (amux = "0000111111") then encoder_address <= "0110";
	elsif (amux = "0001111111") then encoder_address <= "0111";
	elsif (amux = "0011111111") then encoder_address <= "1000";
	elsif (amux = "0111111111") then encoder_address <= "1001";
	elsif (amux = "1111111111") then encoder_address <= "1010";
	else
	encoder_address <= "XXXX";
	end if;
end process pencoder_address;

mux81_address_inst : MUX_81 generic map (delay_and => delay_and, delay_or => delay_or, delay_not => delay_not) port map (in0 => '1', in1 => acopy(0), in2 => acopy(1), in3 => acopy(2), in4 => acopy(3), in5 => acopy(4), in6 => acopy(5), in7 => acopy(6), s0 => encoder_address(0), s1 => encoder_address(1), s2 => encoder_address(2), o => addressmux);

address_chain_copy_generate : for i in 0 to ADDRESS_SIZE-1 generate
	address_chain_copy_first : if (i=0) generate
		address_chain_copy_f : LDCPE generic map (INIT => '0') port map (Q => acopy(i), D => '0', CLR => not i_slave_address(i), G => left1, GE => left1, PRE => i_slave_address(i));
	end generate address_chain_copy_first;
	address_chain_copy_middle : if (i>0 and i<ADDRESS_SIZE-1) generate
		address_chain_copy_m : LDCPE generic map (INIT => '0') port map (Q => acopy(i), D => acopy(i-1), CLR => not i_slave_address(i), G => left1, GE => left1, PRE => i_slave_address(i));
	end generate address_chain_copy_middle;
	address_chain_copy_last : if (i=ADDRESS_SIZE-1) generate
		address_chain_copy_l : LDCPE generic map (INIT => '0') port map (Q => acopy(i), D => acopy(i-1), CLR => not i_slave_address(i), G => left1, GE => left1, PRE => i_slave_address(i));
	end generate address_chain_copy_last;
end generate address_chain_copy_generate;

o_busy <= dmux(0);
data_chain_generate : for i in 0 to BYTE_SIZE generate
	data_chain_first : if (i=0) generate
		data_chain_f : LDCPE generic map (INIT => '0') port map (Q => dmux(i), D => '1', CLR => dmux(BYTE_SIZE), G => amux(N/2-1) and left1, GE => left1, PRE => '0');
	end generate data_chain_first;
	data_chain_middle : if (i>0 and i<BYTE_SIZE) generate
		data_chain_m : LDCPE generic map (INIT => '0') port map (Q => dmux(i), D => dmux(i-1), CLR => dmux(BYTE_SIZE), G => amux(N/2-1) and not left1, GE => left1, PRE => '0');
	end generate data_chain_middle;
	data_chain_last : if (i=BYTE_SIZE) generate
		data_chain_l : LDCPE generic map (INIT => '0') port map (Q => dmux(i), D => dmux(i-1), CLR => dmux(BYTE_SIZE), G => amux(N/2-1) and not left1, GE => left1, PRE => '0');
	end generate data_chain_last;
end generate data_chain_generate;

pencoder_data : process (dmux) is
begin
	if    (dmux = "000000000") then encoder_data <= "0000";
	elsif (dmux = "000000001") then encoder_data <= "0001";
	elsif (dmux = "000000011") then encoder_data <= "0010";
	elsif (dmux = "000000111") then encoder_data <= "0011";
	elsif (dmux = "000001111") then encoder_data <= "0100";
	elsif (dmux = "000011111") then encoder_data <= "0101";
	elsif (dmux = "000111111") then encoder_data <= "0110";
	elsif (dmux = "001111111") then encoder_data <= "0111";
	elsif (dmux = "011111111") then encoder_data <= "1000";
	elsif (dmux = "111111111") then encoder_data <= "1001";
	else
	encoder_data <= "XXXX";
	end if;
end process pencoder_data;

mux81_data_inst : MUX_81 generic map (delay_and => delay_and, delay_or => delay_or, delay_not => delay_not) port map (in0 => dcopy(0), in1 => dcopy(1), in2 => dcopy(2), in3 => dcopy(3), in4 => dcopy(4), in5 => dcopy(5), in6 => dcopy(6), in7 => dcopy(7), s0 => encoder_data(0), s1 => encoder_data(1), s2 => encoder_data(2), o => datamux);

data_chain_copy_generate : for i in 0 to BYTE_SIZE-1 generate
	data_chain_copy_first : if (i=0) generate
		data_chain_copy_f : LDCPE generic map (INIT => '0') port map (Q => dcopy(i), D => '0', CLR => not i_bytes_to_send(i), G => left1, GE => left1, PRE => i_bytes_to_send(i));
	end generate data_chain_copy_first;
	data_chain_copy_middle : if (i>0 and i<BYTE_SIZE-1) generate
		data_chain_copy_m : LDCPE generic map (INIT => '0') port map (Q => dcopy(i), D => dcopy(i-1), CLR => not i_bytes_to_send(i), G => left1, GE => left1, PRE => i_bytes_to_send(i));
	end generate data_chain_copy_middle;
	data_chain_copy_last : if (i=BYTE_SIZE-1) generate
		data_chain_copy_l : LDCPE generic map (INIT => '0') port map (Q => dcopy(i), D => dcopy(i-1), CLR => not i_bytes_to_send(i), G => left1, GE => left1, PRE => i_bytes_to_send(i));
	end generate data_chain_copy_last;
end generate data_chain_copy_generate;

end architecture Behavioral;
