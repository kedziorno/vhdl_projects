--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:03:02 03/09/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/pwm_led/tb_debounce.vhd
-- Project Name:  pwm_led
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: debounce
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

ENTITY tb_debounce IS
END tb_debounce;

ARCHITECTURE behavior OF tb_debounce IS

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT debounce
	PORT(
	i_clk : IN  std_logic;
	i_reset : in  STD_LOGIC;
	i_btn : IN  std_logic;
	o_db_btn : OUT  std_logic
	);
	END COMPONENT;

	COMPONENT lfsr1 IS
	generic (G_SIZE : integer);
	port (
		reset : in std_logic;
		clk : in std_logic;
		enable : in std_logic;
		count : out std_logic_vector (G_SIZE-1 downto 0) -- lfsr output
	);
	END COMPONENT lfsr1;

	COMPONENT clock_divider_cnt IS
	Generic (
		g_board_clock : integer;
		g_divider : integer
	);
	Port (
		i_reset : in  STD_LOGIC;
		i_clock : in STD_LOGIC;
		o_clock : out STD_LOGIC
	);
	END COMPONENT clock_divider_cnt;

	--Inputs
	signal i_clk : std_logic := '0';
	signal i_btn : std_logic := '0';
	signal reset : std_logic := '0';
	signal enable : std_logic := '1';

	--Outputs
	signal o_db_btn : std_logic;
	constant LFSR : integer := 32;
	signal o_count : std_logic_vector (LFSR-1 downto 0);
	signal o_clk_div : std_logic;

	-- Clock period definitions
	constant G_BOARD_CLOCK : integer := 50_000_000;
	constant i_clk_period : time := (1_000_000_000/G_BOARD_CLOCK) * 1 ns; -- XXX 50Mhz
	constant WAIT0_COUNT : integer := LFSR;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: debounce PORT MAP (
	i_clk => i_clk,
	i_reset => reset,
	i_btn => i_btn,
	o_db_btn => o_db_btn
	);

	uut_lfsr: lfsr1
	GENERIC MAP (G_SIZE => LFSR)
	PORT MAP (
		reset => reset,
		clk => i_clk,
		enable => enable,
		count => o_count
	);

	uut_clkdiv: clock_divider_cnt
	GENERIC MAP (
		g_board_clock => G_BOARD_CLOCK,
		g_divider => G_BOARD_CLOCK / LFSR -- out clk cnt = LFSR
	)
	PORT MAP (
		i_reset => reset,
		i_clock => i_clk,
		o_clock => o_clk_div
	);

	-- Clock process definitions
	i_clk_process :process
	begin
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for i_clk_period/2;
	end process;

	reset <= '1', '0' after i_clk_period;

	-- Stimulus process
	stim_proc: process (i_clk) is
		variable index : integer range 0 to LFSR-1 := 0;
		variable wait0 : integer range 0 to WAIT0_COUNT-1 := 0;
		type state_type is (enable_lfsr,send_state,send_again,disable_lfsr,wait0_state);
		variable state : state_type;
		constant send_the_same : integer := 1;
		variable send_the_same_index : integer range 0 to send_the_same-1 := 0;
	begin
		-- insert stimulus here
		if (rising_edge(i_clk)) then
			case (state) is
				when enable_lfsr =>
					state := disable_lfsr;
					enable <= '1';
				when disable_lfsr =>
					state := send_state;
					enable <= '0';
				when send_state =>
					if (index < LFSR-1) then
						state := send_state;
						i_btn <= o_count(index);
						index := index + 1;
					else
						index := 0;
						state := wait0_state;
					end if;
				when send_again =>
					if (send_the_same_index < send_the_same) then
						send_the_same_index := send_the_same_index + 1;
						state := send_state;
					else
						send_the_same_index := 0;
						state := wait0_state;
					end if;
				when wait0_state =>
					if (wait0 < WAIT0_COUNT) then
						state := wait0_state;
						wait0 := wait0 + 1;
						i_btn <= '0';
					else
						state := enable_lfsr;
						wait0 := 0;
					end if;
			end case;
		end if;
	end process;

END;
