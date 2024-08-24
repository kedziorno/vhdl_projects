----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:56:40 07/10/2022 
-- Design Name: 
-- Module Name:    camera - Behavioral 
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

-- XXX ov7670 camera emulator vga 640x480 30fps
-- XXX based on datasheet VGA Frame Timing Figure 6 p. 7
entity camera is
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
end camera;

architecture Behavioral of camera is
	constant CLOCK_PERIOD1 : integer := 21;
	constant CLOCK_PERIOD2 : integer := 42;
	constant CLOCK_PERIOD3 : integer := 100;
	-- 1 or 2 pclk for tp
	constant tp : integer := 2**RAW_RGB;
	-- tline = 784tp = 640tp + 144tp
	constant HREF1 : integer := 640;
	constant CHREF1 : integer := HREF1 * tp; -- HREF 1 pulse time
	constant HREF0 : integer := 144;
	constant CHREF0 : integer := HREF0 * tp; -- HREF 0 pulse time
	constant tline : integer := CHREF1 + CHREF0;
	-- VSYNC pulse have 510tline
	constant CVSYNC1 : integer := 3;
	constant VSYNC1 : integer := CVSYNC1 * tline;
	constant CVSYNC2 : integer := 17;
	constant VSYNC2 : integer := CVSYNC2 * tline;
	constant CVSYNC3 : integer := 480;
	constant VSYNC3 : integer := CVSYNC3 * tline;
	constant CVSYNC4 : integer := 10;
	constant VSYNC4 : integer := CVSYNC4 * tline;
	constant CVSYNCALL : integer := CVSYNC1 + CVSYNC2 + CVSYNC3 + CVSYNC4; -- 510tline
	signal href_time : std_logic;
	signal pixel_time : std_logic;
begin

	-- check the clock period
	p0 : process (i_rst) is
	begin
		if (i_rst = '0') then
			assert (CLOCK_PERIOD = CLOCK_PERIOD1 or CLOCK_PERIOD = CLOCK_PERIOD2 or CLOCK_PERIOD = CLOCK_PERIOD3)
			report "-- CLOCK_PERIOD must have " & integer'image(CLOCK_PERIOD1) & "," & integer'image(CLOCK_PERIOD2) & "," & integer'image(CLOCK_PERIOD3) & " --"
			severity failure;
		end if;
	end process p0;

	-- generate sync pulse
	-- p.14 15 COM10 0x00 RW [2] - VSYNC changes on falling edge PCLK
	p1 : process (i_xclk,i_rst) is
		variable count : integer range 0 to CVSYNCALL*tline - 1;
		variable vvsync : std_logic;
		type states is (svs1,svs2,svs3,svs4);
		variable state : states;
	begin
		if (i_rst = '0') then
			count := 0;
			vvsync := '0';
			state := svs1;
			href_time <= '0';
		elsif (falling_edge(i_xclk)) then
			case (state) is
				when svs1 =>
					vvsync := '1';
					href_time <= '0';
					if (count = VSYNC1) then
						state := svs2;
						count := 0;
					else
						state := svs1;
						count := count + 1;
					end if;
				when svs2 =>
					vvsync := '0';
					href_time <= '0';
					if (count = VSYNC2) then
						state := svs3;
						count := 0;
					else
						state := svs2;
						count := count + 1;
					end if;
				when svs3 =>
					vvsync := '0';
					href_time <= '1';
					if (count = VSYNC3) then
						state := svs4;
						count := 0;
					else
						state := svs3;
						count := count + 1;
					end if;
				when svs4 =>
					vvsync := '0';
					href_time <= '0';
					if (count = VSYNC4) then
						state := svs1;
						count := 0;
					else
						state := svs4;
						count := count + 1;
					end if;
			end case;
			o_vs <= vvsync;
		end if;
	end process p1;

	-- generate href pulse
	-- on falling edge
	p2 : process (i_rst,i_xclk,href_time) is
		variable count : integer range 0 to VSYNC3 - 1;
		variable counth1 : integer range 0 to CHREF1 - 1;
		variable counth0 : integer range 0 to CHREF0 - 1;
		type states is (swait4vsync,shref1,shref0);
		variable state : states;
		variable vhref : std_logic;
	begin
		if (i_rst = '0') then
			count := 0;
			counth1 := 0;
			counth0 := 0;
			state := swait4vsync;
			vhref := '0';
		elsif (falling_edge(i_xclk)) then
			case (state) is
				when swait4vsync =>
					pixel_time <= '0';
					if (href_time = '1') then
						if (count = VSYNC3) then
							state := swait4vsync;
							count := 0;
						else
							state := shref1;
							pixel_time <= '1';
							count := count + 1;
						end if;
					else
						state := swait4vsync;
					end if;
				when shref1 =>
					pixel_time <= '1';
					vhref := '1';
					if (counth1 = CHREF1 - 1) then
						pixel_time <= '0';
						state := shref0;
						counth1 := 0;
					else
						state := shref1;
						counth1 := counth1 + 1;
					end if;
				when shref0 =>
					pixel_time <= '0';
					vhref := '0';
					if (counth0 = CHREF0 - 1) then
						state := swait4vsync;
						counth0 := 0;
					else
						state := shref0;
						counth0 := counth0 + 1;
					end if;
			end case;
			o_hs <= vhref;
		end if;
	end process p2;

	p3 : process (i_rst,i_xclk,pixel_time) is
		constant CDATALENGTH : integer := 5;
		constant CNUMPIXELS : integer := HREF1 - CDATALENGTH*2;
		variable count : integer range 0 to CDATALENGTH - 1;
		type tdata is array(0 to CDATALENGTH - 1) of std_logic_vector(7 downto 0);
		constant startdata : tdata := (x"FF",x"EE",x"DD",x"CC",x"BB");
		constant enddata : tdata := (x"BB",x"CC",x"DD",x"EE",x"FF");
		constant odddata : std_logic_vector(7 downto 0) := x"AA";
		constant evendata : std_logic_vector(7 downto 0) := x"55";
		type states is (s1,s2,s3);
		variable state : states;
		variable vd : std_logic_vector(7 downto 0);
	begin
		if (i_rst = '0') then
			vd := (others => '0');
			state := s1;
			count := 0;
		elsif (falling_edge(i_xclk)) then
			if (pixel_time = '1') then
				case (state) is
					when s1 =>
						vd := startdata(count);
						if (count = CDATALENGTH - 1) then
							count := 0;
							state := s2;
						else
							count := count + 1;
							state := s1;
						end if;
					when s2 =>
						if (count = CNUMPIXELS - 1) then
							state := s3;
							count := 0;
						else
							state := s2;
							if (count mod 2 = 0) then
								vd := odddata;
								count := count + 1;
							elsif (count mod 2 = 1) then
								vd := evendata;
								count := count + 1;
							else
								vd := (others => 'U');
							end if;
						end if;
					when s3 =>
						vd := enddata(count);
						if (count = CDATALENGTH - 1) then
							count := 0;
							state := s1;
						else
							count := count + 1;
							state := s3;
						end if;
				end case;
			else
				vd := (others => '0');
			end if;
			o_d <= vd;
		end if;
	end process p3;

o_pclk <= i_xclk;

end Behavioral;
