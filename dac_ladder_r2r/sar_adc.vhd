----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:47:54 05/07/2021 
-- Design Name: 
-- Module Name:    sar_adc - Behavioral 
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

entity sar_adc is
Generic (
G_BOARD_CLOCK : integer := 5_000_000;
--G_BOARD_CLOCK : integer := 200_000;
data_size : integer := 8
);
Port (
i_clock : in std_logic;
i_reset : in std_logic;
i_from_comparator : in std_logic;
io_ladder : inout std_logic_vector(data_size-1 downto 0);
o_data : out std_logic_vector(data_size-1 downto 0);
o_eoc : out std_logic
);
end sar_adc;

architecture Behavioral of sar_adc is

component succesive_approximation_register is
Generic (
n : integer := data_size
);
Port (
i_clock : in  STD_LOGIC;
i_reset : in  STD_LOGIC;
i_select : in  STD_LOGIC;
o_q : out  STD_LOGIC_VECTOR (n-1 downto 0);
o_end : inout  STD_LOGIC
);
end component succesive_approximation_register;

component nxp_74hc573 is
generic (
nbit : integer := 8
);
port (
i_le : in std_logic;
i_oeb : in std_logic;
i_d : in std_logic_vector(nbit-1 downto 0);
o_q : out std_logic_vector(nbit-1 downto 0)
);
end component nxp_74hc573;

signal divclock,eoc : std_logic;
signal oeb : std_logic;
signal ladder_latch,data : std_logic_vector(data_size-1 downto 0);

begin

p_clockdivider : process (i_clock,i_reset) is
	constant count_max : integer := G_BOARD_CLOCK/10;
	variable count : integer range 0 to count_max-1 := 0;
begin
	if (i_reset = '1') then
		count := 0;
		divclock <= '0';
	elsif (rising_edge(i_clock)) then
		if (count = count_max-1) then
			count := 0;
			divclock <= '1';
		else
			count := count + 1;
			divclock <= '0';
		end if;
	end if;
end process p_clockdivider;

p_comparator : process (divclock,i_reset) is
	variable a : std_logic;
	constant ccount : integer := 2**data_size;
	variable count : integer range 0 to ccount-1 := 0;
	variable voeb : std_logic;
begin
	if (i_reset = '1') then
		count := 0;
		a := '0';
		eoc <= '0';
		voeb := '1';
	elsif (rising_edge(divclock)) then
		a := i_from_comparator;
		case (a) is
			when '0' =>
				if (count = ccount-1) then
					count := ccount-1;
					eoc <= '1';
					voeb := '1';
				else
					count := count + 1;
					eoc <= '0';
					voeb := '1';
				end if;
			when '1' =>
				count := count;
				eoc <= '1';
				voeb := '0';
			when others =>
				count := 0;
				eoc <= '0';
				voeb := '1';
		end case;
		io_ladder <= std_logic_vector(to_unsigned(count,data_size));
	end if;
	oeb <= voeb;
end process p_comparator;

g0 : for i in 0 to data_size-1 generate
inst : OBUF port map (I=>io_ladder(i),O=>ladder_latch(i));
end generate g0;
o_data <= data;
o_eoc <= eoc;

latch_entity : nxp_74hc573
generic map(
nbit => data_size
)
port map (
i_le => divclock,
i_oeb => oeb,
i_d => ladder_latch,
o_q => data
);

end Behavioral;
