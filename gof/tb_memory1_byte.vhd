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

ENTITY tb_memory1_byte IS
END tb_memory1_byte;

ARCHITECTURE behavior OF tb_memory1_byte IS

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

	--Inputs - leave byte options and set default bit to 0
	signal i_clk : std_logic;
	signal i_enable_byte : std_logic;
	signal i_enable_bit : std_logic := '0';
	signal i_write_byte : std_logic;
	signal i_write_bit : std_logic := '0';
	signal i_row : std_logic_vector(6 downto 0);
	signal i_col_pixel : std_logic_vector(4 downto 0) := (others => '0');
	signal i_col_block : std_logic_vector(1 downto 0);
	signal i_byte : std_logic_vector(7 downto 0);
	signal i_bit : std_logic := '0';

	--Outputs - leave byte options and set default bit to 0
	signal o_byte : std_logic_vector(7 downto 0);
	signal o_bit : std_logic := '0';

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
		-- output byte from row 3-10 and col 3
		--

		-- enable module
		i_enable_byte <= '1';

		-- 10000000
		i_row <= std_logic_vector(to_unsigned(3,7));
		i_col_block <= std_logic_vector(to_unsigned(3,2));
		wait for i_clk_period;
		
		-- 01000000
		i_row <= std_logic_vector(to_unsigned(4,7));
		i_col_block <= std_logic_vector(to_unsigned(3,2));
		wait for i_clk_period;
		
		-- 00100000
		i_row <= std_logic_vector(to_unsigned(5,7));
		i_col_block <= std_logic_vector(to_unsigned(3,2));
		wait for i_clk_period;
		
		-- 00010000
		i_row <= std_logic_vector(to_unsigned(6,7));
		i_col_block <= std_logic_vector(to_unsigned(3,2));
		wait for i_clk_period;
		
		-- 00001000
		i_row <= std_logic_vector(to_unsigned(7,7));
		i_col_block <= std_logic_vector(to_unsigned(3,2));
		wait for i_clk_period;
		
		-- 00000100
		i_row <= std_logic_vector(to_unsigned(8,7));
		i_col_block <= std_logic_vector(to_unsigned(3,2));
		wait for i_clk_period;
		
		-- 00000010
		i_row <= std_logic_vector(to_unsigned(9,7));
		i_col_block <= std_logic_vector(to_unsigned(3,2));
		wait for i_clk_period;
		
		-- 00000001
		i_row <= std_logic_vector(to_unsigned(10,7));
		i_col_block <= std_logic_vector(to_unsigned(3,2));
		wait for i_clk_period;
		
		-- disable module
		i_enable_byte <= 'U';
		
		-- better visible in simulation
		i_row <= "UUUUUUU";
		i_col_block <= "UU";

		wait for 10*i_clk_period;

		-- 3 writes block byte in random positions
		
		-- enable and write to module
		i_enable_byte <= '1';
		i_write_byte <= '1';
		
		-- write 0 where we have ones
		i_row <= std_logic_vector(to_unsigned(0,7));
		i_col_block <= std_logic_vector(to_unsigned(3,2));
		i_byte <= x"55";
		wait for i_clk_period;
		
		i_row <= std_logic_vector(to_unsigned(0,7));
		i_col_block <= std_logic_vector(to_unsigned(2,2));
		i_byte <= x"AA";
		wait for i_clk_period;
		
		-- write 1 where we have zeros
		i_row <= std_logic_vector(to_unsigned(65,7));
		i_col_block <= std_logic_vector(to_unsigned(2,2));
		i_byte <= x"55";
		wait for i_clk_period;
		
		i_row <= std_logic_vector(to_unsigned(65,7));
		i_col_block <= std_logic_vector(to_unsigned(1,2));
		i_byte <= x"AA";
		wait for i_clk_period;
		
		-- write 16bit 01...01 to random
		i_row <= std_logic_vector(to_unsigned(117,7));
		i_col_block <= std_logic_vector(to_unsigned(2,2));
		i_byte <= x"55";
		wait for i_clk_period;
		
		i_row <= std_logic_vector(to_unsigned(117,7));
		i_col_block <= std_logic_vector(to_unsigned(1,2));
		i_byte <= x"AA";
		wait for i_clk_period;
		
		-- disable write
		i_enable_byte <= 'U';
		i_write_byte <= 'U';
		i_row <= "UUUUUUU";
		i_col_block <= "UU";
		i_byte <= "UUUUUUUU";

		wait for 10*i_clk_period;

		-- check the writes
		i_enable_byte <= '1';
		
		i_row <= std_logic_vector(to_unsigned(0,7));
		i_col_block <= std_logic_vector(to_unsigned(3,2));
		wait for i_clk_period;
		
		i_row <= std_logic_vector(to_unsigned(0,7));
		i_col_block <= std_logic_vector(to_unsigned(2,2));
		wait for i_clk_period;
		
		i_row <= std_logic_vector(to_unsigned(65,7));
		i_col_block <= std_logic_vector(to_unsigned(2,2));
		wait for i_clk_period;
		
		i_row <= std_logic_vector(to_unsigned(65,7));
		i_col_block <= std_logic_vector(to_unsigned(1,2));
		wait for i_clk_period;
		
		i_row <= std_logic_vector(to_unsigned(117,7));
		i_col_block <= std_logic_vector(to_unsigned(2,2));
		wait for i_clk_period;
		
		i_row <= std_logic_vector(to_unsigned(117,7));
		i_col_block <= std_logic_vector(to_unsigned(1,2));
		wait for i_clk_period;
		
		i_enable_byte <= 'U';
		i_row <= "UUUUUUU";
		i_col_block <= "UU";
		
		wait;
	end process;

END;
