--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:51:58 08/28/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/i2c_test_1/tb_test_oled.vhd
-- Project Name:  i2c_test_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: test_oled
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

ENTITY tb_oled_display IS
END tb_oled_display;

ARCHITECTURE behavior OF tb_oled_display IS 

    constant INPUT_CLOCK : integer := 50_000_000;
    constant BUS_CLOCK : integer := 100_000;
    constant OLED_WIDTH : integer := 128;
    constant OLED_HEIGHT : integer := 32;
    constant OLED_W_BITS : integer := 7;
    constant OLED_H_BITS : integer := 5;

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT oled_display
    GENERIC(
         GLOBAL_CLK : integer;
         I2C_CLK : integer;
         WIDTH : integer;
         HEIGHT : integer;
         W_BITS : integer;
         H_BITS : integer);
    PORT(
         i_clk : IN  std_logic;
         i_rst : IN  std_logic;
         i_x : in std_logic_vector(W_BITS-1 downto 0);
         i_y : in std_logic_vector(H_BITS-1 downto 0);
         i_data : in std_logic;
         io_sda : INOUT  std_logic;
         io_scl : INOUT  std_logic
        );
    END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal a : std_logic_vector(OLED_W_BITS-1 downto 0) := (others => '0');
   signal b : std_logic_vector(OLED_H_BITS-1 downto 0) := (others => '0');

	--BiDirs
   signal sda : std_logic;
   signal scl : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;

   constant NV : integer := 10;
   type t_coord_x is array(0 to NV-1) of std_logic_vector(7 downto 0);
   type t_coord_y is array(0 to NV-1) of std_logic_vector(7 downto 0);
   signal x_coord : t_coord_x := (x"00",x"00",x"20",x"20",x"40",x"40",x"60",x"60",x"7F",x"7F");
   signal y_coord : t_coord_y := (x"00",x"1F",x"00",x"1F",x"00",x"1F",x"00",x"1F",x"00",x"1F");

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: oled_display 
	GENERIC MAP (
		GLOBAL_CLK => INPUT_CLOCK,
		I2C_CLK => BUS_CLOCK,
		WIDTH => OLED_WIDTH,
		HEIGHT => OLED_HEIGHT,
		W_BITS => OLED_W_BITS,
		H_BITS => OLED_H_BITS)
	PORT MAP (
		i_clk => clk,
		i_rst => rst,
		i_x => a,
		i_y => b,
		i_data => '1',
		io_sda => sda,
		io_scl => scl
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
	begin
		wait for 20 ns;
		rst <= '1';
		wait for 20 ns;
		rst <= '0';

		wait for 60 ms;
		a <= x_coord(0)(OLED_W_BITS-1 downto 0);
		b <= y_coord(0)(OLED_H_BITS-1 downto 0);
		wait for 60 ms;
		a <= x_coord(1)(OLED_W_BITS-1 downto 0);
		b <= y_coord(1)(OLED_H_BITS-1 downto 0);
		wait for 60 ms;
		a <= x_coord(2)(OLED_W_BITS-1 downto 0);
		b <= y_coord(2)(OLED_H_BITS-1 downto 0);
		wait for 60 ms;
		a <= x_coord(3)(OLED_W_BITS-1 downto 0);
		b <= y_coord(3)(OLED_H_BITS-1 downto 0);
		wait for 60 ms;
		a <= x_coord(4)(OLED_W_BITS-1 downto 0);
		b <= y_coord(4)(OLED_H_BITS-1 downto 0);
		wait for 60 ms;
		a <= x_coord(5)(OLED_W_BITS-1 downto 0);
		b <= y_coord(5)(OLED_H_BITS-1 downto 0);
		wait for 60 ms;
		a <= x_coord(6)(OLED_W_BITS-1 downto 0);
		b <= y_coord(6)(OLED_H_BITS-1 downto 0);
		wait for 60 ms;
		a <= x_coord(7)(OLED_W_BITS-1 downto 0);
		b <= y_coord(7)(OLED_H_BITS-1 downto 0);
		wait for 60 ms;
		a <= x_coord(8)(OLED_W_BITS-1 downto 0);
		b <= y_coord(8)(OLED_H_BITS-1 downto 0);
		wait for 60 ms;
		a <= x_coord(9)(OLED_W_BITS-1 downto 0);
		b <= y_coord(9)(OLED_H_BITS-1 downto 0);
	end process;

END;
