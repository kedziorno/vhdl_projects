LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

USE ieee.numeric_std.ALL;

USE WORK.p_constants.ALL;

ENTITY tb_top IS
END tb_top;

ARCHITECTURE behavior OF tb_top IS 

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT top
GENERIC (
constant G_BOARD_CLOCK : integer := G_BOARD_CLOCK;
constant G_LCD_CLOCK_DIVIDER : integer := G_LCD_CLOCK_DIVIDER
);
PORT (
signal i_clock : in std_logic;
signal i_reset : in std_logic;
signal i_push : in std_logic;
signal i_phase1 : in std_logic;
signal i_phase2 : in std_logic;
signal o_anode : out std_logic_vector(3 downto 0);
signal o_segment : out std_logic_vector(6 downto 0)
);
END COMPONENT;


--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_push : std_logic := '0';
signal i_phase1 : std_logic := '0';
signal i_phase2 : std_logic := '0';

--Outputs
signal o_anode : std_logic_vector(3 downto 0);
signal o_segment : std_logic_vector(6 downto 0);

-- Clock period definitions
constant i_clock_period : time := (1_000_000_000 / G_BOARD_CLOCK) * 1 ns;

constant C_WAIT_LCD : time := 6.03 us;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: top PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_push => i_push,
i_phase1 => i_phase1,
i_phase2 => i_phase2,
o_anode => o_anode,
o_segment => o_segment
);

-- Clock process definitions
i_clock_process :process
begin
i_clock <= '0';
wait for i_clock_period/2;
i_clock <= '1';
wait for i_clock_period/2;
end process;

i_phase1 <= 
'1' after C_WAIT_LCD + i_clock_period*20,
'0' after C_WAIT_LCD + i_clock_period*50,
'1' after C_WAIT_LCD + i_clock_period*70,
'0' after C_WAIT_LCD + i_clock_period*100;
i_phase2 <= 
'1' after C_WAIT_LCD + i_clock_period*15,
'0' after C_WAIT_LCD + i_clock_period*45,
'1' after C_WAIT_LCD + i_clock_period*82,
'0' after C_WAIT_LCD + i_clock_period*112;

-- Stimulus process
stim_proc: process
begin
wait for C_WAIT_LCD + 0.02 us;

-- hold reset state for 100 ns.
i_reset <= '1';
wait for i_clock_period*1.3;
i_reset <= '0';
wait for i_clock_period*2.5;
i_push <= '1';
wait for i_clock_period*1;
i_push <= '0';
wait for i_clock_period*46;
i_reset <= '1';
wait for i_clock_period*1.3;
i_reset <= '0';
wait for i_clock_period*2.5;
i_push <= '1';
wait for i_clock_period*1;
i_push <= '0';
wait for 3 us; -- wait for all
-- insert stimulus here 
report "done" severity failure;
end process;

END;
