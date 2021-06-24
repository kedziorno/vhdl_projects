----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:32:30 05/04/2021 
-- Design Name: 
-- Module Name:    ripple_counter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ripple_counter is
Generic (
N : integer := 12;
MAX : integer := 571
);
Port (
i_clock : in std_logic;
i_cpb : in std_logic;
i_mrb : in std_logic;
o_q : inout std_logic_vector(N-1 downto 0);
o_ping : out std_logic
);
end ripple_counter;

architecture Behavioral of ripple_counter is

	component FTCE is
	generic(
	INIT : bit := '0'
	);
	port (
	Q   : out STD_LOGIC := '0';
	C   : in STD_LOGIC;
	CE  : in STD_LOGIC;
	CLR : in STD_LOGIC;
	T   : in STD_LOGIC
	);
	end component FTCE;

	signal cp,mr : std_logic;
	signal q : std_logic_vector(N-1 downto 0);

begin

	cp <= i_cpb;
	mr <= '1' when o_q = std_logic_vector(to_unsigned(MAX,N)) else i_mrb;
	o_ping <= '1' when o_q = std_logic_vector(to_unsigned(MAX,N)) else '0';
	o_q <= q;

	g0 : for i in N-1 downto 0 generate
		ffjk_first : if (i=0) generate
			ffjk : FTCE port map (T=>cp,C=>i_clock,CE=>'1',CLR=>mr,Q=>q(0));
		end generate ffjk_first;
		ffjk_chain : if (i>0) generate
			ffjk : FTCE port map (T=>cp,C=>not q(i-1),CE=>'1',CLR=>mr,Q=>q(i));
		end generate ffjk_chain;
	end generate g0;

end Behavioral;
