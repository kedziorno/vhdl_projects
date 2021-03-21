--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:48:53 03/19/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/rs232_1/tb_top.vhd
-- Project Name:  rs232_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
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
USE WORK.p_constants.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_top IS
END tb_top;

ARCHITECTURE behavior OF tb_top IS 

	-- Clock period definitions
	constant i_clock_period : time := (1_000_000_000/G_BOARD_CLOCK) * 1 ns;
	constant one_uart_bit : time := (G_BOARD_CLOCK/G_BAUD_RATE) * i_clock_period;

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT top
	GENERIC(
		G_BOARD_CLOCK : integer := G_BOARD_CLOCK;
		G_BAUD_RATE : integer := G_BAUD_RATE
	);
	PORT(
		i_clock : IN  std_logic;
		i_reset : IN  std_logic;
		o_RsTX : OUT  std_logic;
		i_RsRX : IN  std_logic
	);
	END COMPONENT;

	--Inputs
	signal i_clock : std_logic := '0';
	signal i_reset : std_logic := '0';
	signal i_RsRX : std_logic := '0';

	--Outputs
	signal o_RsTX : std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: top
	GENERIC MAP (
		G_BOARD_CLOCK => G_BOARD_CLOCK,
		G_BAUD_RATE => G_BAUD_RATE
	)
	PORT MAP (
		i_clock => i_clock,
		i_reset => i_reset,
		o_RsTX => o_RsTX,
		i_RsRX => i_RsRX
	);

	-- Clock process definitions
	i_clock_process :process
	begin
		i_clock <= '0';
		wait for i_clock_period/2;
		i_clock <= '1';
		wait for i_clock_period/2;
	end process;

	-- Stimulus process
	stim_proc: process
		type test_array is array(0 to 10) of std_logic_vector(7 downto 0);
		variable test : test_array := (x"AA",x"55",x"FF",x"00",x"41",x"42",x"43",x"44",x"45",x"46",x"47");
	begin
		i_reset <= '1';
		wait for i_clock_period;
		i_reset <= '0';
		wait for 40 ms; -- must wait for user key
		-- insert stimulus here
		l0 : for i in 0 to 10 loop
			i_RsRX <= '1';
			wait for one_uart_bit;
			l1 : for j in 0 to 7 loop
				i_RsRX <= test(i)(j);
				wait for one_uart_bit;
			end loop l1;
			i_RsRX <= test(i)(0) xor test(i)(1) xor test(i)(2) xor test(i)(3) xor test(i)(4) xor test(i)(5) xor test(i)(6) xor test(i)(7);
			wait for one_uart_bit;
			i_RsRX <= '0';
			wait for one_uart_bit;
		end loop l0;
		wait;
	end process;

END;
