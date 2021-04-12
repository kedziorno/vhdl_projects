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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity sram_62256 is
Generic (
address_size : integer := 15;
data_size : integer := 8
);
Port (
i_ceb : in  STD_LOGIC;
i_web : in  STD_LOGIC;
i_oeb : in  STD_LOGIC;
i_address : in  STD_LOGIC_VECTOR (address_size-1 downto 0);
io_data : inout  STD_LOGIC_VECTOR (data_size-1 downto 0)
);
end sram_62256;

architecture Behavioral of sram_62256 is
	-- XXX probe from Cypress_SRAM_CY62256.pdf LOGIC BLOCK DIAGRAM

	component decoder is
	Generic (
	SIZE : integer := 4
	);
	Port (
	input : in  STD_LOGIC_VECTOR(SIZE-1 downto 0);
	output : out  STD_LOGIC_VECTOR(2**SIZE-1 downto 0)
	);
	end component decoder;

	constant memory_bits_rows : integer := 9;
	constant memory_bits_cols : integer := 6;	

	-- 512x512 = 256k = 2**9x2**6*8bit
	type memory_array is array(0 to (2**memory_bits_rows-1)*(2**memory_bits_cols-1)) of std_logic_vector(data_size-1 downto 0);

	signal memory : memory_array;
	signal ceb,web,oeb,tristate_input,tristate_output : std_logic;
	signal data : std_logic_vector(data_size-1 downto 0);
	signal decoder_row_input : std_logic_vector(memory_bits_rows-1 downto 0);
	signal decoder_row_output : std_logic_vector(2**memory_bits_rows-1 downto 0);
	signal decoder_col_input : std_logic_vector(memory_bits_cols-1 downto 0);
	signal decoder_col_output : std_logic_vector(2**memory_bits_cols-1 downto 0);

begin

	ceb <= not i_ceb;
	web <= not i_web;
	oeb <= not i_oeb;
	tristate_input <= ceb and web;
	tristate_output <= ceb and web and oeb;
	decoder_row_input <= i_address(10 downto 2); -- XXX
	decoder_col_input <= i_address(14 downto 11) & i_address(1 downto 0); -- XXX

	memory(to_integer(unsigned(decoder_row_input))*to_integer(unsigned(decoder_col_input))) <= data when tristate_input = '1';
	data <= memory(to_integer(unsigned(decoder_row_input))*to_integer(unsigned(decoder_col_input))) when tristate_output = '1';
	-- memory(decoder_row_output*decoder_col_output) <= io_data;

	decoder_row : decoder
	Generic map (SIZE => memory_bits_rows)
	Port map (input => decoder_row_input,output => decoder_row_output);

	decoder_col : decoder
	Generic map (SIZE => memory_bits_cols)
	Port map (input => decoder_col_input,output => decoder_col_output);

	input_OBUFT_generate : for i in 0 to data_size-1 generate
	begin
	input_OBUFT_inst : OBUFT
	port map (O => data(i),I => io_data(i),T => tristate_input);
	end generate input_OBUFT_generate;

	output_OBUFT_generate : for i in 0 to data_size-1 generate
	begin
	output_OBUFT_inst : OBUFT
	port map (O => io_data(i),I => data(i),T => tristate_output);
	end generate output_OBUFT_generate;

end Behavioral;