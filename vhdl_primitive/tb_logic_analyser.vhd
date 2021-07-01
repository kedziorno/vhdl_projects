--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:32:30 05/04/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/vhdl_primitive/tb_logic_analyser.vhd
-- Project Name:  vhdl_primitive
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: logic_analyser
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

ENTITY tb_logic_analyser IS
END tb_logic_analyser;

ARCHITECTURE behavior OF tb_logic_analyser IS 

constant G_BOARD_CLOCK : integer := 50_000_000;
constant G_BAUD_RATE : integer := 115_200;
constant address_size : integer := 8;
constant data_size : integer := 8;

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT logic_analyser
GENERIC(
G_BOARD_CLOCK : integer := 50_000_000;
G_BAUD_RATE : integer := 9_600;
address_size : integer := 8;
data_size : integer := 8
);
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
i_catch : IN  std_logic;
i_data : IN  std_logic_vector(data_size-1 downto 0);
o_rs232_tx : OUT  std_logic;
o_sended : OUT  std_logic
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_catch : std_logic := '0';
signal i_data : std_logic_vector(data_size-1 downto 0) := (others => '0');

--Outputs
signal o_rs232_tx : std_logic;
signal o_sended : std_logic;

-- Clock period definitions
constant i_clock_period : time := 20 ns;

constant N : integer := 2**address_size-1;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: logic_analyser
GENERIC MAP (
G_BOARD_CLOCK => G_BOARD_CLOCK,
G_BAUD_RATE => G_BAUD_RATE,
address_size => address_size,
data_size => data_size
)
PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_catch => i_catch,
i_data => i_data,
o_rs232_tx => o_rs232_tx,
o_sended => o_sended
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
write_proc : process
begin

i_reset <= '1';
wait for 100 ns;
i_reset <= '0';

wait for 10*i_clock_period;

-- insert stimulus here

l0 : for i in 0 to N-1 loop

i_data <= std_logic_vector(to_unsigned(i,data_size));

i_catch <= '1';
wait for i_clock_period;
i_catch <= '0';
wait for i_clock_period;

end loop l0;

wait;

end process write_proc;

assert (o_sended /= '1') report "end test" severity failure;

END;
