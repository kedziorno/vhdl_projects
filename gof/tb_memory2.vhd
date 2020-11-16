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
		i_clk : IN  std_logic;
		i_enable : IN  std_logic;
		i_write : IN  std_logic;
		i_row : IN  std_logic_vector(6 downto 0);
		i_col_pixel : IN  std_logic_vector(4 downto 0);
		i_col_block : IN  std_logic_vector(1 downto 0);
		i_byte : IN  std_logic_vector(7 downto 0);
		o_bit : OUT  std_logic;
		o_byte : OUT  std_logic_vector(7 downto 0));
	END COMPONENT;

	--Inputs
	signal i_clk : std_logic;
	signal i_enable : std_logic;
	signal i_write : std_logic;
	signal i_row : std_logic_vector(6 downto 0);
	signal i_col_pixel : std_logic_vector(4 downto 0);
	signal i_col_block : std_logic_vector(1 downto 0);
	signal i_byte : std_logic_vector(7 downto 0);
	signal i : integer range 0 to ROWS-1;
	signal j : integer range 0 to COLS_BLOCK-1;

	--Outputs
	signal o_bit : std_logic;
	signal o_byte : std_logic_vector(7 downto 0);

	-- Clock period definitions
	constant i_clk_period : time := 20 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: memory1 PORT MAP (
		i_clk => i_clk,
		i_enable => i_enable,
		i_write => i_write,
		i_row => i_row,
		i_col_pixel => i_col_pixel,
		i_col_block => i_col_block,
		i_byte => i_byte,
		o_bit => o_bit,
		o_byte => o_byte
	);

	-- Clock process definitions
	i_clk_process :process
	begin
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for i_clk_period/2;
	end process;

	i_enable <= '1';

	-- Stimulus process
	p0 : process (i_clk) is
	begin
		if (rising_edge(i_clk)) then
			if (j < COLS_BLOCK) then
				if (i < ROWS-1) then
					i <= i + 1;
				else
					j <= j + 1;
					i <= 0;
				end if;
			end if;
		end if;
	end process p0;

	i_row <= std_logic_vector(to_unsigned(i,i_row'length));
	i_col_block <= std_logic_vector(to_unsigned(j,i_col_block'length));

END;
