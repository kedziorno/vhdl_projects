--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:00:19 09/08/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/rs232_1/tbmodule_1.vhd
-- Project Name:  rs232_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: module_1
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

ENTITY tb_rs232_1 IS END tb_rs232_1;

ARCHITECTURE behavior OF tb_rs232_1 IS 

	constant G_BOARD_CLOCK : integer := 50_000_000;
	constant G_BAUD_RATE : integer := 9_600;
	-- Clock period definitions
	constant clk_period : time := (1_000_000_000/G_BOARD_CLOCK) * 1 ns;
	constant one_uart_bit : time := (G_BOARD_CLOCK/G_BAUD_RATE) * clk_period;

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT rs232 IS
	Generic (
		G_BOARD_CLOCK : integer := G_BOARD_CLOCK;
		G_BAUD_RATE : integer := G_BAUD_RATE
	);
	Port(
		clk : in  STD_LOGIC;
		rst : in  STD_LOGIC;
		enable : in  STD_LOGIC;
		byte_to_send : in  STD_LOGIC_VECTOR (7 downto 0);
		byte_received : out  STD_LOGIC_VECTOR (7 downto 0);
		busy : out  STD_LOGIC;
		ready : out  STD_LOGIC;
		RsTx : out  STD_LOGIC;
		RsRx : in  STD_LOGIC
	);
	END COMPONENT rs232;

	--Inputs
	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal enable : std_logic := '0';
	signal byte_to_send : std_logic_vector(7 downto 0) := (others => '0');
	signal RsRx : std_logic := '0';

	--Outputs
	signal byte_received : std_logic_vector(7 downto 0);
	signal busy : std_logic;
	signal ready : std_logic;
	signal RsTx : std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : rs232
	GENERIC MAP (
		G_BOARD_CLOCK => G_BOARD_CLOCK,
		G_BAUD_RATE => G_BAUD_RATE
	)
	PORT MAP (
		clk => clk,
		rst => rst,
		enable => enable,
		byte_to_send => byte_to_send,
		byte_received => byte_received,
		busy => busy,
		ready => ready,
		RsTx => RsTx, -- byte_to_send => 
		RsRx => RsRx -- byte_received <=
	);

	-- Clock process definitions
	clk_process :process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	rst <= '1','0' after clk_period;

	-- Stimulus process
	stim_proc: process
	begin
		RsRx <= '1';
		wait for one_uart_bit;
		RsRx <= '0';
		wait for one_uart_bit;
		RsRx <= '1';
		wait for one_uart_bit;
		RsRx <= '0';
		wait for one_uart_bit;
		RsRx <= '1';
		wait for one_uart_bit;
		RsRx <= '0';
		wait for one_uart_bit;
		RsRx <= '1';
		wait for one_uart_bit;
		RsRx <= '0';
		wait for one_uart_bit;
		RsRx <= '1';
		wait for one_uart_bit;
		RsRx <= '0';
		wait for one_uart_bit;
		wait;
	end process;

END;
