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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_oled is 
port (signal clk : in std_logic; signal sda,scl : inout std_logic);
end test_oled;

architecture Behavioral of test_oled is

--signal clk,sda,scl : std_logic;
--
--procedure clk_gen(signal clk : out std_logic; constant wait_start : time; constant HT : time; constant LT : time) is
--begin
--clk <= '0';
--wait for wait_start;
--loop
--clk <= '1';
--wait for HT;
--clk <= '0';
--wait for LT;
--end loop;
--end procedure;

--signal Instrs: IAR := (x"A8", x"3F", x"D3", x"00", x"40", x"A1", x"DA", x"12", x"81", x"7F", x"20", x"00", x"21", x"00", x"7F", x"22", x"00", x"07", x"A6", x"DB", x"40", x"A4", x"D5", x"80", x"8D", x"14", x"AF");
--signal Instrs : IAR := (x"AE",x"D5",x"80",x"A8",x"3F",x"D3",x"00",x"40",x"8D",x"14",x"20",x"00",x"A0",x"C8",x"DA",x"12",x"81",x"CF",x"D9",x"F1",x"DB",x"40",x"A4",x"A6",x"AF");
--signal Instrs : IAR := (x"ae",x"00",x"10",x"40",x"b0",x"81",x"ff",x"a1",x"a6",x"c9",x"a8",x"3f",x"d3",x"00",x"d5",x"80",x"d9",x"f1",x"da",x"12",x"db",x"40",x"8d",x"14",x"af");

--work1	
--constant NI_INIT : natural := 25;
--type INIT is array (0 to NI_INIT-1) of std_logic_vector(7 downto 0);
--signal init_display : INIT :=
--(
--	x"AE",
--	x"D5",
--	x"80",
--	x"A8",
--	x"3F",
--	x"00",
--	x"40",
--	x"8D",
--	x"14",
--	x"20",
--	x"02",
--	x"A1",
--	x"C8",
--	x"DA",
--	x"12",
--	x"81",
--	x"CF",
--	x"D9",
--	x"F1",
--	x"DB",
--	x"40",
--	x"A4",
--	x"A6",
--	x"AF",
--	x"A5"
--);

--constant NI_INIT : natural := 18;
--type INIT is array (0 to NI_INIT-1) of std_logic_vector(7 downto 0);
--signal init_display : INIT :=
--(
--	x"a8", -- Set Display Clock Divide Ratio / OSC Frequency
--	x"c0", -- Display Clock Divide Ratio / OSC Frequency 
--	
--	x"d3", -- Set Multiplex Ratio
--	x"00", -- Multiplex Ratio for 128x64 (64-1)
--	
--	x"40", -- Set Display Offset
--	
--	x"a0", -- Set Display Start Line
--	
--	x"c0", -- Charge Pump (0x10 External, 0x14 Internal DC/DC)
--	
--	x"da", -- horizontal addressing mode
--	x"02", -- set segment re-map, column address 127 is mapped to SEG0
--	
--	x"81", -- Set Com Output Scan Direction
--	x"ff", -- Set COM Hardware Configuration
--	
--	x"a5", -- COM Hardware Configuration
--	
--	x"a6", -- Set Contrast
--	
--	x"d5", -- Contrast
--	x"80", -- Set Pre-Charge Period
--	
--	x"8d", -- Set Pre-Charge Period (0x22 External, 0xF1 Internal)
--	x"14", -- Set VCOMH Deselect Level
--	
--	x"AF" -- Set display On
--);

constant NI_INIT : natural := 27;
type A_INIT is array (0 to NI_INIT-1) of std_logic_vector(7 downto 0);
signal init_display : A_INIT :=
(
	x"AE",
	
	x"A8",
	x"1f",

	x"D3",
	x"00",

	x"40",

	x"A1",

	x"C8",

	x"DA",
	x"12",

	x"81",
	x"7F",

	x"A4",

	x"A6",

	x"D5",
	x"80",

	x"8D",
	x"14",

--	x"db",
--	x"40",
--
--	x"d9",
--	x"f1",
--
--	x"20",
--	x"00",

	x"AF",
	
	x"21", -- 
	x"00", -- 
	x"7F", -- 
	
	x"22", -- 
	x"00", -- 
	x"07", --
	
	x"20", --
	x"00"  --
);

--constant NI_CLEAR : natural := 8;
--type A_CLEAR is array (0 to NI_CLEAR-1) of std_logic_vector(7 downto 0);
--
--signal clear_display : A_CLEAR :=
--(
--	--x"40", --
--	x"21", -- 
--	x"00", -- 
--	x"7F", -- 
--	x"22", -- 
--	x"00", -- 
--	x"07", --
--	x"20", --
--	x"00"  --
--);

--signal Instrs : IAR := 
--(
--x"AE", -- SSD1306_DISPLAYOFF,
--x"00", -- SSD1306_SETLOWCOLUMN,
--x"10", -- SSD1306_SETHIGHCOLUMN,
--x"40", -- SSD1306_SETSTARTLINE,
--x"81", -- SSD1306_SETCONTRAST,
--x"CF",
--x"A1", -- SSD1306_SEGREMAP,
--x"A6", -- SSD1306_NORMALDISPLAY,
--x"A8", -- SSD1306_SETMULTIPLEX,
--x"3F",
--x"D3", -- SSD1306_SETDISPLAYOFFSET,
--x"00",
--x"D5", -- SSD1306_SETDISPLAYCLOCKDIV,
--x"80",
--x"D9", -- SSD1306_SETPRECHARGE,
--x"F1",
--x"DA", -- SSD1306_SETCOMPINS,
--x"12",
--x"DB", -- SSD1306_SETVCOMDETECT,
--x"40",
--x"8D", -- SSD1306_CHARGEPUMP,
--x"14",
--x"A5" -- SSD1306_DISPLAYON
--);

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
bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
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
	start,
	clear,
	stop
);
signal c_state,n_state : state := start;

shared variable idx_i : integer := 0;

begin

--clk_gen(clk,0 ns,20 ns,20 ns);

c1 : i2c
GENERIC MAP(bus_clk => 400_000)
PORT MAP(
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
VARIABLE busy_cnt : INTEGER := 0;
variable a : integer := 0;
variable b : integer := 4;
begin
IF(i2c_reset='0') THEN
i2c_ena <= '0';
busy_cnt := 0;
c_state <= start;
i2c_reset <= '1';
elsif(rising_edge(clk)) then
c_state <= n_state;
case c_state is
	when start =>
		busy_prev <= i2c_busy;
		if(busy_prev='0' and i2c_busy='1') then
			busy_cnt := busy_cnt + 1;
		end if;
		case busy_cnt is
			when 0 =>
				--i2c_reset <= '1';
				i2c_ena <= '1'; -- we are busy
				i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
				i2c_rw <= '0';
			when 1 to NI_INIT =>
				i2c_data_wr <= init_display(busy_cnt-1); -- command
			when NI_INIT+1 =>
				i2c_ena <= '0';
				if(i2c_busy='0') then
					busy_cnt := 0;
					n_state <= stop;
				end if;
			when others => null;
		end case;
--	when clear =>
--		if (a<b) then
--			busy_prev <= i2c_busy;
--			if(busy_prev='0' and i2c_busy='1') then
--				busy_cnt := busy_cnt + 1;
--			end if;
--			case busy_cnt is
--				when 0 =>
--					--i2c_reset <= '1';
--					i2c_ena <= '1'; -- we are busy
--					i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
--					i2c_rw <= '0';
--				when 1 =>
--					i2c_data_wr <= x"40";
--				when 2 =>
--					i2c_data_wr <= x"00";
--				when 3 =>
--					i2c_ena <= '0';
--					if(i2c_busy='0') then
--						busy_cnt := 0;
--						a := a + 1;
--					end if;
--				when others => null;
--			end case;
--		else
--			n_state <= stop;
--		end if;
	when stop =>
		--i2c_ena <= '0';
		n_state <= stop;
	when others => null;
end case;
end if;
end process p0;
end Behavioral;

