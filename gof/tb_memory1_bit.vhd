--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   18:32:08 11/11/2020
-- Design Name:
-- Module Name:   /home/user/workspace/vhdl_projects/gof/tb_memory1.vhd
-- Project Name:  gof
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: memory1
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
use WORK.p_memory_content.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

ENTITY tb_memory1_bit IS
END tb_memory1_bit;

ARCHITECTURE behavior OF tb_memory1_bit IS

	COMPONENT memory1
	PORT(
		i_clk : in std_logic;
		i_enable_byte : in std_logic;
		i_enable_bit : in std_logic;
		i_write_byte : in std_logic;
		i_write_bit : in std_logic;
		i_row : in std_logic_vector(ROWS_BITS-1 downto 0);
		i_col_pixel : in std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
		i_col_block : in std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
		i_byte : in std_logic_vector(BYTE_BITS-1 downto 0);
		i_bit : in std_logic;
		o_byte : out std_logic_vector(BYTE_BITS-1 downto 0);
		o_bit : out std_logic);
	END COMPONENT;

	--Inputs - leave bit options and set default byte to 0
	signal i_clk : std_logic;
	signal i_enable_byte : std_logic := '0';
	signal i_enable_bit : std_logic;
	signal i_write_byte : std_logic := '0';
	signal i_write_bit : std_logic;
	signal i_row : std_logic_vector(6 downto 0);
	signal i_col_pixel : std_logic_vector(4 downto 0);
	signal i_col_block : std_logic_vector(1 downto 0) := (others => '0');
	signal i_byte : std_logic_vector(7 downto 0) := (others => '0');
	signal i_bit : std_logic;

	--Outputs - leave bit options and set default byte to 0
	signal o_byte : std_logic_vector(7 downto 0) := (others => '0');
	signal o_bit : std_logic;

	-- Clock period definitions
	constant i_clk_period : time := 20 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: memory1 PORT MAP (
		i_clk => i_clk,
		i_enable_byte => i_enable_byte,
		i_enable_bit => i_enable_bit,
		i_write_byte => i_write_byte,
		i_write_bit => i_write_bit,
		i_row => i_row,
		i_col_pixel => i_col_pixel,
		i_col_block => i_col_block,
		i_byte => i_byte,
		i_bit => i_bit,
		o_byte => o_byte,
		o_bit => o_bit
	);

	-- Clock process definitions
	i_clk_process :process
	begin
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for i_clk_period/2;
	end process;

	-- Stimulus process
	stim_proc: process
	begin
		wait for i_clk_period;

		--
		-- 12 random pixels - first/last two have 0 and rest have 1
		--

		-- enable module
		i_enable_bit <= '1';

		i_row <= std_logic_vector(to_unsigned(123,7));
		i_col_pixel <= std_logic_vector(to_unsigned(13,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(25,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(127,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(20,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(96,7));
		i_col_pixel <= std_logic_vector(to_unsigned(0,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(65,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(62,7));
		i_col_pixel <= std_logic_vector(to_unsigned(28,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(2,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(19,7));
		i_col_pixel <= std_logic_vector(to_unsigned(16,5));
		wait for i_clk_period;

		-- disable module
		i_enable_bit <= '0';

		-- better visible in simulation
		i_row <= "UUUUUUU";
		i_col_pixel <= "UUUUU";
		i_enable_bit <= 'U';
		
		wait for 10*i_clk_period;
		
		--
		-- 12 writes 1 bit - write sequence 010101010101
		--
		
		-- enable module and enable write
		i_enable_bit <= '1';
		i_write_bit <= '1';
		
		i_row <= std_logic_vector(to_unsigned(123,7));
		i_col_pixel <= std_logic_vector(to_unsigned(13,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(25,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(127,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(20,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(96,7));
		i_col_pixel <= std_logic_vector(to_unsigned(0,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(65,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(62,7));
		i_col_pixel <= std_logic_vector(to_unsigned(28,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(2,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(19,7));
		i_col_pixel <= std_logic_vector(to_unsigned(16,5));
		i_bit <= '1';
		wait for i_clk_period;
		
		-- disable module
		i_enable_bit <= '0';
		i_write_bit <= '0';
		
		-- better visible in simulation
		i_row <= "UUUUUUU";
		i_col_pixel <= "UUUUU";
		i_enable_bit <= 'U';
		i_write_bit <= 'U';
		i_bit <= 'U';
		
		wait for 10*i_clk_period;
		
		--
		-- 12 reads the same 1 bit - sequence 010101010101
		--
		
		-- enable module
		i_enable_bit <= '1';

		i_row <= std_logic_vector(to_unsigned(123,7));
		i_col_pixel <= std_logic_vector(to_unsigned(13,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(25,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(127,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(20,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(96,7));
		i_col_pixel <= std_logic_vector(to_unsigned(0,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(65,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(62,7));
		i_col_pixel <= std_logic_vector(to_unsigned(28,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(2,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(19,7));
		i_col_pixel <= std_logic_vector(to_unsigned(16,5));
		wait for i_clk_period;

		-- disable module
		i_enable_bit <= '0';

		-- better visible in simulation
		i_row <= "UUUUUUU";
		i_col_pixel <= "UUUUU";
		i_enable_bit <= 'U';
		
		wait for 10*i_clk_period;
		
		--
		-- 12 writes 1 bit - write sequence 101010101010
		--
		
		-- enable module and enable write
		i_enable_bit <= '1';
		i_write_bit <= '1';
		
		i_row <= std_logic_vector(to_unsigned(123,7));
		i_col_pixel <= std_logic_vector(to_unsigned(13,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(25,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(127,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(20,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(96,7));
		i_col_pixel <= std_logic_vector(to_unsigned(0,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(65,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(62,7));
		i_col_pixel <= std_logic_vector(to_unsigned(28,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(2,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(19,7));
		i_col_pixel <= std_logic_vector(to_unsigned(16,5));
		i_bit <= '0';
		wait for i_clk_period;
		
		-- disable module
		i_enable_bit <= '0';
		i_write_bit <= '0';
		
		-- better visible in simulation
		i_row <= "UUUUUUU";
		i_col_pixel <= "UUUUU";
		i_enable_bit <= 'U';
		i_write_bit <= 'U';
		i_bit <= 'U';
		
		wait for 10*i_clk_period;
		
		--
		-- 12 reads the same 1 bit - sequence 101010101010
		--
		
		-- enable module
		i_enable_bit <= '1';

		i_row <= std_logic_vector(to_unsigned(123,7));
		i_col_pixel <= std_logic_vector(to_unsigned(13,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(25,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(127,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(20,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(96,7));
		i_col_pixel <= std_logic_vector(to_unsigned(0,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(65,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(62,7));
		i_col_pixel <= std_logic_vector(to_unsigned(28,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(2,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(19,7));
		i_col_pixel <= std_logic_vector(to_unsigned(16,5));
		wait for i_clk_period;

		-- disable module
		i_enable_bit <= '0';

		-- better visible in simulation
		i_row <= "UUUUUUU";
		i_col_pixel <= "UUUUU";
		i_enable_bit <= 'U';
		
		wait for 10*i_clk_period;
		
		--
		-- 12 writes 1 bit - write sequence 111111111111
		--
		
		-- enable module and enable write
		i_enable_bit <= '1';
		i_write_bit <= '1';
		
		i_row <= std_logic_vector(to_unsigned(123,7));
		i_col_pixel <= std_logic_vector(to_unsigned(13,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(25,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(127,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(20,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(96,7));
		i_col_pixel <= std_logic_vector(to_unsigned(0,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(65,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(62,7));
		i_col_pixel <= std_logic_vector(to_unsigned(28,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(2,5));
		i_bit <= '1';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(19,7));
		i_col_pixel <= std_logic_vector(to_unsigned(16,5));
		i_bit <= '1';
		wait for i_clk_period;
		
		-- disable module
		i_enable_bit <= '0';
		i_write_bit <= '0';
		
		-- better visible in simulation
		i_row <= "UUUUUUU";
		i_col_pixel <= "UUUUU";
		i_enable_bit <= 'U';
		i_write_bit <= 'U';
		i_bit <= 'U';
		
		wait for 10*i_clk_period;
		
		--
		-- 12 reads the same 1 bit - sequence 111111111111
		--
		
		-- enable module
		i_enable_bit <= '1';

		i_row <= std_logic_vector(to_unsigned(123,7));
		i_col_pixel <= std_logic_vector(to_unsigned(13,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(25,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(127,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(20,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(96,7));
		i_col_pixel <= std_logic_vector(to_unsigned(0,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(65,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(62,7));
		i_col_pixel <= std_logic_vector(to_unsigned(28,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(2,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(19,7));
		i_col_pixel <= std_logic_vector(to_unsigned(16,5));
		wait for i_clk_period;

		-- disable module
		i_enable_bit <= '0';

		-- better visible in simulation
		i_row <= "UUUUUUU";
		i_col_pixel <= "UUUUU";
		i_enable_bit <= 'U';
		
		wait for 10*i_clk_period;
		
		--
		-- 12 writes 1 bit - write sequence 000000000000
		--
		
		-- enable module and enable write
		i_enable_bit <= '1';
		i_write_bit <= '1';
		
		i_row <= std_logic_vector(to_unsigned(123,7));
		i_col_pixel <= std_logic_vector(to_unsigned(13,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(25,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(127,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(20,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(96,7));
		i_col_pixel <= std_logic_vector(to_unsigned(0,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(65,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(62,7));
		i_col_pixel <= std_logic_vector(to_unsigned(28,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(2,5));
		i_bit <= '0';
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(19,7));
		i_col_pixel <= std_logic_vector(to_unsigned(16,5));
		i_bit <= '0';
		wait for i_clk_period;
		
		-- disable module
		i_enable_bit <= '0';
		i_write_bit <= '0';
		
		-- better visible in simulation
		i_row <= "UUUUUUU";
		i_col_pixel <= "UUUUU";
		i_enable_bit <= 'U';
		i_write_bit <= 'U';
		i_bit <= 'U';
		
		wait for 10*i_clk_period;
		
		--
		-- 12 reads the same 1 bit - sequence 000000000000
		--
		
		-- enable module
		i_enable_bit <= '1';

		i_row <= std_logic_vector(to_unsigned(123,7));
		i_col_pixel <= std_logic_vector(to_unsigned(13,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(25,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(127,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(20,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(116,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(96,7));
		i_col_pixel <= std_logic_vector(to_unsigned(0,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(65,7));
		i_col_pixel <= std_logic_vector(to_unsigned(31,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(62,7));
		i_col_pixel <= std_logic_vector(to_unsigned(28,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(43,7));
		i_col_pixel <= std_logic_vector(to_unsigned(9,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(29,7));
		i_col_pixel <= std_logic_vector(to_unsigned(2,5));
		wait for i_clk_period;

		i_row <= std_logic_vector(to_unsigned(19,7));
		i_col_pixel <= std_logic_vector(to_unsigned(16,5));
		wait for i_clk_period;

		-- disable module
		i_enable_bit <= '0';

		-- better visible in simulation
		i_row <= "UUUUUUU";
		i_col_pixel <= "UUUUU";
		i_enable_bit <= 'U';
		
		wait;
	end process;

END;
