----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:38:38 06/23/2022 
-- Design Name: 
-- Module Name:    top - Behavioral 
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

entity top is
port (
i_clock : in std_logic;
i_reset : in std_logic;
o_r : out std_logic_vector(3 downto 1);
o_g : out std_logic_vector(3 downto 1);
o_b : out std_logic_vector(3 downto 2);
o_h : out std_logic;
o_v : out std_logic
);
end top;

architecture Behavioral of top is

signal clock_25mhz : std_logic;
signal h : std_logic;

begin

o_r <= (others => '1');
o_g <= (others => '1');
o_b <= (others => '1');
o_h <= h;

p0 : process (i_clock,i_reset) is
	constant C_COUNT : integer := 1;
	variable count : integer range 0 to C_COUNT - 1 := 0;
	variable divide2 : std_logic;
begin
	if (i_reset = '1') then
		divide2 := '0';
		count := 0;
	elsif (rising_edge(i_clock)) then
		if (count = C_COUNT - 1) then
			divide2 := not divide2;
			count := 0;
		else
			count := count + 1;
		end if;
		clock_25mhz <= divide2;
	end if;
end process p0;

p1 : process (clock_25mhz,i_reset) is
	constant C_H : integer := 800;
	variable hc : integer range 0 to C_H - 1 := 0;
begin
	if (i_reset = '1') then
		hc := 0;
		h <= '0';
	elsif (rising_edge(clock_25mhz)) then
		if (hc = C_H - 1) then
			hc := 0;
		else
			if (hc = 96) then
				h <= '1';
			else
				h <= '0';
			end if;
			hc := hc + 1;
		end if;
	end if;
end process p1;

p2 : process (clock_25mhz,i_reset,h) is
	constant C_V : integer := 521;
	variable vc : integer range 0 to C_V - 1 := 0;
begin
	if (i_reset = '1') then
		vc := 0;
		o_v <= '0';
	elsif (rising_edge(clock_25mhz)) then
		if (h = '1') then
			if (vc = C_V-1) then
				o_v <= '1';
				vc := 0;
			else
				o_v <= '0';
				vc := vc + 1;
			end if;
		else
			vc := vc;
		end if;
	end if;
end process p2;

end Behavioral;
