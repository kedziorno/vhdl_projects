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
i_soc: in std_logic;
o_soc: out std_logic;
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

signal divclock,soc,eoc,oeb,le : std_logic;
signal ladder1,ladder2,ladderbuf,data : std_logic_vector(data_size-1 downto 0);
signal sample : std_logic;

type states is (idle,start,stop);
signal state : states;

begin

p_fsm : process (divclock,i_reset) is
	constant CW : integer := 10;
	variable w : integer range 0 to CW-1;
begin
	if (i_reset = '1') then
		state <= idle;
		soc <= '0';
		oeb <= '1';
		w := 0;
	elsif (rising_edge(divclock)) then
		case (state) is
			when idle =>
				if (sample = '1') then
					state <= start;
					soc <= '1';
					oeb <= '1';
				else
					state <= idle;
					soc <= '0';
					oeb <= '0';
				end if;
			when start =>
				if (eoc = '1') then
					state <= stop;
					oeb <= '1';
					soc <= '0';
					ladderbuf <= io_ladder;
				else
					state <= start;
					soc <= '1';
				end if;
			when stop =>
				if (w = CW-1) then
					state <= idle;
					w := 0;
					oeb <= '1';
				else
					state <= stop;
					w := w + 1;
					oeb <= '0';
				end if;
			when others => null;
		end case;
	end if;
end process p_fsm;

p_clockdivider : process (i_clock,i_reset) is
	constant count_max : integer := G_BOARD_CLOCK;
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

p_sampleclock : process (i_clock,i_reset) is
	constant count_max : integer := G_BOARD_CLOCK/1000;
	variable count : integer range 0 to count_max-1 := 0;
begin
	if (i_reset = '1') then
		count := 0;
		sample <= '0';
	elsif (rising_edge(i_clock)) then
		if (count = count_max-1) then
			count := 0;
			sample <= '1';
		else
			count := count + 1;
			sample <= '0';
		end if;
	end if;
end process p_sampleclock;

--ladderbuf <= io_ladder when eoc = '1' else (others => 'Z');
g0 : for i in 0 to data_size-1 generate
inst : OBUF port map (I=>ladderbuf(i),O=>ladder2(i));
end generate g0;
o_data <= data;
o_eoc <= eoc;
o_soc <= i_soc;

sar_entity : succesive_approximation_register
Generic map (
n => data_size
)
Port map (
i_clock => divclock,
i_reset => soc,
i_select => not i_from_comparator,
o_q => io_ladder,
o_end => eoc
);

latch_entity : nxp_74hc573
generic map(
nbit => data_size
)
port map (
i_le => sample,
i_oeb => oeb,
i_d => ladder2,
o_q => data
);

end Behavioral;
