--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:46:35 04/13/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_sram_62256.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sram_62256
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

ENTITY tb_sram_62256 IS
END tb_sram_62256;

ARCHITECTURE behavior OF tb_sram_62256 IS

constant address_size : integer := 15; -- 2;
constant data_size : integer := 8; -- 2;

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT sram_62256
GENERIC(
address_size : integer := address_size;
data_size : integer := data_size
);
PORT(
i_ceb : IN  std_logic;
i_web : IN  std_logic;
i_oeb : IN  std_logic;
i_address : IN  std_logic_vector(address_size-1 downto 0);
i_data : in  STD_LOGIC_VECTOR (data_size-1 downto 0);
o_data : out  STD_LOGIC_VECTOR (data_size-1 downto 0)
);
END COMPONENT;


--Inputs
signal i_ceb : std_logic := '1';
signal i_web : std_logic := '1';
signal i_oeb : std_logic := '1';
signal i_address : std_logic_vector(address_size-1 downto 0) := (others => '0');

--BiDirs
signal i_data : std_logic_vector(data_size-1 downto 0) := (others => 'Z');
signal o_data : std_logic_vector(data_size-1 downto 0) := (others => 'Z');

-- No clocks detected in port list. Replace <clock> below with 
-- appropriate port name 
constant clock_period : time := 100 ns;
signal clock : std_logic := '0';

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: sram_62256 PORT MAP (
i_ceb => i_ceb,
i_web => i_web,
i_oeb => i_oeb,
i_address => i_address,
i_data => i_data,
o_data => o_data
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
-- insert stimulus here
wait for 10*clock_period;
i_ceb <= '0';
wait for 01*clock_period;
i_web <= '0';
i_oeb <= '1';
i_address <= "0000000" & x"0E";
i_data <= x"55";
--i_address <= '0'&'0';
--io_data <= '1'&'0';
wait for 01*clock_period;
i_ceb <= '1';
i_web <= '1';
i_oeb <= '1';
i_data <= (others => 'Z');
wait for 10*clock_period;
i_ceb <= '0';
wait for 01*clock_period;
i_web <= '0';
i_oeb <= '1';
i_address <= "0000000" & x"0F";
i_data <= x"AA";
--i_address <= '0'&'1';
--io_data <= '0'&'1';
wait for 01*clock_period;
i_ceb <= '1';
i_web <= '1';
i_oeb <= '1';
i_data <= (others => 'Z');
wait for 10*clock_period;
i_ceb <= '0';
wait for 01*clock_period;
i_web <= '1';
i_oeb <= '0';
--i_address <= '0'&'0';
i_address <= "0000000" & x"0E";
wait for 01*clock_period;
i_ceb <= '1';
i_web <= '1';
i_oeb <= '1';
i_data <= (others => 'Z');
wait;
end process;

END;