--	--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:03:46 02/02/2022 
-- Design Name: 
-- Module Name:    ic_74hc73 - Behavioral 
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

entity ic_74hc73 is
port (
	signal i_j : in std_logic;
	signal i_k : in std_logic;
	signal i_r : in std_logic;
	signal i_cpb : in std_logic;
	signal o_q : out std_logic;
	signal o_qb : out std_logic
);
end ic_74hc73;

architecture Behavioral of ic_74hc73 is

	constant delay_not : time := 0 ns;
	constant delay_and : time := 0 ns;
	constant delay_nand : time := 0 ns;
	constant delay_nor2 : time := 0 ns;

	component transmission_gate_rl is
	port (
		io_a : out std_logic;
		io_b : in std_logic;
		i_s : in std_logic;
		i_sb : in std_logic
	);
	end component transmission_gate_rl;
	for all : transmission_gate_rl use entity WORK.transmission_gate_rl(Behavioral);

	component transmission_gate_lr is
	port (
		io_a : in std_logic;
		io_b : out std_logic;
		i_s : in std_logic;
		i_sb : in std_logic
	);
	end component transmission_gate_lr;
	for all : transmission_gate_lr use entity WORK.transmission_gate_lr(Behavioral);

	component GATE_AND is
	generic (delay_and : TIME := delay_and);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GATE_AND;
	for all : GATE_AND use entity WORK.GATE_AND(GATE_AND_LUT);

	component GATE_NOR2 is
	generic (delay_nor2 : TIME := delay_nor2);
	port (A,B : in STD_LOGIC; C : out STD_LOGIC);
	end component GATE_NOR2;
	for all : GATE_NOR2 use entity WORK.GATE_NOR2(GATE_NOR2_LUT);

	component GATE_NOT is
	generic (delay_not : TIME := delay_not);
	port (A : in STD_LOGIC; B : out STD_LOGIC);
	end component GATE_NOT;
	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);

	component GATE_NAND is
	Generic (delay_nand : time := delay_nand);
	Port (A,B : in  STD_LOGIC; C : out  STD_LOGIC);
	end component GATE_NAND;
	for all : GATE_NAND use entity WORK.GATE_NAND(GATE_NAND_LUT);

	signal cp,cp_not1,cp_not2,cp_not3 : std_logic;
	signal s,sb : std_logic;
	signal nor2_1,nor2_2,nor2_3,nor2_4,nor2_5 : std_logic;
	signal j_nor2,k_and : std_logic;
	signal tg1_b,tg2_b,tg3_b,tg4_b : std_logic;
	signal r1,r2,nor2_r1_cp,k_not,k_nor2,j_not,j_and,i_jk,g4_out,g8_not,g8_not1 : std_logic;

begin

	g1 : GATE_NOT port map (A => i_r, B => r1);
	g2 : GATE_NOT port map (A => r1, B => r2);
	g0 : GATE_NOT port map (A => i_cpb, B => cp);
--	cp <= i_cpb;
	g3 : GATE_NOR2 port map (A => r1, B => cp, C => nor2_r1_cp);
	sb <= nor2_r1_cp;
	g4 : GATE_NOT port map (A => nor2_r1_cp, B => s);
	
	k_nor2_not_inst : GATE_NOT port map (A => i_k, B =>k_not);
	k_nor2_inst : GATE_NOR2 port map (A => k_not, B => tg3_b, C => k_nor2);
	j_and_not_inst : GATE_NOT port map (A => i_j, B =>j_not);
	j_and_inst : GATE_AND port map (A => tg3_b, B => j_not, C => j_and);
	jk_nor2_inst : GATE_NOR2 port map (A => k_nor2, B => j_and, C => i_jk);

	tg1_lr : transmission_gate_lr port map (io_a => i_jk, io_b => tg1_b, i_s => sb, i_sb => s);
	tg1_rl : transmission_gate_rl port map (io_a => tg1_b, io_b => i_jk, i_s => sb, i_sb => s);

	g5 : GATE_NAND port map (A => tg1_b, B => r2, C => g4_out);

	tg2_lr : transmission_gate_lr port map (io_a => tg1_b, io_b => tg2_b, i_s => s, i_sb => sb);
	tg2_rl : transmission_gate_rl port map (io_a => tg2_b, io_b => tg1_b, i_s => s, i_sb => sb);

	g6 : GATE_NOT port map (A => g4_out, B => tg2_b);

	tg3_lr : transmission_gate_lr port map (io_a => g4_out, io_b => tg3_b, i_s => s, i_sb => sb);
	tg3_rl : transmission_gate_rl port map (io_a => tg3_b, io_b => g4_out, i_s => s, i_sb => sb);

	tg4_lr : transmission_gate_lr port map (io_a => tg3_b, io_b => tg4_b, i_s => sb, i_sb => s);
	tg4_rl : transmission_gate_rl port map (io_a => tg4_b, io_b => tg3_b, i_s => sb, i_sb => s);

	g8 : GATE_NOT port map (A => tg3_b, B => g8_not);

	g7 : GATE_NOT port map (A => g8_not, B => tg4_b);

	g9 : GATE_NOT port map (A => g8_not, B => o_qb);
	g10 : GATE_NOT port map (A => g8_not, B => g8_not1);
	g11 : GATE_NOT port map (A => g8_not1, B => o_q);

end Behavioral;

