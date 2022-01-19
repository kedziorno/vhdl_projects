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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity my_i2c_pc is
port(
i_clock : in std_logic;
i_reset : in std_logic;
i_slave_address : in std_logic_vector(0 to G_SLAVE_ADDRESS_SIZE-1);
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
	constant delay_nand2 : time := 0 ns;
	constant delay_nand3 : time := 0 ns;
	constant delay_and3 : time := 0 ns;

	component GATE_NOT is
	generic (delay_not : TIME := 0 ns);
	port (A : in STD_LOGIC; B : out STD_LOGIC);
	end component GATE_NOT;
	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);

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

	component MUX_41 is
	generic (delay_and : TIME := 0 ns; delay_or : TIME := 0 ns; delay_not : TIME := 0 ns);
	port (S1,S2,A,B,C,D:in STD_LOGIC; E:out STD_LOGIC);
	end component MUX_41;
	for all : MUX_41 use entity WORK.MUX_41(Behavioral);

	constant N : integer := 10;
	signal a,b,c,d,e : std_logic;
	signal sda_chain : std_logic_vector(N-1 downto 0);
	signal sda_condition_chain_start : std_logic_vector(N/2-1 downto 0);
	signal sda_condition_chain_stop : std_logic_vector(N-1 downto N/2);
	signal sda_start_condition_out : std_logic;
	signal sda_start_condition : std_logic;
	signal sda_stop_condition_out : std_logic;
	signal sda_stop_condition : std_logic;
	signal qmux : std_logic_vector(3 downto 0);
	signal qnmux : std_logic_vector(3 downto 0);
	signal encoder42 : std_logic_vector(1 downto 0);
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

-- clock previous,current
qnot1 : GATE_NOT generic map (delay_not => delay_not) port map (A => a, B => b);
LDCPE1_inst : LDCPE
generic map (INIT => '0') port map (Q => a, CLR => i_reset, D => b, G => '1', GE => '1', PRE => i_reset);
qnot2 : GATE_NOT generic map (delay_not => delay_not) port map (A => b, B => c);
LDCPE2_inst : LDCPE
generic map (INIT => '0') port map (Q => d, CLR => i_reset, D => c, G => '1', GE => '1', PRE => i_reset);

-- generate N latch chain
sda_chain_generate : for i in 0 to N-1 generate
	sda_chain_first : if (i=0) generate
		sda_chain_f : LDCPE generic map (INIT => '0') port map (Q => sda_chain(i), D => e, CLR => i_reset, G => '1', GE => '1', PRE => i_reset);
	end generate sda_chain_first;
	sda_chain_middle : if (i>0 and i<N-1) generate
		sda_chain_m : LDCPE generic map (INIT => '0') port map (Q => sda_chain(i), D => sda_chain(i-1), CLR => i_reset, G => '1', GE => '1', PRE => i_reset);
	end generate sda_chain_middle;
	sda_chain_last : if (i=N-1) generate
		sda_chain_l : LDCPE generic map (INIT => '0') port map (Q => sda_chain(N-1), D => sda_chain(i-1), CLR => i_reset, G => '1', GE => '1', PRE => i_reset);
	end generate sda_chain_last;
end generate sda_chain_generate;

-- generate start condition after N/2 cycles
sda_start_condition_generate : for i in 0 to N/2-1 generate
	sda_start_condition_first : if (i=0) generate
		sda_start_condition_f : GATE_AND generic map (delay_and => delay_and) port map (A => sda_chain(i), B => not sda_chain(i), C => sda_condition_chain_start(i));
	end generate sda_start_condition_first;
	sda_start_condition_middle : if (i>0 and i<N/2-1) generate
		sda_start_condition_m : GATE_NAND generic map (delay_nand => delay_nand) port map (A => sda_condition_chain_start(i-1), B => sda_chain(i), C => sda_condition_chain_start(i));
	end generate sda_start_condition_middle;
	sda_start_condition_last : if (i=N/2-1) generate
		sda_start_condition_l : GATE_NAND generic map (delay_nand => delay_nand) port map (A => sda_condition_chain_start(i-1), B => not sda_chain(i), C => sda_condition_chain_start(i));
		sda_start_condition <= sda_condition_chain_start(i);
	end generate sda_start_condition_last;
end generate sda_start_condition_generate;

-- generate stop condition after N/2 cycles
sda_stop_condition_generate : for i in N/2 to N-1 generate
	sda_stop_condition_first : if (i=N/2) generate
		sda_stop_condition_f : GATE_AND generic map (delay_and => delay_and) port map (A =>  sda_chain(i), B => not sda_chain(i), C => sda_condition_chain_stop(i));
	end generate sda_stop_condition_first;
	sda_stop_condition_middle : if (i>N/2 and i<N-1) generate
		sda_stop_condition_m : GATE_NAND generic map (delay_nand => delay_nand) port map (A =>  sda_condition_chain_stop(i-1), B => sda_chain(i), C => sda_condition_chain_stop(i));
	end generate sda_stop_condition_middle;
	sda_stop_condition_last : if (i=N-1) generate
		sda_stop_condition_l : GATE_NAND generic map (delay_nand => delay_nand) port map (A =>  sda_condition_chain_stop(i-1), B => not sda_chain(i), C => sda_condition_chain_stop(i));
		sda_stop_condition <= sda_condition_chain_stop(i);
	end generate sda_stop_condition_last;
end generate sda_stop_condition_generate;

sdasc_inst1 : LDCPE generic map (INIT => '1') port map (Q => sda_start_condition_out, D => e, CLR => sda_start_condition and i_enable, G => '1', GE => '1', PRE => (not sda_start_condition) and i_enable);

sdasc_inst2 : LDCPE generic map (INIT => '1') port map (Q => sda_stop_condition_out, D => e, CLR => sda_stop_condition and i_enable, G => '1', GE => '1', PRE => (not sda_stop_condition) and i_enable);

MUXCY_inst : MUXCY port map (O => e, CI => '0', DI => '1', S => sda_chain(N-1) and i_enable);

m41_inst : MUX_41 generic map (delay_and => delay_and, delay_or => delay_or, delay_not => delay_not) port map (S1 => encoder42(0), S2 => encoder42(1), A => sda_stop_condition_out, B => '0', C => '0', D => sda_start_condition_out, E => o_sda);

o_scl <= e;

pencoder42 : process (qmux) is
begin
	case (qmux) is
		when "0000" => encoder42 <= "00";
		when "0001" => encoder42 <= "01";
		when "0011" => encoder42 <= "10";
		when "0111" => encoder42 <= "11";
		when others => encoder42 <= "XX";
	end case;
end process pencoder42;

mux_chain_generate : for i in 0 to 3 generate
	a : if (i=0) generate
		chaina : LDCPE generic map (INIT => '0') port map (Q => qmux(i), D => '1', CLR => qmux(3), G => all1, GE => i_enable and not all1, PRE => '0');
	end generate a;
	b : if (i>0 and i<3) generate
		chainb : LDCPE generic map (INIT => '0') port map (Q => qmux(i), D => qmux(i-1), CLR => qmux(3), G => all1, GE => i_enable and not all1, PRE => '0');
	end generate b;
	c : if (i=3) generate
		chainc : LDCPE generic map (INIT => '0') port map (Q => qmux(i), D => qmux(i-1), CLR => qmux(3), G => all1, GE => i_enable and not all1, PRE => '0');
	end generate c;
end generate mux_chain_generate;

end architecture Behavioral;
