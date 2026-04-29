----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:58:01 04/28/2026 
-- Design Name: 
-- Module Name:    simple_memtest - Behavioral 
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
use WORK.p_constants1.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simple_memtest is
generic (
constant c_addr_bits : integer := 23;
constant c_data_bits : integer := 16;
constant c_mem_sizes : integer := 8388608
);
port (
signal i_clk : in std_logic;
signal i_rst : in std_logic;
signal i_refresh : in std_logic;
signal io_sda,io_scl : inout std_logic;
Dq : inout std_logic_vector (c_data_bits - 1 downto 0);
Addr : out std_logic_vector (c_addr_bits downto 1);
Adv_n : out std_logic;
Ce_n : out std_logic;
Clk : out std_logic;
Cre : out std_logic;
Lb_n : out std_logic;
Oe_n : out std_logic;
Ub_n : out std_logic;
We_n : out std_logic;
oWait : in std_logic
);
end entity simple_memtest;

architecture Behavioral of simple_memtest is

constant GCLK : integer := g_board_clock;
constant BCLK : integer := g_bus_clock;

constant OLED_WIDTH : integer := 128;
constant OLED_HEIGHT : integer := 32;
constant OLED_PAGES_ALL : integer := OLED_WIDTH * ((OLED_HEIGHT + 7) / 8);
constant OLED_DATA : std_logic_vector(0 to G_BYTE_SIZE-1) := x"40";
constant OLED_COMMAND : std_logic_vector(0 to G_BYTE_SIZE-1) := x"00"; -- 00,80

-- i2c oled 128x32 initialization sequence  
constant BYTES_SEQUENCE_LENGTH : natural := 26;
type ARRAY_BYTE_SEQUENCE is array(0 to BYTES_SEQUENCE_LENGTH-1) of std_logic_vector(0 to G_BYTE_SIZE-1);
constant sequence : ARRAY_BYTE_SEQUENCE := (
x"AE",x"D5",x"80",x"A8",x"1F",x"D3",x"00",x"40",x"8D",
x"14",x"20",x"00",x"A1",x"C8",x"DA",x"02",x"81",x"8F",
x"D9",x"F1",x"DB",x"40",x"A4",x"A6",x"2E",x"AF");

constant NI_SET_COORDINATION : natural := 6;
type A_SET_COORDINATION is array (0 to NI_SET_COORDINATION-1) of std_logic_vector(7 downto 0);
constant set_coordination : A_SET_COORDINATION := (
x"21",x"00",std_logic_vector(to_unsigned(OLED_WIDTH-1,8)),
x"22",x"00",std_logic_vector(to_unsigned(4-1,8))
);

SIGNAL i2c_ena     : STD_LOGIC;                     --i2c enable signal
SIGNAL i2c_addr    : STD_LOGIC_VECTOR(6 DOWNTO 0);  --i2c address signal
SIGNAL i2c_rw      : STD_LOGIC;                     --i2c read/write command signal
SIGNAL i2c_data_wr : STD_LOGIC_VECTOR(0 to G_BYTE_SIZE-1);  --i2c write data
SIGNAL i2c_busy    : STD_LOGIC;                     --i2c busy signal
SIGNAL i2c_reset   : STD_LOGIC;                     --i2c busy signal
SIGNAL busy_prev   : STD_LOGIC;                     --previous value of i2c busy signal

signal busy_cnt : INTEGER range 0 to OLED_PAGES_ALL + 3; -- for i2c, count the clk tick when i2c_busy=1
signal index_character : INTEGER range 0 to 1275 - 1;
signal current_character : std_logic_vector(7 downto 0);

component glcdfont is
port(
  i_clk : in std_logic;
  i_index : in std_logic_vector(10 downto 0);
  o_character : out std_logic_vector(7 downto 0)
);
end component glcdfont;
for all : glcdfont use entity WORK.glcdfont(behavioral_glcdfont);

COMPONENT my_i2c IS
GENERIC (
  BOARD_CLOCK : INTEGER := G_BOARD_CLOCK;
  BUS_CLOCK : INTEGER := G_BUS_CLOCK
);
PORT (
  i_clock : in std_logic;
  i_reset : in std_logic;
  i_slave_address : std_logic_vector(0 to G_SLAVE_ADDRESS_SIZE-1);
  i_bytes_to_send : in std_logic_vector(0 to G_BYTE_SIZE-1);
  i_enable : in std_logic;
  o_busy : out std_logic;
  o_sda : out std_logic;
  o_scl : out std_logic
);
END COMPONENT my_i2c;

type state is 
(
  idle, -- reset i2c
  start, -- initialize oled
  set_address_1, -- set begin point 0,0
  clear_display_state_1, -- clear display and power on
  set_address_2, -- set begin point 0,0
  send_character, -- send the some data/text array
  check_character_index, -- check have char
  stop -- when index=counter, i2c disable
);
signal c_state : state;

signal glcdfont_character : std_logic_vector(7 downto 0);
signal glcdfont_index : std_logic_vector(10 downto 0);

--attribute CLOCK_SIGNAL : string;
--attribute CLOCK_SIGNAL of i_clk : signal is "yes"; --{yes | no};
--attribute BUFFER_TYPE : string;
--attribute BUFFER_TYPE of i_clk : signal is "BUFGP"; --" {bufgdll | ibufg | bufgp | ibuf | bufr | none}";

signal dq_i, dq_o : std_logic_vector (c_data_bits - 1 downto 0);

signal we_n_i, oe_n_i : std_logic;

signal i_char : array1(0 to 6);

signal mem_op_st : std_logic;

signal addr_i : std_logic_vector (c_addr_bits downto 1);

type mop_states is (a, a1, b, b1, c, c1, d, d1, d2, d3, d4, d5, d6, d7, d8, d9, fail, pass);
signal mop_state : mop_states := a;

signal dq_i_0, dq_i_1, dq_i_2, dq_i_3, dq_i_4, dq_i_5, dq_i_6, dq_i_7 : integer range 0 to 9;

signal temp1, temp, temp2 : unsigned (31 downto 0);
signal q, n, i : integer;

signal counter : integer range 0 to c_mem_sizes - 1;

begin

addr <= addr_i;

i2c_addr <= "0111100"; -- 3C

fonts : glcdfont
port map
(
  i_clk => i_clk,
  i_index => glcdfont_index,
  o_character => glcdfont_character
);

i2c : my_i2c
GENERIC MAP (
  BOARD_CLOCK => GCLK,
  BUS_CLOCK => BCLK
)
PORT MAP (
  i_clock => i_clk,
  i_reset => i_rst,
  i_slave_address => i2c_addr,
  i_bytes_to_send => i2c_data_wr,
  i_enable => i2c_ena,
  o_busy => i2c_busy,
  o_sda => io_sda,
  o_scl => io_scl
);

Lb_n <= '0';
Ub_n <= '0';
clk <= '0';
cre <= '0';

dq <= dq_o when (we_n_i = '0') else (others => 'Z');

oe_n <= oe_n_i;
we_n <= we_n_i;

p1_memory_operation : process (i_clk) is
  constant c_w8 : integer := 5;
  variable w8 : integer range 0 to c_w8 - 1;
begin
  if (rising_edge (i_clk)) then
    if (i_rst = '1') then
      mop_state <= a;
      counter <= 0;
      Adv_n <= '0';
      ce_n <= '1';
      oe_n_i <= '1';
      we_n_i <= '1';
      addr_i <= (others => '0');
      dq_o <= x"aa55";
      dq_i <= (others => '0');
      i_char <= (x"30", x"30", x"30", x"30", x"30", x"30", x"30");
      w8 := 0;
      q <= 0;
      n <= 0;
      i <= 0;
    else
      case (mop_state) is
        when a =>
          if (mem_op_st = '1') then
            mop_state <= a1;
            dq_o <= dq_o (0) & dq_o (15 downto 1);
            addr_i <= std_logic_vector (to_unsigned (counter, c_addr_bits));
            we_n_i <= '0';
            oe_n_i <= '1';
            adv_n <= '0';
            ce_n <= '0';
          end if;
        when a1 =>
          if (w8 = c_w8 - 1) then
            mop_state <= b;
            w8 := 0;
          else
            w8 := w8 + 1;
          end if;
          addr_i <= std_logic_vector (to_unsigned (counter, c_addr_bits));
          we_n_i <= '0';
          oe_n_i <= '1';
          adv_n <= '0';
          ce_n <= '0';
        when b =>
          mop_state <= b1;
          addr_i <= std_logic_vector (to_unsigned (0, c_addr_bits));
          adv_n <= '0';
          we_n_i <= '1';
          ce_n <= '1';
        when b1 =>
          mop_state <= c;
          adv_n <= '0';
          we_n_i <= '1';
          ce_n <= '1';
          addr_i <= std_logic_vector (to_unsigned (counter, c_addr_bits));
        when c =>
          if (w8 = c_w8 - 1) then
            mop_state <= c1;
            w8 := 0;
          else
            w8 := w8 + 1;
          end if;
          we_n_i <= '1';
          oe_n_i <= '0';
          adv_n <= '0';
          ce_n <= '0';
        when c1 =>
          mop_state <= d;
          we_n_i <= '1';
          oe_n_i <= '1';
          adv_n <= '0';
          ce_n <= '1';
          addr_i <= std_logic_vector (to_unsigned (counter, c_addr_bits));
          dq_i <= dq;
        when d =>
          if (dq_i /= dq_o) then
            mop_state <= fail;
          else
            mop_state <= d1;
          end if;
          addr_i <= std_logic_vector (to_unsigned (0, c_addr_bits));
          counter <= counter + 1;
          adv_n <= '0';
          ce_n <= '1';
          oe_n_i <= '1';
        when d1 =>
          if (counter = c_mem_sizes - 1) then
            mop_state <= pass;
          else
            mop_state <= d2;
          end if;
          adv_n <= '0';
          ce_n <= '1';
          oe_n_i <= '1';
        when d2 =>
          mop_state <= d3;
          n <= counter;
          i <= 0;
        when d3 =>
          q <= n * 6554;
          mop_state <= d4;
        when d4 =>
          mop_state <= d5;
          temp <= (31 downto 16 => '0') & to_unsigned (q, 32)(31 downto 16);
        when d5 =>
          mop_state <= d6;
          temp1 <= (to_unsigned (n, 32) - ((temp sll 3) + (temp sll 1)));
        when d6 =>
          mop_state <= d7;
          if (to_integer (temp1 (7 downto 0)) >= 250) then
            temp1 (7 downto 0) <= to_unsigned (250, 8);
          end if;
        when d7 =>
          i_char (6-i) <= std_logic_vector (temp1 (7 downto 0) + x"30");
          if (q = n) then
            mop_state <= a;
          else
            n <= to_integer (temp);
            mop_state <= d3;
            if (i = 6) then
              i <= 0;
            else
              i <= i + 1;
            end if;
          end if;
        when fail =>
          i_char <= (x"45", x"41", x"49", x"4c", x"00", x"00", x"00");
        when pass =>
          i_char <= (x"50", x"41", x"53", x"53", x"00", x"00", x"00");
        when others => mop_state <= a;
      end case;
    end if;
  end if;
end process p1_memory_operation;

p0 : process (i_clk) is
begin
  if (rising_edge(i_clk)) then
    if (i_rst = '1') then
      c_state <= idle;
      busy_cnt <= 0;
      index_character <= 0;
      glcdfont_index <= (others => '0');
      i2c_reset <= '1';
      mem_op_st <= '0';
      current_character <= (others => '0');
    else
      case c_state is
        when idle =>
          c_state <= start;
          i2c_reset <= '1';
        when start =>
          i2c_reset <= '0';
          busy_prev <= i2c_busy;
          if (busy_prev = '0' and i2c_busy = '1') then
            busy_cnt <= busy_cnt + 1;
          end if;
          case busy_cnt is
            when 0 =>
              i2c_ena <= '1'; -- we are busy
            when 1 =>
              i2c_data_wr <= OLED_COMMAND;
            when 2 to BYTES_SEQUENCE_LENGTH+1 =>
              i2c_data_wr <= sequence(busy_cnt-2); -- command
            when BYTES_SEQUENCE_LENGTH+2 =>
              i2c_ena <= '0';
              i2c_data_wr <= (others => '0');
              if (i2c_busy = '0') then
                busy_cnt <= 0;
                c_state <= set_address_1;
              end if;
            when others => null;
          end case;
        when set_address_1 =>
          busy_prev <= i2c_busy;
          if (busy_prev = '0' and i2c_busy = '1') then
            busy_cnt <= busy_cnt + 1;
          end if;
          case busy_cnt is
            when 0 =>
              i2c_ena <= '1'; -- we are busy
            when 1 =>
              i2c_data_wr <= OLED_COMMAND;
            when 2 to NI_SET_COORDINATION+1 =>
              i2c_data_wr <= set_coordination(busy_cnt-2); -- command
            when NI_SET_COORDINATION+2 =>
              i2c_ena <= '0';
              if (i2c_busy = '0') then
                busy_cnt <= 0;
                c_state <= clear_display_state_1;
              end if;
            when others => null;
          end case;
        when clear_display_state_1 =>
          mem_op_st <= '0';
          busy_prev <= i2c_busy;
          if (busy_prev = '0' and i2c_busy = '1') then
            busy_cnt <= busy_cnt + 1;
          end if;
          case busy_cnt is
            when 0 =>
              i2c_ena <= '1'; -- we are busy
            when 1 =>
              i2c_data_wr <= OLED_DATA;
            when 2 to OLED_PAGES_ALL+1 =>
              i2c_data_wr <= x"00"; -- command - FF/allpixels,00/blank,F0/zebra
            when OLED_PAGES_ALL+2 =>
              i2c_ena <= '0';
              if (i2c_busy = '0') then
                busy_cnt <= 0;
                c_state <= set_address_2;
              end if;
            when others => null;
          end case;
        when set_address_2 =>
          mem_op_st <= '0';
          busy_prev <= i2c_busy;
          if (busy_prev = '0' and i2c_busy = '1') then
            busy_cnt <= busy_cnt + 1;
          end if;
          case busy_cnt is
            when 0 =>
              i2c_ena <= '1'; -- we are busy
            when 1 =>
              i2c_data_wr <= OLED_COMMAND;
            when 2 to NI_SET_COORDINATION+1 =>
              i2c_data_wr <= set_coordination(busy_cnt-2); -- command
            when NI_SET_COORDINATION+2 =>
              i2c_ena <= '0';
              if (i2c_busy = '0') then
                busy_cnt <= 0;
                c_state <= send_character;
              end if;
            when others => null;
          end case;
        when send_character =>
          mem_op_st <= '0';
          busy_prev <= i2c_busy;
          if (busy_prev = '0' and i2c_busy = '1') then
            busy_cnt <= busy_cnt + 1;
          end if;
          case busy_cnt is
            when 0 =>
              i2c_ena <= '1'; -- we are busy
              current_character <= i_char(index_character);
            when 1 =>
              i2c_data_wr <= x"40";
						when 2 =>
							glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+0,glcdfont_index'length));
							i2c_data_wr <= glcdfont_character;
						when 3 =>
							glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+1,glcdfont_index'length));
							i2c_data_wr <= glcdfont_character;
						when 4 =>
							glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+2,glcdfont_index'length));
							i2c_data_wr <= glcdfont_character;
						when 5 =>
							glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+3,glcdfont_index'length));
							i2c_data_wr <= glcdfont_character;
						when 6 =>
							glcdfont_index <= std_logic_vector(to_unsigned(to_integer(unsigned(current_character))*5+4,glcdfont_index'length));
							i2c_data_wr <= glcdfont_character;
						when 7 =>
              i2c_ena <= '0';
              if (i2c_busy = '0') then
                busy_cnt <= 0;
                c_state <= check_character_index;
              end if;
            when others => null;
          end case;
        when check_character_index =>
          if (index_character = i_char'length-1) then
            c_state <= stop;
            index_character <= 0;
          else
            c_state <= send_character;
            index_character <= index_character + 1;
          end if;
        when stop =>
--          c_state <= clear_display_state_1;
          c_state <= set_address_2;
--          c_state <= send_character;
          i2c_ena <= '0';
          mem_op_st <= '1';
        when others => null;
      end case;
    end if;
  end if;
end process p0;

end Behavioral;

