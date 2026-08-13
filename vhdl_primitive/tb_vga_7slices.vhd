--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:37:34 08/08/2026
-- Design Name:   
-- Module Name:   /home/osboxes/_WORKSPACE_/kedziorno/vhdl_projects/vhdl_primitive/tb_vga_7slices.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: vga_7slices
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

ENTITY tb_vga_7slices IS
END tb_vga_7slices;

ARCHITECTURE behavior OF tb_vga_7slices IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT vga_7slices
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
o_hs : out std_logic;
o_hblank : out std_logic;
o_vs : out std_logic;
o_vblank : out std_logic
);
END COMPONENT;


--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';

--Outputs
signal o_hs : std_logic;
signal o_hb : std_logic;
signal o_vs : std_logic;
signal o_vb : std_logic;

-- Clock period definitions
constant i_clock_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: vga_7slices PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
o_hs => o_hs,
o_hblank => o_hb,
o_vs => o_vs,
o_vblank => o_vb
);

-- Clock process definitions
i_clock_process :process
begin
i_clock <= '0';
wait for i_clock_period/2;
i_clock <= '1';
wait for i_clock_period/2;
end process;


-- Stimulus process
stim_proc: process
begin		
-- hold reset state for 100 ns.
i_reset <= '1';
wait for 100 ns;
i_reset <= '0';
wait for i_clock_period*10;

-- insert stimulus here 

wait;
end process;

END;
