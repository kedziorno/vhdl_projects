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

constant C_WAIT_LCD : time := 4.99 us;

constant PHASE_OFFSET1 : integer := 20;
constant PHASE_LENGTH1 : integer := 5;
constant PHASE_DIFFER1 : integer := 3;

constant PHASE_OFFSET2 : integer := 65;
constant PHASE_LENGTH2 : integer := 12;
constant PHASE_DIFFER2 : integer := 7;

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
'1' after C_WAIT_LCD + i_clock_period*PHASE_OFFSET1,
'0' after C_WAIT_LCD + i_clock_period*PHASE_OFFSET1 + i_clock_period*PHASE_LENGTH1;
--'1' after C_WAIT_LCD + i_clock_period*PHASE_OFFSET2,
--'0' after C_WAIT_LCD + i_clock_period*PHASE_OFFSET2 + i_clock_period*PHASE_LENGTH2;

i_phase2 <=
'1' after C_WAIT_LCD + i_clock_period*PHASE_OFFSET1 + i_clock_period*PHASE_DIFFER1,
'0' after C_WAIT_LCD + i_clock_period*PHASE_OFFSET1 + i_clock_period*PHASE_LENGTH1 + i_clock_period*PHASE_DIFFER1;
--'1' after C_WAIT_LCD + i_clock_period*PHASE_OFFSET2 + i_clock_period*PHASE_LENGTH2,
--'0' after C_WAIT_LCD + i_clock_period*PHASE_OFFSET2 + i_clock_period*PHASE_LENGTH2;

i_push <=
'1' after C_WAIT_LCD + i_clock_period*PHASE_OFFSET1 - i_clock_period*1,
'0' after C_WAIT_LCD + i_clock_period*PHASE_OFFSET1;

i_reset <=
'1' after C_WAIT_LCD + i_clock_period*PHASE_OFFSET1 - i_clock_period*2,
'0' after C_WAIT_LCD + i_clock_period*PHASE_OFFSET1 - i_clock_period*1;

--i_phase1 <=
--'1' after C_WAIT_LCD + i_clock_period*20,
--'0' after C_WAIT_LCD + i_clock_period*50,
--'1' after C_WAIT_LCD + i_clock_period*70,
--'0' after C_WAIT_LCD + i_clock_period*100,
--'1' after C_WAIT_LCD + i_clock_period*70000,
--'0' after C_WAIT_LCD + i_clock_period*100000
--;
--i_phase2 <=
--'1' after C_WAIT_LCD + i_clock_period*15,
--'0' after C_WAIT_LCD + i_clock_period*45,
--'1' after C_WAIT_LCD + i_clock_period*82,
--'0' after C_WAIT_LCD + i_clock_period*112,
--'1' after C_WAIT_LCD + i_clock_period*82000,
--'0' after C_WAIT_LCD + i_clock_period*112000;
--
--i_reset <=
--'1' after C_WAIT_LCD + i_clock_period*1.3,
--'0' after C_WAIT_LCD + i_clock_period*2.5,
--'1' after C_WAIT_LCD + i_clock_period*3,
--'0' after C_WAIT_LCD + i_clock_period*4,
--'1' after C_WAIT_LCD + i_clock_period*82000,
--'0' after C_WAIT_LCD + i_clock_period*82001;
--
--i_push <=
--'1' after C_WAIT_LCD + i_clock_period*1,
--'0' after C_WAIT_LCD + i_clock_period*46,
--'1' after C_WAIT_LCD + i_clock_period*47,
--'0' after C_WAIT_LCD + i_clock_period*48,
--'1' after C_WAIT_LCD + i_clock_period*112000,
--'0' after C_WAIT_LCD + i_clock_period*112001;

-- Stimulus process
stim_proc: process
begin
wait for C_WAIT_LCD;
--wait until o_segment /= "10000000";

wait for 3000 us; -- wait for all
-- insert stimulus here 
report "done" severity failure;
end process;

END;
