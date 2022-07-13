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
library UNISIM;
use UNISIM.VComponents.all;

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
signal clock : std_logic;
signal clockbuf1a,clockbuf1b,clockbuf1,clkdv_vga : std_logic;
signal clockbuf2a,clockbuf2b,clockbuf2,clkdv_cam : std_logic;

component camera is
generic (
constant CLOCK_PERIOD : integer := 42; -- 21/42/100 ns - 10/24/48 MHZ - Min/Typ/Max Unit
constant RAW_RGB : integer := 0; -- 0 - RAW / 1 - RGB
constant ZERO : integer := 0
);
port (
io_scl : inout std_logic;
io_sda : inout std_logic;
o_vs : out std_logic;
o_hs : out std_logic;
o_pclk : out std_logic;
i_xclk : in std_logic;
o_d : out std_logic_vector(7 downto 0);
i_rst : in std_logic;
i_pwdn : in std_logic
);
end component camera;
signal camera_io_scl,camera_io_sda,camera_o_vs,camera_o_hs,camera_o_pclk,camera_i_xclk,camera_i_rst,camera_i_pwdn : std_logic;
signal camera_o_d : std_logic_vector(7 downto 0);

constant C_BRAM_VGA_WIDTH : integer := 8;
constant C_BRAM_VGA_DEPTH : integer := 1;
component bram_vga is
generic (
constant WIDTH : integer := C_BRAM_VGA_WIDTH;
constant DEPTH : integer := C_BRAM_VGA_DEPTH
);
port (
clka : in std_logic;
clkb : in std_logic;
wea : in std_logic;
addra : in std_logic_vector(DEPTH-1 downto 0);
addrb : in std_logic_vector(DEPTH-1 downto 0);
dina : in std_logic_vector(WIDTH-1 downto 0);
douta : out std_logic_vector(WIDTH-1 downto 0)
);
end component bram_vga;
signal bram_vga_clka,bram_vga_clkb,bram_vga_wea : std_logic;
signal bram_vga_addra,bram_vga_addrb : std_logic_vector(C_BRAM_VGA_DEPTH - 1 downto 0);
signal bram_vga_dina,bram_vga_douta : std_logic_vector(C_BRAM_VGA_WIDTh - 1 downto 0);

signal activeh : std_logic;

begin

mem : bram_vga
port map (
clka => bram_vga_clka,
clkb => bram_vga_clkb,
wea => bram_vga_wea,
addra => bram_vga_addra,
addrb => bram_vga_addrb,
dina => bram_vga_dina,
douta => bram_vga_douta
);

bram_vga_clka <= clockbuf1; --clkdv_cam;
bram_vga_clkb <= clkdv_vga;
bram_vga_wea <= '1';
bram_vga_dina <= camera_o_d;

pmemaddra : process (bram_vga_clka,i_reset) is
	constant C_COUNT : integer := 2**C_BRAM_VGA_DEPTH;
	variable count : integer range 0 to C_COUNT - 1;
begin
	if (i_reset = '1') then
		count := 0;
	elsif(rising_edge(bram_vga_clka)) then
		if (camera_o_hs = '1') then
			if (count = C_COUNT - 1) then
				count := 0;
			else
				count := count + 1;
			end if;
		end if;
	end if;
	bram_vga_addra <= std_logic_vector(to_unsigned(count,C_BRAM_VGA_DEPTH));
end process pmemaddra;

pmemaddrb : process (bram_vga_clkb,i_reset) is
	constant C_COUNT : integer := 2**C_BRAM_VGA_DEPTH;
	variable count : integer range 0 to C_COUNT - 1;
begin
	if (i_reset = '1') then
		count := 0;
	elsif(rising_edge(bram_vga_clkb)) then
		if (camera_o_hs = '1') then
			if (count = C_COUNT - 1) then
				count := 0;
			else
				count := count + 1;
			end if;
		end if;
	end if;
	bram_vga_addrb <= std_logic_vector(to_unsigned(count,C_BRAM_VGA_DEPTH));
end process pmemaddrb;

clock <= i_clock;

dcm_vga : DCM
generic map (
CLKDV_DIVIDE => 2.0, -- Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5,7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
CLKFX_DIVIDE => 1, -- Can be any interger from 1 to 32
CLKFX_MULTIPLY => 4, -- Can be any integer from 1 to 32
CLKIN_DIVIDE_BY_2 => FALSE, -- TRUE/FALSE to enable CLKIN divide by two feature
CLKIN_PERIOD => 20.0, -- Specify period of input clock
CLKOUT_PHASE_SHIFT => "NONE", -- Specify phase shift of NONE, FIXED or VARIABLE
CLK_FEEDBACK => "1X", -- Specify clock feedback of NONE, 1X or 2X
DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", -- SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or an integer from 0 to 15
DFS_FREQUENCY_MODE => "LOW", -- HIGH or LOW frequency mode for frequency synthesis
DLL_FREQUENCY_MODE => "LOW", -- HIGH or LOW frequency mode for DLL
DUTY_CYCLE_CORRECTION => TRUE, -- Duty cycle correction, TRUE or FALSE
FACTORY_JF => X"C080", -- FACTORY JF Values
PHASE_SHIFT => 0, -- Amount of fixed phase shift from -255 to 255
SIM_MODE => "SAFE", -- Simulation: "SAFE" vs "FAST", see "Synthesis and Simulation Design Guide" for details
STARTUP_WAIT => FALSE -- Delay configuration DONE until DCM LOCK, TRUE/FALSE
)
port map (
CLK0 => clockbuf1a, -- 0 degree DCM CLK ouptput
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
CLKFB => clockbuf1b, -- DCM clock feedback
CLKIN => clockbuf1, -- Clock input (from IBUFG, BUFG or DCM)
PSCLK => '0', -- Dynamic phase adjust clock input
PSEN => '0', -- Dynamic phase adjust enable input
PSINCDEC => open, -- Dynamic phase adjust increment/decrement
RST => i_reset -- DCM asynchronous reset input
);
ibuf_clk_vga : ibufg
port map (o => clockbuf1, i => clock);
buf_clk_vga : bufg
port map (o => clockbuf1b, i => clockbuf1a);

dcm_cam : DCM
generic map (
CLKDV_DIVIDE => 2.0, -- Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5,7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
CLKFX_DIVIDE => 31, -- Can be any interger from 1 to 32
CLKFX_MULTIPLY => 15, -- Can be any integer from 1 to 32
CLKIN_DIVIDE_BY_2 => FALSE, -- TRUE/FALSE to enable CLKIN divide by two feature
CLKIN_PERIOD => 20.0, -- Specify period of input clock
CLKOUT_PHASE_SHIFT => "NONE", -- Specify phase shift of NONE, FIXED or VARIABLE
CLK_FEEDBACK => "1X", -- Specify clock feedback of NONE, 1X or 2X
DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", -- SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or an integer from 0 to 15
DFS_FREQUENCY_MODE => "LOW", -- HIGH or LOW frequency mode for frequency synthesis
DLL_FREQUENCY_MODE => "LOW", -- HIGH or LOW frequency mode for DLL
DUTY_CYCLE_CORRECTION => TRUE, -- Duty cycle correction, TRUE or FALSE
FACTORY_JF => X"C080", -- FACTORY JF Values
PHASE_SHIFT => 0, -- Amount of fixed phase shift from -255 to 255
SIM_MODE => "SAFE", -- Simulation: "SAFE" vs "FAST", see "Synthesis and Simulation Design Guide" for details
STARTUP_WAIT => FALSE -- Delay configuration DONE until DCM LOCK, TRUE/FALSE
)
port map (
CLK0 => clockbuf2a, -- 0 degree DCM CLK ouptput
CLK180 => open, -- 180 degree DCM CLK output
CLK270 => open, -- 270 degree DCM CLK output
CLK2X => open, -- 2X DCM CLK output
CLK2X180 => open, -- 2X, 180 degree DCM CLK out
CLK90 => open, -- 90 degree DCM CLK output
CLKDV => open, -- Divided DCM CLK out (CLKDV_DIVIDE)
CLKFX => clkdv_cam, -- DCM CLK synthesis out (M/D)
CLKFX180 => open, -- 180 degree CLK synthesis out
LOCKED => open, -- DCM LOCK status output
PSDONE => open, -- Dynamic phase adjust done output
STATUS => open, -- 8-bit DCM status bits output
CLKFB => clockbuf2b, -- DCM clock feedback
CLKIN => clockbuf2, -- Clock input (from IBUFG, BUFG or DCM)
PSCLK => '0', -- Dynamic phase adjust clock input
PSEN => '0', -- Dynamic phase adjust enable input
PSINCDEC => open, -- Dynamic phase adjust increment/decrement
RST => i_reset -- DCM asynchronous reset input
);
ibuf_clk_cam : bufg
port map (o => clockbuf2, i => clockbuf1);
buf_clk_cam : bufg
port map (o => clockbuf2b, i => clockbuf2a);

cam : camera
port map (
io_scl => camera_io_scl,
io_sda => camera_io_sda,
o_vs => camera_o_vs,
o_hs => camera_o_hs,
o_pclk => camera_o_pclk,
i_xclk => camera_i_xclk,
o_d => camera_o_d,
i_rst => camera_i_rst,
i_pwdn => camera_i_pwdn
);

camera_i_rst <= not i_reset;
camera_i_xclk <= clkdv_cam;
o_h <= h;
o_v <= v;

o_r(3) <= bram_vga_douta(7) when display_flag = '1' else '0';
o_r(2) <= bram_vga_douta(6) when display_flag = '1' else '0';
o_r(1) <= bram_vga_douta(5) when display_flag = '1' else '0';
o_g(3) <= bram_vga_douta(4) when display_flag = '1' else '0';
o_g(2) <= bram_vga_douta(3) when display_flag = '1' else '0';
o_g(1) <= bram_vga_douta(2) when display_flag = '1' else '0';
o_b(3) <= bram_vga_douta(1) when display_flag = '1' else '0';
o_b(2) <= bram_vga_douta(0) when display_flag = '1' else '0';

p3 : process (clkdv_vga,i_reset,h) is
	constant C_PW : integer := 96;
	constant C_FP : integer := 48;
	constant C_BP : integer := 16;
	constant C_DISP : integer := 640;
	variable pwh : integer range 0 to C_PW - 1 := 0;
	variable fph : integer range 0 to C_FP - 1 := 0;
	variable bph : integer range 0 to C_BP - 1 := 0;
	variable disph : integer range 0 to C_DISP - 1 := 0;
	type statesh is (idleh,state_pwh,state_fph,state_disph,state_bph);
	variable stateh : statesh;
begin
	if (i_reset = '1') then
		fph := 0;
		bph := 0;
		disph := 0;
		stateh := idleh;
		display_flag <= '0';
	elsif (rising_edge(clkdv_vga)) then
		case (stateh) is
			when idleh =>
				display_flag <= '0';
				h <= '0';
				if (activeh = '1') then
					stateh := state_pwh;
				else
					stateh := idleh;
				end if;
			when state_pwh =>
				display_flag <= '0';
				h <= '0';
				if (pwh = C_PW - 1) then
					stateh := state_fph;
					pwh := 0;
				else
					stateh := state_pwh;
					pwh := pwh + 1;
				end if;
			when state_fph =>
				display_flag <= '0';
				h <= '1';
				if (fph = C_FP - 1) then
					stateh := state_disph;
					fph := 0;
				else
					stateh := state_fph;
					fph := fph + 1;
				end if;
			when state_disph =>
				display_flag <= '1';
				h <= '1';
				if (disph = C_DISP - 1) then
					stateh := state_bph;
					disph := 0;
				else
					stateh := state_disph;
					disph := disph + 1;
				end if;
			when state_bph =>
				display_flag <= '0';
				h <= '1';
				if (bph = C_BP - 1) then
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

p4 : process (clkdv_vga,i_reset,v) is
	constant C_PW : integer := 1600;
	constant C_FP : integer := 23200*4*2;
	constant C_BP : integer := 8000*4*2;
	constant C_DISP : integer := 384000/4;
	variable pwv : integer range 0 to C_PW - 1 := 0;
	variable fpv : integer range 0 to C_FP - 1 := 0;
	variable bpv : integer range 0 to C_BP - 1 := 0;
	variable dispv : integer range 0 to C_DISP - 1 := 0;
	type statesv is (idlev,state_pwv,state_fpv,state_dispv,state_bpv);
	variable statev : statesv;
begin
	if (i_reset = '1') then
		pwv := 0;
		fpv := 0;
		bpv := 0;
		dispv := 0;
		statev := idlev;
		activeh <= '0';
	elsif (rising_edge(clkdv_vga)) then
		case (statev) is
			when idlev =>
				activeh <= '0';
				v <= '1';
				statev := state_pwv;
			when state_pwv =>
				activeh <= '0';
				v <= '0';
				if (pwv = C_PW - 1) then
					statev := state_fpv;
					pwv := 0;
				else
					statev := state_pwv;
					pwv := pwv + 1;
				end if;
			when state_fpv =>
				activeh <= '0';
				v <= '1';
				if (fpv = C_FP - 1) then
					statev := state_dispv;
					fpv := 0;
				else
					statev := state_fpv;
					fpv := fpv + 1;
				end if;
			when state_dispv =>
				activeh <= '1';
				v <= '1';
				if (dispv = C_DISP - 1) then
					statev := state_bpv;
					dispv := 0;
				else
					statev := state_dispv;
					dispv := dispv + 1;
				end if;
			when state_bpv =>
				activeh <= '0';
				v <= '1';
				if (bpv = C_BP - 1) then
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
