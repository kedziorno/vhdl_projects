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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity mem_decoder_row is
Generic (
	constant C_DECODER_3x8_OUT : integer := 8
);
Port (
	signal decoder_row_input : in std_logic_vector(9-1 downto 0);
	signal decoder_row_output : out std_logic_vector(2**9-1 downto 0)
);
end mem_decoder_row;

architecture Behavioral of mem_decoder_row is
	signal enable_a_row : std_logic_vector(C_DECODER_3x8_OUT-1 downto 0);
	signal enable_b_row : std_logic_vector((C_DECODER_3x8_OUT**2)-1 downto 0);
	component D3_8E is port(D0:out std_logic;D1:out std_logic;D2:out std_logic;D3:out std_logic;D4:out std_logic;D5:out std_logic;D6:out std_logic;D7:out std_logic;A0:in std_logic;A1:in std_logic;A2:in std_logic;E:in std_logic); end component D3_8E;
begin
	aaa : for i in 0 to 2 generate
	begin
		qwe : if (i = 0) generate a : D3_8E port map (D0 => enable_a_row(0),D1 => enable_a_row(1),D2 => enable_a_row(2),D3 => enable_a_row(3),D4 => enable_a_row(4),D5 => enable_a_row(5),D6 => enable_a_row(6),D7 => enable_a_row(7),A0 => decoder_row_input(0),A1 => decoder_row_input(1),A2 => decoder_row_input(2),E =>'1'); end generate qwe;
		asd : if (i = 1) generate b : for j in 0 to C_DECODER_3x8_OUT-1 generate begin c : D3_8E port map (D0=>enable_b_row(C_DECODER_3x8_OUT*j+0),D1=>enable_b_row(C_DECODER_3x8_OUT*j+1),D2=>enable_b_row(C_DECODER_3x8_OUT*j+2),D3=>enable_b_row(C_DECODER_3x8_OUT*j+3),D4=>enable_b_row(C_DECODER_3x8_OUT*j+4),D5=>enable_b_row(C_DECODER_3x8_OUT*j+5),D6=>enable_b_row(C_DECODER_3x8_OUT*j+6),D7=>enable_b_row(C_DECODER_3x8_OUT*j+7),A0=>decoder_row_input(3),A1=>decoder_row_input(4),A2=>decoder_row_input(5),E=>enable_a_row(j)); end generate b; end generate asd;
		zxc : if (i = 2) generate d : for j in 0 to (C_DECODER_3x8_OUT**2)-1 generate begin e : D3_8E port map (D0=>decoder_row_output(C_DECODER_3x8_OUT*j+0),D1=>decoder_row_output(C_DECODER_3x8_OUT*j+1),D2=>decoder_row_output(C_DECODER_3x8_OUT*j+2),D3=>decoder_row_output(C_DECODER_3x8_OUT*j+3),D4=>decoder_row_output(C_DECODER_3x8_OUT*j+4),D5=>decoder_row_output(C_DECODER_3x8_OUT*j+5),D6=>decoder_row_output(C_DECODER_3x8_OUT*j+6),D7=>decoder_row_output(C_DECODER_3x8_OUT*j+7),A0=>decoder_row_input(6),A1=>decoder_row_input(7),A2=>decoder_row_input(8),E=>enable_b_row(j)); end generate d; end generate zxc;
	end generate aaa;
end Behavioral;
