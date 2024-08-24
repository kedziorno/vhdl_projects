--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:16:58 07/09/2022
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/camera1/tb_top.vhd
-- Project Name:  camera1
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

ENTITY tb_top IS
END tb_top;

ARCHITECTURE behavior OF tb_top IS 

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

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT top
PORT(
i_clock : IN  std_logic;
o_r : OUT  std_logic_vector(3 downto 1);
o_g : OUT  std_logic_vector(3 downto 1);
o_b : OUT  std_logic_vector(3 downto 2);
o_h : OUT  std_logic;
o_v : OUT  std_logic;
i_sw : IN  std_logic_vector(7 downto 0);
cam_xclk : OUT  std_logic;
cam_pclk : IN  std_logic;
cam_sioc : INOUT  std_logic;
cam_siod : INOUT  std_logic;
cam_data : IN  std_logic_vector(7 downto 0);
cam_vsync : IN  std_logic;
cam_href : IN  std_logic
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_sw : std_logic_vector(7 downto 0) := (others => '0');
signal cam_pclk : std_logic := '0';
signal cam_data : std_logic_vector(7 downto 0) := (others => '0');
signal cam_vsync : std_logic := '0';
signal cam_href : std_logic := '0';

--BiDirs
signal cam_sioc : std_logic;
signal cam_siod : std_logic;

--Outputs
signal o_r : std_logic_vector(3 downto 1);
signal o_g : std_logic_vector(3 downto 1);
signal o_b : std_logic_vector(3 downto 2);
signal o_h : std_logic;
signal o_v : std_logic;
signal cam_xclk : std_logic;

-- Clock period definitions
constant i_clock_period : time := 20 ns;
--   constant cam_xclk_period : time := 40 ns;
constant cam_pclk_period : time := 41 ns;

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
constant i_xclk_period : time := 41 ns;

BEGIN

cam : camera PORT MAP (
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

-- Instantiate the Unit Under Test (UUT)
uut: top PORT MAP (
i_clock => i_clock,
o_r => o_r,
o_g => o_g,
o_b => o_b,
o_h => o_h,
o_v => o_v,
i_sw => i_sw,
cam_xclk => cam_xclk,
cam_pclk => cam_pclk,
cam_sioc => cam_sioc,
cam_siod => cam_siod,
cam_data => o_d,
cam_vsync => o_vs,
cam_href => o_hs
);

-- Clock process definitions
i_clock_process :process
begin
i_clock <= '0';
wait for i_clock_period/2;
i_clock <= '1';
wait for i_clock_period/2;
end process;

--   cam_xclk_process :process
--   begin
--		cam_xclk <= '0';
--		wait for cam_xclk_period/2;
--		cam_xclk <= '1';
--		wait for cam_xclk_period/2;
--   end process;

cam_pclk_process :process
begin
cam_pclk <= '0';
wait for cam_pclk_period/2;
cam_pclk <= '1';
wait for cam_pclk_period/2;
end process;

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
i_sw(0) <= '1';
i_rst <= '0';
wait for 100 ns;	
i_sw(0) <= '0';
i_rst <= '1';
wait for i_clock_period*10;
-- insert stimulus here
wait;
end process;

END;
