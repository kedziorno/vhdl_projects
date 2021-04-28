----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:41:34 04/26/2021 
-- Design Name: 
-- Module Name:    mem_decoder_col - Behavioral 
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

entity mem_decoder_col is
Generic (
	constant C_DECODER_2x4_OUT : integer := 4;
	constant C_DECODER_4x16_OUT : integer := 16
);
Port (
	signal decoder_col_input : in std_logic_vector(6-1 downto 0);
	signal decoder_col_output : out std_logic_vector(2**6-1 downto 0);
	signal e : std_logic
);
end mem_decoder_col;

architecture Behavioral of mem_decoder_col is
	signal enable_a_col : std_logic_vector(C_DECODER_2x4_OUT-1 downto 0);
	component D2_4E is port(D0:out std_logic;D1:out std_logic;D2:out std_logic;D3:out std_logic;A0:in std_logic;A1:in std_logic;E:in std_logic); end component D2_4E;
	component D4_16E is port(D0:out std_logic;D1:out std_logic;D2:out std_logic;D3:out std_logic;D4:out std_logic;D5:out std_logic;D6:out std_logic;D7:out std_logic;D8:out std_logic;D9:out std_logic;D10:out std_logic;D11:out std_logic;D12:out std_logic;D13:out std_logic;D14:out std_logic;D15:out std_logic;A0:in std_logic;A1:in std_logic;A2:in std_logic;A3:in std_logic;E:in std_logic); end component D4_16E;
begin

--Work
--a : for i in (2**(decoder_col_input'left+1))-1 downto 0 generate
--	decoder_col_output(i) <= '1' when (i=to_integer(unsigned(decoder_col_input))) else '0';
--end generate a;

	bbb : for i in 0 to 1 generate
	begin
		qqq : if (i = 0) generate
			a : D2_4E port map (
			D0=>enable_a_col(0),
			D1=>enable_a_col(1),
			D2=>enable_a_col(2),
			D3=>enable_a_col(3),
			A0=>decoder_col_input(0),
			A1=>decoder_col_input(1),
			E=>e);
		end generate qqq;
		www : if (i = 1) generate
		b : for j in 0 to C_DECODER_2x4_OUT-1 generate
		begin
			c : D4_16E
			port map (
			D0=>decoder_col_output(C_DECODER_4x16_OUT*j+0),
			D1=>decoder_col_output(C_DECODER_4x16_OUT*j+1),
			D2=>decoder_col_output(C_DECODER_4x16_OUT*j+2),
			D3=>decoder_col_output(C_DECODER_4x16_OUT*j+3),
			D4=>decoder_col_output(C_DECODER_4x16_OUT*j+4),
			D5=>decoder_col_output(C_DECODER_4x16_OUT*j+5),
			D6=>decoder_col_output(C_DECODER_4x16_OUT*j+6),
			D7=>decoder_col_output(C_DECODER_4x16_OUT*j+7),
			D8=>decoder_col_output(C_DECODER_4x16_OUT*j+8),
			D9=>decoder_col_output(C_DECODER_4x16_OUT*j+9),
			D10=>decoder_col_output(C_DECODER_4x16_OUT*j+10),
			D11=>decoder_col_output(C_DECODER_4x16_OUT*j+11),
			D12=>decoder_col_output(C_DECODER_4x16_OUT*j+12),
			D13=>decoder_col_output(C_DECODER_4x16_OUT*j+13),
			D14=>decoder_col_output(C_DECODER_4x16_OUT*j+14),
			D15=>decoder_col_output(C_DECODER_4x16_OUT*j+15),
			A0=>decoder_col_input(2),
			A1=>decoder_col_input(3),
			A2=>decoder_col_input(4),
			A3=>decoder_col_input(5),
			E=>enable_a_col(j));
		end generate b;
		end generate www;
	end generate bbb;
end Behavioral;
