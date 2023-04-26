--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:15:36 04/26/2023
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/weirdboyjim_circuits/tb_vga_horizontalsync_hardwiredlogic.vhd
-- Project Name:  weirdboyjim_circuits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: vga_horizontalsync_hardwiredlogic
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

ENTITY tb_vga_horizontalsync_hardwiredlogic IS
END tb_vga_horizontalsync_hardwiredlogic;

ARCHITECTURE behavior OF tb_vga_horizontalsync_hardwiredlogic IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT vga_horizontalsync_hardwiredlogic
PORT(
i_bit0 : IN  std_logic;
i_bit1 : IN  std_logic;
i_bit2 : IN  std_logic;
i_bit3 : IN  std_logic;
i_bit4 : IN  std_logic;
i_bit5 : IN  std_logic;
o_sync : OUT  std_logic;
o_blank : OUT  std_logic;
o_reset : OUT  std_logic
);
END COMPONENT;

--Inputs
signal i_bit : std_logic_vector (5 downto 0);

--Outputs
signal o_sync : std_logic;
signal o_blank : std_logic;
signal o_reset : std_logic;

signal clock : std_logic;
constant clock_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: vga_horizontalsync_hardwiredlogic PORT MAP (
i_bit0 => i_bit(0),
i_bit1 => i_bit(1),
i_bit2 => i_bit(2),
i_bit3 => i_bit(3),
i_bit4 => i_bit(4),
i_bit5 => i_bit(5),
o_sync => o_sync,
o_blank => o_blank,
o_reset => o_reset
);

-- Clock process definitions
clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
--wait for 100 ns;
-- insert stimulus here
l0 : for i in 0 to 63 loop
  i_bit <= std_logic_vector (to_unsigned (i, 6));
  wait for clock_period*5;
end loop l0;
report "done" severity failure;
end process;

END;
