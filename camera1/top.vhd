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
library UNISIM;
use UNISIM.VComponents.all;

entity top is
port (
i_clock : in std_logic;
i_reset : in std_logic;
ja : inout std_logic_vector(7 downto 0);
jb : inout std_logic_vector(7 downto 0);
jc : inout std_logic_vector(7 downto 0);
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
signal c : std_logic_vector(8 downto 0);
signal c1,c2,c3 : std_logic;
signal clock1 : std_logic;
signal count : std_logic_vector(8 downto 0);

signal d,q : std_logic_vector(1 downto 0);
signal fb : std_logic;
signal div : std_logic;
signal divv : std_logic;
signal div1 : std_logic;
signal divv1 : std_logic;

signal clock1_a,clock2_a : std_logic;
signal clock1_b,clock2_b : std_logic;

signal hh,hh1 : std_logic;
signal vv,vv1 : std_logic;

begin

--DCM_SP_inst_vga : DCM_SP
--generic map (
--CLKDV_DIVIDE => 2.0, -- Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
---- 7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
--CLKFX_DIVIDE => 13, -- Can be any interger from 1 to 32
--CLKFX_MULTIPLY => 7, -- Can be any integer from 2 to 32
--CLKIN_DIVIDE_BY_2 => FALSE, -- TRUE/FALSE to enable CLKIN divide by two feature
--CLKIN_PERIOD => 20.0, -- Specify period of input clock
--CLKOUT_PHASE_SHIFT => "NONE", -- Specify phase shift of "NONE", "FIXED" or "VARIABLE"
--CLK_FEEDBACK => "1X", -- Specify clock feedback of "NONE", "1X" or "2X"
--DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", -- "SOURCE_SYNCHRONOUS", "SYSTEM_SYNCHRONOUS" or
---- an integer from 0 to 15
--DFS_FREQUENCY_MODE => "LOW", -- "HIGH" or "LOW" frequency mode for
---- frequency synthesis
--DLL_FREQUENCY_MODE => "LOW", -- "HIGH" or "LOW" frequency mode for DLL
--DUTY_CYCLE_CORRECTION => TRUE, -- Duty cycle correction, TRUE or FALSE
--FACTORY_JF => X"F0F0", -- FACTORY JF Values
--PHASE_SHIFT => 0, -- Amount of fixed phase shift from -255 to 255
--STARTUP_WAIT => FALSE) -- Delay configuration DONE until DCM_SP LOCK, TRUE/FALSE
--port map (
--CLK0 => clock1_b, -- 0 degree DCM CLK ouptput
--CLK180 => open, -- 180 degree DCM CLK output
--CLK270 => open, -- 270 degree DCM CLK output
--CLK2X => open, -- 2X DCM CLK output
--CLK2X180 => open, -- 2X, 180 degree DCM CLK out
--CLK90 => open, -- 90 degree DCM CLK output
--CLKDV => div1, -- Divided DCM CLK out (CLKDV_DIVIDE)
--CLKFX => open, -- DCM CLK synthesis out (M/D)
--CLKFX180 => open, -- 180 degree CLK synthesis out
--LOCKED => open, -- DCM LOCK status output
--PSDONE => open, -- Dynamic phase adjust done output
--STATUS => open, -- 8-bit DCM status bits output
--CLKFB => clock2_b, -- DCM clock feedback
--CLKIN => div, -- Clock input (from IBUFG, BUFG or DCM)
--PSCLK => '0', -- Dynamic phase adjust clock input
--PSEN => '0', -- Dynamic phase adjust enable input
--PSINCDEC => '0', -- Dynamic phase adjust increment/decrement
--RST => i_reset -- DCM asynchronous reset input
--);
--
--IBUFG_inst_vga : IBUFG
--generic map (IBUF_DELAY_VALUE => "0", IOSTANDARD => "DEFAULT")
--port map (O => div,I => i_clock);
--
--BUFG_inst_vga : BUFG
--port map (O => clock2_b, I => clock1_b);
--
--DCM_SP_inst1 : DCM_SP
--generic map (
--CLKDV_DIVIDE => 2.5, -- Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
---- 7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
--CLKFX_DIVIDE => 13, -- Can be any interger from 1 to 32
--CLKFX_MULTIPLY => 7, -- Can be any integer from 2 to 32
--CLKIN_DIVIDE_BY_2 => FALSE, -- TRUE/FALSE to enable CLKIN divide by two feature
--CLKIN_PERIOD => 20.0, -- Specify period of input clock
--CLKOUT_PHASE_SHIFT => "NONE", -- Specify phase shift of "NONE", "FIXED" or "VARIABLE"
--CLK_FEEDBACK => "1X", -- Specify clock feedback of "NONE", "1X" or "2X"
--DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", -- "SOURCE_SYNCHRONOUS", "SYSTEM_SYNCHRONOUS" or
---- an integer from 0 to 15
--DFS_FREQUENCY_MODE => "LOW", -- "HIGH" or "LOW" frequency mode for
---- frequency synthesis
--DLL_FREQUENCY_MODE => "LOW", -- "HIGH" or "LOW" frequency mode for DLL
--DUTY_CYCLE_CORRECTION => TRUE, -- Duty cycle correction, TRUE or FALSE
--FACTORY_JF => X"F0F0", -- FACTORY JF Values
--PHASE_SHIFT => 0, -- Amount of fixed phase shift from -255 to 255
--STARTUP_WAIT => FALSE) -- Delay configuration DONE until DCM_SP LOCK, TRUE/FALSE
--port map (
--CLK0 => clock1_a, -- 0 degree DCM CLK ouptput
--CLK180 => open, -- 180 degree DCM CLK output
--CLK270 => open, -- 270 degree DCM CLK output
--CLK2X => open, -- 2X DCM CLK output
--CLK2X180 => open, -- 2X, 180 degree DCM CLK out
--CLK90 => open, -- 90 degree DCM CLK output
--CLKDV => divv1, -- Divided DCM CLK out (CLKDV_DIVIDE)
--CLKFX => open, -- DCM CLK synthesis out (M/D)
--CLKFX180 => open, -- 180 degree CLK synthesis out
--LOCKED => open, -- DCM LOCK status output
--PSDONE => open, -- Dynamic phase adjust done output
--STATUS => open, -- 8-bit DCM status bits output
--CLKFB => clock2_a, -- DCM clock feedback
--CLKIN => divv, -- Clock input (from IBUFG, BUFG or DCM)
--PSCLK => '0', -- Dynamic phase adjust clock input
--PSEN => '0', -- Dynamic phase adjust enable input
--PSINCDEC => '0', -- Dynamic phase adjust increment/decrement
--RST => i_reset -- DCM asynchronous reset input
--);
--
--IBUFG_inst : BUFG
--port map (O => divv,I => div);
--
--BUFG_inst : BUFG
--port map (O => clock2_a, I => clock1_a);
--
--pa : process(fb,i_reset,jb) is
--begin
--	if (i_reset = '1') then
--		o_r(3) <= '0';
--		o_r(2) <= '0';
--		o_r(1) <= '0';
--		o_g(3) <= '0';
--		o_g(2) <= '0';
--		o_g(1) <= '0';
--		o_b(3) <= '0';
--		o_b(2) <= '0';
--	elsif (rising_edge(fb)) then
--		o_r(3) <= jb(7);
--		o_r(2) <= jb(6);
--		o_r(1) <= jb(5);
--		o_g(3) <= jb(4);
--		o_g(2) <= jb(3);
--		o_g(1) <= jb(2);
--		o_b(3) <= jb(1);
--		o_b(2) <= jb(0);	
--	end if;
--end process pa;

--o_r(3) <= jb(7) when display_flag = '1' else '0';
--o_r(2) <= jb(6) when display_flag = '1' else '0';
--o_r(1) <= jb(5) when display_flag = '1' else '0';
--o_g(3) <= jb(4) when display_flag = '1' else '0';
--o_g(2) <= jb(3) when display_flag = '1' else '0';
--o_g(1) <= jb(2) when display_flag = '1' else '0';
--o_b(3) <= jb(1) when display_flag = '1' else '0';
--o_b(2) <= jb(0) when display_flag = '1' else '0';

o_r(3) <= jb(2);
o_r(2) <= jb(1);
o_r(1) <= jb(0);
o_g(3) <= jb(5);
o_g(2) <= jb(4);
o_g(1) <= jb(3);
o_b(3) <= jb(7);
o_b(2) <= jb(6);

--pclk4dot5: process (i_clock,i_reset) is
--begin
--	if (i_reset = '1') then
--		count <= (8 downto 1 => '0') & '1';
--	elsif (rising_edge(i_clock)) then
--		count <= count(7 downto 0) & '0';
--		count(0) <= count(8);
--	end if;
--	if (i_reset = '1') then
--		c1 <= '0';
--		c2 <= '0';
--		c3 <= '0';
--	elsif (falling_edge(i_clock)) then
--		c1 <= count(0);
--		c2 <= count(4);
--		c3 <= count(5);
--	end if;
--end process pclk4dot5;
--clock1 <= (c2 or c3 or count(5)) or (count(0) or count(1) or c1);

--pclk1dot5re : process (i_clock,i_reset) is
--begin
--	if (i_reset = '1') then
--		q(0) <= '0';
--	elsif (rising_edge(i_clock)) then
--		q(0) <= d(0);
--	end if;
--end process pclk1dot5re;
--
--pclk1dot5fe : process (i_clock,i_reset) is
--begin
--	if (i_reset = '1') then
--		q(1) <= '0';
--	elsif (falling_edge(i_clock)) then
--		q(1) <= d(1);
--	end if;
--end process pclk1dot5fe;
--
--fb <= not (q(0) or q(1));
--d(0) <= fb;
--d(1) <= fb;
--div <= fb;

p0 : process (i_clock,i_reset) is
	constant C_DIV : integer := 2;
	variable count : integer range 0 to C_DIV - 1 := 0;
	variable divide2 : std_logic;
begin
	if (i_reset = '1') then
		divide2 := '0';
		count := 0;
	elsif (rising_edge(i_clock)) then
		if (count = C_DIV - 1) then
			divide2 := not divide2;
			count := 0;
		else
			count := count + 1;
		end if;
		clock_25mhz <= divide2;
	end if;
end process p0;

--clock_25mhz <= div1;
ja(0) <= not i_reset;
o_h <= hh1;
o_v <= vv1;
--o_h <= h;
--o_v <= v;
--ja(3) <= clock_25mhz;
ja(3) <= div1;
--ja(3) <= divv1;
--ja(3) <= clock2_b;
--ja(3) <= i_clock;
--jc(0) <= h;
--jc(1) <= v;
--jc(2) <= clock_25mhz;
--fb <= jc(3);

IBUFG_clock : IBUFG
generic map (IBUF_DELAY_VALUE => "0", IOSTANDARD => "DEFAULT")
port map (O => div,I => i_clock);
BUFG_clock : BUFG
port map (O => div1, I => div);

IBUFG_v : IBUFG
generic map (IBUF_DELAY_VALUE => "0", IOSTANDARD => "DEFAULT")
port map (O => vv,I => ja(2));
BUFG_v : BUFG
port map (O => vv1, I => vv);

IBUFG_h : IBUFG
generic map (IBUF_DELAY_VALUE => "0", IOSTANDARD => "DEFAULT")
port map (O => hh,I => ja(1));
BUFG_h : BUFG
port map (O => hh1, I => hh);

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
