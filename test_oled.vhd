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
--port (
--signal clk : in std_logic;
--signal sda,scl : inout std_logic
--);
end test_oled;

architecture Behavioral of test_oled is

signal clk,sda,scl : std_logic;
procedure clk_gen(signal clk : out std_logic; constant wait_start : time; constant HT : time; constant LT : time) is
begin
clk <= '0';
wait for wait_start;
loop
clk <= '1';
wait for HT;
clk <= '0';
wait for LT;
end loop;
end procedure;
	
constant AMNT_INSTRS: natural := 25;
type IAR is array (0 to AMNT_INSTRS-1) of std_logic_vector(7 downto 0);
--signal Instrs: IAR := (x"A8", x"3F", x"D3", x"00", x"40", x"A1", x"DA", x"12", x"81", x"7F", x"20", x"00", x"21", x"00", x"7F", x"22", x"00", x"07", x"A6", x"DB", x"40", x"A4", x"D5", x"80", x"8D", x"14", x"AF");
signal Instrs : IAR := (x"AE",x"D5",x"80",x"A8",x"3F",x"D3",x"00",x"40",x"8D",x"14",x"20",x"00",x"A0",x"C8",x"DA",x"12",x"81",x"CF",x"D9",x"F1",x"DB",x"40",x"A4",x"A6",x"AF");

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

type state is (start,reset1,reset2,enable1,enable2,send_a,send_c,send_i,stop);
signal c_state,n_state : state := start;

begin

clk_gen(clk,0 ns,20 ns,20 ns);

c1 : i2c 
GENERIC MAP(bus_clk => 100_000)
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

p0 : process (clk) is
begin
if(rising_edge(clk)) then
c_state <= n_state;
end if;
end process p0;

process (c_state,clk) is
variable idx_i : integer := 0;
VARIABLE busy_cnt : INTEGER := 0;
begin
	case c_state is
		when start =>
			busy_prev <= i2c_busy;
			if(busy_prev='0' and i2c_busy='1') then
				busy_cnt := busy_cnt + 1;
			end if;
			case busy_cnt is
				when 0 =>
					i2c_reset <= '1';
					i2c_ena <= '1';
					i2c_addr <= "1010101"; -- address 3C 3D 78 ; 0111100 0111101 1111000
					i2c_rw <= '0';
					i2c_data_wr <= X"00"; -- control 80
					n_state <= start;
				when 1 =>
					i2c_reset <= '0';
					i2c_ena <= '0';
					if(i2c_busy='0') then
						busy_cnt := 0;
						n_state <= send_c;
					end if;
				when others => null;
			end case;
		when send_c =>
			busy_prev <= i2c_busy;
			if(busy_prev='0' and i2c_busy='1') then
				busy_cnt := busy_cnt + 1;
			end if;
			case busy_cnt is
				when 0 =>
					i2c_ena <= '1';
					i2c_addr <= "0111100"; -- address 3C 3D 78 ; 0111100 0111101 1111000
					i2c_rw <= '0';
					i2c_data_wr <= "00000000";
					n_state <= send_c;
				when 1 =>
					i2c_ena <= '0';
					if(i2c_busy='0') then
						busy_cnt := 0;
						n_state <= send_i;
					end if;
				when others => null;
			end case;
		when send_i =>
			busy_prev <= i2c_busy;
			if(busy_prev='0' and i2c_busy='1') then
				busy_cnt := busy_cnt + 1;
				i2c_ena <= '1';
				if(idx_i < AMNT_INSTRS) then
					i2c_data_wr <= Instrs(idx_i); -- command
					idx_i := idx_i + 1;
					n_state <= send_i;
				else
					n_state <= stop;
				end if;
			end if;
		when stop =>
			n_state <= stop;
		when others => null;
	end case;
end process;
end Behavioral;

