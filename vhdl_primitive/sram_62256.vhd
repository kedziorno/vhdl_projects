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
address_size : integer := 8;
data_size : integer := 8
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

--	component mem_decoder_col is
--	Port (
--		signal decoder_col_input : in std_logic_vector(4-1 downto 0);
--		signal decoder_col_output : out std_logic_vector(2**4-1 downto 0);
--		signal e : std_logic
--	);
--	end component mem_decoder_col;
--	component mem_decoder_row
--	Port (
--		signal decoder_row_input : IN  std_logic_vector(4-1 downto 0);
--		signal decoder_row_output : OUT  std_logic_vector(2**4-1 downto 0);
--		signal e : IN  std_logic
--	);
--	end component mem_decoder_row;

	component sram_cell is
	Generic (
		N : integer := 4
	);
	Port (
		i_ce : in std_logic;
		i_we : in std_logic;
		i_oe : in std_logic;
		i_address_row : in std_logic_vector(N-1 downto 0);
		i_address_col : in std_logic_vector(N-1 downto 0);
		i_bit : in std_logic;
		o_bit : out std_logic
	);
	end component sram_cell;

	constant memory_bits_rows : integer := address_size/2;
	constant memory_bits_cols : integer := address_size/2;
	constant memory_rows : integer := 2**memory_bits_rows;
	constant memory_cols : integer := 2**memory_bits_cols;
	constant memory_cols_bits : integer := memory_cols*data_size;

	signal ceb,web,oeb,tristate_input,tristate_output : std_logic;
	signal data_in,data_out : std_logic_vector(data_size-1 downto 0);

	signal decoder_row_input : std_logic_vector(memory_bits_rows-1 downto 0);
	signal decoder_col_input : std_logic_vector(memory_bits_cols-1 downto 0);

--	signal decoder_row_output : std_logic_vector(memory_rows-1 downto 0);
--	signal decoder_col_output : std_logic_vector(memory_cols-1 downto 0);

--	type ram is array(memory_rows-1 downto 0,memory_cols-1 downto 0) of std_logic_vector(data_size-1 downto 0);
--	signal mem : ram;

	function one_position(v : unsigned) return integer is
		variable r : integer;
	begin
		if (v'ascending = true) then
			r := 0;
			l0 : for i in 0 to v'left loop
				if (v(i) = '1') then
					exit;
				else
					r := r + 1;
				end if;
			end loop l0;
		elsif (v'ascending = false) then
			r := v'left;
			l1 : for i in v'left downto 0 loop
				if (v(i) = '1') then
					exit;
				else
					r := r - 1;
				end if;
			end loop l1;
		end if;
		return r;
	end function one_position;

--	signal bufi1,bufi2 : std_logic := '0';
--	signal bufo1,bufo2 : std_logic := '0';
	signal a3,b3 : std_logic;

begin

--	b3 <= web when i_ceb='0' else not web;
--	bufi <= '1' when (falling_edge(tristate_input))
--	else '0';
--	bufo <= '1' when (falling_edge(tristate_output))
--	else '0';

--	LDCPE_bufi1 : LDCPE port map (Q=>bufi2,D=>bufi1,GE=>'1',G=>'1',CLR=>not ceb,PRE=>web);
--	LDCPE_bufi2 : LDCPE port map (Q=>bufi1,D=>bufi2,GE=>'1',G=>'1',CLR=>'0',PRE=>'0');
--	bufo1 <= bufi1 xor bufi2;

	b3 <= not a3;
	LDCPE_bufo1 : LDCPE port map (Q=>a3,D=>b3,GE=>'1',G=>'1',CLR=>not web,PRE=>web);
--	LDCPE_bufo2 : LDCPE port map (Q=>a3,D=>b3,GE=>'1',G=>'1',CLR=>'0',PRE=>bufo1);

--	BUFG_inst2 : LDCPE port map (
--	Q => bufo,D => tristate_output, GE => not i_ceb, G => tristate_output, CLR => '0', PRE => '0');

	ceb <= not i_ceb;
	web <= not i_web;
	oeb <= not i_oeb;
--	tristate_input <= ceb and web;
	tristate_output <= ceb and i_web and oeb;
--	decoder_row_input <= i_address(5 downto 2); -- XXX
--	decoder_col_input <= i_address(7 downto 6) & i_address(1 downto 0); -- XXX
	decoder_row_input <= i_address(address_size-1 downto address_size/2); -- XXX
	decoder_col_input <= i_address(address_size/2-1 downto 0); -- XXX
--	decoder_row_input <= i_address(7 downto 4); -- XXX
--	decoder_col_input <= i_address(3 downto 0); -- XXX
--	decoder_col_input <= i_address; -- XXX

--	process (tristate_input,tristate_output,decoder_row_output,decoder_col_output,data_in) is
--		variable r : integer range 0 to 2**memory_rows-1;
--		variable c : integer range 0 to 2**memory_cols-1;
--	begin
--		r := one_position(unsigned(decoder_row_output));
--		c := one_position(unsigned(decoder_col_output));
--		if (falling_edge(tristate_input) and tristate_output = '0') then
--			mem(r,c) <= data_in;
--		end if;
--		if (tristate_input = '0' and rising_edge(tristate_output)) then
--			data_out <= mem(r,c);
--		end if;
--	end process;

	sram_data_generate : for i in 0 to data_size-1 generate
		sram_cell_entity : sram_cell
		Generic map (N=>memory_bits_rows) Port map (
		i_ce=>ceb,
		i_we=>web,
		i_oe=>oeb,
		i_address_row=>decoder_row_input,
		i_address_col=>decoder_col_input,
		i_bit=>data_in(i),
		o_bit=>data_out(i)
	);
	end generate sram_data_generate;

	input_IOBUFDS_generate : for i in 0 to data_size-1 generate
--		input_IOBUFDS_inst  : IOBUF port map (O=>data_in(i), I=>i_data(i),   T=>not tristate_input);
		input_IOBUFDS_inst  : IBUF port map (O=>data_in(i), I=>i_data(i));
	end generate input_IOBUFDS_generate;
	output_OBUFTDS_generate : for i in 0 to data_size-1 generate
		output_OBUFTDS_inst : IOBUF port map (O=>o_data(i),  I=>data_out(i), T=>tristate_output);
	end generate output_OBUFTDS_generate;

--	mdc_entity : mem_decoder_col
--	Port map (decoder_col_input=>decoder_col_input,decoder_col_output=>decoder_col_output,e=>'1');

--	mdr_entity : mem_decoder_row
--	Port map (decoder_row_input=>decoder_row_input,decoder_row_output=>decoder_row_output,e=>'1');

end Behavioral;
