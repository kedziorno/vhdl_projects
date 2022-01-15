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
--constant i_clock_period : time := (1_000_000_000 / G_BOARD_CLOCK) * 1 ns;
constant i_clock_period : time := 1 ns;

constant C_WAIT_LCD : time := 1 us;
constant N : integer := 3;
type vsubarray is array(0 to 2) of integer range 0 to 2**16-1;
type subarray is array(integer range <>) of vsubarray;
signal v : subarray(0 to N-1) := (
	-- 0 => offset, 1 => length, 2 => differ
	(1,1,1),
	(65,12,7),
	(80,17,9)
);

signal a,b,c : integer range 0 to 2**16-1 := 0;
signal flag : std_logic;

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

--process (i_clock)
----	variable a,b,c : integer range 0 to 2**16-1 := 0;
--variable i : integer range 0 to N-1 := 0;
--begin
--if (rising_edge(i_clock)) then
--	if (i = N-1) then
--		i := 0;
--flag <= '0';
--	
--	else
--	flag <= '1';
--
--		i := i + 1;
--	a <= v(i)(0);
--	b <= v(i)(1);
--	c <= v(i)(2);
--report " a = " & integer'image(a) & " b=" & integer'image(b) & " c=" & integer'image(c);
--	
--	end if;
--
--end if;
--
--end process;
--

process (i_clock)
variable i : integer range 0 to N-1;
variable a,b,c : integer range 0 to 2**16-1 := 0;
begin
if (rising_edge(i_clock)) then
if (i = N-1) then
i := 0;
else
i := i + 1;
end if;
a := a + v(i)(0);
b := b + v(i)(1);
c := c + v(i)(2);
report " a = " & integer'image(a) & " b=" & integer'image(b) & " c=" & integer'image(c);
i_phase1 <= transport '1' after (a * i_clock_period);
i_phase1 <= transport '0' after (a * i_clock_period) + (b * i_clock_period);
i_phase2 <= transport '1' after (a * i_clock_period) + (c * i_clock_period);
i_phase2 <= transport '0' after (a * i_clock_period) + (b * i_clock_period) + (c * i_clock_period);

end if;
end process;

stim_proc : process
--	variable a,b,c : integer range 0 to 2**16-1 := 0;
begin
l0 : for i in 0 to N-1 loop
--	a <= a + v(i)(0);
--	b <= b + v(i)(1);
--	c <= c + v(i)(2);
--	i_push <=
--	'1' after C_WAIT_LCD + (a * i_clock_period) - i_clock_period*1,
--	'0' after C_WAIT_LCD + (a * i_clock_period);
--	i_reset <=
--	'1' after C_WAIT_LCD + (a * i_clock_period) - i_clock_period*2,
--	'0' after C_WAIT_LCD + (a * i_clock_period) - i_clock_period*1;
end loop l0;
wait;
end process;

process
begin
wait for 10 us;
report "done" severity failure;
end process;

END;
