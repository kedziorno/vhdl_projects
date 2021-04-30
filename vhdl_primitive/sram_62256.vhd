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

	component mem_decoder_col is
	Port (
		signal decoder_col_input : in std_logic_vector(4-1 downto 0);
		signal decoder_col_output : out std_logic_vector(2**4-1 downto 0);
		signal e : std_logic
	);
	end component mem_decoder_col;
	component mem_decoder_row
	Port (
		signal decoder_row_input : IN  std_logic_vector(4-1 downto 0);
		signal decoder_row_output : OUT  std_logic_vector(2**4-1 downto 0);
		signal e : IN  std_logic
	);
	end component mem_decoder_row;

	constant memory_bits_rows : integer := 4;
	constant memory_bits_cols : integer := 4;
	constant memory_rows : integer := 2**memory_bits_rows;
	constant memory_cols : integer := 2**memory_bits_cols;
	constant memory_cols_bits : integer := memory_cols*data_size;

	signal ceb,web,oeb,tristate_input,tristate_output : std_logic;
	signal data_in,data_out : std_logic_vector(data_size-1 downto 0);

	signal decoder_row_input : std_logic_vector(memory_bits_rows-1 downto 0);
	signal decoder_col_input : std_logic_vector(memory_bits_cols-1 downto 0);

	signal decoder_row_output : std_logic_vector(memory_rows-1 downto 0);
	signal decoder_col_output : std_logic_vector(memory_cols-1 downto 0);

--	type colt is array(memory_cols-1 downto 0) of std_logic_vector(data_size-1 downto 0);
--	type ram is array(memory_rows-1 downto 0) of colt;
--	signal mem : ram;
--	signal col : colt;

	subtype colt is unsigned(memory_cols_bits-1 downto 0);
	subtype ram is unsigned((memory_rows*memory_cols_bits)-1 downto 0);
	signal mem : ram;
	signal col : colt;

	impure function one_position(v : unsigned) return integer is
		variable r : integer := 0;
	begin
		--report "range : left = " & integer'image(v'left) & " , right = " & integer'image(v'right) severity note;
		if (v'ascending = true) then
			l0 : for i in 0 to v'left-1 loop
				--report "index : i = " & integer'image(i) severity note;
				if (v(v'left-1-i) = '1') then
					exit;
				else
					r := r + 1;
				end if;
			end loop l0;
			return r;
		else
			l1 : for i in v'left-1 downto 0 loop
				--report "index : i = " & integer'image(i) severity note;
				if (v(v'left-1-i) = '1') then
					exit;
				else
					r := r + 1;
				end if;
			end loop l1;
			return r;
		end if;
	end function one_position;

begin

	ceb <= not i_ceb;
	web <= not i_web;
	oeb <= not i_oeb;
	tristate_input <= ceb and web;
	tristate_output <= ceb and i_web and oeb;
	decoder_row_input <= i_address(5 downto 2); -- XXX
	decoder_col_input <= i_address(7 downto 6) & i_address(1 downto 0); -- XXX

-- XXX col v1
--	ggg : for i in 0 to memory_cols-1 generate
--		col(i*data_size+(data_size-1) downto i*data_size+0) <= unsigned(data_in) when (decoder_row_output=std_logic_vector(to_unsigned(i,memory_rows)) and tristate_input='1');
--	end generate ggg;
--	hhh : for i in 0 to memory_rows-1 generate
--		data_out <= std_logic_vector(col(i*data_size+(data_size-1) downto i*data_size+0)) when (decoder_row_output=std_logic_vector(to_unsigned(i,memory_rows)) and tristate_output='1');
--	end generate hhh;

-- XXX col v2
	col(one_position(unsigned(decoder_col_output))*data_size+(data_size-1) downto one_position(unsigned(decoder_col_output))*data_size+0) <= unsigned(data_in) when tristate_input='1';
	data_out <= std_logic_vector(col(one_position(unsigned(decoder_col_output))*data_size+(data_size-1) downto one_position(unsigned(decoder_col_output))*data_size+0)) when tristate_output='1';

-- XXX row v1
--	ggg : for i in 0 to memory_cols-1 generate
--		col <= mem(i*memory_cols_bits+(memory_cols_bits-1) downto i*memory_cols_bits+(0)) when (decoder_row_output=std_logic_vector(to_unsigned(i,memory_rows)) and tristate_output='0');
--	end generate ggg;
--	hhh : for i in 0 to memory_rows-1 generate
--		mem(i*memory_cols_bits+(memory_cols_bits-1) downto i*memory_cols_bits+(0)) <= col when (decoder_row_output=std_logic_vector(to_unsigned(i,memory_rows)) and tristate_input='0');
--	end generate hhh;

-- XXX row v2
	col <= mem(one_position(unsigned(decoder_row_output))*memory_cols_bits+(memory_cols_bits-1) downto one_position(unsigned(decoder_row_output))*memory_cols_bits+(0))
	when (tristate_output='0' and tristate_input='1');
	mem(one_position(unsigned(decoder_row_output))*memory_cols_bits+(memory_cols_bits-1) downto one_position(unsigned(decoder_row_output))*memory_cols_bits+(0)) <= col
	when (tristate_output='0' and tristate_input='0');

--	ggg : for i in 0 to memory_cols-1 generate
--		col <= mem(i) when (decoder_row_output=std_logic_vector(to_unsigned(i,memory_rows)) and tristate_output='1');
--	end generate ggg;
--	hhh : for i in 0 to memory_rows-1 generate
--		mem(i) <= col when (decoder_row_output=std_logic_vector(to_unsigned(i,memory_rows)) and tristate_input='1');
--	end generate hhh;

--	ggg : for i in 0 to memory_rows-1 generate
--		a : if (tristate_output='1') generate
--			col <= mem(one_position(unsigned(decoder_row_output))) when (decoder_row_output=std_logic_vector(to_unsigned(i,memory_rows)));
--		end generate a;
--		b : if (tristate_input='1') generate
--			mem(one_position(unsigned(decoder_row_output))) <= col when (decoder_row_output=std_logic_vector(to_unsigned(i,memory_rows)));
--		end generate b;
--			col <= mem(one_position(unsigned(decoder_row_output))) when (decoder_row_output=std_logic_vector(to_unsigned(i,memory_rows)) and tristate_output='1') else
--			mem(one_position(unsigned(decoder_row_output))) <= col when (decoder_row_output=std_logic_vector(to_unsigned(i,memory_rows)));
--	end generate ggg;

--	ggg : for i in 0 to memory_rows-1 generate
--		col <= mem(i) when (decoder_row_output=std_logic_vector(to_unsigned(i,memory_rows)) and tristate_output='1');
--	end generate ggg;
--	hhh : for i in 0 to memory_rows-1 generate
--		mem(i) <= col when (decoder_row_output=std_logic_vector(to_unsigned(i,memory_rows)) and tristate_input='1');
--	end generate hhh;

--	ggg : for i in 0 to memory_rows-1 generate
--		col <= mem(i) when (one_position(unsigned(decoder_row_output))=i);
--	end generate ggg;
--	hhh : for i in 0 to memory_rows-1 generate
--		mem(i) <= col when (one_position(unsigned(decoder_row_output))=i);
--	end generate hhh;

--	aaa : for i in 0 to memory_rows-1 generate
--		col <= mem(i)
--		when one_position(unsigned(decoder_row_output))=i and tristate_output='0';
--	end generate aaa;
--	bbb : for i in 0 to memory_cols-1 generate
--		data_out <= col(i)
--		when one_position(unsigned(decoder_col_output))=i and tristate_output='0';
--	end generate bbb;
--	hhh : for i in 0 to memory_rows-1 generate
--		mem(i) <= col
--		when one_position(unsigned(decoder_row_output))=i and tristate_input='0';
--	end generate hhh;
--	ggg : for i in 0 to memory_cols-1 generate
--		col(i) <= data_in
--		when one_position(unsigned(decoder_col_output))=i and tristate_input='0';
--	end generate ggg;

--	process (tristate_input,tristate_output,decoder_row_input,decoder_row_output) is
--	begin
--		if (tristate_input = '0') then
--			data_out <= col(one_position(unsigned(decoder_col_output)));
--		elsif (tristate_input = '1') then
--			mem(one_position(unsigned(decoder_row_output))) <= col;
--		end if;
--		if (tristate_output = '0') then
--			col(one_position(unsigned(decoder_col_output))) <= data_in;
--		elsif (tristate_output = '1') then
--			col <= mem(one_position(unsigned(decoder_row_output)));
--		end if;
--	end process;

--	process (tristate_input,tristate_output,decoder_row_input,decoder_row_output) is
--		variable a : std_logic_vector(1 downto 0);
--	begin
--		a := tristate_input & tristate_output;
--		case (a) is
--			when "00" =>
--				data_out <= col(one_position(unsigned(decoder_col_output)));
--				col(one_position(unsigned(decoder_col_output))) <= data_in;
--			when "01" =>
--				data_out <= col(one_position(unsigned(decoder_col_output)));
--				mem(one_position(unsigned(decoder_row_output))) <= col;
--			when "10" =>
--				mem(one_position(unsigned(decoder_row_output))) <= col;
--				col(one_position(unsigned(decoder_col_output))) <= data_in;
--			when "11" =>
--				mem(one_position(unsigned(decoder_row_output))) <= col;
--				col <= mem(one_position(unsigned(decoder_row_output)));
--			when others => null;
--		end case;
--	end process;

	input_IOBUFDS_generate : for i in 0 to data_size-1 generate
		input_IOBUFDS_inst  : OBUFT port map (O=>data_in(i), I=>i_data(i),   T=>not tristate_input);
	end generate input_IOBUFDS_generate;
	output_OBUFTDS_generate : for i in 0 to data_size-1 generate
		output_OBUFTDS_inst : OBUFT port map (O=>o_data(i),  I=>data_out(i), T=>not tristate_output);
	end generate output_OBUFTDS_generate;

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
