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
	constant SIZE : integer := 8;
	constant DEBOUNCE_REGISTER : integer := 5;
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

	COMPONENT lfsr1 IS
	GENERIC (G_SIZE : integer);
	PORT (
		reset : in std_logic;
		clk : in std_logic;
		enable : in std_logic;
		count : out std_logic_vector (G_SIZE-1 downto 0) -- lfsr output
	);
	END COMPONENT lfsr1;

	COMPONENT graycode IS
	GENERIC (G_SIZE : integer);
	PORT (
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
	signal enable_gc : std_logic := '0';
	signal enable_lfsr : std_logic := '0';
	signal i_int : std_logic_vector (SIZE-1 downto 0) := (others => '0');

	--Outputs
	signal o_db_btn : std_logic;
	signal o_gc : std_logic_vector (SIZE-1 downto 0);
	signal o_lfsr : std_logic_vector (SIZE-1 downto 0);
	signal o_clk_div : std_logic;

	-- Clock period definitions
	constant i_clk_period : time := (1_000_000_000/G_BOARD_CLOCK) * 1 ns; -- XXX 50Mhz

	-- States
	type state_type is (idle,start,lfsr_enable,lfsr_disable,lfsr_send,lfsr_increment,lfsr_wait0,gc_send,gc_increment,gc_wait0,stop);
	signal state : state_type := idle;
	signal simulation_finish : std_logic := '0';

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

	uut_lfsr: lfsr1
	GENERIC MAP (G_SIZE => SIZE)
	PORT MAP (
		reset => reset,
		clk => i_clk,
		enable => enable_lfsr,
		count => o_lfsr
	);

	uut_graycode: graycode
	GENERIC MAP (G_SIZE => SIZE)
	PORT MAP (
		reset => reset,
		clk => i_clk,
		enable => enable_gc,
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
		while simulation_finish = '0' loop
			i_clk <= '0';
			wait for i_clk_period/2;
			i_clk <= '1';
			wait for i_clk_period/2;
			end loop;
		wait;
	end process;

	-- Stimulus process
	stim_proc: process (i_clk) is

		constant WAIT0_COUNT : integer := SIZE;
		variable wait0 : integer range 0 to WAIT0_COUNT-1 := 0;
-- LFSR
		variable index : integer range 0 to SIZE-1 := 0;
		constant send_the_same : integer := 1;
		variable send_the_same_index : integer range 0 to send_the_same-1 := 0;
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
				when idle =>
					state <= start;
					reset <= '1', '0' after 10*i_clk_period;
				when start =>
					state <= gc_send;
					REPORT "GRAYCODE" SEVERITY NOTE;
				when gc_send => -- start from gc mode
					if (o_gc_index = o_gc_max-1) then
						state <= gc_increment;
						o_gc_index := 0;
						enable_gc <= '1';
					else
						state <= gc_send;
						i_btn <= o_gc(o_gc_index);
						o_gc_index := o_gc_index + 1;
					end if;
				when gc_increment =>
					enable_gc <= '0';
					if (to_integer(unsigned(gc_index)) = to_integer(unsigned(gc_max))-1) then
						state <= lfsr_enable; -- jump to lfsr mode
						REPORT "LFSR" SEVERITY NOTE;
						gc_index := std_logic_vector(to_unsigned(0,SIZE));
					else
						state <= gc_wait0;
						gc_index := std_logic_vector(to_unsigned(to_integer(unsigned(gc_index) + 1),SIZE));
						i_int <= gc_index;
					end if;
				when gc_wait0 =>
					if (wait0 < WAIT0_COUNT) then
						state <= gc_wait0;
						wait0 := wait0 + 1;
						i_btn <= '0';
					else
						state <= gc_send;
						wait0 := 0;
					end if;
				when lfsr_enable =>
					state <= lfsr_disable;
					enable_lfsr <= '1';
				when lfsr_disable =>
					state <= lfsr_send;
					enable_lfsr <= '0';
				when lfsr_send =>
					if (index = SIZE-1) then
						state <= lfsr_increment;
						index := 0;
					else
						state <= lfsr_send;
						i_btn <= o_lfsr(index);
						index := index + 1;
					end if;
				when lfsr_increment =>
					if (o_lfsr = std_logic_vector(to_unsigned(0,SIZE))) then
						state <= stop;
					else
						state <= lfsr_wait0;
					end if;
				when lfsr_wait0 =>
					if (wait0 = WAIT0_COUNT-1) then
						state <= lfsr_enable;
						wait0 := 0;
					else
						state <= lfsr_wait0;
						wait0 := wait0 + 1;
						i_btn <= '0';
					end if;
				when stop =>
					REPORT "END" SEVERITY NOTE;
					simulation_finish <= '1';
					state <= stop;
			end case;
		end if;
	end process;

END;
