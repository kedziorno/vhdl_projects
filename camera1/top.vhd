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
use WORK.p_memory_content.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity top is
generic (
	constant G_BOARD_CLOCK : integer := 50_000_000;
	constant G_I2C_CLOCK : integer := 100_000;
	constant G_CONSTANT1 : integer := 100 -- XXX wait reset for real hardware
);
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
o_v : out std_logic;
io_sda : inout std_logic;
io_scl : inout std_logic
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
signal clkdv_vga : std_logic;
signal clkdv_cam : std_logic;

signal clock1_a,clock2_a : std_logic;
signal clock1_b,clock2_b : std_logic;

signal hh,hh1 : std_logic;
signal vv,vv1 : std_logic;

signal dcm2_locked : std_logic;

type statesmem is (mema,memb,memc,memd,meme,memf,memg,memh,memi,memj,memk);
signal state : statesmem;

signal flag : std_logic;

signal dlatch : std_logic_vector(7 downto 0);
signal dlatch2 : std_logic_vector(15 downto 0);
signal hlatch,vlatch : std_logic;

signal sda,scl : std_logic;

COMPONENT i2c_master IS
GENERIC(
input_clk : INTEGER := G_BOARD_CLOCK; --input clock speed from user logic in Hz
bus_clk   : INTEGER := G_I2C_CLOCK);   --speed the i2c bus (scl) will run at in Hz
PORT(
clk       : IN     STD_LOGIC;                    --system clock
reset_n   : IN     STD_LOGIC;                    --active low reset
ena       : IN     STD_LOGIC;                    --latch in command
addr      : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --address of target slave
rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
addr_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
scl       : INOUT  STD_LOGIC);                   --serial clock output of i2c bus
END COMPONENT i2c_master;
signal i2cenable,i2caddress,i2cbusy,i2cbusyprev,i2creset : std_logic;
signal i2cdatawr,i2caddrwr : std_logic_vector(7 downto 0);

constant C_ARRAYCOUNT : integer := 74;
type rom_array is array(0 to C_ARRAYCOUNT*2-1) of std_logic_vector(7 downto 0);
constant values : rom_array := (
x"ff",x"ff",
x"12",x"04",
x"11",x"80",
x"0C",x"00",
x"3E",x"00",
x"04",x"00",
x"40",x"d0",
x"3a",x"04",
x"14",x"18",
x"4F",x"B3",
x"50",x"B3",
x"51",x"00",
x"52",x"3d",
x"53",x"A7",
x"54",x"E4",
x"58",x"9E",
x"3D",x"C0",
x"17",x"14",
x"18",x"02",
x"32",x"80",
x"19",x"03",
x"1A",x"7B",
x"03",x"0A",
x"0F",x"41",
x"1E",x"00",
x"33",x"0B",
x"3C",x"78",
x"69",x"00",
x"74",x"00",
x"B0",x"84",
x"B1",x"0c",
x"B2",x"0e",
x"B3",x"80",
x"70",x"3a",
x"71",x"35",
x"72",x"11",
x"73",x"f0",
x"a2",x"02",
x"7a",x"20",
x"7b",x"10",
x"7c",x"1e",
x"7d",x"35",
x"7e",x"5a",
x"7f",x"69",
x"80",x"76",
x"81",x"80",
x"82",x"88",
x"83",x"8f",
x"84",x"96",
x"85",x"a3",
x"86",x"af",
x"87",x"c4",
x"88",x"d7",
x"89",x"e8",
x"13",x"e0",
x"00",x"00",
x"10",x"00",
x"0d",x"40",
x"14",x"18",
x"a5",x"05",
x"ab",x"07",
x"24",x"95",
x"25",x"33",
x"26",x"e3",
x"9f",x"78",
x"a0",x"68",
x"a1",x"03",
x"a6",x"d8",
x"a7",x"d8",
x"a8",x"f0",
x"a9",x"90",
x"aa",x"94",
x"13",x"e5",
x"FF",x"FF" -- XXX end marker
);

begin

pi2c : process(div,i_reset) is
	type states is (a,b,c,d,e,f,g,h,i,j,k);
	variable state : states;
	constant C_COUNT : integer := G_BOARD_CLOCK;
	variable count : integer range 0 to C_COUNT - 1 := 0;
	variable index : integer range 0 to C_ARRAYCOUNT - 1 := 0;
begin
	if (i_reset = '1') then
		state := a;
		count := 0;
		index := 0;
	elsif (rising_edge(div)) then
		case (state) is
			when a =>
				state := b;
				i2cenable <= '1';
			when b =>
				state := c;
				i2caddrwr <= x"12"; -- XXX reset device command 1x
				i2cdatawr <= x"80";
			when c =>
				if (i2cbusy = '1') then
					state := c;
				else
					state := d;
				end if;
			when d =>
				i2cenable <= '0';
				state := e;
			when e =>
				state := f;
				i2cenable <= '1';
			when f =>
				state := g;
				i2caddrwr <= x"12"; -- XXX reset device command
				i2cdatawr <= x"80";
			when g =>
				if (i2cbusy = '1') then
					state := g;
				else
					state := h;
				end if;
			when h =>
				i2cenable <= '0';
				state := i;
			when i =>
				i2caddrwr <= x"00";
				i2cdatawr <= x"00";
				if (count = C_COUNT/G_CONSTANT1 - 1) then -- XXX 10 ms wait for reset
					count := 0;
					state := j;
				else
					count := count + 1;
					state := i;
				end if;
			when j =>
				i2cbusyprev <= i2cbusy;
				if (i2cbusyprev = '0' and i2cbusy = '1') then
					index := index + 1;
				end if;
				i2cenable <= '1';
				case index is
					when 0 to C_ARRAYCOUNT-2 =>
						i2caddrwr <= values(2*index);
						i2cdatawr <= values(2*index+1);
					when C_ARRAYCOUNT-1 =>
						i2cenable <= '0';
						if (i2cbusy = '0') then
							index := 0;
							state := k;
						end if;
--					when others => null;
				end case;
			when k =>
				state := k;
		end case;
	end if;
end process pi2c;

i2creset <= not i_reset;

i2c_master_inst : i2c_master
PORT MAP (
clk => div,
reset_n => i2creset,
ena => i2cenable,
addr => x"42",
rw => '0',
addr_wr => i2caddrwr,
data_wr => i2cdatawr,
busy => i2cbusy,
data_rd => open,
ack_error => open,
sda => open,
scl => open
);
io_sda <= 'Z';
io_scl <= 'Z';

DCM_SP_inst_vga : DCM_SP
generic map (
CLKDV_DIVIDE => 2.0, -- Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5,7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
CLKFX_DIVIDE => 13, -- Can be any interger from 1 to 32
CLKFX_MULTIPLY => 7, -- Can be any integer from 2 to 32
CLKIN_DIVIDE_BY_2 => FALSE, -- TRUE/FALSE to enable CLKIN divide by two feature
CLKIN_PERIOD => 20.0, -- Specify period of input clock
CLKOUT_PHASE_SHIFT => "NONE", -- Specify phase shift of "NONE", "FIXED" or "VARIABLE"
CLK_FEEDBACK => "1X", -- Specify clock feedback of "NONE", "1X" or "2X"
DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", -- "SOURCE_SYNCHRONOUS", "SYSTEM_SYNCHRONOUS" or an integer from 0 to 15
DFS_FREQUENCY_MODE => "LOW", -- "HIGH" or "LOW" frequency mode for frequency synthesis
DLL_FREQUENCY_MODE => "LOW", -- "HIGH" or "LOW" frequency mode for DLL
DUTY_CYCLE_CORRECTION => TRUE, -- Duty cycle correction, TRUE or FALSE
FACTORY_JF => X"F0F0", -- FACTORY JF Values
PHASE_SHIFT => 0, -- Amount of fixed phase shift from -255 to 255
STARTUP_WAIT => FALSE) -- Delay configuration DONE until DCM_SP LOCK, TRUE/FALSE
port map (
CLK0 => clock1_b, -- 0 degree DCM CLK ouptput
CLK180 => open, -- 180 degree DCM CLK output
CLK270 => open, -- 270 degree DCM CLK output
CLK2X => open, -- 2X DCM CLK output
CLK2X180 => open, -- 2X, 180 degree DCM CLK out
CLK90 => open, -- 90 degree DCM CLK output
CLKDV => clkdv_vga, -- Divided DCM CLK out (CLKDV_DIVIDE)
CLKFX => open, -- DCM CLK synthesis out (M/D)
CLKFX180 => open, -- 180 degree CLK synthesis out
LOCKED => open, -- DCM LOCK status output
PSDONE => open, -- Dynamic phase adjust done output
STATUS => open, -- 8-bit DCM status bits output
CLKFB => clock2_b, -- DCM clock feedback
CLKIN => div, -- Clock input (from IBUFG, BUFG or DCM)
PSCLK => '0', -- Dynamic phase adjust clock input
PSEN => '0', -- Dynamic phase adjust enable input
PSINCDEC => '0', -- Dynamic phase adjust increment/decrement
RST => i_reset -- DCM asynchronous reset input
);
IBUFG_inst_vga : IBUFG
generic map (IBUF_DELAY_VALUE => "0", IOSTANDARD => "DEFAULT")
port map (O => div,I => i_clock);
BUFG_inst_vga : BUFG
port map (O => clock2_b, I => clock1_b);

DCM_SP_inst1 : DCM_SP
generic map (
CLKDV_DIVIDE => 1.5, -- Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5,7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
CLKFX_DIVIDE => 31, -- Can be any interger from 1 to 32
CLKFX_MULTIPLY => 15, -- Can be any integer from 2 to 32
CLKIN_DIVIDE_BY_2 => FALSE, -- TRUE/FALSE to enable CLKIN divide by two feature
CLKIN_PERIOD => 20.0, -- Specify period of input clock
CLKOUT_PHASE_SHIFT => "NONE", -- Specify phase shift of "NONE", "FIXED" or "VARIABLE"
CLK_FEEDBACK => "1X", -- Specify clock feedback of "NONE", "1X" or "2X"
DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", -- "SOURCE_SYNCHRONOUS", "SYSTEM_SYNCHRONOUS" or an integer from 0 to 15
DFS_FREQUENCY_MODE => "LOW", -- "HIGH" or "LOW" frequency mode for frequency synthesis
DLL_FREQUENCY_MODE => "LOW", -- "HIGH" or "LOW" frequency mode for DLL
DUTY_CYCLE_CORRECTION => TRUE, -- Duty cycle correction, TRUE or FALSE
FACTORY_JF => X"F0F0", -- FACTORY JF Values
PHASE_SHIFT => 0, -- Amount of fixed phase shift from -255 to 255
STARTUP_WAIT => FALSE) -- Delay configuration DONE until DCM_SP LOCK, TRUE/FALSE
port map (
CLK0 => clock1_a, -- 0 degree DCM CLK ouptput
CLK180 => open, -- 180 degree DCM CLK output
CLK270 => open, -- 270 degree DCM CLK output
CLK2X => open, -- 2X DCM CLK output
CLK2X180 => open, -- 2X, 180 degree DCM CLK out
CLK90 => open, -- 90 degree DCM CLK output
CLKDV => clkdv_cam, -- Divided DCM CLK out (CLKDV_DIVIDE)
CLKFX => open, -- DCM CLK synthesis out (M/D)
CLKFX180 => open, -- 180 degree CLK synthesis out
LOCKED => dcm2_locked, -- DCM LOCK status output
PSDONE => open, -- Dynamic phase adjust done output
STATUS => open, -- 8-bit DCM status bits output
CLKFB => clock2_a, -- DCM clock feedback
CLKIN => divv, -- Clock input (from IBUFG, BUFG or DCM)
PSCLK => '0', -- Dynamic phase adjust clock input
PSEN => '0', -- Dynamic phase adjust enable input
PSINCDEC => '0', -- Dynamic phase adjust increment/decrement
RST => i_reset -- DCM asynchronous reset input
);
IBUFG_inst1 : BUFG
port map (O => divv,I => div);
BUFG_inst1 : BUFG
port map (O => clock2_a, I => clock1_a);

pa : process(fb,i_reset,jb,display_flag,hh1,vv1) is
begin
	if (i_reset = '1') then
		dlatch <= (others => '0');
		hlatch <= '0';
		vlatch <= '0';
--		o_r(3) <= '0';
--		o_r(2) <= '0';
--		o_r(1) <= '0';
--		o_g(3) <= '0';
--		o_g(2) <= '0';
--		o_g(1) <= '0';
--		o_b(3) <= '0';
--		o_b(2) <= '0';
	elsif (falling_edge(fb)) then
--		if (hh1 = '1') then
--			if (display_flag = '1') then
				dlatch <= jb;
				hlatch <= h;
				vlatch <= v;
--			end if;
--		end if;
	end if;
end process pa;

o_r(3) <= dlatch2(3) when i_reset = '0' else '0';
o_r(2) <= dlatch2(2) when i_reset = '0' else '0';
o_r(1) <= dlatch2(1) when i_reset = '0' else '0';
o_g(3) <= dlatch2(15) when i_reset = '0' else '0';
o_g(2) <= dlatch2(14) when i_reset = '0' else '0';
o_g(1) <= dlatch2(13) when i_reset = '0' else '0';
o_b(3) <= dlatch2(11) when i_reset = '0' else '0';
o_b(2) <= dlatch2(10) when i_reset = '0' else '0';

pc : process (fb,i_reset,hlatch,vlatch) is
	variable FSM_state : std_logic;
begin
	if (i_reset = '1') then
		FSM_state := '0';
	elsif (rising_edge(fb)) then
		case(FSM_state) is
			when '0' =>
				if (vlatch = '1') then
					FSM_state := '1';
				else
					FSM_state := '0';
				end if;
			when '1' =>
				if (vlatch = '0') then
					FSM_state := '0';
				else
					FSM_state := '1';
				end if;
				if (hlatch = '1') then
				end if;
			when others => null;
		end case;
	end if;
end process pc;

					dlatch2 <= dlatch2(7 downto 0) & dlatch;

--o_r(3) <= jb(7) when display_flag = '1' else '0';
--o_r(2) <= jb(6) when display_flag = '1' else '0';
--o_r(1) <= jb(5) when display_flag = '1' else '0';
--o_g(3) <= jb(4) when display_flag = '1' else '0';
--o_g(2) <= jb(3) when display_flag = '1' else '0';
--o_g(1) <= jb(2) when display_flag = '1' else '0';
--o_b(3) <= jb(1) when display_flag = '1' else '0';
--o_b(2) <= jb(0) when display_flag = '1' else '0';

--o_r(3) <= jb(2);
--o_r(2) <= jb(1);
--o_r(1) <= jb(0);
--o_g(3) <= jb(5);
--o_g(2) <= jb(4);
--o_g(1) <= jb(3);
--o_b(3) <= jb(7);
--o_b(2) <= jb(6);

--clock_25mhz <= div1; -- XXX from DCM vga
ja(0) <= not i_reset;
--o_h <= hh1;
--o_v <= vv1;
o_h <= h;
o_v <= v;
--ja(3) <= clock_25mhz;
--BUFG_ja : BUFG
--port map (O => ja(3), I => i_clock);
--IBUFG_clock : IBUFG
--generic map (IBUF_DELAY_VALUE => "0", IOSTANDARD => "DEFAULT")
--port map (O => div,I => i_clock);
--BUFG_ja : BUFG
--port map (O => ja(3), I => div);
ja(3) <= clkdv_cam;
jc(0) <= h;
jc(1) <= v;
--jc(2) <= clock_25mhz;
--IBUFG_fb : IBUFG
--generic map (IBUF_DELAY_VALUE => "0", IOSTANDARD => "DEFAULT")
--port map (O => fb,I => jc(3));
fb <= jc(3);

--IBUFG_v : IBUFG
--generic map (IBUF_DELAY_VALUE => "0", IOSTANDARD => "DEFAULT")
--port map (O => vv,I => ja(2));
--BUFG_v : BUFG
--port map (O => vv1, I => vv);
--BUFG_v : BUFG
--port map (O => vv1, I => v);

--IBUFG_h : IBUFG
--generic map (IBUF_DELAY_VALUE => "0", IOSTANDARD => "DEFAULT")
--port map (O => hh,I => ja(1));
--BUFG_h : BUFG
--port map (O => hh1, I => hh);
--BUFG_h : BUFG
--port map (O => hh1, I => h);

--p0vga : process (i_clock,i_reset) is
--	variable divide2 : std_logic;
--begin
--	if (i_reset = '1') then
--		divide2 := '0';
--	elsif (rising_edge(i_clock)) then
--		divide2 := not divide2;
--		clock_25mhz <= divide2;
--	end if;
--end process p0vga;
clock_25mhz <= clkdv_vga;

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

p3 : process (clock_25mhz,i_reset,h,ja(1),ja(2)) is
	constant C_PW : integer := 96;
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
				if (ja(1) = '1') then
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
				display_flag <= not display_flag;
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

p4 : process (clock_25mhz,i_reset,v,ja(1),ja(2)) is
	constant C_PW : integer := 1600;
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
				if (ja(2) = '1') then
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
