----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:53:18 12/09/2021 
-- Design Name: 
-- Module Name:    ic_74hct574 - Behavioral 
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

entity ic_74hct574 is
port (
	signal i_d0,i_d1,i_d2,i_d3,i_d4,i_d5,i_d6,i_d7 : in std_logic;
	signal i_cp : in std_logic;
	signal i_oe : in std_logic;
	signal o_q0,o_q1,o_q2,o_q3,o_q4,o_q5,o_q6,o_q7 : out std_logic
);
end ic_74hct574;

architecture Behavioral of ic_74hct574 is

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

	signal i_oe_not : std_logic;
	signal d,q,q_ff : std_logic_vector(7 downto 0);

begin

	d(0) <= i_d0;
	d(1) <= i_d1;
	d(2) <= i_d2;
	d(3) <= i_d3;
	d(4) <= i_d4;
	d(5) <= i_d5;
	d(6) <= i_d6;
	d(7) <= i_d7;

	o_q0 <= q(0);
	o_q1 <= q(1);
	o_q2 <= q(2);
	o_q3 <= q(3);
	o_q4 <= q(4);
	o_q5 <= q(5);
	o_q6 <= q(6);
	o_q7 <= q(7);

	i_oe_not_inst : GATE_NOT port map (A => i_oe, B => i_oe_not);

	ff_generate : for i in 0 to 7 generate
		FDCE_inst : FDCE
		generic map (INIT => '0')
		port map (
			Q => q_ff(i),
			C => i_cp,
			CE => i_oe_not,
			CLR => i_oe,
			D => d(i)
		);
	end generate ff_generate;

	obuf_generate : for i in 0 to 7 generate
		OBUFT_inst : OBUFT
		generic map (DRIVE => 12, IOSTANDARD => "DEFAULT", SLEW => "SLOW")
		port map (
			O => q(i),
			I => q_ff(i),
			T => i_oe
		);
	end generate obuf_generate;

end Behavioral;
