----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:52:38 12/08/2021 
-- Design Name: 
-- Module Name:    ic_74hct164 - Behavioral 
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

entity ic_74hct164 is
port (
	signal i_dsa : in std_logic;
	signal i_dsb : in std_logic;
	signal i_cp : in std_logic;
	signal i_mr : in std_logic;
	signal o_q0,o_q1,o_q2,o_q3,o_q4,o_q5,o_q6,o_q7 : out std_logic
);
end ic_74hct164;

architecture Behavioral of ic_74hct164 is

	component GATE_AND is
	generic (
		delay_and : TIME := 0 ps
	);
	port (
		A,B : in STD_LOGIC;
		C : out STD_LOGIC
	);
	end component GATE_AND;
	for all : GATE_AND use entity WORK.GATE_AND(GATE_AND_LUT);

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

	signal q : std_logic_vector(7 downto 0);
	signal i_mr_not,dsadsb : std_logic;

begin

	o_q0 <= q(0);
	o_q1 <= q(1);
	o_q2 <= q(2);
	o_q3 <= q(3);
	o_q4 <= q(4);
	o_q5 <= q(5);
	o_q6 <= q(6);
	o_q7 <= q(7);

	i_mr_not_inst : GATE_NOT port map (A => i_mr, B => i_mr_not);
	gate_and_dsadsb_inst : GATE_AND port map (A => i_dsa, B => i_dsb, C => dsadsb);

	g0 : for i in 0 to 7 generate
		g0_first : if (i = 0) generate
			FDCE_inst : FDCE
			generic map (INIT => '1')
			port map (
				Q => q(0),
				C => i_cp,
				CE => '1',
				CLR => i_mr_not,
				D => dsadsb
			);
		end generate g0_first;
		g0_chain : if (i > 0) generate
			FDCE_inst : FDCE
			generic map (INIT => '0')
			port map (
				Q => q(i),
				C => i_cp,
				CE => '1',
				CLR => i_mr_not,
				D => q(i-1)
			);
		end generate g0_chain;
	end generate g0;

end Behavioral;
