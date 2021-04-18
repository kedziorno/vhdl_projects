----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:19:16 04/18/2021 
-- Design Name: 
-- Module Name:    succesive_approximation_register - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity succesive_approximation_register is
Generic (
n : integer := 4
);
Port (
i_clock : in  STD_LOGIC;
i_reset : in  STD_LOGIC;
i_select : in  STD_LOGIC;
o_q : out  STD_LOGIC_VECTOR (n-1 downto 0);
o_end : inout  STD_LOGIC
);
end succesive_approximation_register;

architecture Behavioral of succesive_approximation_register is

COMPONENT FDCPE_Q_QB IS
Generic (
	INIT : BIT := '0'
);
Port (
	Q : out  STD_LOGIC;
	QB : out  STD_LOGIC;
	C : in  STD_LOGIC;
	CE : in  STD_LOGIC;
	CLR : in  STD_LOGIC;
	D : in  STD_LOGIC;
	PRE : in  STD_LOGIC
);
END COMPONENT FDCPE_Q_QB;

signal pull_up : std_logic;
signal first_q,first_qb : std_logic;
signal q1 : std_logic_vector(n-1 downto 0);
signal qb1 : std_logic_vector(n-2 downto 0);
signal q2 : std_logic_vector(n-1 downto 0);

begin

o_end <= q1(n-1);

PULLUP_inst : PULLUP
port map (O=>pull_up);
	
first : FDCPE_Q_QB
generic map (INIT => '0')
port map (Q=>first_q,QB=>first_qb,C=>i_clock,CE=>'1',CLR=>pull_up,D=>o_end,PRE=>i_reset);

FDCPE_g1 : for i in 0 to n-1 generate
	n1_first : if (i=0) generate
		FDCPE_inst : FDCPE_Q_QB
		generic map (INIT => '0')
		port map (Q=>q1(i),QB=>qb1(i),C=>i_clock,CE=>'1',CLR=>i_reset,D=>first_q,PRE=>pull_up);
	end generate n1_first;
	n1_chain : if (0<i and i<n-1) generate
		FDCPE_inst : FDCPE_Q_QB
		generic map (INIT => '0')
		port map (Q=>q1(i),QB=>qb1(i),C=>i_clock,CE=>'1',CLR=>i_reset,D=>q1(i-1),PRE=>pull_up);
	end generate n1_chain;
	n1_last : if (i=n-1) generate
		FDCPE_inst : FDCPE
		generic map (INIT => '0')
		port map (Q=>q1(n-1),C=>i_clock,CE=>'1',CLR=>i_reset,D=>q1(i-1),PRE=>pull_up);
	end generate n1_last;
end generate FDCPE_g1;

FDCPE_g2 : for i in 0 to n-1 generate
	n2_first : if (i=0) generate
		FDCPE_inst : FDCPE
		generic map (INIT => '0')
		port map (Q=>q2(i),C=>first_qb,CE=>'1',CLR=>i_reset,D=>i_select,PRE=>pull_up);
	end generate n2_first;
	n2_chain : if (0<i) generate
		FDCPE_inst : FDCPE
		generic map (INIT => '0')
		port map (Q=>q2(i),C=>qb1(i-1),CE=>'1',CLR=>i_reset,D=>i_select,PRE=>pull_up);
	end generate n2_chain;
end generate FDCPE_g2;

OR_gates : for i in 0 to n-1 generate
	or_first : if (i=0) generate
		o_q(n-1-i) <= q2(i) or first_qb;
	end generate or_first;
	or_rest : if (0<i) generate
		o_q(n-1-i) <= q2(i) or q1(i-1);
	end generate or_rest;
end generate OR_gates;

end Behavioral;
