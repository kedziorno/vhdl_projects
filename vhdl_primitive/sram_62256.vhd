----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:41:53 04/12/2021 
-- Design Name: 
-- Module Name:    sram_62256 - Behavioral 
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
use WORK.p_package1.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity sram_62256 is
Generic (
address_size : integer := 15; -- 2
data_size : integer := 8 -- 2
);
Port (
i_ceb : in  STD_LOGIC;
i_web : in  STD_LOGIC;
i_oeb : in  STD_LOGIC;
i_address : in  STD_LOGIC_VECTOR (address_size-1 downto 0);
i_data : in  STD_LOGIC_VECTOR (data_size-1 downto 0);
o_data : out  STD_LOGIC_VECTOR (data_size-1 downto 0)
);
end sram_62256;

architecture Behavioral of sram_62256 is
	-- XXX probe from Cypress_SRAM_CY62256.pdf LOGIC BLOCK DIAGRAM
	-- 512x512 = 256k = 2**9x2**6*8bit

	component D2_4E is port(D0:out std_logic;D1:out std_logic;D2:out std_logic;D3:out std_logic;A0:in std_logic;A1:in std_logic;E:in std_logic); end component D2_4E;
	component D3_8E is port(D0:out std_logic;D1:out std_logic;D2:out std_logic;D3:out std_logic;D4:out std_logic;D5:out std_logic;D6:out std_logic;D7:out std_logic;A0:in std_logic;A1:in std_logic;A2:in std_logic;E:in std_logic); end component D3_8E;

	constant memory_bits_rows : integer := 9;
	constant memory_bits_cols : integer := 6;
	constant memory_rows : integer := 2**memory_bits_rows;
	constant memory_cols : integer := 2**memory_bits_cols;
	constant memory_cols_bits : integer := memory_cols*data_size;

	signal ceb,web,oeb,tristate_input,tristate_output : std_logic;
	signal data_in,data_out : std_logic_vector(data_size-1 downto 0);

	signal decoder_row_input : std_logic_vector(memory_bits_rows-1 downto 0);
	signal decoder_col_input : std_logic_vector(memory_bits_cols-1 downto 0);

	signal decoder_row_output : std_logic_vector(memory_rows-1 downto 0);
	signal decoder_col_output : std_logic_vector(memory_cols-1 downto 0);

	signal decoder_row_int,decoder_col_int : integer;

	constant C_DECODER_2x4_OUT : integer := 4;
	signal enable_a_col : std_logic_vector(C_DECODER_2x4_OUT-1 downto 0);
	signal enable_b_col : std_logic_vector((C_DECODER_2x4_OUT**2)-1 downto 0);
	constant C_DECODER_3x8_OUT : integer := 8;
	signal enable_a_row : std_logic_vector(C_DECODER_3x8_OUT-1 downto 0);
	signal enable_b_row : std_logic_vector((C_DECODER_3x8_OUT**2)-1 downto 0);

	subtype colt is unsigned(memory_cols_bits-1 downto 0); -- XXX 64 x 8bit = 512
	subtype ram is unsigned((memory_rows*memory_cols_bits)-1 downto 0); -- XXX (64 x 8bit) x 512 = 256kb
	signal mem : ram;
	signal col : colt;

	signal col_wo_shift_r : std_logic_vector(31 downto 0);
	signal col_wo_shift_l : std_logic_vector(31 downto 0);
	signal col_wi_shift_r : std_logic_vector(31 downto 0);
	signal col_wi_shift_l : std_logic_vector(31 downto 0);

begin

	ceb <= not i_ceb;
	web <= not i_web;
	oeb <= not i_oeb;
	tristate_input <= ceb and web;
	tristate_output <= ceb and i_web and oeb;
	decoder_row_input <= i_address(10 downto 2); -- XXX
	decoder_col_input <= i_address(14 downto 11) & i_address(1 downto 0); -- XXX

	col_wo_shift_r <= std_logic_vector(to_unsigned(to_integer(unsigned(decoder_col_output))*data_size+(data_size-1),32)) when tristate_input = '0';
	col_wo_shift_l <= std_logic_vector(to_unsigned(to_integer(unsigned(decoder_col_output))*data_size+0,32)) when tristate_input = '0';
	col_wi_shift_r <= std_logic_vector(to_unsigned(to_integer(shift_right(unsigned(decoder_col_output),3)*data_size+(data_size-1)),32)) when tristate_input = '0';
	col_wi_shift_l <= std_logic_vector(to_unsigned(to_integer(shift_right(unsigned(decoder_col_output),3)*data_size+0),32)) when tristate_input = '0';

--	ggg : for i in 0 to memory_rows-1 generate col <= mem(i*memory_cols_bits+(memory_cols_bits-1) downto i*memory_cols_bits+0) when (decoder_row_output=std_logic_vector(to_unsigned(i,memory_rows))) else (others => '-'); end generate ggg;
--	hhh : for i in 0 to memory_rows-1 generate mem(i*memory_cols_bits+(memory_cols_bits-1) downto i*memory_cols_bits+0) <= col when (decoder_row_output=std_logic_vector(to_unsigned(i,memory_rows))) else (others => '-'); end generate hhh;
	col(to_integer(unsigned(col_wo_shift_r)) downto to_integer(unsigned(col_wo_shift_l))) <= unsigned(data_in) when tristate_input = '1';
--	col(
--	to_integer(shift_right(unsigned(decoder_col_output),3)*data_size+(data_size-1)) 
--	downto 
--	to_integer(shift_right(unsigned(decoder_col_output),3)*data_size+0)
--	) <= unsigned(data_in) when tristate_input = '1';

	data_out <= std_logic_vector(col(to_integer(unsigned(col_wo_shift_r)) downto to_integer(unsigned(col_wo_shift_l)))) when tristate_output = '1';
--	data_out <= std_logic_vector(
--	col(
--	to_integer(shift_right(unsigned(decoder_col_output),3)*data_size+(data_size-1)) 
--	downto 
--	to_integer(shift_right(unsigned(decoder_col_output),3)*data_size+0))
--	) when tristate_output = '1';

--	col(data_size-1 downto 0) <= unsigned(data_in) when tristate_input = '1'; -- XXX work
--	data_out <= std_logic_vector(col(data_size-1 downto 0)) when tristate_output = '1'; -- XXX work

	input_IOBUFDS_generate : for i in 0 to data_size-1 generate begin input_IOBUFDS_inst   : OBUFT port map (O=>data_in(i), I=>i_data(i),   T=>not tristate_input); end generate input_IOBUFDS_generate;
	output_OBUFTDS_generate : for i in 0 to data_size-1 generate begin output_OBUFTDS_inst : IOBUF port map (O=>o_data(i),  I=>data_out(i), T=>not tristate_output); end generate output_OBUFTDS_generate;

	bbb : for i in 0 to 2 generate
		qqq : if (i = 0) generate a : D2_4E port map (D0=>enable_a_col(0),D1=>enable_a_col(1),D2=>enable_a_col(2),D3=>enable_a_col(3),A0=>decoder_col_input(0),A1=>decoder_col_input(1),E=>not tristate_input); end generate qqq;
		www : if (i = 1) generate b : for j in 0 to C_DECODER_2x4_OUT-1 generate begin c : D2_4E port map (D0=>enable_b_col(C_DECODER_2x4_OUT*j+0),D1=>enable_b_col(C_DECODER_2x4_OUT*j+1),D2=>enable_b_col(C_DECODER_2x4_OUT*j+2),D3=>enable_b_col(C_DECODER_2x4_OUT*j+3),A0=>decoder_col_input(2),A1=>decoder_col_input(3),E=>enable_a_col(j)); end generate b; end generate www;
		eee : if (i = 2) generate d : for j in 0 to (C_DECODER_2x4_OUT**2)-1 generate begin e : D2_4E port map (D0=>decoder_col_output(C_DECODER_2x4_OUT*j+0),D1=>decoder_col_output(C_DECODER_2x4_OUT*j+1),D2=>decoder_col_output(C_DECODER_2x4_OUT*j+2),D3=>decoder_col_output(C_DECODER_2x4_OUT*j+3),A0=>decoder_col_input(4),A1=>decoder_col_input(5),E=>enable_b_col(j)); end generate d; end generate eee;
	end generate bbb;

	aaa : for i in 0 to 2 generate
	begin
		qwe : if (i = 0) generate a : D3_8E port map (D0 => enable_a_row(0),D1 => enable_a_row(1),D2 => enable_a_row(2),D3 => enable_a_row(3),D4 => enable_a_row(4),D5 => enable_a_row(5),D6 => enable_a_row(6),D7 => enable_a_row(7),A0 => decoder_row_input(0),A1 => decoder_row_input(1),A2 => decoder_row_input(2),E => not tristate_input); end generate qwe;
		asd : if (i = 1) generate b : for j in 0 to C_DECODER_3x8_OUT-1 generate begin c : D3_8E port map (D0=>enable_b_row(C_DECODER_3x8_OUT*j+0),D1=>enable_b_row(C_DECODER_3x8_OUT*j+1),D2=>enable_b_row(C_DECODER_3x8_OUT*j+2),D3=>enable_b_row(C_DECODER_3x8_OUT*j+3),D4=>enable_b_row(C_DECODER_3x8_OUT*j+4),D5=>enable_b_row(C_DECODER_3x8_OUT*j+5),D6=>enable_b_row(C_DECODER_3x8_OUT*j+6),D7=>enable_b_row(C_DECODER_3x8_OUT*j+7),A0=>decoder_row_input(3),A1=>decoder_row_input(4),A2=>decoder_row_input(5),E=>enable_a_row(j)); end generate b; end generate asd;
		zxc : if (i = 2) generate d : for j in 0 to (C_DECODER_3x8_OUT**2)-1 generate begin e : D3_8E port map (D0=>decoder_row_output(C_DECODER_3x8_OUT*j+0),D1=>decoder_row_output(C_DECODER_3x8_OUT*j+1),D2=>decoder_row_output(C_DECODER_3x8_OUT*j+2),D3=>decoder_row_output(C_DECODER_3x8_OUT*j+3),D4=>decoder_row_output(C_DECODER_3x8_OUT*j+4),D5=>decoder_row_output(C_DECODER_3x8_OUT*j+5),D6=>decoder_row_output(C_DECODER_3x8_OUT*j+6),D7=>decoder_row_output(C_DECODER_3x8_OUT*j+7),A0=>decoder_row_input(6),A1=>decoder_row_input(7),A2=>decoder_row_input(8),E=>enable_b_row(j)); end generate d; end generate zxc;
	end generate aaa;
end Behavioral;
