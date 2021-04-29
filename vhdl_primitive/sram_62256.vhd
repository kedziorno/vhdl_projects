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

	component mem_decoder_col is
	Port (
		signal decoder_col_input : in std_logic_vector(6-1 downto 0);
		signal decoder_col_output : out std_logic_vector(2**6-1 downto 0);
		signal e : std_logic
	);
	end component mem_decoder_col;
	component mem_decoder_row
	Port (
		signal decoder_row_input : IN  std_logic_vector(9-1 downto 0);
		signal decoder_row_output : OUT  std_logic_vector(2**9-1 downto 0);
		signal e : IN  std_logic
	);
	end component mem_decoder_row;

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

	type colt is array(memory_cols-1 downto 0) of std_logic_vector(data_size-1 downto 0); -- XXX 64 x 8bit = 512
	type ram is array(memory_rows-1 downto 0) of colt; -- XXX (64 x 8bit) x 512 = 256kb
	signal mem : ram;
	signal col : colt;

	function one_position(v : unsigned) return integer is
		variable r : integer := 0;
	begin
		l0 : for i in v'range loop
			if (v(v'high-i) = '1') then
				exit;
			else
				r := r + 1;
			end if;
		end loop l0;
		return r;
	end function one_position;

begin

	ceb <= not i_ceb;
	web <= not i_web;
	oeb <= not i_oeb;
	tristate_input <= ceb and web;
	tristate_output <= ceb and i_web and oeb;
	decoder_row_input <= i_address(10 downto 2); -- XXX
	decoder_col_input <= i_address(14 downto 11) & i_address(1 downto 0); -- XXX

--	col <= mem(one_position(unsigned(decoder_row_output))) when tristate_output = '1';
--	mem(one_position(unsigned(decoder_row_output))-1) <= col when tristate_input = '0';

	col(one_position(unsigned(decoder_col_output))) <= data_in when tristate_input = '1'; -- XXX work must div/srl
	data_out <= std_logic_vector(col(one_position(unsigned(decoder_col_output)))) when tristate_output = '1';

--	col(data_size-1 downto 0) <= unsigned(data_in) when tristate_input = '1'; -- XXX work
--	data_out <= std_logic_vector(col(data_size-1 downto 0)) when tristate_output = '1'; -- XXX work

	input_IOBUFDS_generate : for i in 0 to data_size-1 generate begin input_IOBUFDS_inst   : OBUFT port map (O=>data_in(i), I=>i_data(i),   T=>not tristate_input); end generate input_IOBUFDS_generate;
	output_OBUFTDS_generate : for i in 0 to data_size-1 generate begin output_OBUFTDS_inst : OBUFT port map (O=>o_data(i),  I=>data_out(i), T=>not tristate_output); end generate output_OBUFTDS_generate;

	mdc_entity : mem_decoder_col
	Port map (decoder_col_input=>decoder_col_input,decoder_col_output=>decoder_col_output,e=>'1');

	mdr_entity : mem_decoder_row
	Port map (decoder_row_input=>decoder_row_input,decoder_row_output=>decoder_row_output,e=>'1');

	infos : process (i_web,i_oeb) is
	begin
		if (i_web = '0') then
			REPORT "Write : " & integer'image(one_position(unsigned(decoder_col_output))) SEVERITY NOTE;
		end if;
		if (i_oeb = '0') then
			REPORT "Read : " & integer'image(one_position(unsigned(decoder_col_output))) SEVERITY NOTE;
		end if;
	end process infos;

end Behavioral;
