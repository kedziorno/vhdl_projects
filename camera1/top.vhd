library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity top is
port (
i_clock : in std_logic;
--i_reset : in std_logic;
o_r : out std_logic_vector(3 downto 1);
o_g : out std_logic_vector(3 downto 1);
o_b : out std_logic_vector(3 downto 2);
o_h : out std_logic;
o_v : out std_logic;
btn : in std_logic_vector(3 downto 0);
i_sw : in std_logic_vector(7 downto 0);
cam_xclk : out std_logic;
cam_pclk : in std_logic;
cam_sioc : inout std_logic;
cam_siod : inout std_logic;
cam_data : in std_logic_vector(7 downto 0);
cam_vsync : in std_logic;
cam_href : in std_logic;
cam_rst : out std_logic
);
end top;

architecture Behavioral of top is

component Address_Generator is
Port (
CLK25,enable : in  STD_LOGIC;
rez_160x120  : IN std_logic;
rez_320x240  : IN std_logic;
vsync        : in  STD_LOGIC;
address 		 : out STD_LOGIC_VECTOR (14 downto 0)
);
end component Address_Generator;

component RGB is
Port (
Din 	: in	STD_LOGIC_VECTOR (7 downto 0);
Nblank : in	STD_LOGIC;
R 	: out	STD_LOGIC_VECTOR (3 downto 1);
G 	: out	STD_LOGIC_VECTOR (3 downto 1);
B 	: out	STD_LOGIC_VECTOR (3 downto 2)
);
end component RGB;

component VGA is
Port (
CLK25 : in  STD_LOGIC;
rez_160x120 : IN std_logic;
rez_320x240 : IN std_logic;
Hsync,Vsync : out  STD_LOGIC;
activeArea : out  STD_LOGIC;
video : out std_logic
);
end component VGA;

--component debounce is
--Port (
--clk : in  STD_LOGIC;
--i : in  STD_LOGIC;
--o : out  STD_LOGIC
--);
--end component debounce;

component ov7670_capture is
Port (
pclk  : in   STD_LOGIC;
rez_160x120 : IN std_logic;
rez_320x240 : IN std_logic;
vsync : in   STD_LOGIC;
href  : in   STD_LOGIC;
d     : in   STD_LOGIC_VECTOR (7 downto 0);
addr  : out  STD_LOGIC_VECTOR (14 downto 0);
dout  : out  STD_LOGIC_VECTOR (7 downto 0);
we    : out  STD_LOGIC
);
end component ov7670_capture;

component ov7670_controller is
Port (
clk   : in    STD_LOGIC;
resend :in    STD_LOGIC;
config_finished : out std_logic;
sioc  : out   STD_LOGIC;
siod  : inout STD_LOGIC;
reset : out   STD_LOGIC;
pwdn  : out   STD_LOGIC;
xclk  : out   STD_LOGIC
);
end component ov7670_controller;

--component i3c2 is
--Generic(
--clk_divide : STD_LOGIC_VECTOR (7 downto 0)
--);
--Port (
--clk : in  STD_LOGIC;
--inst_address : out  STD_LOGIC_VECTOR (9 downto 0);
--inst_data : in  STD_LOGIC_VECTOR (8 downto 0);
--i2c_scl : out  STD_LOGIC;
--i2c_sda : inout  STD_LOGIC;
--inputs : in  STD_LOGIC_VECTOR (15 downto 0);
--outputs : out  STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
--reg_addr : out  STD_LOGIC_VECTOR (4 downto 0);
--reg_data : out  STD_LOGIC_VECTOR (7 downto 0);
--reg_write : out  STD_LOGIC;
--error : out STD_LOGIC
--);
--end component i3c2;

signal ag_clk25,ag_enable,ag_rez1,ag_rez2,ag_vsync : std_logic;
signal ag_address : std_logic_vector(14 downto 0);
signal rgb_nblank : std_logic;
signal rgb_din : STD_LOGIC_VECTOR (7 downto 0);
signal rgb_r : std_logic_vector(3 downto 1);
signal rgb_g : std_logic_vector(3 downto 1);
signal rgb_b : std_logic_vector(3 downto 2);
signal vga_clk25,vga_rez1,vga_rez2,vga_hs,vga_vs,vga_aa,vga_video : std_logic;
--signal d_clk,d_i,d_o : std_logic;
signal ov1_pclk,ov1_rez1,ov1_rez2,ov1_vs,ov1_hr,ov1_we : std_logic;
signal ov1_d : STD_LOGIC_VECTOR (7 downto 0);
signal ov1_addr : STD_LOGIC_VECTOR (14 downto 0);
signal ov1_dout : STD_LOGIC_VECTOR (7 downto 0);
signal ovc2_clk,ovc2_resend,ovc2_cf,ovc2_sioc,ovc2_siod,ovc2_reset,ovc2_pwdn,ovc2_xclk : std_logic;
--signal ic_clk,ic_scl,ic_sda,ic_regwrite,ic_error : std_logic;
--signal ic_addr : STD_LOGIC_VECTOR (9 downto 0);
--signal ic_data : STD_LOGIC_VECTOR (8 downto 0);
--signal ic_regaddr : STD_LOGIC_VECTOR (4 downto 0);
--signal ic_regdata : STD_LOGIC_VECTOR (7 downto 0);
--signal ic_ip : STD_LOGIC_VECTOR (15 downto 0);
--signal ic_op : STD_LOGIC_VECTOR (15 downto 0);

signal clockbuf,clockbuf1,clockbuf2 : std_logic;
signal clock25 : std_logic;
signal reset : std_logic;
signal clock : std_logic;

component bram_vga is
generic (
constant WIDTH : integer := 0;
constant DEPTH: integer := 0
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

signal bram_wea,bram_clka,bram_ena,bram_clkb : std_logic;
signal bram_addra : std_logic_vector(14 downto 0);
signal bram_addrb : std_logic_vector(14 downto 0);
signal bram_dina : std_logic_vector(7 downto 0);
signal bram_doutb : std_logic_vector(7 downto 0);

begin

clock <= i_clock;
--reset <= i_reset;
reset <= btn(0);
cam_rst <= not btn(1);
vga_clk25 <= clock25;
ag_clk25 <= clock25;
--ovc2_clk <= clockbuf when ovc2_cf = '0' else '0';
ovc2_clk <= clockbuf;
vga_rez1 <= i_sw(1);
vga_rez2 <= i_sw(2);
ag_rez1 <= i_sw(1);
ag_rez2 <= i_sw(2);
ov1_rez1 <= i_sw(1);
ov1_rez2 <= i_sw(2);
o_h <= vga_hs;
o_v <= vga_vs;
ov1_pclk <= cam_pclk;
cam_sioc <= ovc2_sioc;
--cam_sioc <= 'Z';
cam_siod <= ovc2_siod;
--cam_siod <= 'Z';
ov1_d <= cam_data;
ov1_vs <= cam_vsync;
ov1_hr <= cam_href;
ag_enable <= vga_aa;
rgb_nblank <= vga_aa;
ag_vsync <= vga_vs;
cam_xclk <= ovc2_xclk;

o_r <= rgb_r;
o_g <= rgb_g;
o_b <= rgb_b;

clk25 : DCM
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
CLK0 => clockbuf1, -- 0 degree DCM CLK ouptput
CLK180 => open, -- 180 degree DCM CLK output
CLK270 => open, -- 270 degree DCM CLK output
CLK2X => open, -- 2X DCM CLK output
CLK2X180 => open, -- 2X, 180 degree DCM CLK out
CLK90 => open, -- 90 degree DCM CLK output
CLKDV => clock25, -- Divided DCM CLK out (CLKDV_DIVIDE)
CLKFX => open, -- DCM CLK synthesis out (M/D)
CLKFX180 => open, -- 180 degree CLK synthesis out
LOCKED => open, -- DCM LOCK status output
PSDONE => open, -- Dynamic phase adjust done output
STATUS => open, -- 8-bit DCM status bits output
CLKFB => clockbuf2, -- DCM clock feedback
CLKIN => clockbuf, -- Clock input (from IBUFG, BUFG or DCM)
PSCLK => '0', -- Dynamic phase adjust clock input
PSEN => '0', -- Dynamic phase adjust enable input
PSINCDEC => open, -- Dynamic phase adjust increment/decrement
RST => reset -- DCM asynchronous reset input
);
ibuf_clk25 : ibufg
port map (o => clockbuf, i => clock);
buf_clk25 : bufg
port map (o => clockbuf2, i => clockbuf1);

a1 : Address_Generator
Port map (
CLK25 => ag_clk25,
enable => ag_enable,
rez_160x120 => ag_rez1,
rez_320x240 => ag_rez2,
vsync => ag_vsync,
address => ag_address
);

b1 : RGB
Port map (
Din => rgb_din,
Nblank => rgb_nblank,
R => rgb_r,
G => rgb_g,
B => rgb_b
);

c1 : VGA
Port map (
CLK25 => vga_clk25,
rez_160x120 => vga_rez1,
rez_320x240 => vga_rez2,
Hsync => vga_hs,
Vsync => vga_vs,
activeArea => vga_aa,
video => vga_video
);

--d1 : debounce
--Port map (
--clk => d_clk,
--i => d_i,
--o => d_o
--);

e1 : ov7670_capture
Port map (
pclk => ov1_pclk,
rez_160x120 => ov1_rez1,
rez_320x240 => ov1_rez2,
vsync => ov1_vs,
href => ov1_hr,
d => ov1_d,
addr => ov1_addr,
dout => ov1_dout,
we => ov1_we
);

f1 : ov7670_controller
Port map (
clk => ovc2_clk,
resend => ovc2_resend,
config_finished => ovc2_cf,
sioc => ovc2_sioc,
siod => ovc2_siod,
reset => ovc2_reset,
pwdn => ovc2_pwdn,
xclk => ovc2_xclk
);

--g1 : i3c2
--Generic map (
--clk_divide => "10000000"
--)
--Port map (
--clk => ic_clk,
--inst_address => ic_addr,
--inst_data => ic_data,
--i2c_scl => ic_scl,
--i2c_sda => ic_sda,
--inputs => ic_ip,
--outputs => ic_op,
--reg_addr => ic_regaddr,
--reg_data => ic_regdata,
--reg_write => ic_regwrite,
--error => ic_error
--);

ram : bram_vga
generic map (
WIDTH => 8,
DEPTH => 15
)
port map (
clka => bram_clka,
clkb => bram_clkb,
wea => bram_wea,
addra => bram_addra,
addrb => bram_addrb,
dina => bram_dina,
douta => bram_doutb
);

rgb_din <= bram_doutb;
bram_addrb <= ag_address;
bram_clkb <= clock25;

bram_addra <= ov1_addr;
bram_clka <= ov1_pclk;
bram_dina <= ov1_dout;
bram_wea <= ov1_we;
bram_ena <= '1';

end Behavioral;
