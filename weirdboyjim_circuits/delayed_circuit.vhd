----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:57:28 12/18/2021 
-- Design Name: 
-- Module Name:    delayed_circuit - Behavioral 
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
use WORK.p_package1.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity delayed_circuit is
port (
i_clock : in std_logic;
i_input : in std_logic;
o_output : out std_logic
);
end delayed_circuit;

architecture Behavioral of delayed_circuit is

	component GATE_NOT is
	generic (
	delay_not : TIME := 0 ps
	);
	port (
	A : in STD_LOGIC;
	B : out STD_LOGIC
	);
	end component GATE_NOT;
	for all : GATE_NOT use entity WORK.GATE_NOT(GATE_NOT_LUT);

	signal t : std_logic;
	signal q1,q2 : std_logic;
	signal tq1,tq2 : std_logic;

	constant N : integer := 6;
	constant N2 : integer := 2**N;

	signal tv1 : std_logic_vector(31 downto 0) := (others => '0');

begin

--tv1 <= std_logic_vector(to_unsigned(v1,32));

t <= i_input after 0 ns;
p3 : process (t,q2) is
	constant cv2 : integer := P1_CV1;
	type state is (a,b,c);
	variable vs : state;
	variable v1 : integer range 0 to N2-1 := 0;
	variable v2 : integer range 0 to cv2-1 := 0;
	variable s : std_logic;
begin
	if (rising_edge(q2)) then
		case (vs) is
			when a =>
				s := '0';
				if (t = '1') then
					vs := b;
				else
					vs := a;
				end if;
			when b =>
				s := '0';
				if (v1 = N2-1) then
					vs := c;
					v1 := 0;
				else
					vs := b;
					v1 := v1 + 1;
				end if;
			when c =>
				s := '1';
				if (v2 = cv2-1) then
					vs := a;
					v2 := 0;
				else
					vs := c;
					v2 := v2 + 1;
				end if;
		end case;
	end if;
	o_output <= s;
end process p3;

tq1 <= q1 after 0 ns;
g0 : GATE_NOT generic map (0 ns) port map (A => tq1, B => q2);
LDCPE_inst : LDCPE
generic map (INIT => '0')
port map (
	Q => q1,
	CLR => '0',
	D => q2,
	G => '1',
	GE => '1',
	PRE => '0'
);

end Behavioral;
