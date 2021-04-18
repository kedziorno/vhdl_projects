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
--i_select : in  STD_LOGIC_VECTOR (n-1 downto 0);
i_select : in  STD_LOGIC;
o_q : out  STD_LOGIC_VECTOR (n-1 downto 0);
o_end : inout  STD_LOGIC
);
end succesive_approximation_register;

architecture Behavioral of succesive_approximation_register is

COMPONENT FDCPE_Q_QB IS
Generic (
	INIT : STD_LOGIC := '0'
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
signal first_q,first_qb,first_d : std_logic;
signal q1,qb1 : std_logic_vector(n-1 downto 0);
signal q2,qb2 : std_logic_vector(n-1 downto 0);

begin

PULLUP_inst : PULLUP
port map (O=>pull_up);

first : FDCPE_Q_QB
generic map (INIT => '0')
port map (Q=>first_q,QB=>first_qb,C=>i_clock,CE=>'1',CLR=>pull_up,D=>o_end,PRE=>i_reset);

FDCPE_g1 : for i in 0 to n-1 generate
n1_f : if (i=0) generate
	FDCPE_inst : FDCPE_Q_QB
	generic map (INIT => '0')
	port map (Q=>q1(0),QB=>qb1(0),C=>i_clock,CE=>'1',CLR=>i_reset,D=>first_q,PRE=>pull_up);
end generate n1_f;
n1_m : if (0<i and i<n-1) generate
	FDCPE_inst : FDCPE_Q_QB
	generic map (INIT => '0')
	port map (Q=>q1(i),QB=>qb1(i),C=>i_clock,CE=>'1',CLR=>i_reset,D=>q1(i-1),PRE=>pull_up);
end generate n1_m;
n1_l : if (i=n-1) generate
	FDCPE_inst : FDCPE_Q_QB
	generic map (INIT => '0')
	port map (Q=>o_end,QB=>open,C=>i_clock,CE=>'1',CLR=>i_reset,D=>q1(i-1),PRE=>pull_up);
end generate n1_l;
end generate FDCPE_g1;

FDCPE_g2 : for i in 0 to n-1 generate
	n2_f : if (i=0) generate
		FDCPE_inst : FDCPE_Q_QB
		generic map (INIT => '0')
		port map (Q=>q2(0),QB=>open,C=>qb1(0),CE=>'1',CLR=>i_reset,D=>i_select,PRE=>pull_up);
		o_q(0) <= q2(0) or q1(0);
	end generate n2_f;
	n2_m : if (0<i) generate
		FDCPE_inst : FDCPE_Q_QB
		generic map (INIT => '0')
		port map (Q=>q2(i),QB=>open,C=>qb1(i),CE=>'1',CLR=>i_reset,D=>i_select,PRE=>pull_up);
		o_q(i) <= q2(i) or q1(i);
	end generate n2_m;
end generate FDCPE_g2;

end Behavioral;
