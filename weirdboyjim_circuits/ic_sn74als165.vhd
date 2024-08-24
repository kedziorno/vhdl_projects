----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:03:08 12/09/2021 
-- Design Name: 
-- Module Name:    ic_sn74als165 - Behavioral 
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

entity ic_sn74als165 is
port (
	signal i_sh_ld : in std_logic;
	signal i_clk,i_clk_inh : in std_logic;
	signal i_ser : in std_logic;
	signal i_d0,i_d1,i_d2,i_d3,i_d4,i_d5,i_d6,i_d7 : in std_logic;
	signal o_q7,o_q7_not : out std_logic
);
end ic_sn74als165;

architecture Behavioral of ic_sn74als165 is

	component GATE_NAND2 is
	generic (
		delay_nand2 : TIME := 0 ns
	);
	port (
		A,B : in STD_LOGIC;
		C : out STD_LOGIC
	);
	end component GATE_NAND2;
	for all : GATE_NAND2 use entity WORK.GATE_NAND2(GATE_NAND2_LUT);

	component GATE_NOT is
	generic (
		delay_not : TIME := 0 ns
	);
	port (
		A : in STD_LOGIC;
		B : out STD_LOGIC
	);
	end component GATE_NOT;
	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);

	component GATE_OR is
	generic (
		delay_or : TIME := 0 ns
	);
	port (
		A,B : in STD_LOGIC;
		C : out STD_LOGIC
	);
	end component GATE_OR;
	for all : GATE_OR use entity WORK.GATE_OR(GATE_OR_LUT);

	signal q,i_d,gate_nand2_u,gate_nand2_d,gate_nand2_u_not,gate_nand2_d_not : std_logic_vector(7 downto 0);
	signal i_sh_ld_not,i_clk_inh_not : std_logic;
	signal clock_pulse : std_logic;

begin

	o_q7 <= q(7);
	o_q7_not <= not q(7);

	i_d(0) <= i_d0;
	i_d(1) <= i_d1;
	i_d(2) <= i_d2;
	i_d(3) <= i_d3;
	i_d(4) <= i_d4;
	i_d(5) <= i_d5;
	i_d(6) <= i_d6;
	i_d(7) <= i_d7;

	i_sh_ld_not_inst : GATE_NOT port map (A => i_sh_ld, B => i_sh_ld_not);

	i_clk_inst : GATE_OR port map (A => i_clk, B => i_clk_inh, C => clock_pulse);

	generate_nand2_up : for i in 0 to 7 generate
		nand2_up : GATE_NAND2 port map (A => i_sh_ld_not, B => i_d(i), C => gate_nand2_u(i));
	end generate generate_nand2_up;

	generate_nand2_down : for i in 0 to 7 generate
		nand2_down : GATE_NAND2 port map (A => i_sh_ld_not, B => gate_nand2_u(i), C => gate_nand2_d(i));
	end generate generate_nand2_down;

	fdcpe_generate : for i in 0 to 7 generate
		fdcpe_first : if (i = 0) generate
			FDCPE_inst : FDCPE
			generic map (INIT => '0')
			port map (
				Q => q(0),
				C => clock_pulse,
				CE => '1',
				CLR => gate_nand2_d_not(0),
				D => i_ser,
				PRE => gate_nand2_u_not(0)
			);
		end generate fdcpe_first;
		fdcpe_chain : if (i > 0) generate
			FDCPE_inst : FDCPE
			generic map (INIT => '0')
			port map (
				Q => q(i),
				C => clock_pulse,
				CE => '1',
				CLR => gate_nand2_d_not(i),
				D => q(i-1),
				PRE => gate_nand2_u_not(i)
			);
		end generate fdcpe_chain;
	end generate fdcpe_generate;

	gate_nand2_d_not_generate : for i in 0 to 7 generate
		gate_nand2_d_not_inst : GATE_NOT port map (A => gate_nand2_d(i), B => gate_nand2_d_not(i));
	end generate gate_nand2_d_not_generate;

	gate_nand2_u_not_generate : for i in 0 to 7 generate
		gate_nand2_u_not_inst : GATE_NOT port map (A => gate_nand2_u(i), B => gate_nand2_u_not(i));
	end generate gate_nand2_u_not_generate;

end Behavioral;

