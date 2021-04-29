----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:59:12 04/25/2021 
-- Design Name: 
-- Module Name:    mem_decoder_row - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity mem_decoder_row is
Generic (
	constant C_DECODER_4x16_OUT : integer := 16
);
Port (
	signal decoder_row_input : in std_logic_vector(9-1 downto 0);
	signal decoder_row_output : out std_logic_vector(2**9-1 downto 0);
	e : in std_logic
);
end mem_decoder_row;

architecture Behavioral of mem_decoder_row is
	signal enable_a_row : std_logic_vector(1 downto 0);
	signal enable_b_row : std_logic_vector((C_DECODER_4x16_OUT*2)-1 downto 0);
	component D4_16E is port(D0:out std_logic;D1:out std_logic;D2:out std_logic;D3:out std_logic;D4:out std_logic;D5:out std_logic;D6:out std_logic;D7:out std_logic;D8:out std_logic;D9:out std_logic;D10:out std_logic;D11:out std_logic;D12:out std_logic;D13:out std_logic;D14:out std_logic;D15:out std_logic;A0:in std_logic;A1:in std_logic;A2:in std_logic;A3:in std_logic;E:in std_logic); end component D4_16E;
begin

	enable_a_row(0) <= e and (not decoder_row_input(8));
	enable_a_row(1) <= e and (decoder_row_input(8));

	aaa : for i in 0 to 2 generate
	begin
		qwe : if (i = 0) generate
			f : for j in 0 to 1 generate
				c : D4_16E
				port map (
				D0=>enable_b_row(C_DECODER_4x16_OUT*j+0),
				D1=>enable_b_row(C_DECODER_4x16_OUT*j+1),
				D2=>enable_b_row(C_DECODER_4x16_OUT*j+2),
				D3=>enable_b_row(C_DECODER_4x16_OUT*j+3),
				D4=>enable_b_row(C_DECODER_4x16_OUT*j+4),
				D5=>enable_b_row(C_DECODER_4x16_OUT*j+5),
				D6=>enable_b_row(C_DECODER_4x16_OUT*j+6),
				D7=>enable_b_row(C_DECODER_4x16_OUT*j+7),
				D8=>enable_b_row(C_DECODER_4x16_OUT*j+8),
				D9=>enable_b_row(C_DECODER_4x16_OUT*j+9),
				D10=>enable_b_row(C_DECODER_4x16_OUT*j+10),
				D11=>enable_b_row(C_DECODER_4x16_OUT*j+11),
				D12=>enable_b_row(C_DECODER_4x16_OUT*j+12),
				D13=>enable_b_row(C_DECODER_4x16_OUT*j+13),
				D14=>enable_b_row(C_DECODER_4x16_OUT*j+14),
				D15=>enable_b_row(C_DECODER_4x16_OUT*j+15),
				A0=>decoder_row_input(4),
				A1=>decoder_row_input(5),
				A2=>decoder_row_input(6),
				A3=>decoder_row_input(7),
				E=>enable_a_row(j));
			end generate f;
		end generate qwe;
		asd : if (i = 1) generate
			b : for j in 0 to 2*C_DECODER_4x16_OUT-1 generate
			begin
				c : D4_16E
				port map (
				D0=>decoder_row_output(C_DECODER_4x16_OUT*j+0),
				D1=>decoder_row_output(C_DECODER_4x16_OUT*j+1),
				D2=>decoder_row_output(C_DECODER_4x16_OUT*j+2),
				D3=>decoder_row_output(C_DECODER_4x16_OUT*j+3),
				D4=>decoder_row_output(C_DECODER_4x16_OUT*j+4),
				D5=>decoder_row_output(C_DECODER_4x16_OUT*j+5),
				D6=>decoder_row_output(C_DECODER_4x16_OUT*j+6),
				D7=>decoder_row_output(C_DECODER_4x16_OUT*j+7),
				D8=>decoder_row_output(C_DECODER_4x16_OUT*j+8),
				D9=>decoder_row_output(C_DECODER_4x16_OUT*j+9),
				D10=>decoder_row_output(C_DECODER_4x16_OUT*j+10),
				D11=>decoder_row_output(C_DECODER_4x16_OUT*j+11),
				D12=>decoder_row_output(C_DECODER_4x16_OUT*j+12),
				D13=>decoder_row_output(C_DECODER_4x16_OUT*j+13),
				D14=>decoder_row_output(C_DECODER_4x16_OUT*j+14),
				D15=>decoder_row_output(C_DECODER_4x16_OUT*j+15),
				A0=>decoder_row_input(0),
				A1=>decoder_row_input(1),
				A2=>decoder_row_input(2),
				A3=>decoder_row_input(3),
				E=>enable_b_row(j));
			end generate b;
		end generate asd;
	end generate aaa;
end Behavioral;
