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
USE work.p_globals.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

ENTITY tb_logic_analyser IS
END tb_logic_analyser;

ARCHITECTURE behavior OF tb_logic_analyser IS 

constant G_BOARD_CLOCK : integer := G_BOARD_CLOCK;
constant G_BAUD_RATE : integer := 115_200;
constant address_size : integer := 4;
constant data_size : integer := 8;

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT logic_analyser
GENERIC(
G_BOARD_CLOCK : integer;
G_BAUD_RATE : integer;
address_size : integer;
data_size : integer;
G_RC_N : integer;
G_RC_MAX : integer
);
PORT(
i_clock : in std_logic;
i_reset : in std_logic; -- XXX use for catch data
i_catch : in std_logic;
i_data : in std_logic_vector(data_size-1 downto 0);
o_rs232_tx : out std_logic;
o_sended : out std_logic;
o_seg : out std_logic_vector(G_LCDSegment-1 downto 0);
--o_dp : out std_logic;
o_an : out std_logic_vector(G_LCDAnode-1 downto 0);
o_data : out std_logic_vector(G_Led-1 downto 0)
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
signal o_seg : std_logic_vector(G_LCDSegment-1 downto 0);
--signal o_dp : std_logic;
signal o_an : std_logic_vector(G_LCDAnode-1 downto 0);
signal o_data : std_logic_vector(G_Led-1 downto 0);

-- Clock period definitions
constant i_clock_period : time := (1_000_000_000/G_BOARD_CLOCK) * 1 ns; -- XXX 50Mhz

constant N : integer := 2**address_size-1;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: logic_analyser
GENERIC MAP (
G_BOARD_CLOCK => G_BOARD_CLOCK,
G_BAUD_RATE => G_BAUD_RATE,
address_size => address_size,
data_size => data_size,
G_RC_N => 21,
G_RC_MAX => G_DEBOUNCE_MS_COUNT
)
PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_catch => i_catch,
i_data => i_data,
o_rs232_tx => o_rs232_tx,
o_sended => o_sended,
o_seg => o_seg,
--o_dp => o_dp,
o_an => o_an,
o_data => o_data
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

report "CLOCK PERIOD " & time'image(i_clock_period) severity warning;

i_reset <= '1';
wait for 100 ns;
i_reset <= '0';

wait for 10*i_clock_period;

-- insert stimulus here

l0 : for i in 0 to N-1 loop

i_data <= std_logic_vector(to_unsigned(i,data_size));

wait for 3*i_clock_period;
i_catch <= '1';
wait for 50.5 ms; -- wait for debounce
i_catch <= '0';
wait for 25*i_clock_period;

end loop l0;

wait;

end process write_proc;

assert (o_sended /= '1') report "end test" severity failure;

END;
