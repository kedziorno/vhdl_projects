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
USE ieee.numeric_std.ALL;

ENTITY tb_debounce IS
END tb_debounce;

ARCHITECTURE behavior OF tb_debounce IS

	-- Constant
	constant SIZE : integer := 18;
	constant DEBOUNCE_REGISTER : integer := 8;
	constant G_BOARD_CLOCK : integer := 50_000_000;

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT debounce
	GENERIC (
	G_BOARD_CLOCK : integer;
	G_SIZE : integer
	);
	PORT(
	i_clk : IN  std_logic;
	i_reset : in  STD_LOGIC;
	i_btn : IN  std_logic;
	o_db_btn : OUT  std_logic
	);
	END COMPONENT;

--	COMPONENT lfsr1 IS
--	generic (G_SIZE : integer);
--	port (
--		reset : in std_logic;
--		clk : in std_logic;
--		enable : in std_logic;
--		count : out std_logic_vector (G_SIZE-1 downto 0) -- lfsr output
--	);
--	END COMPONENT lfsr1;

	COMPONENT graycode IS
	generic (G_SIZE : integer);
	port (
		reset : in std_logic;
		clk : in std_logic;
		enable : in std_logic;
		input : in std_logic_vector (G_SIZE-1 downto 0);
		output : out std_logic_vector (G_SIZE-1 downto 0)
	);
	END COMPONENT graycode;

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
	signal i_int : std_logic_vector (SIZE-1 downto 0) := (others => '0');

	--Outputs
	signal o_db_btn : std_logic;
	signal o_gc : std_logic_vector (SIZE-1 downto 0);
	signal o_clk_div : std_logic;

	-- Clock period definitions
	constant i_clk_period : time := (1_000_000_000/G_BOARD_CLOCK) * 1 ns; -- XXX 50Mhz

	-- States
	-- type state_type is (enable_lfsr,send_state,send_again,disable_lfsr,wait0_state);
	-- signal state : state_type;
	type state_type is (send,increment,w0s);
	signal state : state_type;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: debounce
	GENERIC MAP (
	G_BOARD_CLOCK => G_BOARD_CLOCK,
	G_SIZE => DEBOUNCE_REGISTER
	)
	PORT MAP (
	i_clk => i_clk,
	i_reset => reset,
	i_btn => i_btn,
	o_db_btn => o_db_btn
	);

--	uut_lfsr: lfsr1
--	GENERIC MAP (G_SIZE => SIZE)
--	PORT MAP (
--		reset => reset,
--		clk => i_clk,
--		enable => enable,
--		count => o_count
--	);

	uut_graycode: graycode
	GENERIC MAP (G_SIZE => SIZE)
	PORT MAP (
		reset => reset,
		clk => i_clk,
		enable => enable,
		input => i_int,
		output => o_gc
	);

	uut_clkdiv: clock_divider_cnt
	GENERIC MAP (
		g_board_clock => G_BOARD_CLOCK,
		g_divider => G_BOARD_CLOCK / SIZE -- out clk cnt
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
		constant WAIT0_COUNT : integer := SIZE;
		variable wait0 : integer range 0 to WAIT0_COUNT-1 := 0;

-- LFSR
--		variable index : integer range 0 to SIZE-1 := 0;
--		constant send_the_same : integer := 1;
--		variable send_the_same_index : integer range 0 to send_the_same-1 := 0;

-- GRAYCODE
		constant o_gc_max : integer := SIZE;
		variable o_gc_index : integer range 0 to o_gc_max-1 := 0;
		constant gc_max : std_logic_vector(SIZE-1 downto 0) := (others => '1');
		variable gc_index : std_logic_vector(SIZE-1 downto 0) := (others => '0');

	begin
		-- insert stimulus here
-- GRAYCODE
		if (rising_edge(i_clk)) then
			case (state) is
				when send =>
					if (o_gc_index = o_gc_max-1) then
						o_gc_index := 0;
						state <= increment;
						enable <= '1';
					else
						state <= send;
						i_btn <= o_gc(o_gc_index);
						o_gc_index := o_gc_index + 1;
					end if;
				when increment =>
					if (to_integer(unsigned(gc_index)) = to_integer(unsigned(gc_max))-1) then
						state <= send;
						gc_index := std_logic_vector(to_unsigned(0,SIZE));
					else
						enable <= '0';
						state <= w0s;
						gc_index := std_logic_vector(to_unsigned(to_integer(unsigned(gc_index) + 1),SIZE));
						i_int <= gc_index;
					end if;
				when w0s =>
					if (wait0 < WAIT0_COUNT) then
						state <= w0s;
						wait0 := wait0 + 1;
						i_btn <= '0';
					else
						state <= send;
						wait0 := 0;
					end if;
			end case;
		end if;

-- LFSR
--		if (rising_edge(i_clk)) then
--			case (state) is
--				when enable_lfsr =>
--					state := disable_lfsr;
--					enable <= '1';
--				when disable_lfsr =>
--					state := send_state;
--					enable <= '0';
--				when send_state =>
--					if (index < SIZE-1) then
--						state := send_state;
--						i_btn <= o_count(index);
--						index := index + 1;
--					else
--						index := 0;
--						state := wait0_state;
--					end if;
--				when send_again =>
--					if (send_the_same_index < send_the_same) then
--						send_the_same_index := send_the_same_index + 1;
--						state := send_state;
--					else
--						send_the_same_index := 0;
--						state := wait0_state;
--					end if;
--				when wait0_state =>
--					if (wait0 < WAIT0_COUNT) then
--						state := wait0_state;
--						wait0 := wait0 + 1;
--						i_btn <= '0';
--					else
--						state := enable_lfsr;
--						wait0 := 0;
--					end if;
--			end case;
--		end if;
	end process;

END;
