----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:23:43 04/26/2023 
-- Design Name: 
-- Module Name:    vga_horizontalsync_configurablelogic - Behavioral 
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

entity vga_horizontalsync_configurablelogic is
port (
  signal i_clock,i_reset : in std_logic;
  signal i_startvaluereg8bit_1,i_startvaluereg8bit_2,i_startvaluereg8bit_3,i_startvaluereg8bit_4 : in std_logic_vector (7 downto 0);
  signal o_sync, o_blank : out std_logic
);
end vga_horizontalsync_configurablelogic;

architecture Behavioral of vga_horizontalsync_configurablelogic is

component FF_SR_GATED is
generic (
delay_and : time := 0 ns;
delay_or : time := 0 ns;
delay_not : time := 0 ns;
delay_nand2 : time := 1 ns;
delay_nor2 : time := 0 ns
);
port (S,R,E:in STD_LOGIC;Q1,Q2:inout STD_LOGIC);
end component FF_SR_GATED;
for all : FF_SR_GATED use entity WORK.FF_SR_GATED(LUT_GATED_SR_1_WON);

COMPONENT ic_74hct163
PORT(
i_d0 : IN  std_logic;
i_d1 : IN  std_logic;
i_d2 : IN  std_logic;
i_d3 : IN  std_logic;
i_cet : IN  std_logic;
i_cep : IN  std_logic;
i_pe_b : IN  std_logic;
i_cp : IN  std_logic;
i_mr_b : IN  std_logic;
o_q0 : OUT  std_logic;
o_q1 : OUT  std_logic;
o_q2 : OUT  std_logic;
o_q3 : OUT  std_logic;
o_tc : OUT  std_logic
);
END COMPONENT;

signal i_counter1_d0,i_counter1_d1,i_counter1_d2,i_counter1_d3,i_counter1_cet,i_counter1_cep,i_counter1_pe_b,i_counter1_cp,i_counter1_mr_b,o_counter1_q0,o_counter1_q1,o_counter1_q2,o_counter1_q3,o_counter1_tc : std_logic;
signal i_counter2_d0,i_counter2_d1,i_counter2_d2,i_counter2_d3,i_counter2_cet,i_counter2_cep,i_counter2_pe_b,i_counter2_cp,i_counter2_mr_b,o_counter2_q0,o_counter2_q1,o_counter2_q2,o_counter2_q3,o_counter2_tc : std_logic;
signal i_counter3_d0,i_counter3_d1,i_counter3_d2,i_counter3_d3,i_counter3_cet,i_counter3_cep,i_counter3_pe_b,i_counter3_cp,i_counter3_mr_b,o_counter3_q0,o_counter3_q1,o_counter3_q2,o_counter3_q3,o_counter3_tc : std_logic;
signal i_counter4_d0,i_counter4_d1,i_counter4_d2,i_counter4_d3,i_counter4_cet,i_counter4_cep,i_counter4_pe_b,i_counter4_cp,i_counter4_mr_b,o_counter4_q0,o_counter4_q1,o_counter4_q2,o_counter4_q3,o_counter4_tc : std_logic;
signal i_counter5_d0,i_counter5_d1,i_counter5_d2,i_counter5_d3,i_counter5_cet,i_counter5_cep,i_counter5_pe_b,i_counter5_cp,i_counter5_mr_b,o_counter5_q0,o_counter5_q1,o_counter5_q2,o_counter5_q3,o_counter5_tc : std_logic;
signal i_counter6_d0,i_counter6_d1,i_counter6_d2,i_counter6_d3,i_counter6_cet,i_counter6_cep,i_counter6_pe_b,i_counter6_cp,i_counter6_mr_b,o_counter6_q0,o_counter6_q1,o_counter6_q2,o_counter6_q3,o_counter6_tc : std_logic;
signal i_counter7_d0,i_counter7_d1,i_counter7_d2,i_counter7_d3,i_counter7_cet,i_counter7_cep,i_counter7_pe_b,i_counter7_cp,i_counter7_mr_b,o_counter7_q0,o_counter7_q1,o_counter7_q2,o_counter7_q3,o_counter7_tc : std_logic;
signal i_counter8_d0,i_counter8_d1,i_counter8_d2,i_counter8_d3,i_counter8_cet,i_counter8_cep,i_counter8_pe_b,i_counter8_cp,i_counter8_mr_b,o_counter8_q0,o_counter8_q1,o_counter8_q2,o_counter8_q3,o_counter8_tc : std_logic;

signal sync,blank : std_logic;

begin

i_counter1_d0 <= i_startvaluereg8bit_1 (0);
i_counter1_d1 <= i_startvaluereg8bit_1 (1);
i_counter1_d2 <= i_startvaluereg8bit_1 (2);
i_counter1_d3 <= i_startvaluereg8bit_1 (3);
i_counter2_d0 <= i_startvaluereg8bit_1 (4);
i_counter2_d1 <= i_startvaluereg8bit_1 (5);
i_counter2_d2 <= i_startvaluereg8bit_1 (6);
i_counter2_d3 <= i_startvaluereg8bit_1 (7);

i_counter1_cp <= i_clock;
i_counter1_cet <= o_counter8_tc;
i_counter1_cep <= '1';
i_counter1_pe_b <= '1';
i_counter1_mr_b <= i_reset;

i_counter2_cp <= i_clock;
i_counter2_cet <= o_counter1_tc;
i_counter2_cep <= '1';
i_counter2_pe_b <= '1';
i_counter2_mr_b <= i_reset;

i_counter3_d0 <= i_startvaluereg8bit_2 (0);
i_counter3_d1 <= i_startvaluereg8bit_2 (1);
i_counter3_d2 <= i_startvaluereg8bit_2 (2);
i_counter3_d3 <= i_startvaluereg8bit_2 (3);
i_counter4_d0 <= i_startvaluereg8bit_2 (4);
i_counter4_d1 <= i_startvaluereg8bit_2 (5);
i_counter4_d2 <= i_startvaluereg8bit_2 (6);
i_counter4_d3 <= i_startvaluereg8bit_2 (7);

i_counter3_cp <= i_clock;
i_counter3_cet <= o_counter8_tc;
i_counter3_cep <= '1';
i_counter3_pe_b <= '1';
i_counter3_mr_b <= i_reset;

i_counter4_cp <= i_clock;
i_counter4_cet <= o_counter3_tc;
i_counter4_cep <= '1';
i_counter4_pe_b <= '1';
i_counter4_mr_b <= i_reset;

i_counter5_d0 <= i_startvaluereg8bit_3 (0);
i_counter5_d1 <= i_startvaluereg8bit_3 (1);
i_counter5_d2 <= i_startvaluereg8bit_3 (2);
i_counter5_d3 <= i_startvaluereg8bit_3 (3);
i_counter6_d0 <= i_startvaluereg8bit_3 (4);
i_counter6_d1 <= i_startvaluereg8bit_3 (5);
i_counter6_d2 <= i_startvaluereg8bit_3 (6);
i_counter6_d3 <= i_startvaluereg8bit_3 (7);

i_counter5_cp <= i_clock;
i_counter5_cet <= o_counter8_tc;
i_counter5_cep <= '1';
i_counter5_pe_b <= '1';
i_counter5_mr_b <= i_reset;

i_counter6_cp <= i_clock;
i_counter6_cet <= o_counter5_tc;
i_counter6_cep <= '1';
i_counter6_pe_b <= '1';
i_counter6_mr_b <= i_reset;

i_counter7_d0 <= i_startvaluereg8bit_4 (0);
i_counter7_d1 <= i_startvaluereg8bit_4 (1);
i_counter7_d2 <= i_startvaluereg8bit_4 (2);
i_counter7_d3 <= i_startvaluereg8bit_4 (3);
i_counter8_d0 <= i_startvaluereg8bit_4 (4);
i_counter8_d1 <= i_startvaluereg8bit_4 (5);
i_counter8_d2 <= i_startvaluereg8bit_4 (6);
i_counter8_d3 <= i_startvaluereg8bit_4 (7);

i_counter7_cp <= i_clock;
i_counter7_cet <= '1';
i_counter7_cep <= '1';
i_counter7_pe_b <= '1';
i_counter7_mr_b <= i_reset;

i_counter8_cp <= i_clock;
i_counter8_cet <= o_counter7_tc;
i_counter8_cep <= '1';
i_counter8_pe_b <= '1';
i_counter8_mr_b <= i_reset;

counter1 : ic_74hct163 PORT MAP (
i_d0 => i_counter1_d0,
i_d1 => i_counter1_d1,
i_d2 => i_counter1_d2,
i_d3 => i_counter1_d3,
i_cet => i_counter1_cet,
i_cep => i_counter1_cep,
i_pe_b => i_counter1_pe_b,
i_cp => i_counter1_cp,
i_mr_b => i_counter1_mr_b,
o_q0 => o_counter1_q0,
o_q1 => o_counter1_q1,
o_q2 => o_counter1_q2,
o_q3 => o_counter1_q3,
o_tc => o_counter1_tc
);

counter2 : ic_74hct163 PORT MAP (
i_d0 => i_counter2_d0,
i_d1 => i_counter2_d1,
i_d2 => i_counter2_d2,
i_d3 => i_counter2_d3,
i_cet => i_counter2_cet,
i_cep => i_counter2_cep,
i_pe_b => i_counter2_pe_b,
i_cp => i_counter2_cp,
i_mr_b => i_counter2_mr_b,
o_q0 => o_counter2_q0,
o_q1 => o_counter2_q1,
o_q2 => o_counter2_q2,
o_q3 => o_counter2_q3,
o_tc => o_counter2_tc
);

counter3 : ic_74hct163 PORT MAP (
i_d0 => i_counter3_d0,
i_d1 => i_counter3_d1,
i_d2 => i_counter3_d2,
i_d3 => i_counter3_d3,
i_cet => i_counter3_cet,
i_cep => i_counter3_cep,
i_pe_b => i_counter3_pe_b,
i_cp => i_counter3_cp,
i_mr_b => i_counter3_mr_b,
o_q0 => o_counter3_q0,
o_q1 => o_counter3_q1,
o_q2 => o_counter3_q2,
o_q3 => o_counter3_q3,
o_tc => o_counter3_tc
);

counter4 : ic_74hct163 PORT MAP (
i_d0 => i_counter4_d0,
i_d1 => i_counter4_d1,
i_d2 => i_counter4_d2,
i_d3 => i_counter4_d3,
i_cet => i_counter4_cet,
i_cep => i_counter4_cep,
i_pe_b => i_counter4_pe_b,
i_cp => i_counter4_cp,
i_mr_b => i_counter4_mr_b,
o_q0 => o_counter4_q0,
o_q1 => o_counter4_q1,
o_q2 => o_counter4_q2,
o_q3 => o_counter4_q3,
o_tc => o_counter4_tc
);

counter5 : ic_74hct163 PORT MAP (
i_d0 => i_counter5_d0,
i_d1 => i_counter5_d1,
i_d2 => i_counter5_d2,
i_d3 => i_counter5_d3,
i_cet => i_counter5_cet,
i_cep => i_counter5_cep,
i_pe_b => i_counter5_pe_b,
i_cp => i_counter5_cp,
i_mr_b => i_counter5_mr_b,
o_q0 => o_counter5_q0,
o_q1 => o_counter5_q1,
o_q2 => o_counter5_q2,
o_q3 => o_counter5_q3,
o_tc => o_counter5_tc
);

counter6 : ic_74hct163 PORT MAP (
i_d0 => i_counter6_d0,
i_d1 => i_counter6_d1,
i_d2 => i_counter6_d2,
i_d3 => i_counter6_d3,
i_cet => i_counter6_cet,
i_cep => i_counter6_cep,
i_pe_b => i_counter6_pe_b,
i_cp => i_counter6_cp,
i_mr_b => i_counter6_mr_b,
o_q0 => o_counter6_q0,
o_q1 => o_counter6_q1,
o_q2 => o_counter6_q2,
o_q3 => o_counter6_q3,
o_tc => o_counter6_tc
);

counter7 : ic_74hct163 PORT MAP (
i_d0 => i_counter7_d0,
i_d1 => i_counter7_d1,
i_d2 => i_counter7_d2,
i_d3 => i_counter7_d3,
i_cet => i_counter7_cet,
i_cep => i_counter7_cep,
i_pe_b => i_counter7_pe_b,
i_cp => i_counter7_cp,
i_mr_b => i_counter7_mr_b,
o_q0 => o_counter7_q0,
o_q1 => o_counter7_q1,
o_q2 => o_counter7_q2,
o_q3 => o_counter7_q3,
o_tc => o_counter7_tc
);

counter8 : ic_74hct163 PORT MAP (
i_d0 => i_counter8_d0,
i_d1 => i_counter8_d1,
i_d2 => i_counter8_d2,
i_d3 => i_counter8_d3,
i_cet => i_counter8_cet,
i_cep => i_counter8_cep,
i_pe_b => i_counter8_pe_b,
i_cp => i_counter8_cp,
i_mr_b => i_counter8_mr_b,
o_q0 => o_counter8_q0,
o_q1 => o_counter8_q1,
o_q2 => o_counter8_q2,
o_q3 => o_counter8_q3,
o_tc => o_counter8_tc
);

sync_sr_latch : FF_SR_GATED
port map (
S => o_counter2_tc,
R => o_counter4_tc,
E => '1',
Q1 => sync,
Q2 => open
);
o_sync <= sync;

reset_sr_latch : FF_SR_GATED
port map (
S => o_counter6_tc,
R => o_counter8_tc,
E => '1',
Q1 => blank,
Q2 => open
);
o_blank <= blank;

end Behavioral;
