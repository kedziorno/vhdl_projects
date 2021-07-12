--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:09:48 11/01/2020
-- Design Name:   
-- Module Name:   /home/user/workspace/i2c_test_3/tb_top.vhd
-- Project Name:  i2c_test_3
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

ENTITY st7735r_tb_top IS
END st7735r_tb_top;

ARCHITECTURE behavior OF st7735r_tb_top IS 

constant IC : integer := 1_000_000;
constant DC : integer := 1_000;

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT st7735r_gof
GENERIC(
INPUT_CLOCK : integer;
DIVIDER_CLOCK : integer
);
PORT(
clk : in std_logic;
btn_1 : in std_logic;
btn_2 : in std_logic;
btn_3 : in std_logic;
o_cs : out std_logic;
o_do : out std_logic;
o_ck : out std_logic;
o_reset : out std_logic;
o_rs : out std_logic
);
END COMPONENT;

--Inputs
signal clk : std_logic := '0';
signal btn_1 : std_logic := '0';
signal btn_2 : std_logic := '0';
signal btn_3 : std_logic := '0';

--Outputs
signal o_cs : std_logic;
signal o_do : std_logic;
signal o_ck : std_logic;
signal o_reset : std_logic;
signal o_rs : std_logic;

-- Clock period definitions 
constant clk_period : time := (1_000_000_000 / IC) * 1 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: st7735r_gof 
GENERIC MAP (
INPUT_CLOCK => IC,
DIVIDER_CLOCK => DC
)
PORT MAP (
clk => clk,
btn_1 => btn_1,
btn_2 => btn_2,
btn_3 => btn_3,
o_cs => o_cs,
o_do => o_do,
o_ck => o_ck,
o_reset => o_reset,
o_rs => o_rs
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
-- hold reset state for 100 ns.
btn_1 <= '1';
wait for 100 ns;
btn_1 <= '0';
wait for clk_period*10;
-- insert stimulus here
wait;
end process;

END;
