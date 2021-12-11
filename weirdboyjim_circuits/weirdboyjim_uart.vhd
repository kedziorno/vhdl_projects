----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:25:12 11/28/2021 
-- Design Name: 
-- Module Name:    weirdboyjim_uart - Behavioral 
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

entity weirdboyjim_uart is
port (
	signal tx : out std_logic;
	signal rx : in std_logic;
	signal UartClock : in std_logic;
	signal txData : in std_logic_vector(7 downto 0);
	signal txClock : in std_logic;
	signal TFcount_slv30 : std_logic_vector(3 downto 0)
);
end weirdboyjim_uart;

-- https://easyeda.com/weirdboyjim/UART
architecture Behavioral of weirdboyjim_uart is

	component ic_74hct32 is
	port (
		i_1a,i_1b : in std_logic;
		o_1y : out std_logic;
		i_2a,i_2b : in std_logic;
		o_2y : out std_logic;
		i_3a,i_3b : in std_logic;
		o_3y : out std_logic;
		i_4a,i_4b : in std_logic;
		o_4y : out std_logic
	);
	end component ic_74hct32;
	for all : ic_74hct32 use entity WORK.ic_74hct32(Behavioral);

	component ic_74hct193 is
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
	end component ic_74hct193;
	for all : ic_74hct193 use entity WORK.ic_74hct193(Behavioral);

	component ic_74hct00 is
	port (
		i_1a,i_1b : in std_logic;
		o_1y : out std_logic;
		i_2a,i_2b : in std_logic;
		o_2y : out std_logic;
		i_3a,i_3b : in std_logic;
		o_3y : out std_logic;
		i_4a,i_4b : in std_logic;
		o_4y : out std_logic
	);
	end component ic_74hct00;
	for all : ic_74hct00 use entity WORK.ic_74hct00(Behavioral);

	component ic_sn74als165 is
	port (
		signal i_sh_ld : in std_logic;
		signal i_clk,i_clk_inh : in std_logic;
		signal i_ser : in std_logic;
		signal i_d0,i_d1,i_d2,i_d3,i_d4,i_d5,i_d6,i_d7 : in std_logic;
		signal o_q7,o_q7_not : out std_logic
	);
	end component ic_sn74als165;
	for all : ic_sn74als165 use entity WORK.ic_sn74als165(Behavioral);

	signal txStart,txDataReady,txDataRead,TFDataRead : std_logic := '0';
	signal u9_1a,u9_1b,u9_2a,u9_2b,u9_3a,u9_3b,u9_4a,u9_4b,u9_1y,u9_2y,u9_3y,u9_4y : std_logic := '0';
	signal u8_1a,u8_1b,u8_2a,u8_2b,u8_3a,u8_3b,u8_4a,u8_4b,u8_1y,u8_2y,u8_3y,u8_4y : std_logic := '0';
	signal u5_d0,u5_d1,u5_d2,u5_d3,u5_q0,u5_q1,u5_q2,u5_q3,u5_cpd,u5_cpu,u5_pl,u5_tcu,u5_tcd,u5_mr : std_logic := '0';
	signal u7_d0,u7_d1,u7_d2,u7_d3,u7_q0,u7_q1,u7_q2,u7_q3,u7_cpd,u7_cpu,u7_pl,u7_tcu,u7_tcd,u7_mr : std_logic := '0';
	signal u10_sh_ld,u10_clk,u10_clk_inh,u10_ser,u10_d0,u10_d1,u10_d2,u10_d3,u10_d4,u10_d5,u10_d6,u10_d7,u10_q7,u10_q7_not : std_logic := '0';
	signal u11_sh_ld,u11_clk,u11_clk_inh,u11_ser,u11_d0,u11_d1,u11_d2,u11_d3,u11_d4,u11_d5,u11_d6,u11_d7,u11_q7,u11_q7_not : std_logic := '0';

begin

	U9_inst : ic_74hct32 port map (
		i_1a => u9_1a, i_1b => u9_1b, o_1y => u9_1y,
		i_2a => u9_2a, i_2b => u9_2b, o_2y => u9_2y,
		i_3a => u9_3a, i_3b => u9_3b, o_3y => u9_3y,
		i_4a => u9_4a, i_4b => u9_4b, o_4y => u9_4y
	);

	U9_connect1 : u9_1a <= u9_4y;
	U9_connect2 : u9_1b <= u9_3y;
	U9_connect3 : txDataReady <= u9_1y;
	U9_connect4 : u9_2a <= '0';
	U9_connect5 : u9_2b <= '0';
	--U9_connect6 : u9_2y <= 'X';
	U9_connect7 : u9_4b <= TFcount_slv30(3);
	U9_connect8 : u9_4a <= TFcount_slv30(2);
	U9_connect9 : u9_3b <= TFcount_slv30(1);
	U9_connect10 : u9_3a <= TFcount_slv30(0);

	U5_inst : ic_74hct193 port map (
		i_clock => 'X',
		i_d0 => u5_d0, i_d1 => u5_d1, i_d2 => u5_d2, i_d3 => u5_d3,
		o_q0 => u5_q0, o_q1 => u5_q1, o_q2 => u5_q2, o_q3 => u5_q3,
		i_cpd => u5_cpd, i_cpu => u5_cpu, i_pl => u5_pl,
		o_tcu => u5_tcu, o_tcd => u5_tcd, i_mr => u5_mr
	);

	U5_connect1 : u5_d0 <= '0';
	U5_connect2 : u5_d1 <= '0';
	U5_connect3 : u5_d2 <= '0';
	U5_connect4 : u5_d3 <= '0';
	U5_connect5 : u5_q0 <= 'X';
	U5_connect6 : u5_q1 <= 'X';
	U5_connect7 : u5_q2 <= 'X';
	U5_connect8 : u5_q3 <= txClock;
	U5_connect9 : u5_cpd <= '1';
	U5_connect10 : u5_cpu <= UartClock;
	U5_connect11 : u5_pl <= '0';
	U5_connect12 : u5_tcu <= 'X';
	U5_connect13 : u5_tcd <= 'X';
	U5_connect14 : u5_mr <= '0';

	U7_inst : ic_74hct193 port map (
		i_clock => 'X',
		i_d0 => u7_d0, i_d1 => u7_d1, i_d2 => u7_d2, i_d3 => u7_d3,
		o_q0 => u7_q0, o_q1 => u7_q1, o_q2 => u7_q2, o_q3 => u7_q3,
		i_cpd => u7_cpd, i_cpu => u7_cpu, i_pl => u7_pl,
		o_tcu => u7_tcu, o_tcd => u7_tcd, i_mr => u7_mr
	);

	U7_connect1 : u7_d0 <= '1';
	U7_connect2 : u7_d1 <= '0';
	U7_connect3 : u7_d2 <= '1';
	U7_connect4 : u7_d3 <= '0';
	U7_connect5 : u7_q0 <= 'X';
	U7_connect6 : u7_q1 <= 'X';
	U7_connect7 : u7_q2 <= 'X';
	U7_connect8 : u7_q3 <= 'X';
	U7_connect9 : u7_cpd <= '1';
	U7_connect10 : u7_cpu <= txClock;
	U7_connect11 : u7_pl <= txStart;
--	U7_connect12 : u7_tcu <= u8_3a;
	U7_connect13 : u7_tcd <= 'X';
	U7_connect14 : u7_mr <= '0';

	U8_inst : ic_74hct00 port map (
		i_1a => u8_1a, i_1b => u8_1b, o_1y => u8_1y,
		i_2a => u8_2a, i_2b => u8_2b, o_2y => u8_2y,
		i_3a => u8_3a, i_3b => u8_3b, o_3y => u8_3y,
		i_4a => u8_4a, i_4b => u8_4b, o_4y => u8_4y
	);

	U8_connect1 : u8_1a <= txClock;
	U8_connect2 : u8_1b <= txDataReady;
--	U8_connect3 : u8_1y <= 'X';
	U8_connect4 : u8_2a <= '0';
	U8_connect5 : u8_2b <= '0';
	U8_connect6 : u8_2y <= 'X';
	U8_connect7 : u8_3a <= u7_tcu;
	U8_connect8 : u8_3b <= txStart;
	U8_connect9 : u8_3y <= TFDataRead;
	U8_connect10 : u8_4a <= txDataRead;
	U8_connect11 : u8_4b <= u8_1y;
	U8_connect12 : u8_4y <= txStart;

	U10_inst : ic_sn74als165 port map (
		i_sh_ld => u10_sh_ld,
		i_clk => u10_clk,
		i_clk_inh => u10_clk_inh,
		i_ser => u10_ser,
		i_d0 => u10_d0,
		i_d1 => u10_d1,
		i_d2 => u10_d2,
		i_d3 => u10_d3,
		i_d4 => u10_d4,
		i_d5 => u10_d5,
		i_d6 => u10_d6,
		i_d7 => u10_d7,
		o_q7 => u10_q7,
		o_q7_not => u10_q7_not
	);

	U10_connect1 : u10_sh_ld <= txStart;
	U10_connect2 : u10_clk <= txClock;
	U10_connect3 : u10_clk_inh <= '1';
	U10_connect4 : u10_ser <= u11_q7;
	U10_connect5 : u10_d0 <= txData(5);
	U10_connect6 : u10_d1 <= txData(4);
	U10_connect7 : u10_d2 <= txData(3);
	U10_connect8 : u10_d3 <= txData(2);
	U10_connect9 : u10_d4 <= txData(1);
	U10_connect10 : u10_d5 <= txData(0);
	U10_connect11 : u10_d6 <= '0';
	U10_connect12 : u10_d7 <= '1';
	U10_connect13 : tx <= u10_q7;
	U10_connect14 : u10_q7_not <= 'X';

	U11_inst : ic_sn74als165 port map (
		i_sh_ld => u11_sh_ld,
		i_clk => u11_clk,
		i_clk_inh => u11_clk_inh,
		i_ser => u11_ser,
		i_d0 => u11_d0,
		i_d1 => u11_d1,
		i_d2 => u11_d2,
		i_d3 => u11_d3,
		i_d4 => u11_d4,
		i_d5 => u11_d5,
		i_d6 => u11_d6,
		i_d7 => u11_d7,
		o_q7 => u11_q7,
		o_q7_not => u11_q7_not
	);

	U11_connect1 : u11_sh_ld <= txStart;
	U11_connect2 : u11_clk <= txClock;
	U11_connect3 : u11_clk_inh <= '1';
	U11_connect4 : u11_ser <= '1';
	U11_connect5 : u11_d0 <= '1';
	U11_connect6 : u11_d1 <= '1';
	U11_connect7 : u11_d2 <= '1';
	U11_connect8 : u11_d3 <= '1';
	U11_connect9 : u11_d4 <= '1';
	U11_connect10 : u11_d5 <= '1';
	U11_connect11 : u11_d6 <= txData(7);
	U11_connect12 : u11_d7 <= txData(6);
--	U11_connect13 : u11_q7 <= u10_ser;
	U11_connect14 : u11_q7_not <= 'X';

end Behavioral;

