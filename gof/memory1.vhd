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

signal CLK_BUFG: std_logic;
signal INV_SET_RESET : std_logic;

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

begin

ENABLE <=
p0_enable when i_copy_content = '1' else
p1_enable when i_enable_byte = '1' and i_write_byte = '1' else
p2_enable when i_enable_byte = '1' and i_write_byte = '0' else
p3_enable when i_enable_bit = '1' and i_write_bit = '1' else
p4_enable when i_enable_bit = '1' and i_write_bit = '0' else
'Z';

WRITE_EN <=
p0_write_en when i_copy_content = '1' else
p1_write_en when i_enable_byte = '1' and i_write_byte = '1' else
p2_write_en when i_enable_byte = '1' and i_write_byte = '0' else
p3_write_en when i_enable_bit = '1' and i_write_bit = '1' else
p4_write_en when i_enable_bit = '1' and i_write_bit = '0' else
'Z';

ADDRESS <=
p0_address when i_copy_content = '1' else
p1_address when i_enable_byte = '1' and i_write_byte = '1' else
p2_address when i_enable_byte = '1' and i_write_byte = '0' else
p3_address when i_enable_bit = '1' and i_write_bit = '1' else
p4_address when i_enable_bit = '1' and i_write_bit = '0' else
(others => 'Z');

DATA_IN <=
p0_data_in when i_copy_content = '1' else
p1_data_in when i_enable_byte = '1' and i_write_byte = '1' else
p2_data_in when i_enable_byte = '1' and i_write_byte = '0' else
p3_data_in when i_enable_bit = '1' and i_write_bit = '1' else
p4_data_in when i_enable_bit = '1' and i_write_bit = '0' else
(others => 'Z');

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
		end case;
	end if;
end process p0;

p1 : process (i_clk,i_reset) is
begin
	if (i_reset = '1') then
		p1_enable <= '0';
		p1_write_en <= '0';
		p1_address <= (others => '0');
		p1_data_in <= (others => '0');
	elsif (rising_edge(i_clk)) then
--		if (i_enable_byte = '1') then
--			if (i_write_byte = '1') then
				p1_enable <= '1';
				p1_write_en <= '1';
				p1_address(ROWS_BITS-1 downto 0) <= i_row;
				case (to_integer(unsigned(i_col_block))) is
					when 0 =>
						p1_data_in <= DATA_IN(31 downto 8) & i_byte;
					when 1 =>
						p1_data_in <= DATA_IN(31 downto 16) & i_byte & DATA_IN(7 downto 0);
					when 2 =>
						p1_data_in <= DATA_IN(31 downto 24) & i_byte & DATA_IN(15 downto 0);
					when 3 =>
						p1_data_in <= i_byte & DATA_IN(23 downto 0);
					when others => null;
				end case;
--			end if;
--		end if;
	end if;
end process p1;

p2 : process (i_clk,i_reset) is
begin
	if (i_reset = '1') then
		p2_enable <= '0';
		p2_write_en <= '0';
		p2_address <= (others => '0');
		p2_obyte <= (others => '0');
	elsif (rising_edge(i_clk)) then
--		if (i_enable_byte = '1') then
--			if (i_write_byte = '0') then
				p2_enable <= '1';
				p2_write_en <= '0';
				p2_address(ROWS_BITS-1 downto 0) <= i_row;
				case (to_integer(unsigned(i_col_block))) is
					when 0 =>
						p2_obyte <= DATA_OUT(7 downto 0);
					when 1 =>
						p2_obyte <= DATA_OUT(15 downto 8);
					when 2 =>
						p2_obyte <= DATA_OUT(23 downto 16);
					when 3 =>
						p2_obyte <= DATA_OUT(31 downto 24);
					when others => null;
				end case;
--			end if;
--		end if;
	end if;
end process p2;

p3 : process (i_clk,i_reset) is
begin
	if (i_reset = '1') then
		p3_enable <= '0';
		p3_write_en <= '0';
		p3_address <= (others => '0');
		p3_data_in <= (others => '0');
	elsif (rising_edge(i_clk)) then
--		if (i_enable_bit = '1') then
--			if (i_write_bit = '1') then
				p3_enable <= '1';
				p3_write_en <= '1';
				p3_address(ROWS_BITS-1 downto 0) <= i_row;
				p3_data_in(to_integer(unsigned(i_col_pixel))) <= i_bit;
--			end if;
--		end if;
	end if;
end process p3;

p4 : process (i_clk,i_reset) is
begin
	if (i_reset = '1') then
		p4_enable <= '0';
		p4_write_en <= '0';
		p4_address(ROWS_BITS-1 downto 0) <= (others => '0');
		p4_obit <= '0';
	elsif (rising_edge(i_clk)) then
--		if (i_enable_bit = '1') then
--			if (i_write_bit = '0') then
				p4_enable <= '1';
				p4_write_en <= '0';
				p4_address(ROWS_BITS-1 downto 0) <= i_row;
				p4_obit <= DATA_OUT(to_integer(unsigned(i_col_pixel)));
--			end if;
--		end if;
	end if;
end process p4;

U_RAMB16_S36: RAMB16_S36
generic map (
WRITE_MODE => "NO_CHANGE",
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
CLK => CLK_BUFG,
DO => DATA_OUT,
DOP => DATA_OUTP
);

--ADDRESS(ROWS_BITS-1 downto 0) <= i_row when (i_enable_byte = '1' or i_enable_bit = '1') else (others => 'Z');
--ENABLE <= '1' when (i_enable_byte = '1' or i_enable_bit = '1' or st = start) else '0';
--WRITE_EN <= '1' when (i_write_byte = '1' or i_write_bit = '1' or st = write_content) else '0';

--i_enable_byte : in std_logic;
--i_enable_bit : in std_logic;
--i_write_byte : in std_logic;
--i_write_bit : in std_logic;
--i_row : in std_logic_vector(ROWS_BITS-1 downto 0);
--i_col_pixel : in std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
--i_col_block : in std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
--i_byte : in std_logic_vector(BYTE_BITS-1 downto 0);
--i_bit : in std_logic;
--o_byte : out std_logic_vector(BYTE_BITS-1 downto 0);
--o_bit : out std_logic

--process_byte : process(i_clk) is
--variable t_row : std_logic_vector(ROWS_BITS-1 downto 0);
--variable t_col_block : std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
--variable t_col : std_logic_vector(WORD_BITS-1 downto 0);
--variable t_byte : std_logic_vector(BYTE_BITS-1 downto 0);
--variable v0 : std_logic_vector(BYTE_BITS-1 downto 0);
--variable v1 : std_logic_vector(BYTE_BITS-1 downto 0);
--variable v2 : std_logic_vector(BYTE_BITS-1 downto 0);
--variable v3 : std_logic_vector(BYTE_BITS-1 downto 0);
--begin
--if (rising_edge(i_clk)) then
--t_row := i_row;
--t_col := m1(to_integer(unsigned(t_row)));
--t_col_block := i_col_block;
--t_byte := i_byte;
--v0 := t_col((1*BYTE_BITS)-1 downto 0*BYTE_BITS);
--v1 := t_col((2*BYTE_BITS)-1 downto 1*BYTE_BITS);
--v2 := t_col((3*BYTE_BITS)-1 downto 2*BYTE_BITS);
--v3 := t_col((4*BYTE_BITS)-1 downto 3*BYTE_BITS);
--if (i_enable_byte = '1') then
--if (i_write_byte = '1') then
--case to_integer(unsigned(t_col_block)) is
--when 0 =>
--v0 := t_byte;
--when 1 =>
--v1 := t_byte;
--when 2 =>
--v2 := t_byte;
--when 3 =>
--v3 := t_byte;
--when others => null;
--end case;
--t_col := v3 & v2 & v1 & v0;
--m1(to_integer(unsigned(t_row))) := t_col;
--else
--case to_integer(unsigned(t_col_block)) is
--when 0 =>
--t_byte := v0;
--when 1 =>
--t_byte := v1;
--when 2 =>
--t_byte := v2;
--when 3 =>
--t_byte := v3;
--when others => null;
--end case;
--end if;
--else
--t_byte := "ZZZZZZZZ";
--end if;
--end if;
--obyte <= t_byte;
--end process process_byte;
--o_byte <= obyte;
--
--process_bit : process (i_clk) is
--variable t_row : std_logic_vector(ROWS_BITS-1 downto 0);
--variable t_col_pixel : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
--variable t_bit : std_logic;
--variable t_col : std_logic_vector(WORD_BITS-1 downto 0);
--variable v0 : std_logic_vector(BYTE_BITS-1 downto 0);
--variable v1 : std_logic_vector(BYTE_BITS-1 downto 0);
--variable v2 : std_logic_vector(BYTE_BITS-1 downto 0);
--variable v3 : std_logic_vector(BYTE_BITS-1 downto 0);
--variable t_col_p1 : integer range 0 to COLS_PIXEL_BITS-1;
--variable t_col_p2 : integer range 0 to BYTE_BITS-1;
--begin
--if (rising_edge(i_clk)) then
--t_row := i_row;
--t_col_pixel := i_col_pixel;
--t_bit := i_bit;
--t_col_p1 := to_integer(unsigned(t_col_pixel)) / BYTE_BITS;
--t_col_p2 := to_integer(unsigned(t_col_pixel)) mod BYTE_BITS;
--t_col := m1(to_integer(unsigned(t_row)));
--v0 := t_col((1*BYTE_BITS)-1 downto 0*BYTE_BITS);
--v1 := t_col((2*BYTE_BITS)-1 downto 1*BYTE_BITS);
--v2 := t_col((3*BYTE_BITS)-1 downto 2*BYTE_BITS);
--v3 := t_col((4*BYTE_BITS)-1 downto 3*BYTE_BITS);
--if (i_enable_bit = '1') then
--if (i_write_bit = '1') then
--case t_col_p1 is
--when 0 =>
--v0(t_col_p2) := t_bit;
--when 1 =>
--v1(t_col_p2) := t_bit;
--when 2 =>
--v2(t_col_p2) := t_bit;
--when 3 =>
--v3(t_col_p2) := t_bit;
--when others => null;
--end case;
--t_col := v3 & v2 & v1 & v0;
--m1(to_integer(unsigned(t_row))) := t_col;
--else
--case t_col_p1 is
--when 0 =>
--t_bit := v0(t_col_p2);
--when 1 =>
--t_bit := v1(t_col_p2);
--when 2 =>
--t_bit := v2(t_col_p2);
--when 3 =>
--t_bit := v3(t_col_p2);
--when others => null;
--end case;
--obit <= t_bit;
--end if;
--else
--obit <= 'Z';
--end if;
--end if;
--end process process_bit;
--o_bit <= obit;

end Behavioral;
