----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:51:52 01/31/2022 
-- Design Name: 
-- Module Name:    ic_hef4027b - Behavioral 
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

entity ic_hef4027b is
port (
	signal i_cp : in std_logic;
	signal i_j : in std_logic;
	signal i_k : in std_logic;
	signal i_cd : in std_logic;
	signal i_sd : in std_logic;
	signal o_q : out std_logic;
	signal o_qb : out std_logic
);
end ic_hef4027b;

architecture Behavioral of ic_hef4027b is

	constant delay_not : time := 0 ns;
	constant delay_and : time := 0 ns;
	constant delay_nor2 : time := 0.001 ns;

--	component transmission_gate_rl is
--	port (
--		io_a : out std_logic;
--		io_b : in std_logic;
--		i_s : in std_logic
----		i_sb : in std_logic
--	);
--	end component transmission_gate_rl;
--	for all : transmission_gate_rl use entity WORK.transmission_gate_rl(Behavioral);

	component transmission_gate_lr is
	port (
		io_a : in std_logic;
		io_b : out std_logic;
		i_s : in std_logic
--		i_sb : in std_logic
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

	signal cp,cp_not1,cp_not2,cp_not3 : std_logic;
	signal s,sb : std_logic;
	signal nor2_1,nor2_2,nor2_3,nor2_4,nor2_5 : std_logic;
	signal j_nor2,k_and : std_logic;
	signal tg1_b,tg2_b,tg3_b : std_logic;

begin

--	cp_not_inst1 : GATE_NOT port map (A => i_cp, B => cp_not1);
--	cp_not_inst2 : GATE_NOT port map (A => i_cp, B => cp_not2);
	cp_not_inst3 : GATE_NOT port map (A => i_cp, B => cp_not3);
--	s <= cp_not2;
	s <= i_cp;
	sb <= cp_not3;

	j_nor2_inst : GATE_NOR2 port map (A => i_j, B => nor2_4, C => j_nor2);
	k_and_inst : GATE_AND port map (A => nor2_4, B => i_k, C => k_and);
	nor2_1_inst : GATE_NOR2 port map (A => j_nor2, B => k_and, C => nor2_1);

--	tg1_lr : transmission_gate_lr port map (io_a => nor2_1, io_b => tg1_b, i_s => s, i_sb => sb);
	tg1_lr : transmission_gate_lr port map (io_a => nor2_1, io_b => tg1_b, i_s => sb);
--	tg1_rl : transmission_gate_rl port map (io_b => tg1_b, io_a => nor2_1, i_s => sb, i_sb => s);
--	tg1_rl : transmission_gate_rl port map (io_b => tg1_b, io_a => nor2_1, i_s => s);
	nor2_2_inst : GATE_NOR2 port map (A => tg1_b, B => i_sd, C => nor2_2);

	nor2_3_inst : GATE_NOR2 port map (A => nor2_2, B => i_cd, C => nor2_3);
--	tg2_lr : transmission_gate_lr port map (io_a => nor2_3, io_b => tg1_b, i_s => sb, i_sb => s);
	tg2_lr : transmission_gate_lr port map (io_a => nor2_3, io_b => tg1_b, i_s => s);
--	tg2_rl : transmission_gate_rl port map (io_b => tg1_b, io_a => nor2_3, i_s => s, i_sb => sb);
--	tg2_rl : transmission_gate_rl port map (io_b => tg1_b, io_a => nor2_3, i_s => sb);

--	tg3_lr : transmission_gate_lr port map (io_a => nor2_2, io_b => tg3_b, i_s => sb, i_sb => s);
	tg3_lr : transmission_gate_lr port map (io_a => nor2_2, io_b => tg3_b, i_s => s);
--	tg3_rl : transmission_gate_rl port map (io_b => tg3_b, io_a => nor2_2, i_s => s, i_sb => sb);
--	tg3_rl : transmission_gate_rl port map (io_b => tg3_b, io_a => nor2_2, i_s => sb);
	nor2_4_inst : GATE_NOR2 port map (A => tg3_b, B => i_cd, C => nor2_4);

	nor2_5_inst : GATE_NOR2 port map (A => nor2_4, B => i_sd, C => nor2_5);
--	tg4_lr : transmission_gate_lr port map (io_a => nor2_5, io_b => tg3_b, i_s => s, i_sb => sb);
	tg4_lr : transmission_gate_lr port map (io_a => nor2_5, io_b => tg3_b, i_s => sb);
--	tg4_rl : transmission_gate_rl port map (io_b => tg3_b, io_a => nor2_5, i_s => sb, i_sb => s);
--	tg4_rl : transmission_gate_rl port map (io_b => tg3_b, io_a => nor2_5, i_s => s);

	g1_not_inst : GATE_NOT port map (A => tg3_b, B => o_q);
	g2_not_inst : GATE_NOT port map (A => nor2_4, B => o_qb);

end Behavioral;
