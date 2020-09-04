----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:47:49 08/21/2020 
-- Design Name: 
-- Module Name:    test_oled - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_oled is 
port
(
signal clk : in std_logic;
signal sda,scl : inout std_logic
);
end test_oled;

architecture Behavioral of test_oled is

constant GCLK : integer := 50_000_000;
constant BCLK : integer := 100_000;

constant OLED_WIDTH : integer := 128;
constant OLED_HEIGHT : integer := 32;
constant OLED_PAGES_ALL : integer := OLED_WIDTH * ((OLED_HEIGHT + 7) / 8);
constant OLED_DATA : integer := to_integer(unsigned'(x"40"));
constant OLED_COMMAND : integer := to_integer(unsigned'(x"00")); -- 00,80

constant OLED_STABLE : integer := 2; -- we send the same data x-time

SIGNAL busy_cnt : INTEGER := 0; -- for i2c, count the clk tick when i2c_busy=1

constant NI_INIT : natural := 26;
type A_INIT is array (0 to NI_INIT-1) of std_logic_vector(7 downto 0);
signal init_display : A_INIT :=
(
	x"AE",
	x"D5",
	x"F0",
	x"A8",
	x"1F",
	x"D3",
	x"00",
	x"40",
	x"8D",
	x"14",
	x"20",
	x"00",
	x"A1",
	x"C8",
	x"DA",
	x"02",
	x"81",
	x"8F",
	x"D9",
	x"F1",
	x"DB",
	x"40",
	x"A4",
	x"A6",
	x"2E",
	x"AF"
);

constant NI_CLEAR : natural := 6;
type A_CLEAR is array (0 to NI_CLEAR-1) of std_logic_vector(7 downto 0);

signal clear_display : A_CLEAR :=
(
	x"21", --
	x"00", --
	std_logic_vector(to_unsigned(OLED_WIDTH-1,8)), -- 

	x"22", --
	x"00", --
	x"FF"  -- std_logic_vector(to_unsigned(OLED_HEIGHT-1,8))
);

SIGNAL i2c_ena     : STD_LOGIC;                     --i2c enable signal
SIGNAL i2c_addr    : STD_LOGIC_VECTOR(6 DOWNTO 0);  --i2c address signal
SIGNAL i2c_rw      : STD_LOGIC;                     --i2c read/write command signal
SIGNAL i2c_data_wr : STD_LOGIC_VECTOR(7 DOWNTO 0);  --i2c write data
SIGNAL i2c_busy    : STD_LOGIC;                     --i2c busy signal
SIGNAL i2c_reset   : STD_LOGIC;                     --i2c busy signal
SIGNAL busy_prev   : STD_LOGIC;                     --previous value of i2c busy signal

component glcdfont is
port(
	i_clk : in std_logic;
	i_index : in std_logic_vector(11 downto 0);
	o_character : out std_logic_vector(7 downto 0)
);
end component glcdfont;

for all : glcdfont use entity WORK.glcdfont(behavioral_glcdfont);

COMPONENT i2c IS
GENERIC(
	input_clk : INTEGER := GCLK; --input clock speed from user logic in Hz
	bus_clk   : INTEGER := BCLK  --speed the i2c bus (scl) will run at in Hz
);
PORT(
	clk       : IN     STD_LOGIC;                    --system clock
	reset_n   : IN     STD_LOGIC;                    --active low reset
	ena       : IN     STD_LOGIC;                    --latch in command
	addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
	rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
	data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
	busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
	data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
	ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
	sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
	scl       : INOUT  STD_LOGIC);                   --serial clock output of i2c bus
END component i2c;

for all : i2c use entity WORK.i2c_master(logic);

type state is 
(
	start, -- initialize oled
	set_address_1, -- set begin point 0,0
	clear_display_state, -- clear display
	set_address_2, -- set begin point 0,0
	some_text, -- send the some data
	stop -- when index=counter, i2c disable
);
signal c_state,n_state : state := start;

signal char_o : std_logic_vector(7 downto 0) := (others => '0');
signal char_i : std_logic_vector(11 downto 0) := (others => '0');

begin

c0 : glcdfont
port map
(
	i_clk => clk,
	i_index => char_i,
	o_character => char_o
);

c1 : i2c
GENERIC MAP
(
	input_clk => GCLK,
	bus_clk => BCLK
)
PORT MAP
(
	clk => clk,
	reset_n => i2c_reset,
	ena => i2c_ena,
	addr => i2c_addr,
	rw => i2c_rw,
	data_wr => i2c_data_wr,
	busy => i2c_busy,
	data_rd => open,
	ack_error => open,
	sda => sda,
	scl => scl
);

p0 : process (clk,i2c_reset) is
	variable index : INTEGER RANGE 0 TO OLED_STABLE := 0;
	variable counter : INTEGER RANGE 0 TO OLED_STABLE := OLED_STABLE;
begin
	if (i2c_reset = '0') then
		i2c_ena <= '0';
		busy_cnt <= 0;
		c_state <= start;
		i2c_reset <= '1';
	elsif (rising_edge(clk)) then
		c_state <= n_state;
		if (index < counter) then
			case c_state is
				when start =>
					busy_prev <= i2c_busy;
					if (busy_prev = '0' and i2c_busy = '1') then
						busy_cnt <= busy_cnt + 1;
					end if;
					case busy_cnt is
						when 0 =>
							i2c_ena <= '1'; -- we are busy
							i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
							i2c_rw <= '0';
							i2c_data_wr <= std_logic_vector(to_unsigned(OLED_COMMAND,8));
						when 1 to NI_INIT =>
							i2c_data_wr <= init_display(busy_cnt-1); -- command
						when NI_INIT+1 =>
							i2c_ena <= '0';
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								n_state <= set_address_1;
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
							i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
							i2c_rw <= '0';
							i2c_data_wr <= std_logic_vector(to_unsigned(OLED_COMMAND,8));
						when 1 to NI_CLEAR =>
							i2c_data_wr <= clear_display(busy_cnt-1); -- command
						when NI_CLEAR+1 =>
							i2c_ena <= '0';
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								n_state <= clear_display_state;
							end if;
						when others => null;
					end case;
				when clear_display_state =>
					busy_prev <= i2c_busy;
					if (busy_prev = '0' and i2c_busy = '1') then
						busy_cnt <= busy_cnt + 1;
					end if;
					case busy_cnt is
						when 0 =>
							i2c_ena <= '1'; -- we are busy
							i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
							i2c_rw <= '0';
							i2c_data_wr <= std_logic_vector(to_unsigned(OLED_DATA,8));
						when 1 to OLED_PAGES_ALL =>
							i2c_data_wr <= x"00"; -- command - FF/allpixels,00/blank,F0/zebra
						when OLED_PAGES_ALL+1 =>
							i2c_ena <= '0';
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								n_state <= set_address_2;
							end if;
						when others => null;
					end case;
				when set_address_2 =>
					busy_prev <= i2c_busy;
					if (busy_prev = '0' and i2c_busy = '1') then
						busy_cnt <= busy_cnt + 1;
					end if;
					case busy_cnt is
						when 0 =>
							i2c_ena <= '1'; -- we are busy
							i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
							i2c_rw <= '0';
							i2c_data_wr <= std_logic_vector(to_unsigned(OLED_COMMAND,8));
						when 1 to NI_CLEAR =>
							i2c_data_wr <= clear_display(busy_cnt-1); -- command
						when NI_CLEAR+1 =>
							i2c_ena <= '0';
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								n_state <= some_text;
							end if;
						when others => null;
					end case;
				when some_text =>
					busy_prev <= i2c_busy;
					if (busy_prev = '0' and i2c_busy = '1') then
						busy_cnt <= busy_cnt + 1;
					end if;
					case busy_cnt is
						when 0 =>
							i2c_ena <= '1'; -- we are busy
							i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
							i2c_rw <= '0';
							i2c_data_wr <= std_logic_vector(to_unsigned(OLED_DATA,8));
						when 1 =>
							char_i <= std_logic_vector(to_unsigned(1120,char_i'length));
							i2c_data_wr <= char_o;
						when 2 =>
							char_i <= std_logic_vector(to_unsigned(1121,char_i'length));
							i2c_data_wr <= char_o;
						when 3 =>
							char_i <= std_logic_vector(to_unsigned(1122,char_i'length));
							i2c_data_wr <= char_o;
						when 4 =>
							char_i <= std_logic_vector(to_unsigned(1123,char_i'length));
							i2c_data_wr <= char_o;
						when 5 =>
							char_i <= std_logic_vector(to_unsigned(1124,char_i'length));
							i2c_data_wr <= char_o;
						when 6 =>
							i2c_ena <= '0';
							if (i2c_busy = '0') then
								busy_cnt <= 0;
								n_state <= stop;
							end if;
						when others => null;
					end case;
				when stop =>
					index := index + 1;
					n_state <= start;
				when others => null;
			end case;
		else
			i2c_ena <= '0'; -- if index=counter then disable i2c, high impedance on sda/scl
		end if;
	end if;
end process p0;

end Behavioral;

