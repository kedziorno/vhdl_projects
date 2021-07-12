----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:09:37 06/23/2021 
-- Design Name: 
-- Module Name:    draw_box - Behavioral 
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
use WORK.st7735r_p_package.ALL;
use WORK.st7735r_p_screen.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity st7735r_draw_box is
generic (
	C_CLOCK_COUNTER : integer
);
port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	i_run : in std_logic;
	i_sended : in std_logic;
	i_color : in COLOR_TYPE;
	i_raxs : in BYTE_TYPE;
	i_raxe : in BYTE_TYPE;
	i_rays : in BYTE_TYPE;
	i_raye : in BYTE_TYPE;
	i_caxs : in BYTE_TYPE;
	i_caxe : in BYTE_TYPE;
	i_cays : in BYTE_TYPE;
	i_caye : in BYTE_TYPE;
	o_data : out BYTE_TYPE;
	o_enable : out std_logic;
	o_rs : out std_logic;
	o_initialized : out std_logic
);
end st7735r_draw_box;

architecture Behavioral of st7735r_draw_box is

	signal rs,enable,sended,initialized : std_logic;
	signal send_data,send_command : BYTE_TYPE;
	signal raxs,raxe,rays,raye,caxs,caxe,cays,caye : BYTE_TYPE;
	type states is (
	idle,start,
	sendracmd,sendracmdw1,sendracmdw1a,
	sendraxs,sendraxsw1,sendraxsw1a,
	sendrays,sendraysw1,sendraysw1a,
	sendraxe,sendraxew1,sendraxew1a,
	sendraye,sendrayew1,sendrayew1a,
	sendcacmd,sendcacmdw1,sendcacmdw1a,
	sendcaxs,sendcaxsw1,sendcaxsw1a,
	sendcays,sendcaysw1,sendcaysw1a,
	sendcaxe,sendcaxew1,sendcaxew1a,
	sendcaye,sendcayew1,sendcayew1a,
	sendmemwr,sendmemwrw1,sendmemwrw1a,
	fillarealb,fillarealbw1,fillarealbw1a,
	fillareahb,fillareahbw1,fillareahbw1a,
	fillarenaindex,
	stop);
	signal state : states;

begin

	o_data <= send_command when rs = '0' else send_data when rs = '1';
	o_rs <= rs;
	sended <= i_sended;
	o_enable <= enable;
	o_initialized <= initialized;
	raxs <= i_raxs;
	raxe <= i_raxe;
	rays <= i_rays;
	raye <= i_raye;
	caxs <= i_caxs;
	caxe <= i_caxe;
	cays <= i_cays;
	caye <= i_caye;

	p0 : process (i_clock,i_reset) is
		variable w0_index : integer range 0 to 2**25;
		variable index : integer;
		variable x,y : integer;
	begin
		if (i_reset = '1') then
			state <= idle;
			w0_index := 0;
			enable <= '0';
			rs <= '0';
			send_command <= (others => '0');
			send_data <= (others => '0');
			initialized <= '0';
			x := 0;
			y := 0;
			index := 0;
		elsif (rising_edge(i_clock)) then
			case (state) is
				when idle =>
					initialized <= '0';
					if (i_run = '1') then
						state <= start;
					else
						state <= idle;
					end if;
				when start =>
					state <= sendracmd;
				when sendracmd =>
					send_command <= x"2b"; --RASET
					rs <= '0';
					enable <= '1';
					if (sended = '1') then
						state <= sendracmdw1;
					else
						state <= sendracmd;
					end if;
				when sendracmdw1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendracmdw1a;
						w0_index := 0;
						enable <= '0';
					else
						state <= sendracmdw1;
						w0_index := w0_index + 1;
					end if;
				when sendracmdw1a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendraxs;
						w0_index := 0;
					else
						state <= sendracmdw1a;
						w0_index := w0_index + 1;
					end if;
				when sendraxs => -- c1
					rs <= '1';
					send_data <= raxs;
					enable <= '1';
					if (sended = '1') then
						state <= sendraxsw1;
					else
						state <= sendraxs;
					end if;
				when sendraxsw1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendraxsw1a;
						w0_index := 0;
						enable <= '0';
					else
						state <= sendraxsw1;
						w0_index := w0_index + 1;
					end if;
				when sendraxsw1a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendrays;
						w0_index := 0;
					else
						state <= sendraxsw1a;
						w0_index := w0_index + 1;
					end if;
				when sendrays => -- c2
					rs <= '1';
					send_data <= raxe;
					enable <= '1';
					if (sended = '1') then
						state <= sendraysw1;
					else
						state <= sendrays;
					end if;
				when sendraysw1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendraysw1a;
						w0_index := 0;
						enable <= '0';
					else
						state <= sendraysw1;
						w0_index := w0_index + 1;
					end if;
				when sendraysw1a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendraxe;
						w0_index := 0;
					else
						state <= sendraysw1a;
						w0_index := w0_index + 1;
					end if;
				when sendraxe => -- c3
					rs <= '1';
					send_data <= rays;
					enable <= '1';
					if (sended = '1') then
						state <= sendraxew1;
					else
						state <= sendraxe;
					end if;
				when sendraxew1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendraxew1a;
						w0_index := 0;
						enable <= '0';
					else
						state <= sendraxew1;
						w0_index := w0_index + 1;
					end if;
				when sendraxew1a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendraye;
						w0_index := 0;
					else
						state <= sendraxew1a;
						w0_index := w0_index + 1;
					end if;
				when sendraye => -- c4
					rs <= '1';
					send_data <= caxe;
					enable <= '1';
					if (sended = '1') then
						state <= sendrayew1;
					else
						state <= sendraye;
					end if;
				when sendrayew1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendrayew1a;
						w0_index := 0;
						enable <= '0';
					else
						state <= sendrayew1;
						w0_index := w0_index + 1;
					end if;
				when sendrayew1a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendcacmd;
						w0_index := 0;
					else
						state <= sendrayew1a;
						w0_index := w0_index + 1;
					end if;
				when sendcacmd =>
					rs <= '0';
					send_command <= x"2a"; --CASET
					enable <= '1';
					if (sended = '1') then
						state <= sendcacmdw1;
					else
						state <= sendcacmd;
					end if;
				when sendcacmdw1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendcacmdw1a;
						w0_index := 0;
						enable <= '0';
					else
						state <= sendcacmdw1;
						w0_index := w0_index + 1;
					end if;
				when sendcacmdw1a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendcaxs;
						w0_index := 0;
					else
						state <= sendcacmdw1a;
						w0_index := w0_index + 1;
					end if;
				when sendcaxs => -- c5
					rs <= '1';
					send_data <= caxs;
					enable <= '1';
					if (sended = '1') then
						state <= sendcaxsw1;
					else
						state <= sendcaxs;
					end if;
				when sendcaxsw1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendcaxsw1a;
						w0_index := 0;
						enable <= '0';
					else
						state <= sendcaxsw1;
						w0_index := w0_index + 1;
					end if;
				when sendcaxsw1a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendcays;
						w0_index := 0;
					else
						state <= sendcaxsw1a;
						w0_index := w0_index + 1;
					end if;
				when sendcays => -- c6
					rs <= '1';
					send_data <= raye;
					enable <= '1';
					if (sended = '1') then
						state <= sendcaysw1;
					else
						state <= sendcays;
					end if;
				when sendcaysw1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendcaysw1a;
						w0_index := 0;
						enable <= '0';
					else
						state <= sendcaysw1;
						w0_index := w0_index + 1;
					end if;
				when sendcaysw1a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendcaxe;
						w0_index := 0;
					else
						state <= sendcaysw1a;
						w0_index := w0_index + 1;
					end if;
				when sendcaxe => -- c7
					rs <= '1';
					send_data <= cays;
					enable <= '1';
					if (sended = '1') then
						state <= sendcaxew1;
					else
						state <= sendcaxe;
					end if;
				when sendcaxew1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendcaxew1a;
						w0_index := 0;
						enable <= '0';
					else
						state <= sendcaxew1;
						w0_index := w0_index + 1;
					end if;
				when sendcaxew1a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendcaye;
						w0_index := 0;
					else
						state <= sendcaxew1a;
						w0_index := w0_index + 1;
					end if;
				when sendcaye => -- c8
					rs <= '1';
					send_data <= caye;
					enable <= '1';
					if (sended = '1') then
						state <= sendcayew1;
					else
						state <= sendcaye;
					end if;
				when sendcayew1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendcayew1a;
						w0_index := 0;
						enable <= '0';
					else
						state <= sendcayew1;
						w0_index := w0_index + 1;
					end if;
				when sendcayew1a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendmemwr;
						w0_index := 0;
					else
						state <= sendcayew1a;
						w0_index := w0_index + 1;
					end if;
				when sendmemwr =>
					x := to_integer(unsigned(caxe)) - to_integer(unsigned(raxe));
					y := to_integer(unsigned(caye)) - to_integer(unsigned(raye));
					rs <= '0';
					send_command <= x"2c"; --RAMWR
					enable <= '1';
					if (sended = '1') then
						state <= sendmemwrw1;
					else
						state <= sendmemwr;
					end if;
				when sendmemwrw1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= sendmemwrw1a;
						w0_index := 0;
						enable <= '0';
					else
						state <= sendmemwrw1;
						w0_index := w0_index + 1;
					end if;
				when sendmemwrw1a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= fillarealb;
						w0_index := 0;
					else
						state <= sendmemwrw1a;
						w0_index := w0_index + 1;
					end if;
				when fillarealb =>
					rs <= '1';
					send_data <= i_color(15 downto 8);
					enable <= '1';
					if (sended = '1') then
						state <= fillarealbw1;
					else
						state <= fillarealb;
					end if;
				when fillarealbw1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= fillarealbw1a;
						w0_index := 0;
						enable <= '0';
					else
						state <= fillarealbw1;
						w0_index := w0_index + 1;
					end if;
				when fillarealbw1a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= fillareahb;
						w0_index := 0;
					else
						state <= fillarealbw1a;
						w0_index := w0_index + 1;
					end if;
				when fillareahb =>
					rs <= '1';
					send_data <= i_color(7 downto 0);
					enable <= '1';
					if (sended = '1') then
						state <= fillareahbw1;
					else
						state <= fillareahb;
					end if;
				when fillareahbw1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= fillareahbw1a;
						w0_index := 0;
						enable <= '0';
					else
						state <= fillareahbw1;
						w0_index := w0_index + 1;
					end if;
				when fillareahbw1a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= fillarenaindex;
						w0_index := 0;
					else
						state <= fillareahbw1a;
						w0_index := w0_index + 1;
					end if;
				when fillarenaindex =>
					if (index = (x*y) - 1) then -- XXX TODO x*y - 1 drop last pixel
						state <= stop;
						index := 0;
						enable <= '0';
						initialized <= '1';
					else
						state <= fillarealb;
						index := index + 1;
					end if;
				when stop =>
					state <= idle;
				when others =>
					state <= idle;
			end case;
		end if;
	end process p0;

end Behavioral;
