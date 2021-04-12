--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:44:23 04/12/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_nxp_74hc573.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: nxp_74hc573
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

ENTITY tb_nxp_74hc573 IS
END tb_nxp_74hc573;

ARCHITECTURE behavior OF tb_nxp_74hc573 IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT nxp_74hc573
PORT(
i_le : IN  std_logic;
i_oeb : IN  std_logic;
i_d : IN  std_logic_vector(7 downto 0);
o_q : OUT  std_logic_vector(7 downto 0)
);
END COMPONENT;

--Inputs
signal i_le : std_logic := '0';
signal i_oeb : std_logic := '0';
signal i_d : std_logic_vector(7 downto 0) := (others => '0');

--Outputs
signal o_q : std_logic_vector(7 downto 0);

-- No clocks detected in port list. Replace clock below with 
-- appropriate port name 
signal clock : std_logic := '0';

constant clock_period : time := 1000 ns;
constant wait0 : time := 2 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: nxp_74hc573 PORT MAP (
i_le => i_le,
i_oeb => i_oeb,
i_d => i_d,
o_q => o_q
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
constant npattern : integer := 6;
type array_pattern is array(0 to npattern-1) of std_logic_vector(7 downto 0);
variable pattern : array_pattern := (
"01010101","10101010","11111111","11110000","00001111","00000000"
);
begin
-- insert stimulus here
l0 : for i in 0 to npattern-1 loop
i_oeb <= '1';
i_d <= pattern(i);
i_le <= '1';
wait for wait0;
i_le <= '0';
i_oeb <= '1';
wait for wait0;
i_le <= '1';
i_oeb <= '0';
wait for wait0;
i_le <= '0';
i_oeb <= '0';
wait for wait0;
end loop l0;
wait;
end process;

END;
