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

component BUFG
port (I : in std_logic;
O : out std_logic); 
end component;

component RAMB16_S36
-- pragma translate_off
generic (
WRITE_MODE : string := "NO_CHANGE" ; -- WRITE_FIRST(default)/ READ_FIRST/NO_CHANGE
INIT : bit_vector(35 downto 0) := X"000000000";
SRVAL : bit_vector(35 downto 0) := X"012345678");
-- pragma translate_on
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

attribute WRITE_MODE : string;
attribute INIT: string;
attribute SRVAL: string;
attribute WRITE_MODE of U_RAMB16_S36: label is "NO_CHANGE";
attribute INIT of U_RAMB16_S36: label is "000000000";
attribute SRVAL of U_RAMB16_S36: label is "012345678";

signal CLK_BUFG: std_logic;
signal INV_SET_RESET : std_logic;

signal DATA_IN : std_logic_vector(WORD_BITS-1 downto 0);
signal DATA_INP : std_logic_vector(PARITY_BITS-1 downto 0);
signal ADDRESS : std_logic_vector(BRAM_ADDRESS_BITS-1 downto 0);
signal ENABLE : std_logic;
signal WRITE_EN : std_logic;
signal DATA_OUT : std_logic_vector(WORD_BITS-1 downto 0);
signal DATA_OUTP : std_logic_vector(PARITY_BITS-1 downto 0);

type state is (idle,start,write_content,check_byte,check_bit);
signal st : state;

signal copy_content : std_logic;
signal index : integer;

--	shared variable m1 : MEMORY := memory_content;
--	signal obyte : std_logic_vector(BYTE_BITS-1 downto 0);
--	signal obit : std_logic;

begin

U_BUFG: BUFG 
port map (
I => i_clk,
O => CLK_BUFG
);

U_RAMB16_S36: RAMB16_S36
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

pc : process(CLK_BUFG,i_reset) is
begin
    if (i_reset = '1') then
        st <= idle;
        copy_content <= '0';
        index <= 0;
        DATA_IN <= (others => '0');
        ADDRESS <= (others => '0');
    elsif (rising_edge(CLK_BUFG)) then
        case (st) is
            when idle =>
                st <= start;
                ENABLE <= '0';
                WRITE_EN <= '0';
            when start =>
                ENABLE <= '1';
                WRITE_EN <= '0';
                if (index = ROWS-1) then
                    st <= check_byte;
                    copy_content <= '1';
                else
                    st <= write_content;
                    index <= index + 1;
                end if;
            when write_content =>
                st <= start;
                WRITE_EN <= '1';
                ADDRESS <= std_logic_vector(to_unsigned(index,BRAM_ADDRESS_BITS));
                DATA_IN <= memory_content(index);
            when check_byte =>
                st <= check_bit;
                if (copy_content = '1' and i_write_byte = '1') then
                    WRITE_EN <= '1';
                    ADDRESS(ROWS_BITS-1 downto 0) <= i_row;
                    case (to_integer(unsigned(i_col_block))) is
                        when 0 =>
                            DATA_IN <= DATA_IN(31 downto 8) & i_byte;
                        when 1 =>
                            DATA_IN <= DATA_IN(31 downto 16) & i_byte & DATA_IN(7 downto 0);
                        when 2 =>
                            DATA_IN <= DATA_IN(31 downto 24) & i_byte & DATA_IN(15 downto 0);
                        when 3 =>
                            DATA_IN <= i_byte & DATA_IN(23 downto 0);
                        when others => null;
                    end case;
                else
                    WRITE_EN <= '0';
                    ADDRESS(ROWS_BITS-1 downto 0) <= i_row;
                    case (to_integer(unsigned(i_col_block))) is
                        when 0 =>
                            o_byte <= DATA_OUT(7 downto 0);
                        when 1 =>
                            o_byte <= DATA_OUT(15 downto 8);
                        when 2 =>
                            o_byte <= DATA_OUT(23 downto 16);
                        when 3 =>
                            o_byte <= DATA_OUT(31 downto 24);
                        when others => null;
                    end case;
                end if;
            when check_bit =>
                st <= check_byte;
                if (copy_content = '1' and i_write_bit = '1') then
                    WRITE_EN <= '1';
                    ADDRESS(ROWS_BITS-1 downto 0) <= i_row;
                    DATA_IN(to_integer(unsigned(i_col_pixel))) <= i_bit;
                else
                    WRITE_EN <= '0';
                    ADDRESS(ROWS_BITS-1 downto 0) <= i_row;
                    o_bit <= DATA_OUT(to_integer(unsigned(i_col_pixel)));
                end if;
        end case;
    end if;
end process pc;

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
