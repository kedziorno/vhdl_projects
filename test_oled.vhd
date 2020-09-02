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
--use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_oled is 
port (signal clk : in std_logic; signal sda,scl : inout std_logic);
end test_oled;

architecture Behavioral of test_oled is

constant GCLK : integer := 50_000_000;
constant BCLK : integer := 100_000;

constant OLED_WIDTH : integer := 128;
constant OLED_HEIGHT : integer := 32;
constant OLED_PAGES : integer := (OLED_HEIGHT / 8);
constant OLED_PAGES_ALL : integer := OLED_WIDTH * OLED_PAGES;
constant SSD1306_DATA : integer := to_integer(unsigned'(x"40"));
constant SSD1306_COMMAND : integer := to_integer(unsigned'(x"00"));

SIGNAL busy_cnt : INTEGER := 0;
shared variable a,b : integer := 0;

constant NI_INIT : natural := 27;
type A_INIT is array (0 to NI_INIT-1) of std_logic_vector(7 downto 0);
signal init_display : A_INIT :=
(
	x"AE",
	x"D5",
	x"80",
	x"A8",
	x"3F",
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
	x"30",
	x"d9",
	x"f1",
	x"db",
	x"40",
	x"A4",
	x"A6",
	x"2e",
	x"AF",
	x"A5"
);

constant NI_CLEAR : natural := 6;
type A_CLEAR is array (0 to NI_CLEAR-1) of std_logic_vector(7 downto 0);

signal clear_display : A_CLEAR :=
(
	--std_logic_vector(to_unsigned(SSD1306_DATA,8)), --

	x"21", --
	x"00", --
	std_logic_vector(to_unsigned(OLED_WIDTH-1,8)), -- 

	x"22", --
	x"00", --
	std_logic_vector(to_unsigned(OLED_PAGES-1,8))  --
);

SIGNAL i2c_ena     : STD_LOGIC;                     --i2c enable signal
SIGNAL i2c_addr    : STD_LOGIC_VECTOR(6 DOWNTO 0);  --i2c address signal
SIGNAL i2c_rw      : STD_LOGIC;                     --i2c read/write command signal
SIGNAL i2c_data_wr : STD_LOGIC_VECTOR(7 DOWNTO 0);  --i2c write data
SIGNAL i2c_busy    : STD_LOGIC;                     --i2c busy signal
SIGNAL i2c_reset   : STD_LOGIC;                     --i2c busy signal
SIGNAL busy_prev   : STD_LOGIC;                     --previous value of i2c busy signal

COMPONENT i2c IS
GENERIC(
input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
bus_clk   : INTEGER := 100_000 --speed the i2c bus (scl) will run at in Hz
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
--	waiting,
	start,
	set_address,
	clear_display_state,
	stop
);
signal c_state,n_state : state := start;
	
begin

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
variable counter : INTEGER RANGE 0 TO GCLK/10 := 0; --counts 100ms to wait before communicating
begin
IF(i2c_reset='0') THEN
i2c_ena <= '0';
busy_cnt <= 0;
c_state <= start;
elsif(rising_edge(clk)) then
c_state <= n_state;
case c_state is
--	WHEN waiting =>
--		IF(counter < GCLK/10) THEN --100ms not yet reached
--			counter := counter + 1; --increment counter
--			n_state <= waiting;
--		ELSE --100ms reached
--			counter := 0; --clear counter
--			n_state <= start; --advance to setting the gain
--		END IF;

	when start =>
		busy_prev <= i2c_busy;
		if(busy_prev='0' and i2c_busy='1') then
			busy_cnt <= busy_cnt + 1;
		end if;
		if (busy_cnt=0) then
			i2c_reset <= '1';
			i2c_ena <= '1'; -- we are busy
			i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
			i2c_rw <= '0';
		end if;
		if ((busy_cnt/=0) and (busy_cnt<(NI_INIT*2)-1) and ((busy_cnt mod 2) = 1)) then
			i2c_data_wr <= x"00";
		end if;
		if ((busy_cnt/=0) and (busy_cnt<(NI_INIT*2)-1) and ((busy_cnt mod 2) = 0)) then
			i2c_data_wr <= init_display((busy_cnt / 2)-1); -- command
		end if;
		if ((busy_cnt/=0) and busy_cnt=(NI_INIT*2)-1) then
			i2c_ena <= '0';
			if(i2c_busy='0') then
				busy_cnt <= 0;
				n_state <= stop;
			end if;
		end if;

--		case busy_cnt is
--			when 0 =>
--				i2c_ena <= '1'; -- we are busy
--				i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
--				i2c_rw <= '0';
--			when 1 to NI_INIT =>
--				i2c_data_wr <= x"00";
--				i2c_data_wr <= init_display(busy_cnt-1); -- command
--			when NI_INIT+1 =>
--				i2c_ena <= '0';
--				if(i2c_busy='0') then
--					busy_cnt := 0;
--					n_state <= set_address;
--				end if;
--			when others => null;
--		end case;

--	when set_address =>
--		busy_prev <= i2c_busy;
--		if(busy_prev='0' and i2c_busy='1') then
--			busy_cnt := busy_cnt + 1;
--		end if;
--		if (busy_cnt=0) then
--			i2c_ena <= '1'; -- we are busy
--			i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
--			i2c_rw <= '0';
--		end if;
--		if ((busy_cnt<(NI_CLEAR*2)-1) and ((busy_cnt mod 2) = 1)) then
--			i2c_data_wr <= x"00";
--		end if;
--		if ((busy_cnt<(NI_CLEAR*2)-1) and ((busy_cnt mod 2) = 0)) then
--			i2c_data_wr <= clear_display((busy_cnt / 2)); -- command
--		end if;
--		if (busy_cnt=(NI_CLEAR*2)-1) then
--			i2c_ena <= '0';
--			if(i2c_busy='0') then
--				busy_cnt := 0;
--				n_state <= clear_display_state;
--			end if;
--		end if;

--		case busy_cnt is
--			when 0 =>
--				i2c_ena <= '1'; -- we are busy
--				i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
--				i2c_rw <= '0';
--			when 1 to NI_CLEAR =>
--				i2c_data_wr <= clear_display(busy_cnt-1); -- command
--			when NI_CLEAR+1 =>
--				i2c_ena <= '0';
--				if(i2c_busy='0') then
--					busy_cnt := 0;
--					n_state <= clear_display_state;
--				end if;
--			when others => null;
--		end case;

--	when clear_display_state =>
--		busy_prev <= i2c_busy;
--		if(busy_prev='0' and i2c_busy='1') then
--			busy_cnt := busy_cnt + 1;
--		end if;
--		case busy_cnt is
--			when 0 =>
--				i2c_ena <= '1'; -- we are busy
--				i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
--				i2c_rw <= '0';
--			when 1 =>
--				i2c_data_wr <= std_logic_vector(to_unsigned(SSD1306_DATA,8));
--			when 2 to OLED_PAGES_ALL =>
--				i2c_data_wr <= x"00";
--			when OLED_PAGES_ALL+1 =>
--				i2c_ena <= '0';
--				if(i2c_busy='0') then
--					busy_cnt := 0;
--					n_state <= stop;
--				end if;
--			when others => null;
--		end case;

--	when stop =>
--		n_state <= waiting;

	when others => null;
end case;
end if;
end process p0;
end Behavioral;

