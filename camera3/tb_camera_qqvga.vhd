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

ENTITY tb_camera_qqvga IS
END tb_camera_qqvga;

ARCHITECTURE behavior OF tb_camera_qqvga IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT camera_qqvga is
generic (
constant CLOCK_PERIOD : integer := 42; -- 21/42/100 ns - 10/24/48 MHZ - Min/Typ/Max Unit
constant RAW_RGB : integer := 0; -- 0 - RAW / 1 - RGB
constant ZERO : integer := 0
);
port (
camera_io_scl : inout std_logic;
camera_io_sda : inout std_logic;
camera_o_vs : out std_logic;
camera_o_hs : out std_logic;
camera_o_pclk : out std_logic;
camera_i_xclk : in std_logic;
camera_o_d : out std_logic_vector(7 downto 0);
camera_i_rst : in std_logic;
camera_i_pwdn : in std_logic
);
END COMPONENT camera_qqvga;

--Inputs
signal camera_i_xclk : std_logic := '0';
signal camera_i_rst : std_logic := '0';
signal camera_i_pwdn : std_logic := '0';

--BiDirs
signal camera_io_scl : std_logic;
signal camera_io_sda : std_logic;

--Outputs
signal camera_o_vs : std_logic;
signal camera_o_hs : std_logic;
signal camera_o_pclk : std_logic;
signal camera_o_d : std_logic_vector(7 downto 0);

-- Clock period definitions
constant camera_i_xclk_period : time := 1000 ns; -- 1mhz
--constant camera_i_xclk_period : time := 500 ns; -- 2mhz
--constant camera_i_xclk_period : time := 125 ns; -- 8mhz
--constant camera_i_xclk_period : time := 83.333 ns; -- 12mhz
--constant camera_i_xclk_period : time := 62.5 ns; -- 16mhz

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: camera_qqvga PORT MAP (
camera_io_scl => camera_io_scl,
camera_io_sda => camera_io_sda,
camera_o_vs => camera_o_vs,
camera_o_hs => camera_o_hs,
camera_o_pclk => camera_o_pclk,
camera_i_xclk => camera_i_xclk,
camera_o_d => camera_o_d,
camera_i_rst => camera_i_rst,
camera_i_pwdn => camera_i_pwdn
);

camera_i_xclk_process : process
begin
camera_i_xclk <= '0';
wait for camera_i_xclk_period/2;
camera_i_xclk <= '1';
wait for camera_i_xclk_period/2;
end process;

-- Stimulus process
stim_proc : process
begin
-- hold reset state for 100 ns.
camera_i_rst <= '0';
wait for 100 ns;
camera_i_rst <= '1';
wait for camera_i_xclk_period*10;
-- insert stimulus here
wait;
end process;

END;
