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
	constant C_DECODER_2x4_OUT : integer := 4
);
Port (
	signal decoder_col_input : in std_logic_vector(6-1 downto 0);
	signal decoder_col_output : out std_logic_vector(2**6-1 downto 0);
	signal e : std_logic
);
end mem_decoder_col;

architecture Behavioral of mem_decoder_col is
	signal enable_a_col : std_logic_vector(C_DECODER_2x4_OUT-1 downto 0);
	signal enable_b_col : std_logic_vector((C_DECODER_2x4_OUT**2)-1 downto 0);
	component D2_4E is port(D0:out std_logic;D1:out std_logic;D2:out std_logic;D3:out std_logic;A0:in std_logic;A1:in std_logic;E:in std_logic); end component D2_4E;
begin
	bbb : for i in 0 to 2 generate
	begin
		qqq : if (i = 0) generate a : D2_4E port map (D0=>enable_a_col(0),D1=>enable_a_col(1),D2=>enable_a_col(2),D3=>enable_a_col(3),A0=>decoder_col_input(0),A1=>decoder_col_input(1),E=>e); end generate qqq;
		www : if (i = 1) generate b : for j in 0 to C_DECODER_2x4_OUT-1 generate begin c : D2_4E port map (D0=>enable_b_col(C_DECODER_2x4_OUT*j+0),D1=>enable_b_col(C_DECODER_2x4_OUT*j+1),D2=>enable_b_col(C_DECODER_2x4_OUT*j+2),D3=>enable_b_col(C_DECODER_2x4_OUT*j+3),A0=>decoder_col_input(2),A1=>decoder_col_input(3),E=>enable_a_col(j)); end generate b; end generate www;
		eee : if (i = 2) generate d : for j in 0 to (C_DECODER_2x4_OUT**2)-1 generate begin e : D2_4E port map (D0=>decoder_col_output(C_DECODER_2x4_OUT*j+0),D1=>decoder_col_output(C_DECODER_2x4_OUT*j+1),D2=>decoder_col_output(C_DECODER_2x4_OUT*j+2),D3=>decoder_col_output(C_DECODER_2x4_OUT*j+3),A0=>decoder_col_input(4),A1=>decoder_col_input(5),E=>enable_b_col(j)); end generate d; end generate eee;
	end generate bbb;
end Behavioral;
