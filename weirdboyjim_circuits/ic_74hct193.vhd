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
	signal i_cpu_not,i_cpd_not,i_mr_not : std_logic;
	signal ibuf_i_cpu_not,ibuf_i_cpd_not : std_logic;

	signal gate_and2_u,gate_and2_d : std_logic;

begin

	i_cpu_not_inst : GATE_NOT port map (A => i_cpu, B => i_cpu_not);
	i_cpd_not_inst : GATE_NOT port map (A => i_cpd, B => i_cpd_not);
	i_mr_not_inst : GATE_NOT port map (A => i_mr, B => i_mr_not);

--	i_cpu_IBUF_inst : OBUF generic map (port map (O => ibuf_i_cpu_not, I => i_cpu_not);
--	i_cpd_IBUF_inst : OBUF generic map (IBUF_DELAY_VALUE => "0", IFD_DELAY_VALUE => "AUTO", IOSTANDARD => "DEFAULT") port map (O => ibuf_i_cpd_not, I => i_cpd_not);
--	i_cpu_OBUF_inst : OBUF port map (O => ibuf_i_cpu_not, I => i_cpu_not);
--	i_cpd_OBUF_inst : OBUF port map (O => ibuf_i_cpd_not, I => i_cpd_not);

--	ff_jk_first_nor2 : GATE_NOR2 port map (A => ibuf_i_cpu_not, B => ibuf_i_cpd_not, C => ff_jk_t(0));
	ff_jk_first_nor2 : GATE_NOR2 port map (A => i_cpu_not, B => i_cpd_not, C => ff_jk_t(0));
	ff_jk_chain1_nor2 : GATE_NOR2 port map (A => gate_and2_u, B => gate_and2_d, C => ff_jk_t(1));

	gate_and2_u_inst : GATE_AND port map (A => ff_jk_q1(0), B => i_cpu_not, C => gate_and2_u);
	gate_and2_d_inst : GATE_AND port map (A => ff_jk_q2(0), B => i_cpd_not, C => gate_and2_d);

	ff_jk_generate : for i in 0 to 3 generate
		ff_jk_first_generate : if (i = 0) generate
			ff_jk_first : FF_JK port map (
			i_r => i_mr_not,
			J => ff_jk_t(0),
			K => ff_jk_t(0),
			C => '1',
			Q1 => ff_jk_q1(0),
			Q2 => ff_jk_q2(0)
			);
		end generate ff_jk_first_generate ;
		ff_jk_chain_generate : if (i > 0) generate
			ff_jk_chain : FF_JK port map (
				i_r => i_mr_not,
				J => ff_jk_t(i),
				K => ff_jk_t(i),
				C => '1',
				Q1 => ff_jk_q1(i),
				Q2 => ff_jk_q2(i)
				);
		end generate ff_jk_chain_generate;
	end generate ff_jk_generate;
	
end Behavioral;
-- XXX with keep_hierarchy = yes/soft generate bit file succesfully
