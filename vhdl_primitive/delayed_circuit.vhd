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

	signal s : std_logic;
	signal q1,q2 : std_logic;

	constant N : integer := 8;
	constant N2 : integer := 2**N;

	signal v1 : integer range 0 to N2-1 := 0;
	signal tv1 : std_logic_vector(31 downto 0) := (others => '0');

	type state is (a,b,c);
	signal vs : state;

begin

tv1 <= std_logic_vector(to_unsigned(v1,32));

o_output <= s;
p3 : process (i_input,q2) is
begin
	if (rising_edge(q2)) then
		case (vs) is
			when a =>
				s <= '0';
				if (i_input = '1') then
					vs <= b;
				else
					vs <= a;
				end if;
			when b =>
				s <= '0';
				if (v1 = N2-1) then
					vs <= c;
					v1 <= 0;
				else
					vs <= b;
					v1 <= v1 + 1 after 1 ns;
				end if;
			when c =>
				s <= '1';
				vs <= a;
		end case;
	end if;
end process p3;

g0 : GATE_NOT port map (A => q1, B => q2);
LDCPE_inst : LDCPE
generic map (INIT => '0')
port map (
	Q => q1,
	CLR => i_input,
	D => q2,
	G => '1',
	GE => '1',
	PRE => '0'
);

end Behavioral;
