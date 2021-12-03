----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:46:00 11/28/2021 
-- Design Name: 
-- Module Name:    ic_74hct193 - Behavioral 
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

entity ic_74hct193 is
port (
	signal i_clock : in std_logic;
	signal i_d0 : in std_logic;
	signal i_d1 : in std_logic;
	signal i_d2 : in std_logic;
	signal i_d3 : in std_logic;
	signal o_q0 : out std_logic;
	signal o_q1 : out std_logic;
	signal o_q2 : out std_logic;
	signal o_q3 : out std_logic;
	signal i_cpd : in std_logic; -- count down clock input LH
	signal i_cpu : in std_logic; -- count up clock input LH
	signal i_pl : in std_logic; -- asynch parallel load input LOW
	signal o_tcu : out std_logic; -- carry - terminal count up output LOW
	signal o_tcd : out std_logic; -- borrow - terminal count down output LOW
	signal i_mr : in std_logic -- asynch master reset input HIGH
);
end ic_74hct193;

architecture Behavioral of ic_74hct193 is

	component FF_JK is
	port (
		i_r : in STD_LOGIC;
		J,K,C : in STD_LOGIC;
		Q1 : inout STD_LOGIC;
		Q2 : inout STD_LOGIC
	);
	end component FF_JK;
	for all : FF_JK use entity WORK.FF_JK(structural);

	component GATE_AND is
	generic (
		delay_and : TIME := 1 ps
	);
	port (
		A,B : in STD_LOGIC;
		C : out STD_LOGIC
	);
	end component GATE_AND;
	for all : GATE_AND use entity WORK.GATE_AND(GATE_AND_LUT);

	component GATE_NAND2 is
	generic (
		delay_nand2 : TIME := 1 ps
	);
	port (
		A,B : in STD_LOGIC;
		C : out STD_LOGIC
	);
	end component GATE_NAND2;
	for all : GATE_NAND2 use entity WORK.GATE_NAND2(GATE_NAND2_LUT);

	component GATE_AND3 is
	generic (
		delay_and3 : TIME := 1 ps
	);
	port (
		A,B,C : in STD_LOGIC;
		D : out STD_LOGIC
	);
	end component GATE_AND3;
	for all : GATE_AND3 use entity WORK.GATE_AND3(GATE_AND3_LUT);

	component GATE_NAND3 is
	generic (
		delay_nand3 : TIME := 1 ps
	);
	port (
		A,B,C : in STD_LOGIC;
		D : out STD_LOGIC
	);
	end component GATE_NAND3;
	for all : GATE_NAND3 use entity WORK.GATE_NAND3(GATE_NAND3_LUT);

	component GATE_AND4 is
	generic (
		delay_and4 : TIME := 1 ps
	);
	port (
		A,B,C,D : in STD_LOGIC;
		E : out STD_LOGIC
	);
	end component GATE_AND4;
	for all : GATE_AND4 use entity WORK.GATE_AND4(GATE_AND4_LUT);

	component GATE_NOR2 is
	generic (
		delay_nor2 : TIME := 1 ps
	);
	port (
		A,B : in STD_LOGIC;
		C : out STD_LOGIC
	);
	end component GATE_NOR2;
	for all : GATE_NOR2 use entity WORK.GATE_NOR2(GATE_NOR2_LUT);

	component GATE_OR2_BAR is
	generic (
		delay_or2_bar : TIME := 1 ps
	);
	port (
		A,B : in STD_LOGIC;
		C : out STD_LOGIC
	);
	end component GATE_OR2_BAR;
	for all : GATE_OR2_BAR use entity WORK.GATE_OR2_BAR(GATE_OR2_BAR_LUT);

	component GATE_NOT is
	generic (
		delay_not : TIME := 1 ps
	);
	port (
		A : in STD_LOGIC;
		B : out STD_LOGIC
	);
	end component GATE_NOT;
	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);

	signal ff_jk_t : std_logic_vector(3 downto 0);
	signal ff_jk_q1,ff_jk_q2 : std_logic_vector(3 downto 0);
	signal ff_jk_r : std_logic_vector(3 downto 0);
	signal i_cpu_not,i_cpd_not,i_mr_not : std_logic;
	signal ibuf_i_cpu_not,ibuf_i_cpd_not : std_logic;

	signal gate_and2_u,gate_and2_d : std_logic;
	signal gate_and3_u,gate_and3_d : std_logic;
	signal gate_and4_u,gate_and4_d : std_logic;

	signal gate_or2_bar1,gate_or2_bar2,gate_or2_bar3,gate_or2_bar4 : std_logic;
	signal gate_nand3_1,gate_nand3_2,gate_nand3_3,gate_nand3_4 : std_logic;

begin

	o_q0 <= ff_jk_q1(0);
	o_q1 <= ff_jk_q1(1);
	o_q2 <= ff_jk_q1(2);
	o_q3 <= ff_jk_q1(3);

	i_cpu_not_inst : GATE_NOT port map (A => i_cpu, B => i_cpu_not);
	i_cpd_not_inst : GATE_NOT port map (A => i_cpd, B => i_cpd_not);
	i_mr_not_inst : GATE_NOT port map (A => i_mr, B => i_mr_not);

	i_cpu_IBUF_inst : IBUF generic map (IBUF_DELAY_VALUE => "0", IFD_DELAY_VALUE => "AUTO", IOSTANDARD => "DEFAULT") port map (O => ibuf_i_cpu_not, I => i_cpu_not);
	i_cpd_IBUF_inst : IBUF generic map (IBUF_DELAY_VALUE => "0", IFD_DELAY_VALUE => "AUTO", IOSTANDARD => "DEFAULT") port map (O => ibuf_i_cpd_not, I => i_cpd_not);

	ff_jk_first_nor2 : GATE_NOR2 port map (A => ibuf_i_cpu_not, B => ibuf_i_cpd_not, C => ff_jk_t(0));

	gate_and2_u_inst1 : GATE_AND port map (A => ff_jk_q1(0), B => i_cpu_not, C => gate_and2_u);
	gate_and2_d_inst1 : GATE_AND port map (A => ff_jk_q2(0), B => i_cpd_not, C => gate_and2_d);
	ff_jk_chain1_nor2 : GATE_NOR2 port map (A => gate_and2_u, B => gate_and2_d, C => ff_jk_t(1));

	gate_and3_u_inst2 : GATE_AND3 port map (A => ff_jk_q1(1), B => ff_jk_q1(0), C => i_cpu_not, D => gate_and3_u);
	gate_and3_d_inst2 : GATE_AND3 port map (A => ff_jk_q2(1), B => ff_jk_q2(0), C => i_cpd_not, D => gate_and3_d);
	ff_jk_chain2_nor2 : GATE_NOR2 port map (A => gate_and3_u, B => gate_and3_d, C => ff_jk_t(2));

	gate_and4_u_inst3 : GATE_AND4 port map (A => ff_jk_q1(2), B => ff_jk_q1(1), C => ff_jk_q1(0), D => i_cpu_not, E => gate_and4_u);
	gate_and4_d_inst3 : GATE_AND4 port map (A => ff_jk_q2(2), B => ff_jk_q2(1), C => ff_jk_q2(0), D => i_cpd_not, E => gate_and4_d);
	ff_jk_chain3_nor2 : GATE_NOR2 port map (A => gate_and4_u, B => gate_and4_d, C => ff_jk_t(3));

	gate_nand3_inst1 : GATE_NAND3 port map (A => i_pl, B => i_mr_not, C => i_d0, D => gate_nand3_1);
	gate_nand2_inst1 : GATE_NAND2 port map (A => i_pl, B => gate_nand3_1, C => gate_or2_bar1);

	gate_nand3_inst2 : GATE_NAND3 port map (A => i_pl, B => i_mr_not, C => i_d1, D => gate_nand3_2);
	gate_nand2_inst2 : GATE_NAND2 port map (A => i_pl, B => gate_nand3_2, C => gate_or2_bar2);

	gate_nand3_inst3 : GATE_NAND3 port map (A => i_pl, B => i_mr_not, C => i_d2, D => gate_nand3_3);
	gate_nand2_inst3 : GATE_NAND2 port map (A => i_pl, B => gate_nand3_3, C => gate_or2_bar3);

	gate_nand3_inst4 : GATE_NAND3 port map (A => i_pl, B => i_mr_not, C => i_d3, D => gate_nand3_4);
	gate_nand2_inst4 : GATE_NAND2 port map (A => i_pl, B => gate_nand3_4, C => gate_or2_bar4);

	gate_or2_bar_inst1 : GATE_OR2_BAR port map (A => i_mr_not, B => gate_or2_bar1, C => ff_jk_r(0));
	gate_or2_bar_inst2 : GATE_OR2_BAR port map (A => i_mr_not, B => gate_or2_bar2, C => ff_jk_r(1));
	gate_or2_bar_inst3 : GATE_OR2_BAR port map (A => i_mr_not, B => gate_or2_bar3, C => ff_jk_r(2));
	gate_or2_bar_inst4 : GATE_OR2_BAR port map (A => i_mr_not, B => gate_or2_bar4, C => ff_jk_r(3));

	ff_jk_generate : for i in 0 to 3 generate
		ff_jk_first_generate : if (i = 0) generate
			ff_jk_first : FF_JK port map (
			i_r => ff_jk_r(0),
			J => ff_jk_t(0),
			K => ff_jk_t(0),
			C => '0',
			Q1 => ff_jk_q1(0),
			Q2 => ff_jk_q2(0)
			);
		end generate ff_jk_first_generate;
		ff_jk_chain_generate : if (i > 0) generate
			ff_jk_chain : FF_JK port map (
				i_r => ff_jk_r(i),
				J => ff_jk_t(i),
				K => ff_jk_t(i),
				C => '0',
				Q1 => ff_jk_q1(i),
				Q2 => ff_jk_q2(i)
				);
		end generate ff_jk_chain_generate;
	end generate ff_jk_generate;

end Behavioral;
