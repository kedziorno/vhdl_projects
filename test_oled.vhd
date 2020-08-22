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
port (
signal clk : in std_logic;
signal sda,scl : inout std_logic
);
end test_oled;

architecture Behavioral of test_oled is

constant AMNT_INSTRS: natural := 27;
type IAR is array (0 to AMNT_INSTRS-1) of std_logic_vector(7 downto 0);
--signal Instrs: IAR := (x"A8", x"3F", x"D3", x"00", x"40", x"A1", x"DA", x"12", x"81", x"7F", x"20", x"00", x"21", x"00", x"7F", x"22", x"00", x"07", x"A6", x"DB", x"40", x"A4", x"D5", x"80", x"8D", x"14", x"AF");
signal Instrs : IAR := (x"AE",x"D5",x"80",x"A8",x"3F",x"D3",x"00",x"40",x"8D",x"14",x"20",x"00",x"A0",x"C8",x"DA",x"12",x"81",x"CF",x"D9",x"F1",x"DB",x"40",x"A4",x"A6",x"AF");

SIGNAL i2c_ena     : STD_LOGIC;                     --i2c enable signal
SIGNAL i2c_addr    : STD_LOGIC_VECTOR(6 DOWNTO 0);  --i2c address signal
SIGNAL i2c_rw      : STD_LOGIC;                     --i2c read/write command signal
SIGNAL i2c_data_wr : STD_LOGIC_VECTOR(7 DOWNTO 0);  --i2c write data
SIGNAL i2c_busy    : STD_LOGIC;                     --i2c busy signal
SIGNAL i2c_reset   : STD_LOGIC;                     --i2c busy signal

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

begin

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

process (clk) is
begin
f0 : for i in Instrs'RANGE loop
i2c_reset <= '1';
i2c_ena <= '1';
i2c_rw <= '1';
i2c_addr <= X"3C"; -- address 3D 78
i2c_data_rw <= X"00"; -- control 80
i2c_data_wr <= Instrs(i); -- command
i2c_ena <= '0';
i2c_reset <= '0';
end loop f0;
end process;
end Behavioral;

