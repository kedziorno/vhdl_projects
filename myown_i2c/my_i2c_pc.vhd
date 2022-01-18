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
	constant delay_nand : time := 0 ns;
	constant delay_and3 : time := 0 ns;
	constant delay_not : time := 0 ns;
	constant delay_nand2 : time := 0 ns;
	constant delay_nand3 : time := 0 ns;

--	component FF_E_LATCH is
--	generic (delay_and : time := 0 ns; delay_and3 : time := 0 ns; delay_not : time := 0 ns; delay_nand2 : time := 0 ns; delay_nand3 : time := 0 ns);
--	port (D,E_H,E_L:in STD_LOGIC; Q:out STD_LOGIC);
--	end component FF_E_LATCH;
----	for all : FF_E_LATCH use entity WORK.FF_E_LATCH(Behavioral_E_LATCH);
----	for all : FF_E_LATCH use entity WORK.FF_E_LATCH(LUT_E_LATCH);
--	for all : FF_E_LATCH use entity WORK.FF_E_LATCH(LUT_E_LATCH_NAND);

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

	constant N : integer := 10;
	signal a,b,c,d : std_logic;
	signal sda_start : std_logic_vector(N-1 downto 0);
	signal sda_start_condition,sdasc_out : std_logic;
	signal sdasc_chain : std_logic_vector(N/2-1 downto 0);
	signal e : std_logic;

begin

-- clock previous,current
qnot1 : GATE_NOT generic map (delay_not => delay_not) port map (A => a, B => b);
LDCPE1_inst : LDCPE
generic map (INIT => '0') port map (Q => a, CLR => i_reset, D => b, G => '1', GE => '1', PRE => i_reset);
qnot2 : GATE_NOT generic map (delay_not => delay_not) port map (A => b, B => c);
LDCPE2_inst : LDCPE
generic map (INIT => '0') port map (Q => d, CLR => i_reset, D => c, G => '1', GE => '1', PRE => i_reset);

-- generate N latch chain
sda_start_generate : for i in 0 to N-1 generate
	sda_start_first : if (i=0) generate
		sda_start_inst : LDCPE generic map (INIT => '0') port map (Q => sda_start(0), D => e, CLR => i_reset, G => '1', GE => '1', PRE => i_reset);
	end generate sda_start_first;
	sda_start_chain : if (i>0 and i<N-1) generate
		sda_start_inst : LDCPE generic map (INIT => '0') port map (Q => sda_start(i), D => sda_start(i-1), CLR => i_reset, G => '1', GE => '1', PRE => i_reset);
	end generate sda_start_chain;
	sda_start_last : if (i=N-1) generate
		sda_start_inst : LDCPE generic map (INIT => '0') port map (Q => sda_start(N-1), D => sda_start(i-1), CLR => i_reset, G => '1', GE => '1', PRE => i_reset);
	end generate sda_start_last;
end generate sda_start_generate;

-- generate start condition after N/2 cycles
sdasc_generate : for i in 0 to N/2 generate
	asd1 : if (i=0) generate
		aaa : GATE_AND generic map (delay_and => delay_and) port map (A => sda_start(i), B => not sda_start(i+1), C => sdasc_chain(0));	
	end generate asd1;
	asd2 : if (i>0 and i<N/2) generate
		aaa : GATE_NAND generic map (delay_nand => delay_nand) port map (A => sdasc_chain(i-1), B => sda_start(i+1), C => sdasc_chain(i));
	end generate asd2;
	asd3 : if (i=N/2) generate
		aaa : GATE_NAND generic map (delay_nand => delay_nand) port map (A => sdasc_chain(i-1), B => not sda_start(i+1), C => sdasc_out);
	end generate asd3;
end generate sdasc_generate;

sdasc_inst : LDCPE generic map (INIT => '0') port map (Q => sda_start_condition, D => '0', CLR => sdasc_out, G => '1', GE => '1', PRE => not sdasc_out);

MUXCY_inst : MUXCY port map (O => e, CI => '0', DI => '1', S => sda_start(N-1));

o_sda <= sda_start_condition;
o_scl <= e;

end architecture Behavioral;
