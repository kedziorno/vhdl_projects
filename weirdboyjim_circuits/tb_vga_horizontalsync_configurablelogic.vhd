--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:23:53 04/26/2023
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/weirdboyjim_circuits/tb_vga_horizontalsync_configurablelogic.vhd
-- Project Name:  weirdboyjim_circuits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: vga_horizontalsync_configurablelogic
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

ENTITY tb_vga_horizontalsync_configurablelogic IS
END tb_vga_horizontalsync_configurablelogic;

ARCHITECTURE behavior OF tb_vga_horizontalsync_configurablelogic IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT vga_horizontalsync_configurablelogic
PORT(
i_clock,i_reset : in std_logic;
i_startvaluereg8bit_1 : IN  std_logic_vector(7 downto 0);
i_startvaluereg8bit_2 : IN  std_logic_vector(7 downto 0);
i_startvaluereg8bit_3 : IN  std_logic_vector(7 downto 0);
i_startvaluereg8bit_4 : IN  std_logic_vector(7 downto 0);
o_sync : OUT  std_logic;
o_blank : OUT  std_logic
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_startvaluereg8bit_1 : std_logic_vector(7 downto 0) := (others => '0');
signal i_startvaluereg8bit_2 : std_logic_vector(7 downto 0) := (others => '0');
signal i_startvaluereg8bit_3 : std_logic_vector(7 downto 0) := (others => '0');
signal i_startvaluereg8bit_4 : std_logic_vector(7 downto 0) := (others => '0');

--Outputs
signal o_sync : std_logic;
signal o_blank : std_logic;

signal clock : std_logic;
--constant clock_period : time := 10 ns; -- 100mhz
constant clock_period : time := 40 ns; -- 25mhz

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: vga_horizontalsync_configurablelogic PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_startvaluereg8bit_1 => i_startvaluereg8bit_1,
i_startvaluereg8bit_2 => i_startvaluereg8bit_2,
i_startvaluereg8bit_3 => i_startvaluereg8bit_3,
i_startvaluereg8bit_4 => i_startvaluereg8bit_4,
o_sync => o_sync,
o_blank => o_blank
);

-- Clock process definitions
clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;
i_clock <= clock;

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
i_reset <= '0';
wait for 100 ns;
i_reset <= '1';
wait for clock_period*10;
-- insert stimulus here
--l0 : for i in 0 to 255 loop
--  i_startvaluereg8bit_1 <= std_logic_vector (to_unsigned (i, 8));
--  i_startvaluereg8bit_2 <= std_logic_vector (to_unsigned (i, 8));
--  i_startvaluereg8bit_3 <= std_logic_vector (to_unsigned (i, 8));
--  i_startvaluereg8bit_4 <= std_logic_vector (to_unsigned (i, 8));
--  wait for clock_period*2;
--end loop l0;
i_startvaluereg8bit_1 <= (others => '0');
i_startvaluereg8bit_2 <= (others => '0');
i_startvaluereg8bit_3 <= (others => '0');
i_startvaluereg8bit_4 <= (others => '0');
--wait for 100 us;
wait for 10 ms;
report "done" severity failure;
end process;

END;
