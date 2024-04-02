-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

-- Component Declaration
COMPONENT core
PORT(
reset : in std_logic;
clk : in std_logic; -- cktpad for txclk
rxd5 : in std_logic;
rxd4 : in std_logic;
rxd3 : in std_logic;
rxd2 : in std_logic;
rxd1 : in std_logic;
rxd0 : in std_logic;
rx_dv : in std_logic;
rx_er : in std_logic;
clk1 : in std_logic;
crs1 : in std_logic;
enable1_bar : in std_logic;
link1_bar : in std_logic;
clk2 : in std_logic;
crs2 : in std_logic;
enable2_bar : in std_logic;
link2_bar : in std_logic;
clk3 : in std_logic;
crs3 : in std_logic;
enable3_bar : in std_logic;
link3_bar : in std_logic;
clk4 : in std_logic;
crs4 : in std_logic;
enable4_bar : in std_logic;
link4_bar : in std_logic;
clk5 : in std_logic;
crs5 : in std_logic;
enable5_bar : in std_logic;
link5_bar : in std_logic;
clk6 : in std_logic;
crs6 : in std_logic;
enable6_bar : in std_logic;
link6_bar : in std_logic;
clk7 : in std_logic;
crs7 : in std_logic;
enable7_bar : in std_logic;
link7_bar : in std_logic;
clk8 : in std_logic;
crs8 : in std_logic;
enable8_bar : in std_logic;
link8_bar : in std_logic;
rx_en1 : out std_logic;
tx_en1 : out std_logic;
partition1_bar : inout std_logic;
jabber1_bar : inout std_logic;
rx_en2 : out std_logic;
tx_en2 : out std_logic;
partition2_bar : inout std_logic;
jabber2_bar : inout std_logic;
rx_en3 : out std_logic;
tx_en3 : out std_logic;
partition3_bar : inout std_logic;
jabber3_bar : inout std_logic;
rx_en4 : out std_logic;
tx_en4 : out std_logic;
partition4_bar : inout std_logic;
jabber4_bar : inout std_logic;
rx_en5 : out std_logic;
tx_en5 : out std_logic;
partition5_bar : inout std_logic;
jabber5_bar : inout std_logic;
rx_en6 : out std_logic;
tx_en6 : out std_logic;
partition6_bar : inout std_logic;
jabber6_bar : inout std_logic;
rx_en7 : out std_logic;
tx_en7 : out std_logic;
partition7_bar : inout std_logic;
jabber7_bar : inout std_logic;
rx_en8 : out std_logic;
tx_en8 : out std_logic;
partition8_bar : inout std_logic;
jabber8_bar : inout std_logic;
txd5 : out std_logic;
txd4 : out std_logic;
txd3 : out std_logic;
txd2 : out std_logic;
txd1 : out std_logic;
txd0 : out std_logic;
txdata : inout std_logic; -- tx_enall
idle : out std_logic;
preamble : out std_logic;
data : out std_logic;
jam : inout std_logic;
collision : inout std_logic;
wptr2 : out std_logic;
wptr1 : out std_logic;
wptr0 : out std_logic;
rptr2 : out std_logic;
rptr1 : out std_logic;
rptr0 : out std_logic
);
END COMPONENT core;

signal reset : std_logic;
signal clk : std_logic;
signal rxd5 : std_logic;
signal rxd4 : std_logic;
signal rxd3 : std_logic;
signal rxd2 : std_logic;
signal rxd1 : std_logic;
signal rxd0 : std_logic;
signal rx_dv : std_logic;
signal rx_er : std_logic;
signal clk1 : std_logic;
signal crs1 : std_logic;
signal enable1_bar : std_logic;
signal link1_bar : std_logic;
signal clk2 : std_logic;
signal crs2 : std_logic;
signal enable2_bar : std_logic;
signal link2_bar : std_logic;
signal clk3 : std_logic;
signal crs3 : std_logic;
signal enable3_bar : std_logic;
signal link3_bar : std_logic;
signal clk4 : std_logic;
signal crs4 : std_logic;
signal enable4_bar : std_logic;
signal link4_bar : std_logic;
signal clk5 : std_logic;
signal crs5 : std_logic;
signal enable5_bar : std_logic;
signal link5_bar : std_logic;
signal clk6 : std_logic;
signal crs6 : std_logic;
signal enable6_bar : std_logic;
signal link6_bar : std_logic;
signal clk7 : std_logic;
signal crs7 : std_logic;
signal enable7_bar : std_logic;
signal link7_bar : std_logic;
signal clk8 : std_logic;
signal crs8 : std_logic;
signal enable8_bar : std_logic;
signal link8_bar : std_logic;
signal rx_en1 : std_logic;
signal tx_en1 : std_logic;
signal partition1_bar : std_logic;
signal jabber1_bar : std_logic;
signal rx_en2 : std_logic;
signal tx_en2 : std_logic;
signal partition2_bar : std_logic;
signal jabber2_bar : std_logic;
signal rx_en3 : std_logic;
signal tx_en3 : std_logic;
signal partition3_bar : std_logic;
signal jabber3_bar : std_logic;
signal rx_en4 : std_logic;
signal tx_en4 : std_logic;
signal partition4_bar : std_logic;
signal jabber4_bar : std_logic;
signal rx_en5 : std_logic;
signal tx_en5 : std_logic;
signal partition5_bar : std_logic;
signal jabber5_bar : std_logic;
signal rx_en6 : std_logic;
signal tx_en6 : std_logic;
signal partition6_bar : std_logic;
signal jabber6_bar : std_logic;
signal rx_en7 : std_logic;
signal tx_en7 : std_logic;
signal partition7_bar : std_logic;
signal jabber7_bar : std_logic;
signal rx_en8 : std_logic;
signal tx_en8 : std_logic;
signal partition8_bar : std_logic;
signal jabber8_bar : std_logic;
signal txd5 : std_logic;
signal txd4 : std_logic;
signal txd3 : std_logic;
signal txd2 : std_logic;
signal txd1 : std_logic;
signal txd0 : std_logic;
signal txdata : std_logic;
signal idle : std_logic;
signal preamble : std_logic;
signal data : std_logic;
signal jam : std_logic;
signal collision : std_logic;
signal wptr2 : std_logic;
signal wptr1 : std_logic;
signal wptr0 : std_logic;
signal rptr2 : std_logic;
signal rptr1 : std_logic;
signal rptr0 : std_logic;

constant clock_period : time := 20 ns;

BEGIN

-- Component Instantiation
uut: core PORT MAP (
reset => reset,
clk => clk,
rxd5 => rxd5,
rxd4 => rxd4,
rxd3 => rxd3,
rxd2 => rxd2,
rxd1 => rxd1,
rxd0 => rxd0,
rx_dv => rx_dv,
rx_er => rx_er,
clk1 => clk1,
crs1 => crs1,
enable1_bar => enable1_bar,
link1_bar => link1_bar,
clk2 => clk2,
crs2 => crs2,
enable2_bar => enable2_bar,
link2_bar => link2_bar,
clk3 => clk3,
crs3 => crs3,
enable3_bar => enable3_bar,
link3_bar => link3_bar,
clk4 => clk4,
crs4 => crs4,
enable4_bar => enable4_bar,
link4_bar => link4_bar,
clk5 => clk5,
crs5 => crs5,
enable5_bar => enable5_bar,
link5_bar => link5_bar,
clk6 => clk6,
crs6 => crs6,
enable6_bar => enable6_bar,
link6_bar => link6_bar,
clk7 => clk7,
crs7 => crs7,
enable7_bar => enable7_bar,
link7_bar => link7_bar,
clk8 => clk8,
crs8 => crs8,
enable8_bar => enable8_bar,
link8_bar => link8_bar,
rx_en1 => rx_en1,
tx_en1 => tx_en1,
partition1_bar => partition1_bar,
jabber1_bar => jabber1_bar,
rx_en2 => rx_en2,
tx_en2 => tx_en2,
partition2_bar => partition2_bar,
jabber2_bar => jabber2_bar,
rx_en3 => rx_en3,
tx_en3 => tx_en3,
partition3_bar => partition3_bar,
jabber3_bar => jabber3_bar,
rx_en4 => rx_en4,
tx_en4 => tx_en4,
partition4_bar => partition4_bar,
jabber4_bar => jabber4_bar,
rx_en5 => rx_en5,
tx_en5 => tx_en5,
partition5_bar => partition5_bar,
jabber5_bar => jabber5_bar,
rx_en6 => rx_en6,
tx_en6 => tx_en6,
partition6_bar => partition6_bar,
jabber6_bar => jabber6_bar,
rx_en7 => rx_en7,
tx_en7 => tx_en7,
partition7_bar => partition7_bar,
jabber7_bar => jabber7_bar,
rx_en8 => rx_en8,
tx_en8 => tx_en8,
partition8_bar => partition8_bar,
jabber8_bar => jabber8_bar,
txd5 => txd5,
txd4 => txd4,
txd3 => txd3,
txd2 => txd2,
txd1 => txd1,
txd0 => txd0,
txdata => txdata,
idle => idle,
preamble => preamble,
data => data,
jam => jam,
collision => collision,
wptr2 => wptr2,
wptr1 => wptr1,
wptr0 => wptr0,
rptr2 => rptr2,
rptr1 => rptr1,
rptr0 => rptr0
);

cp : process
begin
clk <= '1';
wait for clock_period/2;
clk <= '0';
wait for clock_period/2;
end process cp;

--  Test Bench Statements
tb : PROCESS
BEGIN
reset <= '1';
wait for clock_period;
reset <= '0';
wait for clock_period;
wait;
END PROCESS tb;
--  End Test Bench 

END;
