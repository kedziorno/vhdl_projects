----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:07:54 10/27/2020 
-- Design Name: 
-- Module Name:    memory1 - Behavioral 
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
use WORK.p_memory_content.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
-- pragma translate_off
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
-- pragma translate_on

entity memory1 is
Port (
i_clk : in std_logic;
i_reset : in std_logic;
i_copy_content : in std_logic;
o_copy_content : out std_logic;
i_enable_byte : in std_logic;
i_enable_bit : in std_logic;
i_write_byte : in std_logic;
i_write_bit : in std_logic;
i_row : in std_logic_vector(ROWS_BITS-1 downto 0);
i_col_pixel : in std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
i_col_block : in std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
i_byte : in std_logic_vector(BYTE_BITS-1 downto 0);
i_bit : in std_logic;
o_byte : out std_logic_vector(BYTE_BITS-1 downto 0);
o_bit : out std_logic
);
end memory1;

architecture Behavioral of memory1 is

component RAMB16_S36
generic (
WRITE_MODE : string := "NO_CHANGE"; -- WRITE_FIRST/READ_FIRST/NO_CHANGE
INIT : bit_vector(35 downto 0) := X"000000000";
SRVAL : bit_vector(35 downto 0) := X"012345678"
);
port (
DI    : in std_logic_vector (31 downto 0);
DIP   : in std_logic_vector (3 downto 0);
ADDR  : in std_logic_vector (8 downto 0);
EN    : in STD_LOGIC;
WE    : in STD_LOGIC;
SSR   : in STD_LOGIC;
CLK   : in STD_LOGIC;
DO    : out std_logic_vector (31 downto 0);
DOP   : out std_logic_vector (3 downto 0)
);
end component;

signal DATA_IN : std_logic_vector(WORD_BITS-1 downto 0);
signal DATA_INP : std_logic_vector(PARITY_BITS-1 downto 0);
signal ADDRESS : std_logic_vector(BRAM_ADDRESS_BITS-1 downto 0);
signal ENABLE : std_logic;
signal WRITE_EN : std_logic;
signal DATA_OUT : std_logic_vector(WORD_BITS-1 downto 0);
signal DATA_OUTP : std_logic_vector(PARITY_BITS-1 downto 0);

type p0_states is (idle,start,write_content,done_copy);
signal p0_state : p0_states;
signal p0_index : integer range 0 to ROWS - 1;
signal p0_enable,p1_enable,p2_enable,p3_enable,p4_enable : std_logic;
signal p0_write_en,p1_write_en,p2_write_en,p3_write_en,p4_write_en : std_logic;
signal p0_address,p1_address,p2_address,p3_address,p4_address : std_logic_vector(BRAM_ADDRESS_BITS-1 downto 0);
signal p0_data_in,p1_data_in,p2_data_in,p3_data_in,p4_data_in : std_logic_vector(WORD_BITS-1 downto 0);
signal p2_obyte : std_logic_vector(BYTE_BITS-1 downto 0);
signal p4_obit : std_logic;

function vec2str(vec: std_logic_vector) return string is
		variable result: string(vec'left downto 0);
	begin
		for i in vec'range loop
			if (vec(i) = '1') then
				result(i) := '1';
			elsif (vec(i) = '0') then
				result(i) := '0';
			elsif (vec(i) = 'X') then
				result(i) := 'X';
			elsif (vec(i) = 'U') then
				result(i) := 'U';
			else
				result(i) := '?';
			end if;
		end loop;
		return result;
	end;
begin

o_byte <= p2_obyte;
o_bit <= p4_obit;

p0a : process(i_clk) is
	variable t_enable : std_logic_vector(4 downto 0);
begin
	if (rising_edge(i_clk)) then
		t_enable := (i_copy_content,i_enable_byte,i_enable_bit,i_write_byte,i_write_bit);
--		report "enable " & vec2str(t_enable);
		case(t_enable) is
			when "10000" =>
				ENABLE <= p0_enable;
			when "01010" =>
				ENABLE <= p1_enable;
			when "01000" =>
				ENABLE <= p2_enable;
			when "00101" =>
				ENABLE <= p3_enable;
			when "00100" =>
				ENABLE <= p4_enable;
			when others =>
				ENABLE <= '0';
		end case;
	end if;
end process p0a;

p1a : process(i_clk) is
	variable t_write_en : std_logic_vector(4 downto 0);
begin
	if (rising_edge(i_clk)) then
		t_write_en := (i_copy_content,i_enable_byte,i_enable_bit,i_write_byte,i_write_bit);
--		report "write_en " & vec2str(t_write_en);
		case(t_write_en) is
			when "10000" =>
				WRITE_EN <= p0_write_en;
			when "01010" =>
				WRITE_EN <= p1_write_en;
			when "01000" =>
				WRITE_EN <= p2_write_en;
			when "00101" =>
				WRITE_EN <= p3_write_en;
			when "00100" =>
				WRITE_EN <= p4_write_en;
			when others =>
				WRITE_EN <= '0';
		end case;
	end if;
end process p1a;

p2a : process(i_clk) is
	variable t_address : std_logic_vector(4 downto 0);
begin
	if (rising_edge(i_clk)) then
		t_address := (i_copy_content,i_enable_byte,i_enable_bit,i_write_byte,i_write_bit);
--		report "address " & vec2str(t_address);
		case(t_address) is
			when "10000" =>
				ADDRESS <= p0_address;
			when "01010" =>
				ADDRESS <= p1_address;
			when "01000" =>
				ADDRESS <= p2_address;
			when "00101" =>
				ADDRESS <= p3_address;
			when "00100" =>
				ADDRESS <= p4_address;
			when others =>
				ADDRESS <= (others => '0');
		end case;
	end if;
end process p2a;

p3a : process(i_clk) is
	variable t_data_in : std_logic_vector(4 downto 0);
begin
	if (rising_edge(i_clk)) then
		t_data_in := (i_copy_content,i_enable_byte,i_enable_bit,i_write_byte,i_write_bit);
--		report "data_in " & vec2str(t_data_in);
		case(t_data_in) is
			when "10000" =>
				DATA_IN <= p0_data_in;
			when "01010" =>
				DATA_IN <= p1_data_in;
			when "01000" =>
				DATA_IN <= p2_data_in;
			when "00101" =>
				DATA_IN <= p3_data_in;
			when "00100" =>
				DATA_IN <= p4_data_in;
			when others =>
				DATA_IN <= (others => '0');
		end case;
	end if;
end process p3a;

p0 : process (i_clk,i_reset) is
begin
	if (i_reset = '1') then
		p0_state <= idle;
		p0_index <= 0;
		p0_enable <= '0';
		p0_write_en <= '0';
		p0_address <= (others => '0');
		p0_data_in <= (others => '0');
		o_copy_content <= '0';
	elsif (rising_edge(i_clk)) then
		case (p0_state) is
			when idle =>
				if (i_copy_content = '1') then
					p0_state <= start;
				else
					p0_state <= idle;
				end if;
				p0_state <= start;
				p0_enable <= '0';
				p0_write_en <= '0';
			when start =>
				p0_state <= write_content;
				p0_enable <= '1';
				p0_write_en <= '1';
				p0_address <= std_logic_vector(to_unsigned(p0_index,BRAM_ADDRESS_BITS));
				p0_data_in <= memory_content(p0_index);
			when write_content =>
				p0_enable <= '0';
				p0_write_en <= '0';
				if (p0_index = ROWS-1) then
					p0_state <= done_copy;
					p0_index <= 0;
				else
					p0_state <= idle;
					p0_index <= p0_index + 1;
				end if;
			when done_copy =>
				p0_state <= done_copy;
				o_copy_content <= '1';
				p0_enable <= '0';
				p0_write_en <= '0';
				p0_address <= (others => '0');
				p0_data_in <= (others => '0');
		end case;
	end if;
end process p0;

p1 : process (i_reset,i_enable_byte,i_write_byte,i_row,DATA_IN,i_byte,DATA_OUT) is
	variable p1_t0 : std_logic_vector(WORD_BITS-1 downto 0);
	variable p1_t1 : std_logic_vector(WORD_BITS-1 downto 0);
begin
	p1_t0 := DATA_OUT;
	if (i_reset = '1') then
		p1_enable <= '0';
		p1_write_en <= '0';
		p1_address <= (others => '0');
		p1_data_in <= (others => '0');
		p1_t1 := (others => '0');
	elsif (i_enable_byte = '1' and i_write_byte = '1') then
		p1_enable <= '1';
		p1_write_en <= '1';
		p1_address <= std_logic_vector(to_unsigned(0,BRAM_ADDRESS_BITS-ROWS_BITS)) & i_row;
		case (to_integer(unsigned(i_col_block))) is
			when 0 =>
				p1_t1 := p1_t0(31 downto 8) & i_byte;
			when 1 =>
				p1_t1 := p1_t0(31 downto 16) & i_byte & p1_t0(7 downto 0);
			when 2 =>
				p1_t1 := p1_t0(31 downto 24) & i_byte & p1_t0(15 downto 0);
			when 3 =>
				p1_t1 := i_byte & p1_t0(23 downto 0);
			when others => null;
		end case;
		p1_data_in <= p1_t1;
	else
		p1_write_en <= '0';
		p1_enable <= '0';
		p1_data_in <= (others => '0');
		p1_address <= (others => '0');
		p1_t1 := (others => '0');
	end if;
end process p1;

p2 : process (i_reset,i_enable_byte,i_write_byte,i_row,DATA_OUT) is
	variable p2_t : std_logic_vector(BYTE_BITS-1 downto 0);
begin
	if (i_reset = '1') then
		p2_enable <= '0';
		p2_write_en <= '0';
		p2_address <= (others => '0');
		p2_data_in <= (others => '0');
		p2_obyte <= (others => '0');
		p2_t := (others => '0');
	elsif (i_enable_byte = '1' and i_write_byte = '0') then
		p2_enable <= '1';
		p2_write_en <= '0';
		p2_address <= std_logic_vector(to_unsigned(0,BRAM_ADDRESS_BITS-ROWS_BITS)) & i_row;
		case (to_integer(unsigned(i_col_block))) is
			when 0 =>
				p2_t := DATA_OUT(7 downto 0);
			when 1 =>
				p2_t := DATA_OUT(15 downto 8);
			when 2 =>
				p2_t := DATA_OUT(23 downto 16);
			when 3 =>
				p2_t := DATA_OUT(31 downto 24);
			when others => null;
		end case;
		p2_obyte <= p2_t;
	else
		p2_enable <= '0';
		p2_address <= (others => '0');
		p2_obyte <= (others => '0');
		p2_t := (others => '0');
	end if;
end process p2;

p3 : process (i_reset,i_enable_bit,i_write_bit,p3_data_in,i_row,i_bit) is
	variable i : integer range 0 to WORD_BITS-1;
	variable p3_t : std_logic_vector(WORD_BITS-1 downto 0);
begin
	i := to_integer(unsigned(i_col_pixel));
	p3_t := p3_data_in;
	if (i_reset = '1') then
		p3_enable <= '0';
		p3_write_en <= '0';
		p3_address <= (others => '0');
		p3_data_in <= (others => '0');
	elsif (i_enable_bit = '1' and i_write_bit = '1') then
		p3_enable <= '1';
		p3_write_en <= '1';
		p3_address <= std_logic_vector(to_unsigned(0,BRAM_ADDRESS_BITS-ROWS_BITS)) & i_row;
		p3_t(i) := i_bit;
		p3_data_in <= p3_t;
	else
		p3_write_en <= '0';
		p3_enable <= '0';
		p3_data_in <= (others => '0');
		p3_address <= (others => '0');
	end if;
end process p3;

p4 : process (i_reset,i_enable_bit,i_write_bit,i_row,DATA_OUT) is
begin
	if (i_reset = '1') then
		p4_enable <= '0';
		p4_write_en <= '0';
		p4_address <= (others => '0');
		p4_data_in <= (others => '0');
		p4_obit <= '0';
	elsif (i_enable_bit = '1' and i_write_bit = '0') then
		p4_enable <= '1';
		p4_write_en <= '0';
		p4_address <= std_logic_vector(to_unsigned(0,BRAM_ADDRESS_BITS-ROWS_BITS)) & i_row;
		p4_obit <= DATA_OUT(to_integer(unsigned(i_col_pixel)));
	else
		p4_enable <= '0';
		p4_address <= (others => '0');
		p4_obit <= '0';
	end if;
end process p4;

U_RAMB16_S36: RAMB16_S36
generic map (
WRITE_MODE => "WRITE_FIRST",
INIT => X"000000000",
SRVAL => X"000000000"
)
port map (
DI => DATA_IN,
DIP => DATA_INP,
ADDR => ADDRESS,
EN => ENABLE,
WE => WRITE_EN,
SSR => i_reset,
CLK => i_clk,
DO => DATA_OUT,
DOP => DATA_OUTP
);

end Behavioral;
