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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
port (
i_clock : in std_logic;
i_reset : in std_logic;
i_sw : in std_logic_vector(7 downto 0);
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
signal v : std_logic;
signal display_flag : std_logic;

begin

o_h <= h;
o_v <= v;

o_r(3) <= i_sw(7) when display_flag = '1' else '0';
o_r(2) <= i_sw(6) when display_flag = '1' else '0';
o_r(1) <= i_sw(5) when display_flag = '1' else '0';
o_g(3) <= i_sw(4) when display_flag = '1' else '0';
o_g(2) <= i_sw(3) when display_flag = '1' else '0';
o_g(1) <= i_sw(2) when display_flag = '1' else '0';
o_b(3) <= i_sw(1) when display_flag = '1' else '0';
o_b(2) <= i_sw(0) when display_flag = '1' else '0';

p0 : process (i_clock,i_reset) is
	variable divide2 : std_logic;
begin
	if (i_reset = '1') then
		divide2 := '0';
	elsif (rising_edge(i_clock)) then
		divide2 := not divide2;
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
			hc := hc + 1;
		end if;
		if (hc < 96) then
			h <= '0';
		else
			h <= '1';
		end if;
	end if;
end process p1;

p2 : process (h,i_reset) is
	constant C_V : integer := 521;
	variable vc : integer range 0 to C_V - 1 := 0;
begin
	if (i_reset = '1') then
		vc := 0;
		v <= '0';
	elsif (rising_edge(h)) then
		if (vc = C_V - 1) then
			vc := 0;
		else
			vc := vc + 1;
		end if;
		if (vc < 2) then
			v <= '0';
		else
			v <= '1';
		end if;
	end if;
end process p2;

p3 : process (clock_25mhz,i_reset,h) is
	constant C_PW : integer := 1;
	constant C_FP : integer := 48;
	constant C_BP : integer := 16;
	constant C_DISP : integer := 640;
	variable fph : integer range 0 to C_FP - 1 := 0;
	variable bph : integer range 0 to C_BP - 1 := 0;
	variable disph : integer range 0 to C_DISP - 1 := 0;
	type statesh is (idleh,state_fph,state_disph,state_bph);
	variable stateh : statesh;
begin
	if (i_reset = '1') then
		fph := 0;
		bph := 0;
		disph := 0;
		stateh := idleh;
		display_flag <= '0';
	elsif (rising_edge(clock_25mhz)) then
		case (stateh) is
			when idleh =>
				if (h = '1') then
					stateh := state_fph;
				else
					stateh := idleh;
				end if;
				display_flag <= '0';
			when state_fph =>
				if (fph = C_FP - 1) then
					stateh := state_disph;
					fph := 0;
				else
					stateh := state_fph;
					fph := fph + 1;
				end if;
				display_flag <= '0';
			when state_disph =>
				if (disph = C_DISP - 1) then
					stateh := state_bph;
					disph := 0;
				else
					stateh := state_disph;
					disph := disph + 1;
				end if;
				display_flag <= '1';
			when state_bph =>
				if (bph = C_bp - 1) then
					stateh := idleh;
					bph := 0;
				else
					stateh := state_bph;
					bph := bph + 1;
				end if;
				display_flag <= '0';
		end case;
	end if;
end process p3;

p4 : process (clock_25mhz,i_reset,v) is
	constant C_FP : integer := 23200;
	constant C_BP : integer := 8000;
	constant C_DISP : integer := 384000;
	variable fpv : integer range 0 to C_FP - 1 := 0;
	variable bpv : integer range 0 to C_BP - 1 := 0;
	variable dispv : integer range 0 to C_DISP - 1 := 0;
	type statesv is (idlev,state_fpv,state_dispv,state_bpv);
	variable statev : statesv;
begin
	if (i_reset = '1') then
		fpv := 0;
		bpv := 0;
		dispv := 0;
		statev := idlev;
	elsif (rising_edge(clock_25mhz)) then
		case (statev) is
			when idlev =>
				if (v = '1') then
					statev := state_fpv;
				else
					statev := idlev;
				end if;
			when state_fpv =>
				if (fpv = C_FP - 1) then
					statev := state_dispv;
					fpv := 0;
				else
					statev := state_fpv;
					fpv := fpv + 1;
				end if;
			when state_dispv =>
				if (dispv = C_DISP - 1) then
					statev := state_bpv;
					dispv := 0;
				else
					statev := state_dispv;
					dispv := dispv + 1;
				end if;
			when state_bpv =>
				if (bpv = C_bp - 1) then
					statev := idlev;
					bpv := 0;
				else
					statev := state_bpv;
					bpv := bpv + 1;
				end if;
		end case;
	end if;
end process p4;

end Behavioral;
