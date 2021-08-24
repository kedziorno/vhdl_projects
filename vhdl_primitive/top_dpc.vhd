----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:08:36 08/23/2021 
-- Design Name: 
-- Module Name:    top_dpc - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_dpc is
port (
i_clock : in std_logic;
i_reset : in std_logic;
o_led : out std_logic
);
end top_dpc;

architecture Behavioral of top_dpc is

component delayed_programmable_circuit is
port (
i_reg1 : in std_logic;
i_reg2 : in std_logic;
i_reg3 : in std_logic;
i_reg4 : in std_logic;
i_reg5 : in std_logic;
i_reg6 : in std_logic;
i_reg7 : in std_logic;
i_input : in std_logic;
o_output : out std_logic
);
end component delayed_programmable_circuit;

signal reg : std_logic_vector(7 downto 1);

type states is (idle,start,
reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,
stop);
signal state : states;

begin

p0 : process (i_clock,i_reset) is
begin
	if (i_reset = '1') then
		state <= idle;
		reg <= (others => '0');
	elsif (rising_edge(i_clock)) then
		case (state) is
			when idle =>
				state <= start;
			when start =>
				state <= reg1;
				reg <= "1111111";
			when reg1 =>
				state <= reg2;
				reg <= "1111111";
			when reg2 =>
				state <= reg3;
				reg <= "1111111";
			when reg3 =>
				state <= reg4;
				reg <= "1111111";
			when reg4 =>
				state <= reg5;
				reg <= "1111111";
			when reg5 =>
				state <= reg6;
				reg <= "1111111";
			when reg6 =>
				state <= reg7;
				reg <= "1111111";
			when reg7 =>
				state <= reg8;
				reg <= "1111111";
			when reg8 =>
				state <= stop;
			when stop =>
				state <= idle;
		end case;
	end if;
end process p0;

entity_dpc : delayed_programmable_circuit
port map (
i_reg1 => reg(1),
i_reg2 => reg(2),
i_reg3 => reg(3),
i_reg4 => reg(4),
i_reg5 => reg(5),
i_reg6 => reg(6),
i_reg7 => reg(7),
i_input => i_clock,
o_output => o_led
);

end Behavioral;

