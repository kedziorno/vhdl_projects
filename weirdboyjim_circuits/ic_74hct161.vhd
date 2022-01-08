----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:56:14 01/08/2022 
-- Design Name: 
-- Module Name:    ic_74hct161 - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity ic_74hct161 is
port (
	signal i_d0,i_d1,i_d2,i_d3 : in std_logic;
	signal i_cet : in std_logic;
	signal i_cep : in std_logic;
	signal i_pe_b : in std_logic;
	signal i_cp : in std_logic;
	signal i_mr_b : in std_logic;
	signal o_q0,o_q1,o_q2,o_q3 : out std_logic;
	signal o_tc : out std_logic
);
end ic_74hct161;

architecture Behavioral of ic_74hct161 is

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

	component GATE_NOR2 is
	generic (
		delay_nor2 : TIME := 0 ns
	);
	port (
		A,B : in STD_LOGIC;
		C : out STD_LOGIC
	);
	end component GATE_NOR2;
	for all : GATE_NOR2 use entity WORK.GATE_NOR2(GATE_NOR2_LUT);

	component GATE_NOR3 is
	generic (
		delay_nor3 : TIME := 0 ns
	);
	port (
		A,B,C : in STD_LOGIC;
		D : out STD_LOGIC
	);
	end component GATE_NOR3;
	for all : GATE_NOR3 use entity WORK.GATE_NOR3(GATE_NOR3_LUT);

	component GATE_NOR4 is
	generic (
		delay_nor4 : TIME := 0 ns
	);
	port (
		A,B,C,D : in STD_LOGIC;
		E : out STD_LOGIC
	);
	end component GATE_NOR4;
	for all : GATE_NOR4 use entity WORK.GATE_NOR4(GATE_NOR4_LUT);

	component GATE_AND2 is
	generic (
		delay_and : TIME := 0 ns
	);
	port (
		A,B : in STD_LOGIC;
		C : out STD_LOGIC
	);
	end component GATE_AND2;
	for all : GATE_AND2 use entity WORK.GATE_AND(GATE_AND_LUT);

	component GATE_XNOR2 is
	port (
		A,B:in STD_LOGIC;
		C:out STD_LOGIC
	);
	end component GATE_XNOR2;
	for all : GATE_XNOR2 use entity WORK.GATE_XNOR(GATE_XNOR_LUT);

	component GATE_OR2 is
	generic (
		delay_or : TIME := 0 ns
	);
	port (
		A,B : in STD_LOGIC;
		C : out STD_LOGIC
	);
	end component GATE_OR2;
	for all : GATE_OR2 use entity WORK.GATE_OR(GATE_OR_LUT);

	component GATE_NAND5 is
	port (
		signal a,b,c,d,e : in std_logic;
		signal f : out std_logic
	);
	end component GATE_NAND5;
	for all : GATE_NAND5 use entity WORK.my_nand5(Behavioral);

	component FF_D_POSITIVE_EDGE is
	port (
		S : in std_logic;
		R : in std_logic;
		C : in std_logic;
		D : in STD_LOGIC;
		Q1,Q2:out STD_LOGIC
	);
	end component FF_D_POSITIVE_EDGE;
	for all : FF_D_POSITIVE_EDGE use entity WORK.FF_D_POSITIVE_EDGE(D_PE_LUT_1);
--	for all : FF_D_POSITIVE_EDGE use entity WORK.FF_D_POSITIVE_EDGE(D_PE_LUT_2);
--	for all : FF_D_POSITIVE_EDGE use entity WORK.FF_D_POSITIVE_EDGE(D_PE_LUT_3);

	signal i_pe_b_not,i_pe_b_not_not,i_cp_not,i_mr_b_not,i_cet_cep_nand2 : std_logic;
	signal ffd0_q1,ffd1_q1,ffd2_q1,ffd3_q1 : std_logic;
	signal ffd0_q2,ffd1_q2,ffd2_q2,ffd3_q2 : std_logic;
	signal ffd0_d,ffd1_d,ffd2_d,ffd3_d : std_logic;
	signal g10,g11,g12,g13 : std_logic;
	signal g20,g21,g22 : std_logic;
	signal g30,g31,g32,g33,g34,g35,g36,g37 : std_logic;
	signal g40,g41,g42 : std_logic;
	

begin

	inst_i_pe_b_not : GATE_NOT
	port map (A => i_pe_b, B => i_pe_b_not);
	inst_i_cp_not : GATE_NOT
	port map (A => i_cp, B => i_cp_not);
	inst_i_mr_b_not : GATE_NOT
	port map (A => i_mr_b, B => i_mr_b_not);

	inst_i_cet_cep_nand2 : GATE_NAND2
	port map (A => i_cet, B => i_cep, C => i_cet_cep_nand2);

	inst_g00 : GATE_NOT
	port map (A => i_cet_cep_nand2, B => g10);
	inst_g01 : GATE_NOR2
	port map (A => i_cet_cep_nand2, B => ffd0_q2, C => g11);
	inst_g02 : GATE_NOR3
	port map (A => i_cet_cep_nand2, B => ffd0_q2, C => ffd1_q2, D => g12);
	inst_g03 : GATE_NOR4
	port map (A => i_cet_cep_nand2, B => ffd0_q2, C => ffd1_q2, D => ffd2_q2, E => g13);

	inst_g40 : GATE_AND2
	port map (A => g13, B => ffd3_q2, C => g40);
	inst_g41 : GATE_NOR2
	port map (A => g13, B => ffd3_q2, C => g41);
	inst_g42 : GATE_OR2
	port map (A => g40, B => g41, C => g42);

	inst_g10 : GATE_XNOR2
	port map (A => g10, B => ffd0_q2, C => g20);
	inst_g11 : GATE_XNOR2
	port map (A => g11, B => ffd1_q2, C => g21);
	inst_g12 : GATE_XNOR2
	port map (A => g12, B => ffd2_q2, C => g22);

	inst_i_pe_b_not_not : GATE_NOT
	port map (A => i_pe_b_not, B => i_pe_b_not_not);

	inst_g20 : GATE_AND2
	port map (A => i_d0, B => i_pe_b_not, C => g30);
	inst_g21 : GATE_AND2
	port map (A => g20, B => i_pe_b_not_not, C => g31);
	inst_g30 : GATE_NOR2
	port map (A => g30, B => g31, C => ffd0_d);

	inst_g22 : GATE_AND2
	port map (A => i_d1, B => i_pe_b_not, C => g32);
	inst_g23 : GATE_AND2
	port map (A => g21, B => i_pe_b_not_not, C => g33);
	inst_g31 : GATE_NOR2
	port map (A => g32, B => g33, C => ffd1_d);

	inst_g24 : GATE_AND2
	port map (A => i_d2, B => i_pe_b_not, C => g34);
	inst_g25 : GATE_AND2
	port map (A => g22, B => i_pe_b_not_not, C => g35);
	inst_g32 : GATE_NOR2
	port map (A => g34, B => g35, C => ffd2_d);

	inst_g26 : GATE_AND2
	port map (A => i_d3, B => i_pe_b_not, C => g36);
	inst_g27 : GATE_AND2
	port map (A => g42, B => i_pe_b_not_not, C => g37);
	inst_g33 : GATE_NOR2
	port map (A => g36, B => g37, C => ffd3_d);

	ffd0 : FF_D_POSITIVE_EDGE
	port map (S => '0', R => i_mr_b_not, C => i_cp_not, D => not ffd0_d, Q1 => ffd0_q1, Q2 => ffd0_q2);
	ffd1 : FF_D_POSITIVE_EDGE
	port map (S => '0', R => i_mr_b_not, C => i_cp_not, D => not ffd1_d, Q1 => ffd1_q1, Q2 => ffd1_q2);
	ffd2 : FF_D_POSITIVE_EDGE
	port map (S => '0', R => i_mr_b_not, C => i_cp_not, D => not ffd2_d, Q1 => ffd2_q1, Q2 => ffd2_q2);
	ffd3 : FF_D_POSITIVE_EDGE
	port map (S => '0', R => i_mr_b_not, C => i_cp_not, D => not ffd3_d, Q1 => ffd3_q1, Q2 => ffd3_q2);

	inst_o_tc : GATE_NAND5
	port map (a => ffd0_q1, b => ffd1_q1, c => ffd2_q1, d => ffd3_q1, e => i_cet, f => o_tc);

	inst_o_q0 : GATE_NOT
	port map (A => ffd0_q2, B => o_q0);
	inst_o_q1 : GATE_NOT
	port map (A => ffd1_q2, B => o_q1);
	inst_o_q2 : GATE_NOT
	port map (A => ffd2_q2, B => o_q2);
	inst_o_q3 : GATE_NOT
	port map (A => ffd3_q2, B => o_q3);

end Behavioral;

