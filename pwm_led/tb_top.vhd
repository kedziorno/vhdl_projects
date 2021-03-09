--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:27:16 02/26/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/pwm_led/tb_top.vhd
-- Project Name:  pwm_led
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_top IS
END tb_top;

ARCHITECTURE behavior OF tb_top IS 
	constant G_BOARD_CLOCK : integer := 1_000_000;
	constant G_PWM_WIDTH : integer := 8;
	constant G_LEDS : integer := 8;
	constant G_SWITCHS : integer := 8;
	constant G_BUTTONS : integer := 4;

	-- Component Declaration for the Unit Under Test (UUT)

	COMPONENT top IS
	Generic (
		BOARD_CLOCK : integer;
		PWM_WIDTH : integer;
		LEDS : integer;
		SWITCHS : integer;
		BUTTONS : integer
	);
	Port (
		clk : in  STD_LOGIC;
		btn : in  STD_LOGIC_VECTOR(BUTTONS-1 downto 0);
		sw : in  STD_LOGIC_VECTOR (SWITCHS-1 downto 0);
		led : out  STD_LOGIC_VECTOR (LEDS-1 downto 0)
	);
	END COMPONENT top;

	--Inputs
	signal clk : std_logic := '0';
	signal btn : std_logic_vector(G_BUTTONS-1 downto 0) := (others => '0');
	signal sw : std_logic_vector(G_SWITCHS-1 downto 0) := (others => '0');

	--Outputs
	signal led : std_logic_vector(G_LEDS-1 downto 0);

	-- Clock period definitions
	constant clk_period : time := (1_000_000_000/G_BOARD_CLOCK) * 1 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: top
		GENERIC MAP (
		BOARD_CLOCK => G_BOARD_CLOCK,
		PWM_WIDTH => G_PWM_WIDTH,
		LEDS => G_LEDS,
		SWITCHS => G_SWITCHS,
		BUTTONS => G_BUTTONS
	)
	PORT MAP (
		clk => clk,
		btn => btn,
		sw => sw,
		led => led
	);

	-- Clock process definitions
	clk_process :process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	btn(0) <= '1', '0' after clk_period*10;
	 
	-- Stimulus process
	stim_proc: process
		variable delay : time := G_BOARD_CLOCK * clk_period;
	begin
		sw <= "00000000";
		wait for delay;

		sw <= "00000001";
		wait for delay;
		sw <= "00000010";
		wait for delay;
		sw <= "00000100";
		wait for delay;
		sw <= "00001000";
		wait for delay;
		sw <= "00010000";
		wait for delay;
		sw <= "00100000";
		wait for delay;
		sw <= "01000000";
		wait for delay;
		sw <= "10000000";
		wait for delay;

		sw <= "00000000";
		wait for delay;		
		sw <= "00000001";
		wait for delay;
		sw <= "00000011";
		wait for delay;
		sw <= "00000111";
		wait for delay;
		sw <= "00001111";
		wait for delay;
		sw <= "00011111";
		wait for delay;
		sw <= "00111111";
		wait for delay;
		sw <= "01111111";
		wait for delay;
		sw <= "11111111";
		wait for delay;
		sw <= "01111111";
		wait for delay;
		sw <= "00111111";
		wait for delay;
		sw <= "00011111";
		wait for delay;
		sw <= "00001111";
		wait for delay;
		sw <= "00000111";
		wait for delay;
		sw <= "00000011";
		wait for delay;
		sw <= "00000001";
		wait for delay;
		sw <= "00000000";
		wait for delay;
	end process;

END;
