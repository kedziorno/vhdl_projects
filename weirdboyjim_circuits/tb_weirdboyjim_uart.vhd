--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   07:20:18 12/11/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/weirdboyjim_circuits/tb_weirdboyjim_uart.vhd
-- Project Name:  weirdboyjim_circuits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: weirdboyjim_uart
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
USE ieee.numeric_std.ALL;

ENTITY tb_weirdboyjim_uart IS
END tb_weirdboyjim_uart;

ARCHITECTURE behavior OF tb_weirdboyjim_uart IS

COMPONENT weirdboyjim_uart
PORT(
signal i_reset : in std_logic;
signal txUartClock : in std_logic;
signal rxUartClock : in std_logic;
signal tx : out std_logic;
signal txData : in std_logic_vector(7 downto 0);
signal TFcount_slv30 : std_logic_vector(3 downto 0);
signal Rx : in std_logic;
signal RevData : out std_logic_vector(7 downto 0)
);
END COMPONENT;

--Inputs
signal i_reset : std_logic;
signal txUartClock,rxUartClock : std_logic := '0';
signal txData : std_logic_vector(7 downto 0);
signal TFcount_slv30 : std_logic_vector(3 downto 0);
signal Rx : std_logic;

--Outputs
signal tx : std_logic;
signal RevData : std_logic_vector(7 downto 0);

-- Clock period definitions
signal uartClock : std_logic;
constant t : integer := 2**4;
constant uartClockPeriod : time := 0.5 ms;
constant txUartClock_period : time := uartClockPeriod;
constant rxUartClock_period : time := uartClockPeriod;

signal tf_flag : std_logic;
signal tx_run,rx_run : std_logic := '0';

BEGIN

uut: weirdboyjim_uart PORT MAP (
i_reset => i_reset,
txUartClock => txUartClock,
rxUartClock => rxUartClock,
tx => tx,
txData => txData,
TFcount_slv30 => TFcount_slv30,
Rx => Rx,
RevData => RevData
);

-- Clock process definitions

--txUartClock_process : process (uartClock,i_reset,tx_run)
--	type states is (a,b,c);
--	variable state : states := a;
--begin
--	if (i_reset = '1') then
--		txUartClock <= '0';
--	elsif (rising_edge(uartClock)) then
--		case state is
--			when a =>
--				if (tx_run = '1') then
--					state := b;
--				end if;
--			when b =>
--				txUartClock <= '1';
--				if (tx_run = '1') then
--					state := c;
--				else
--					state := a;
--				end if;
--			when c =>
--				txUartClock <= '0';
--				if (tx_run = '1') then
--					state := b;
--				else
--					state := a;
--				end if;
--		end case;
--	end if;
--end process;

--rxUartClock_process : process (uartClock,rx_run)
--	type states is (a,b,c);
--	variable state : states := a;
--begin
--	if (rising_edge(uartClock)) then
--		case state is
--			when a =>
--				if (rx_run = '1') then
--					state := b;
--				end if;
--			when b =>
--				rxUartClock <= '1';
--				if (rx_run = '1') then
--					state := c;
--				else
--					state := a;
--				end if;
--			when c =>
--				rxUartClock <= '0';
--				if (rx_run = '1') then
--					state := b;
--				else
--					state := a;
--				end if;
--		end case;
--	end if;
--end process;

txUartClock_process : txUartClock <= not txUartClock after txUartClock_period/2 when tx_run = '1' else '0';
rxUartClock_process : rxUartClock <= not rxUartClock after rxUartClock_period/2 when rx_run = '1' else '0';

uartClock_process : process
begin
	uartClock <= '0';
	wait for uartClockPeriod/2;
	uartClock <= '1';
	wait for uartClockPeriod/2;
end process;

TFcount_process : process(rxUartClock,txUartClock,i_reset)
	constant N : integer := t;
	variable vtemp : integer range 0 to N-1 := 0;
begin
	if (i_reset = '1') then
		vtemp := 0;
	elsif (rising_edge(rxUartClock) or rising_edge(txUartClock)) then
		TFcount_slv30 <= std_logic_vector(to_unsigned(vtemp,4));
		if (vtemp = N-1) then
			vtemp := 0;
		else
			vtemp := vtemp + 1;
		end if;
	end if;
end process;

tf_flag <= '1' when TFcount_slv30 = "0000" else '0';

-- Stimulus process
stim_proc: process
constant N : integer := 9;
type va is array(integer range <>) of std_logic_vector(7 downto 0);
constant v : va(0 to N-1) := (
"11111111",
"00000000",
"10101011",
"11010101",
"01010100",
"00101010",
"11111111",
"00000000",
"11111111"
);
begin

i_reset <= '1';
wait for uartClockPeriod*2;
i_reset <= '0';

--tx_run <= '1';
--rx_run <= '0';
--
--wait for uartClockPeriod;
--
--tx_l0 : for txi in 0 to v'length - 1 loop
--	txData <= v(txi);
--	wait for txUartClock_period*256;
--	i_reset <= '1';
--	wait for txUartClock_period;
--	i_reset <= '0';
--	wait for txUartClock_period*256;
--end loop tx_l0;
--
--wait for uartClockPeriod;

tx_run <= '0';
rx_run <= '1';

wait for uartClockPeriod;

rx_l0 : for rxi in 0 to v'length - 1 loop
	Rx <= '0';
	wait for rxUartClock_period*t;
	rx_l1 : for j in 0 to 7 loop
		Rx <= v(rxi)(j);
		wait for rxUartClock_period*t;
	end loop rx_l1;
	Rx <= '1';
	wait for rxUartClock_period*t;
	Rx <= '1';
	wait for rxUartClock_period*t*10;
--	i_reset <= '1';
--	wait for rxUartClock_period*2;
--	i_reset <= '0';
--	wait for rxUartClock_period*256;
end loop rx_l0;

wait for uartClockPeriod;

tx_run <= '0';
rx_run <= '0';

wait for uartClockPeriod;

-- insert stimulus here
report "done" severity failure;
wait;
end process;

END;
