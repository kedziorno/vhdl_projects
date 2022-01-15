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
--constant i_clock_period : time := 1 ns;

constant C_WAIT : time := 1 us;
constant N : integer := 28;
type vsubarray is array(0 to 2) of integer range 0 to 2**16-1;
type subarray is array(integer range <>) of vsubarray;
signal v : subarray(0 to N-1) := (
	-- 0 => offset, 1 => length, 2 => differ
	(0,0,0), -- MAX start, not using
	(60,30,7),
	(120,30,9),
	(180,30,11),
	(240,30,13),
	-- XXX in cycles , a(i)=a(i-1)+2*b+10,b=x,c=value>=b => false
	(1010,1000,112),
	(3020,1000,152),
	(5030,1000,274),
	(7040,1000,275),
	(9050,1000,491),
	(11060,1000,619),
	(13070,1000,632),
	(15080,1000,835),
	(17090,1000,874),
	(19100,1000,999),
	(21110,1000,1000),
	(23120,2000,1999),
	(27130,2000,1890),
	(31140,2000,1999),
	(35150,2000,1999),
	(39160,2000,1999),
	(43170,2000,1999),
	(47180,2000,1999),
	(51190,2000,1999),
	(55200,2000,2000),
	(59210,2000,4003), -- 4004 dont work, because on this ts we have reset
	(63220,2000,0000),
	(2**16-1,2**16-1,2**16-1) -- XXX max end, not using
);

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

process (i_clock,i_reset)
	variable i : integer range 0 to N-1 := 0;
	variable a,b,c : integer range 0 to 2**16-1 := 0;
	variable diff : time := 0 ns;
begin
	if (rising_edge(i_clock)) then
		if (i = N-1) then
			i := N-1;
		else
			i := i + 1;
			a := v(i)(0);
			b := v(i)(1);
			c := v(i)(2);
			diff := (i * i_clock_period) - i_clock_period/2;
--			report " a = " & integer'image(a) & " b=" & integer'image(b) & " c=" & integer'image(c);
--			report " diff = " & time'image(diff);
		end if;
		i_phase1 <= transport '1'
		after C_WAIT + (a * i_clock_period) - time(diff);
		i_phase1 <= transport '0'
		after C_WAIT + (a * i_clock_period) + (b * i_clock_period) - time(diff);
		i_phase2 <= transport '1'
		after C_WAIT + (a * i_clock_period) + (c * i_clock_period) - time(diff);
		i_phase2 <= transport '0'
		after C_WAIT + (a * i_clock_period) + (b * i_clock_period) + (c * i_clock_period) - time(diff);
		i_reset <= transport '1'
		after C_WAIT + (a * i_clock_period) - i_clock_period*4 - time(diff);
		i_reset <= transport '0'
		after C_WAIT + (a * i_clock_period) - i_clock_period*3 - time(diff);
		i_push <= transport '1'
		after C_WAIT + (a * i_clock_period) - i_clock_period*2 - time(diff);
		i_push <= transport '0'
		after C_WAIT + (a * i_clock_period) - i_clock_period*1 - time(diff);
	end if;
end process;

process
begin
wait for 70 us;
report "done" severity failure;
end process;

END;
