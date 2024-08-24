--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:18:44 07/10/2022
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/camera1/tb_camera.vhd
-- Project Name:  camera1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: camera
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

ENTITY tb_camera IS
END tb_camera;

ARCHITECTURE behavior OF tb_camera IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT camera
PORT(
io_scl : INOUT  std_logic;
io_sda : INOUT  std_logic;
o_vs : OUT  std_logic;
o_hs : OUT  std_logic;
o_pclk : OUT  std_logic;
i_xclk : IN  std_logic;
o_d : OUT  std_logic_vector(7 downto 0);
i_rst : IN  std_logic;
i_pwdn : IN  std_logic
);
END COMPONENT;


--Inputs
signal i_xclk : std_logic := '0';
signal i_rst : std_logic := '0';
signal i_pwdn : std_logic := '0';

--BiDirs
signal io_scl : std_logic;
signal io_sda : std_logic;

--Outputs
signal o_vs : std_logic;
signal o_hs : std_logic;
signal o_pclk : std_logic;
signal o_d : std_logic_vector(7 downto 0);

-- Clock period definitions
--constant o_pclk_period : time := 10 ns;
constant i_xclk_period : time := 42 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: camera PORT MAP (
io_scl => io_scl,
io_sda => io_sda,
o_vs => o_vs,
o_hs => o_hs,
o_pclk => o_pclk,
i_xclk => i_xclk,
o_d => o_d,
i_rst => i_rst,
i_pwdn => i_pwdn
);

---- Clock process definitions
--o_pclk_process : process
--begin
--o_pclk <= '0';
--wait for o_pclk_period/2;
--o_pclk <= '1';
--wait for o_pclk_period/2;
--end process;

i_xclk_process : process
begin
i_xclk <= '0';
wait for i_xclk_period/2;
i_xclk <= '1';
wait for i_xclk_period/2;
end process;

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
i_rst <= '0';
wait for 100 ns;
i_rst <= '1';
wait for i_xclk_period*10;
-- insert stimulus here
wait;
end process;

END;
