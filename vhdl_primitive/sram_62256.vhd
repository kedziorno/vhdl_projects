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

	component decoder is
	Generic (
	SIZE : integer := address_size
	);
	Port (
	input : in  integer range 0 to SIZE-1;
	output : out  integer range 1 to (2**SIZE)-1
	);
	end component decoder;

	constant memory_bits_rows : integer := 9;
	--constant memory_bits_rows : integer := address_size/2; -- XXX pow2
	constant memory_bits_cols : integer := 6;
	--constant memory_bits_cols : integer := address_size/2; -- XXX pow2

	-- 512x512 = 256k = 2**9x2**6*8bit
	--type memory_array is array(0 to (2**memory_bits_rows-1)*(2**memory_bits_cols-1)) of std_logic_vector(data_size-1 downto 0);
	type memory_row is array(0 to (2**memory_bits_rows)-1) of std_logic_vector(data_size-1 downto 0);
	type memory_array is array(0 to (2**memory_bits_cols)-1) of memory_row;

	--signal memory : memory_array(0 to (2**memory_bits_rows)-1,0 to (2**memory_bits_cols)-1*data_size);
	signal memory : memory_array := (others => (others => (others => '0')));
	signal ceb,web,oeb,tristate_input,tristate_output : std_logic;
	signal data_in,data_out : std_logic_vector(data_size-1 downto 0);
	signal decoder_row_input : integer range 0 to (address_size/2)-1;
	signal decoder_row_output : integer range 1 to (2**(address_size/2))-1;
	signal decoder_col_input : integer range 0 to (address_size/2)-1;
	signal decoder_col_output : integer range 1 to (2**(address_size/2))-1;

begin

	ceb <= not i_ceb;
	web <= not i_web;
	oeb <= not i_oeb;
	tristate_input <= ceb and web;
	tristate_output <= ceb and i_web and oeb;
	decoder_row_input <= to_integer(unsigned(i_address(10 downto 2))); -- XXX
	--decoder_row_input <= to_integer(unsigned(i_address(address_size-1 downto address_size/2))); -- XXX pow2
	decoder_col_input <= to_integer(unsigned(i_address(14 downto 11)) & unsigned(i_address(1 downto 0))); -- XXX
	--decoder_col_input <= to_integer(unsigned(i_address((address_size/2)-1 downto 0))); -- XXX pow2

	decoder_row : decoder
	Generic map (SIZE => memory_bits_rows)
	Port map (input => decoder_row_input,output => decoder_row_output);

	decoder_col : decoder
	Generic map (SIZE => memory_bits_cols)
	Port map (input => decoder_col_input,output => decoder_col_output);

	p0 : process (tristate_input,tristate_output) is
	begin
		if (tristate_input = '1') then
			memory(decoder_row_output)(decoder_col_output) <= data_in;
		end if;
		if (tristate_output = '1') then
			data_out <= memory(decoder_row_output)(decoder_col_output);
		end if;
	end process p0;

	input_IOBUFDS_generate : for i in 0 to data_size-1 generate
	begin
	input_IOBUFDS_inst : IOBUFDS
	port map (O => data_in(i),I => i_data(i),T => not tristate_input);
	end generate input_IOBUFDS_generate;

	output_IOBUFDS_generate : for i in 0 to data_size-1 generate
	begin
	output_IBUFDS_inst : IOBUFDS
	port map (O => o_data(i),I => data_out(i),T => tristate_output);
	end generate output_IOBUFDS_generate;

end Behavioral;
