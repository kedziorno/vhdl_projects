--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:24:06 04/21/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/rs232_1/tb_rs232_1.vhd
-- Project Name:  rs232_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: rs232
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_rs232_1 IS
END tb_rs232_1;

ARCHITECTURE behavior OF tb_rs232_1 IS

constant G_BOARD_CLOCK : integer := 1_000_000;
constant G_BAUD_RATE : integer := 300;
-- Clock period definitions
constant clk_period : time := (1_000_000_000/G_BOARD_CLOCK) * 1 ns;
constant one_uart_bit : time := (G_BOARD_CLOCK/G_BAUD_RATE) * clk_period;

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT rs232
GENERIC(
G_BOARD_CLOCK : integer := G_BOARD_CLOCK;
G_BAUD_RATE : integer := G_BAUD_RATE
);
PORT(
clk : IN  std_logic;
rst : IN  std_logic;
enable_tx : IN  std_logic;
enable_rx : IN  std_logic;
byte_to_send : IN  std_logic_vector(7 downto 0);
byte_received : OUT  std_logic_vector(7 downto 0);
parity_tx : OUT  std_logic;
parity_tx_error : OUT  std_logic;
parity_rx : OUT  std_logic;
parity_rx_error : OUT  std_logic;
busy : OUT  std_logic;
ready : OUT  std_logic;
is_byte_received : OUT  std_logic;
RsTx : OUT  std_logic;
RsRx : IN  std_logic
);
END COMPONENT;

--Inputs
signal clk : std_logic := '0';
signal rst : std_logic := '0';
signal enable_tx : std_logic := '0';
signal enable_rx : std_logic := '0';
signal byte_to_send : std_logic_vector(7 downto 0) := (others => '0');
signal RsRx : std_logic := '0';

--Outputs
signal byte_received : std_logic_vector(7 downto 0);
signal parity_tx : std_logic;
signal parity_tx_error : std_logic;
signal parity_rx : std_logic;
signal parity_rx_error : std_logic;
signal busy : std_logic;
signal ready : std_logic;
signal is_byte_received : std_logic;
signal RsTx : std_logic;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: rs232 PORT MAP (
clk => clk,
rst => rst,
enable_tx => enable_tx,
enable_rx => enable_rx,
byte_to_send => byte_to_send,
byte_received => byte_received,
parity_tx => parity_tx,
parity_tx_error => parity_tx_error,
parity_rx => parity_rx,
parity_rx_error => parity_rx_error,
busy => busy,
ready => ready,
is_byte_received => is_byte_received,
RsTx => RsTx,
RsRx => RsRx
);

-- Clock process definitions
clk_process :process
begin
clk <= '0';
wait for clk_period/2;
clk <= '1';
wait for clk_period/2;
end process;

-- Stimulus process
stim_proc: process
type test_array is array(0 to 10) of std_logic_vector(7 downto 0);
variable test : test_array := (x"AA",x"55",x"FF",x"00",x"41",x"42",x"43",x"44",x"45",x"46",x"47");
variable test_ff : std_logic_vector(7 downto 0) := X"FF";
begin
rst <= '1';
wait for clk_period;
rst <= '0';
wait for clk_period;

enable_tx <= '1';
byte_to_send <= x"DD";
wait for clk_period;
enable_tx <= '0';
wait until busy = '0';


byte_to_send <= (others => 'X');

-- receive raw bits
enable_rx <= '1';
l0 : for i in 0 to 10 loop
RsRx <= '0';
wait for one_uart_bit;
l1 : for j in 0 to 7 loop
RsRx <= test(i)(j);
wait for one_uart_bit;
end loop l1;
--RsRX <= test(i)(0) xor test(i)(1) xor test(i)(2) xor test(i)(3) xor test(i)(4) xor test(i)(5) xor test(i)(6) xor test(i)(7); -- XXX Even
RsRX <= not (test(i)(0) xor test(i)(1) xor test(i)(2) xor test(i)(3) xor test(i)(4) xor test(i)(5) xor test(i)(6) xor test(i)(7)); -- XXX Odd
wait for one_uart_bit;
RsRx <= '1';
wait for one_uart_bit;
end loop l0;
enable_rx <= '0';

-- send bytes
enable_tx <= '1';
l10 : for i in 0 to 10 loop
byte_to_send <= test(i);
wait until busy = '0';
end loop l10;
enable_tx <= '0';

byte_to_send <= (others => 'X');

-- receive FF's
enable_rx <= '1';
l00 : for i in 0 to 20 loop
RsRx <= '0';
wait for one_uart_bit;
l20 : for j in 0 to 7 loop
RsRx <= test_ff(j);
wait for one_uart_bit;
end loop l20;
--RsRX <= test_ff(0) xor test_ff(1) xor test_ff(2) xor test_ff(3) xor test_ff(4) xor test_ff(5) xor test_ff(6) xor test_ff(7); -- XXX Even
RsRX <= not (test_ff(0) xor test_ff(1) xor test_ff(2) xor test_ff(3) xor test_ff(4) xor test_ff(5) xor test_ff(6) xor test_ff(7)); -- XXX Odd
wait for one_uart_bit;
RsRx <= '1';
wait for one_uart_bit;
end loop l00;
enable_rx <= '0';

-- send ff's
enable_tx <= '1';
l1000 : for i in 0 to 20 loop
byte_to_send <= x"FF";
wait for clk_period;
wait until busy = '1';
end loop l1000;
enable_tx <= '0';

byte_to_send <= (others => 'X');

wait;
end process;

END;
