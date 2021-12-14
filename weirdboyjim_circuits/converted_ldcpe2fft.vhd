----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:46:40 12/05/2021 
-- Design Name: 
-- Module Name:    converted_ldcpe2fft - Behavioral 
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

entity converted_ldcpe2fft is
port (
	signal i_t : in std_logic;
	signal i_sd,i_rd : in std_logic;
	signal o_q1,o_q2 : out std_logic
);
end converted_ldcpe2fft;

architecture Behavioral of converted_ldcpe2fft is

--	component FF_D_POSITIVE_EDGE is
--	port (
--	S : in std_logic;
--	R : in std_logic;
--	C : in std_logic;
--	D : in STD_LOGIC;
--	Q1,Q2:out STD_LOGIC);
--	end component FF_D_POSITIVE_EDGE;
--	for all : FF_D_POSITIVE_EDGE use entity WORK.FF_D_POSITIVE_EDGE(D_PE_LUT_2);

--	component delayed_programmable_circuit is
--	port (
--	i_reg1 : in std_logic;
--	i_reg2 : in std_logic;
--	i_reg3 : in std_logic;
--	i_reg4 : in std_logic;
--	i_reg5 : in std_logic;
--	i_reg6 : in std_logic;
--	i_reg7 : in std_logic;
--	i_input : in std_logic;
--	o_output : out std_logic
--	);
--	end component delayed_programmable_circuit;
--	for all : delayed_programmable_circuit use entity WORK.delayed_programmable_circuit(Behavioral);

	component GATE_NOT is
	generic (
		delay_not : TIME := 0 ps
	);
	port (
		A : in STD_LOGIC;
		B : out STD_LOGIC
	);
	end component GATE_NOT;
	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);

	signal d,i_sd_not,dpc_xorout,dpc_q1,q1_not : std_logic := '0';
	signal xorout : std_logic := '0';
	signal q1 : std_logic := '1';
	signal q2 : std_logic := '0';

	signal chain_not : std_logic_vector(255 downto 0);
	signal first_not,last_not : std_logic;
	attribute KEEP : string;
	attribute KEEP of chain_not : signal is "true";

begin

	i_sd_not <= not i_sd;
	q2 <= not q1;

	o_q1 <= q1;
	o_q2 <= q2;

--	dpc_inst : delayed_programmable_circuit
--	port map (
--		i_reg1 => '1',
--		i_reg2 => '1',
--		i_reg3 => '1',
--		i_reg4 => '1',
--		i_reg5 => '1',
--		i_reg6 => '1',
--		i_reg7 => '1',
--		i_input => xorout,
--		o_output => dpc_xorout
--	);

--	XORCY_inst : xorout <= i_t xor q1 after 99 ps; -- XXX half cycle 199 ps
	XORCY_inst : XORCY
	port map (
		O => xorout, -- XOR output signal
		CI => i_t, -- Carry input signal
		LI => dpc_q1 -- LUT4 input signal
	);

--	xorgate_delay : dpc_xorout <= xorout after 10 ns; -- XXX must be clock_period/2
--	xorgate_delay : dpc_xorout <= xorout after 1 ns;
--	q1_delay : dpc_q1 <= q1 after 1 ns;

	q1_first_not : GATE_NOT generic map (0 ns) port map (A => q1, B => q1_not);
	q1_last_not : GATE_NOT generic map (0 ns) port map (A => q1_not, B => dpc_q1);

	g0_first_not : GATE_NOT generic map (0 ps) port map (A => xorout, B => chain_not(0));
	g0_last_not : GATE_NOT generic map (0 ps) port map (A => chain_not(255), B => dpc_xorout);

	g0 : for i in 0 to 255 generate
		g0_chain : if (i>0) generate
			g0_chain_not : GATE_NOT generic map (0 ns) port map (A => chain_not(i-1), B => chain_not(i));
		end generate g0_chain;
	end generate g0;

--	ffd : FF_D_POSITIVE_EDGE
--	port map (
--	S => i_sd,
--	R => i_rd,
--	C => '1',
--	D => dpc_xorout,
--	Q1 => q1,
--	Q2 => q2
--	);

--	FDCPE_inst : FDCPE
--	generic map (INIT => '0')
--	port map (
--		Q => q1,
--		C => dpc_xorout,
--		CE => '1',
--		CLR => i_rd,
--		D => dpc_xorout,
--		PRE => i_sd_not
--	);

	LDCPE_inst : LDCPE
	generic map (INIT => '0') --Initial value of latch ('0' or '1')
	port map (
		Q => q1, -- Data output
		CLR => i_rd, -- Asynchronous clear/reset input
		D => dpc_xorout, -- Data input
		G => '1', -- Gate input
		GE => '1', -- Gate enable input
		PRE => i_sd_not -- Asynchronous preset/set input
	);

end Behavioral;

