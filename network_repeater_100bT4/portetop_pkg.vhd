--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package portetop_pkg is
component rreg
generic (size : integer := 2);
port (
	clk,reset,load : in std_logic;
	d : in std_logic_vector(size-1 downto 0);
	q : inout std_logic_vector(size-1 downto 0)
);
end component;
component reg
generic (size : integer := 2);
port (
	clk,reset : in std_logic;
	rst,pst : in std_logic;
	d : in std_logic_vector(size-1 downto 0);
	q : inout std_logic_vector(size-1 downto 0)
);
end component;
component rsynch port (
	clk,reset : in std_logic;
	d : in std_logic;
	q : out std_logic
);
end component;
component psynch port (
	clk,reset : in std_logic;
	d : in std_logic;
	q : out std_logic
);
end component;
component rdff
generic (size : integer := 2);
port (
	clk,reset : in std_logic;
	d : in std_logic_vector(size-1 downto 0);
	q : out std_logic_vector(size-1 downto 0)
);
end component;
component rdff1 port (
	clk,reset : in std_logic;
	d : in std_logic;
	q : out std_logic
);
end component;
component ascount
	generic (CounterSize : integer := 2);
	port (
	clk,areset,sreset,enable : in std_logic;
	count : inout std_logic_vector(CounterSize-1 downto 0)
);
end component;
component clockmux8
port (
	areset : in std_logic;
	sreset : in std_logic;
	clk1 : in std_logic;
	clk2 : in std_logic;
	clk3 : in std_logic;
	clk4 : in std_logic;
	clk5 : in std_logic;
	clk6 : in std_logic;
	clk7 : in std_logic;
	clk8 : in std_logic;
	clk9 : in std_logic;
	sel1 : in std_logic;
	sel2 : in std_logic;
	sel3 : in std_logic;
	sel4 : in std_logic;
	sel5 : in std_logic;
	sel6 : in std_logic;
	sel7 : in std_logic;
	sel8 : in std_logic;
	sel9 : in std_logic;
	rxclk : out std_logic
);
end component;
component arbiter8
port (
	txclk : in std_logic;
	areset : in std_logic;
	activity1 : in std_logic;
	activity2 : in std_logic;
	activity3 : in std_logic;
	activity4 : in std_logic;
	activity5 : in std_logic;
	activity6 : in std_logic;
	activity7 : in std_logic;
	activity8 : in std_logic;
	sel1 : out std_logic;
	sel2 : out std_logic;
	sel3 : out std_logic;
	sel4 : out std_logic;
	sel5 : out std_logic;
	sel6 : out std_logic;
	sel7 : out std_logic;
	sel8 : out std_logic;
	nosel : out std_logic;
	carrier : out std_logic;
	collision : out std_logic
);
end component;
component fifo
port (
	rxclk : in std_logic; -- from clk mux circuit
	txclk : in std_logic; -- txclk ref
	areset : in std_logic; 
	wptrclr : in std_logic;
	wptrinc : in std_logic;
	rptrclr : in std_logic;
	rptrinc : in std_logic;
	rxd0 : in std_logic;
	rxd1 : in std_logic;
	rxd2 : in std_logic;
	rxd3 : in std_logic;
	rxd4 : in std_logic;
	rxd5 : in std_logic;
	dmuxout : out std_logic_vector(5 downto 0);
	wptr2 : out std_logic;
	wptr1 : out std_logic;
	wptr0 : out std_logic;
	rptr2 : out std_logic;
	rptr1 : out std_logic;
	rptr0 : out std_logic
);
end component;
component symbolmux
port (
	txclk : in std_logic;
	areset : in std_logic;
	symbolclr : in std_logic;
	symbolinc : in std_logic;
	switch1 : in std_logic; -- line 1 d/s switch control
	switch2 : in std_logic;
	switch3 : in std_logic;
	symbol1 : in std_logic_vector(1 downto 0); -- line 1 symbol mux ctrl
	symbol2 : in std_logic_vector(1 downto 0);
	symbol3 : in std_logic_vector(1 downto 0);
	dmuxout : in std_logic_vector(5 downto 0); -- fifo data input
	symbolend1 : buffer std_logic;
	symbolend2 : out std_logic;
	symbolend3 : out std_logic;
	txd5 : out std_logic;
	txd4 : out std_logic;
	txd3 : out std_logic;
	txd2 : out std_logic;
	txd1 : out std_logic;
	txd0 : out std_logic
);
end component;
component porte
port (
	txclk : in std_logic;
	areset : in std_logic;
	crs : in std_logic; -- carrier sense
	enable_bar : in std_logic;
	link_bar : in std_logic; -- pma link ok
	selected : in std_logic; -- arbiter s
	carrier : in std_logic; -- arbiter c
	collision : in std_logic; -- arbiter c
	jam : in std_logic; -- control j
	txdata : in std_logic; -- control tx data
	prescale : in std_logic; -- counter prescale
	rx_en : out std_logic;
	tx_en : out std_logic;
	activity : out std_logic;
	jabber_bar : inout std_logic;
	partition_bar : inout std_logic
);
end component;
component control
port (
	txclk : in std_logic;
	areset : in std_logic;
	carrier : in std_logic;
	collision : in std_logic;
	rx_error : in std_logic; -- rx pma
	rx_dv : in std_logic; -- found sfd
	symbolend1 : in std_logic; -- end symbol line 1
	symbolend2 : in std_logic; -- end symbol line 2
	symbolend3 : in std_logic; -- end symbol line 3
	symbolclr : out std_logic;
	symbolinc : out std_logic;
	symbol1 : out std_logic_vector(1 downto 0); -- selects
	symbol2 : out std_logic_vector(1 downto 0); -- special
	symbol3 : out std_logic_vector(1 downto 0); -- symbols
	switch1 : out std_logic; -- selects special/data symbols
	switch2 : out std_logic; -- selects special/data symbols
	switch3 : out std_logic; -- selects special/data symbols
	wptrclr : out std_logic;
	wptrinc : out std_logic;
	rptrclr : out std_logic;
	rptrinc : out std_logic;
	txdata : out std_logic;
	idle : out std_logic;
	preamble : out std_logic;
	data : out std_logic;
	col : out std_logic;
	prescale : out std_logic
);
end component;
end portetop_pkg;

package body portetop_pkg is 
end portetop_pkg;
