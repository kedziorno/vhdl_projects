--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:52:41 04/28/2026
-- Design Name:   
-- Module Name:   /home/user/_WORKSPACE_/kedziorno/vhdl_projects/myown_i2c/tb_simple_memtest.vhd
-- Project Name:  myown_i2c
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: simple_memtest
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

ENTITY tb_simple_memtest IS
END tb_simple_memtest;

ARCHITECTURE behavior OF tb_simple_memtest IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT simple_memtest
PORT(
i_clk : IN  std_logic;
i_rst : IN  std_logic;
i_refresh : IN  std_logic;
io_sda : INOUT  std_logic;
io_scl : INOUT  std_logic;
Dq : INOUT  std_logic_vector(15 downto 0);
Addr : OUT  std_logic_vector(23 downto 1);
Adv_n : OUT  std_logic;
Ce_n : OUT  std_logic;
Clk : OUT  std_logic;
Cre : OUT  std_logic;
Lb_n : OUT  std_logic;
Oe_n : OUT  std_logic;
Ub_n : OUT  std_logic;
We_n : OUT  std_logic;
oWait : IN  std_logic
);
END COMPONENT;


--Inputs
signal i_clk : std_logic := '0';
signal i_rst : std_logic := '0';
signal i_refresh : std_logic := '0';
signal oWait : std_logic := '0';

--BiDirs
signal io_sda : std_logic;
signal io_scl : std_logic;
signal Dq : std_logic_vector(15 downto 0);

--Outputs
signal Addr : std_logic_vector(23 downto 1);
signal Adv_n : std_logic;
signal Ce_n : std_logic;
signal Clk : std_logic;
signal Cre : std_logic;
signal Lb_n : std_logic;
signal Oe_n : std_logic;
signal Ub_n : std_logic;
signal We_n : std_logic;

-- Clock period definitions
constant i_clk_period : time := 20 ns;

COMPONENT mt45w8mw16bgx
PORT(
Addr : IN  std_logic_vector(22 downto 0);
Adv_n : IN  std_logic;
Ce_n : IN  std_logic;
Clk : IN  std_logic;
Cre : IN  std_logic;
Dq : INOUT  std_logic_vector(15 downto 0);
Lb_n : IN  std_logic;
Oe_n : IN  std_logic;
oWait : OUT  std_logic;
Ub_n : IN  std_logic;
We_n : IN  std_logic
);
END COMPONENT;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: simple_memtest PORT MAP (
i_clk => i_clk,
i_rst => i_rst,
i_refresh => i_refresh,
io_sda => io_sda,
io_scl => io_scl,
Dq => Dq,
Addr => Addr,
Adv_n => Adv_n,
Ce_n => Ce_n,
Clk => Clk,
Cre => Cre,
Lb_n => Lb_n,
Oe_n => Oe_n,
Ub_n => Ub_n,
We_n => We_n,
oWait => oWait
);

-- Instantiate the Unit Under Test (UUT)
mt45 : mt45w8mw16bgx PORT MAP (
Addr => Addr,
Adv_n => Adv_n,
Ce_n => Ce_n,
Clk => Clk,
Cre => Cre,
Dq => Dq,
Lb_n => Lb_n,
Oe_n => Oe_n,
oWait => oWait,
Ub_n => Ub_n,
We_n => We_n
);

-- Clock process definitions
i_clk_process :process
begin
i_clk <= '0';
wait for i_clk_period/2;
i_clk <= '1';
wait for i_clk_period/2;
end process;



-- Stimulus process
stim_proc: process
begin		
-- hold reset state for 100 ns.
i_rst <= '1';
wait for 100 ns;	
i_rst <= '0';

wait for i_clk_period*10;

-- insert stimulus here 

wait;
end process;

END;
