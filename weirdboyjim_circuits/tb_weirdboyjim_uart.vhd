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
tx : OUT  std_logic;
rx : IN  std_logic;
UartClock : IN  std_logic;
txData : IN  std_logic_vector(7 downto 0);
txClock : IN  std_logic;
TFcount_slv30 : IN  std_logic_vector(3 downto 0);
i_reset : IN  std_logic
);
END COMPONENT;

--Inputs
signal rx : std_logic := '0';
signal UartClock,UartClock2 : std_logic := '0';
signal txData : std_logic_vector(7 downto 0) := (others => '0');
signal txClock : std_logic := '0';
signal TFcount_slv30 : std_logic_vector(3 downto 0) := (others => '0');
signal i_reset : std_logic;

--Outputs
signal tx : std_logic;

-- Clock period definitions
constant t : integer := 16;
constant UartClock_period : time := 100 us;
constant txClock_period : time := UartClock_period/t;
signal tf_flag : std_logic := '0';

BEGIN

uut: weirdboyjim_uart PORT MAP (
tx => tx,
rx => rx,
UartClock => UartClock,
txData => txData,
txClock => txClock,
TFcount_slv30 => TFcount_slv30,
i_reset => i_reset
);

-- Clock process definitions
UartClock_process : process
begin
UartClock <= '0';
wait for UartClock_period/2;
--wait for UartClock_period - 100 ps;
UartClock <= '1';
wait for UartClock_period/2;
--wait for 100 ps;
end process;

--UartClock_process2 : process(UartClock)
--	variable vtemp : integer range 0 to t-1;
--begin
--	if (rising_edge(UartClock)) then
--		if (vtemp = t-1) then
--			UartClock2 <= '1';
--			vtemp := 0;
--		else
--			UartClock2 <= '0';
--			vtemp := vtemp + 1;
--		end if;
--	else
--		vtemp := vtemp;
--		UartClock2 <= '0';
--	end if;
--end process;

txClock_process : process
begin
txClock <= '0';
wait for txClock_period/2;
txClock <= '1';
wait for txClock_period/2;
end process;

TFcount_process : process(txClock)
	variable vtemp : integer range 0 to 15 := 0;
begin
	if (rising_edge(txClock)) then
		if (vtemp = 15) then
			vtemp := 0;
		else
			vtemp := vtemp + 1;
		end if;
	end if;
	TFcount_slv30 <= std_logic_vector(to_unsigned(vtemp,4));
end process;

tf_flag <= '1' when TFcount_slv30 = "0000" else '0';

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
i_reset <= '1';
wait for txClock_period;
i_reset <= '0';
txData <= "10101011";
wait for txClock_period*t;
txData <= "11010101";
wait for txClock_period*t;
txData <= "01010100";
wait for txClock_period*t;
txData <= "00101010";
wait for txClock_period*t;
txData <= "11111111";
wait for txClock_period*t;
txData <= "00000000";
wait for txClock_period*t;

-- insert stimulus here
report "done" severity failure;
wait;
end process;

END;
