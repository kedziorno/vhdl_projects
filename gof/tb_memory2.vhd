--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:41:51 11/15/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/gof/tb_memory2.vhd
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

ENTITY tb_memory2 IS
END tb_memory2;

ARCHITECTURE behavior OF tb_memory2 IS

	COMPONENT memory1
	PORT(
	i_clk : in std_logic;
	i_reset : in std_logic;
	i_copy_content : in std_logic;
	o_copy_content : out std_logic;
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

	--Inputs
	signal i_clk : std_logic;
	signal i_reset : std_logic;
	signal i_enable_byte : std_logic;
	signal i_enable_bit : std_logic;
	signal i_write_byte : std_logic;
	signal i_write_bit : std_logic;
	signal i_row : std_logic_vector(ROWS_BITS-1 downto 0);
	signal i_col_pixel : std_logic_vector(COLS_PIXEL_BITS-1 downto 0);
	signal i_col_block : std_logic_vector(COLS_BLOCK_BITS-1 downto 0);
	signal i_byte : std_logic_vector(BYTE_BITS-1 downto 0);
	signal i_bit : std_logic;
	signal i_copy_content : std_logic;
	signal o_copy_content : std_logic;

	--Outputs
	signal o_bit : std_logic;
	signal o_byte : std_logic_vector(BYTE_BITS-1 downto 0);

	-- Clock period definitions
	constant i_clk_period : time := 20 ns;

	type states is (
	ccstart,ccstop,idle,
	st1,st2,st3,st4,st5,st5a,
	st6,st7,st8,st9,st10,
	stop
	);
	signal state : states := ccstart;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: memory1 PORT MAP (
		i_clk => i_clk,
		i_reset => i_reset,
		i_copy_content => i_copy_content,
		o_copy_content => o_copy_content,
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

	i_reset <= '1','0' after i_clk_period;

	-- Stimulus process
	p0 : process (i_clk) is
		variable i : integer range 0 to ROWS-1 := 0;
		variable j : integer range 0 to COLS_BLOCK-1 := 0;
		variable k : integer range 0 to COLS_PIXEL-1 := 0;
	begin
		if (rising_edge(i_clk)) then
--			i_row <= (others => 'U');
--			i_col_pixel <= (others => 'U');
--			i_col_block <= (others => 'U');
--			i_byte <= (others => 'U');
			case (state) is
				when ccstart =>
					state <= ccstop;
					i_copy_content <= '1';
				when ccstop =>
					if (o_copy_content = '1') then
						state <= idle;
						i_copy_content <= '0';
					else
						state <= ccstop;
						i_copy_content <= '1';
					end if;
				when idle =>
					state <= st1;
					i := 0;
					j := 0;
					k := 0;
					i_row <= (others => '0');
					i_col_block <= (others => '0');
					i_col_pixel <= (others => '0');
				when st1 =>
					state <= st2;
					i_enable_byte <= '1';
					i_write_byte <= '1';
				when st2 =>
					state <= st3;
					i_row <= std_logic_vector(to_unsigned(i,i_row'length));
					i_col_block <= std_logic_vector(to_unsigned(k,i_col_block'length));
					i_byte <= memory_content(i)((k*BYTE_BITS+(BYTE_BITS-1)) downto ((k*BYTE_BITS)+0));
				when st3 =>
					if (k = COLS_BLOCK - 1) then
						state <= st4;
						k := 0;
					else
						state <= st2;
						k := k + 1;
					end if;
				when st4 =>
					if (i = ROWS - 1) then
						state <= st5;
						i := 0;
					else
						state <= st2;
						i := i + 1;
					end if;
				when st5 =>
					state <= st5a;
					i_enable_byte <= '0';
					i_write_byte <= '0';
				when st5a =>
					state <= st6;
					i := 0;
					j := 0;
					k := 0;
				when st6 =>
					state <= st7;
					i_enable_byte <= '1';
					i_write_byte <= '0';					
				when st7 =>
					state <= st8;
					i_row <= std_logic_vector(to_unsigned(i,i_row'length));
					i_col_block <= std_logic_vector(to_unsigned(k,i_col_block'length));
				when st8 =>
					if (k = COLS_BLOCK - 1) then
						state <= st9;
						k := 0;
					else
						state <= st7;
						k := k + 1;
					end if;
				when st9 =>
					if (i = ROWS - 1) then
						state <= st10;
						i := 0;
					else
						state <= st7;
						i := i + 1;
					end if;
				when st10 =>
					state <= stop;
					i_enable_byte <= '0';
					i_write_byte <= '0';
				when stop =>
					state <= stop;
				when others => null;
			end case;
		end if;
	end process p0;
END;
