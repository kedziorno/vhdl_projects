--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:37:08 07/11/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_sn5474ls245.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sn5474ls245
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

ENTITY tb_sn5474ls245 IS
END tb_sn5474ls245;

ARCHITECTURE behavior OF tb_sn5474ls245 IS 

constant N : integer := 8;
constant CP : time := 20 ns;

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT sn5474ls245
GENERIC(
N : integer
);
PORT(
i_dir : IN  std_logic;
i_eb : IN  std_logic;
io_a : INOUT  std_logic_vector(N-1 downto 0);
io_b : INOUT  std_logic_vector(N-1 downto 0)
);
END COMPONENT;

--Inputs
signal i_dir : std_logic := 'U';
signal i_eb : std_logic := 'U';

--BiDirs
signal io_a : std_logic_vector(N-1 downto 0) := (others => 'Z');
signal io_b : std_logic_vector(N-1 downto 0) := (others => 'Z');

signal a2b,b2a : std_logic_vector(N-1 downto 0) := (others => 'U');

signal clock : std_logic;
constant clock_period : time := CP;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: sn5474ls245
GENERIC MAP (
N => N
)
PORT MAP (
i_dir => i_dir,
i_eb => i_eb,
io_a => io_a,
io_b => io_b
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
constant TN : integer := 4;
type at is array (0 to TN-1) of std_logic_vector(N-1 downto 0);
variable t : at := (x"00",x"aa",x"bb",x"ff");
constant first : std_logic_vector(N-1 downto 0) := t(0);
constant last : std_logic_vector(N-1 downto 0) := t(t'length-1);
function to_s(a : std_logic_vector) return string is
variable ts : string(a'range) := (others => NUL);
begin
l0 : for i in a'range loop
ts(i) := std_logic'image(a(i))(2); -- XXX 'X' = 1-',2-X,3-'
end loop l0;
return ts;
end function;
begin
-- hold reset state for 100 ns.
wait for 100 ns;
i_dir <= 'U';
i_eb <= 'U';
wait for clock_period*10;

-- insert stimulus here

i_dir <= '0';
i_eb <= '0';
io_b <= t(1);
--io_a <= t(1);
wait for clock_period*1;
b2a <= io_a;
--b <= io_b;

wait for clock_period*40;
i_dir <= 'U';
i_eb <= '1';
io_a <= (others => 'Z');
io_b <= (others => 'Z');
a2b <= (others => 'U');
b2a <= (others => 'U');
wait for clock_period*40;

i_dir <= '1';
i_eb <= '0';
--io_b <= t(2);
io_a <= t(2);
wait for clock_period*1;
--a <= io_a;
a2b <= io_b;

wait for clock_period*40;
i_dir <= 'U';
i_eb <= '1';
io_a <= (others => 'Z');
io_b <= (others => 'Z');
a2b <= (others => 'U');
b2a <= (others => 'U');
wait for clock_period*40;

wait;
end process;

END;
