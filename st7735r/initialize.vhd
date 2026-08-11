----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:41:34 06/14/2021 
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
use WORK.p_package.ALL;
use WORK.p_screen.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity initialize is
port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	i_run : in std_logic;
	i_color : in COLOR_TYPE;
	i_sended : in std_logic;
	o_initialized : out std_logic;
	o_enable : out std_logic;
	o_data_byte : out BYTE_TYPE;
	o_reset : out std_logic;
	o_rs : out std_logic;
	o_cs : out std_logic
);
end initialize;

architecture Behavioral of initialize is
	signal data_byte : BYTE_TYPE;
	signal sended : std_logic;
	type states is (
	idle,
	-- XXX initialize
	smallwait0,smallwait1,smallwait2,
	swreset,initwait0,initwait0a,slpout,initwait1,initwait1a,
	start,check_index,initwait4,wait0,wait1,initwait4a,
	noron,initwait2,initwait2a,dispon,initwait3,initwait3a,
	csup,
	-- XXX black screen
	bsinitwait,bsstart,bs_check_index,bswaitdata0,bswait0,bswait1,
	bswaitdata0a,bsfillbytel,bsfillbytelwait0,bsfillbytelwait0a,
	bsfillbyteh,bsfillbytehwait0,bsfillbytehwait0a,bsfill_check_index,
	bscsup,bsfillwait0,bsfillwait1
	);
	signal state : states;
	signal enable,cs,reset,rs,initialized : std_logic;
	signal data_index : integer range 0 to 2**16;

begin

	o_enable <= enable;
	o_cs <= cs;
	o_reset <= reset;
	o_rs <= rs;
	o_initialized <= initialized;
	sended <= i_sended;
	o_data_byte <= data_byte;

	p0 : process (i_clock,i_reset,sended) is
		variable w0_index : integer range 0 to 2**25;
		constant C_CLOCK_COUNTER_7 : integer := C_CLOCK_COUNTER * 7;
		constant C_CLOCK_COUNTER_150 : integer := C_CLOCK_COUNTER * 150;
		constant C_CLOCK_COUNTER_500 : integer := C_CLOCK_COUNTER * 500;
		constant C_CLOCK_COUNTER_10 : integer := C_CLOCK_COUNTER * 10;
		constant C_CLOCK_COUNTER_100 : integer := C_CLOCK_COUNTER * 100;
	begin
		if (i_reset = '1') then
			state <= idle;
			w0_index := 0;
			data_index <= 0;
			enable <= '0';
			cs <= '1';
			reset <= '1';
			rs <= '1';
			initialized <= '0';
		elsif (rising_edge(i_clock)) then
			case state is
				when idle =>
					initialized <= '0';
					if (i_run = '1') then
						state <= smallwait0;
					else
						state <= idle;
					end if;
				when smallwait0 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= smallwait1;
						w0_index := 0;
						reset <= '0';
					else
						state <= smallwait0;
						w0_index := w0_index + 1;
						cs <= '0';
					end if;
				when smallwait1 =>
					if (w0_index = C_CLOCK_COUNTER_7 - 1) then
						state <= smallwait2;
						w0_index := 0;
						reset <= '1';
					else
						state <= smallwait1;
						w0_index := w0_index + 1;
					end if;
				when smallwait2 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= swreset;
						w0_index := 0;
					else
						state <= smallwait2;
						w0_index := w0_index + 1;
					end if;
				when swreset =>
					data_byte <= x"01";
					enable <= '1';
					rs <= '0';
					if (sended = '1') then
						state <= initwait0;
					else
						state <= swreset;
					end if;
				when initwait0 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= initwait0a;
						w0_index := 0;
						enable <= '0';
						rs <= '1';
					else
						state <= initwait0;
						w0_index := w0_index + 1;
					end if;
				when initwait0a =>
					if (w0_index = C_CLOCK_COUNTER_150 - 1) then
						state <= slpout;
						w0_index := 0;
					else
						state <= initwait0a;
						w0_index := w0_index + 1;
					end if;
				when slpout =>
					data_byte <= x"11";
					enable <= '1';
					rs <= '0';
					if (sended = '1') then
						state <= initwait1;
					else
						state <= slpout;
					end if;
				when initwait1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= initwait1a;
						w0_index := 0;
						enable <= '0';
						rs <= '1';
					else
						state <= initwait1;
						w0_index := w0_index + 1;
					end if;
				when initwait1a =>
					if (w0_index = C_CLOCK_COUNTER_500 - 1) then
						state <= start;
						w0_index := 0;
					else
						state <= initwait1a;
						w0_index := w0_index + 1;
					end if;
				when start =>
					data_byte <= data_rom_initscreen(data_index);
					enable <= '1';
					if (data_rom_initscreen(data_index + 1) = x"01") then
						rs <= '0';
					elsif (data_rom_initscreen(data_index + 1) = x"00") then
						rs <= '1';
					end if;
					if (sended = '1') then
						state <= check_index;
					else
						state <= start;
					end if;
				when check_index =>
					if (data_index = data_size_initscreen - 2) then
						data_index <= 0;
						state <= initwait4;
					else
						data_index <= data_index + 2;
						state <= wait0;
					end if;
				when wait0 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= wait1;
						w0_index := 0;
						enable <= '0';
					else
						state <= wait0;
						w0_index := w0_index + 1;
					end if;
				when wait1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= start;
						w0_index := 0;
					else
						state <= wait1;
						w0_index := w0_index + 1;
					end if;
				when initwait4 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= initwait4a;
						w0_index := 0;
						enable <= '0';
					else
						state <= initwait4;
						w0_index := w0_index + 1;
					end if;
				when initwait4a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= noron;
						w0_index := 0;
					else
						state <= initwait4a;
						w0_index := w0_index + 1;
					end if;
				when noron =>
					data_byte <= x"13";
					enable <= '1';
					rs <= '0';
					if (sended = '1') then
						state <= initwait2;
					else
						state <= noron;
					end if;
				when initwait2 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= initwait2a;
						w0_index := 0;
						enable <= '0';
						rs <= '1';
					else
						state <= initwait2;
						w0_index := w0_index + 1;
					end if;
				when initwait2a =>
					if (w0_index = C_CLOCK_COUNTER_10 - 1) then
						state <= dispon;
						w0_index := 0;
					else
						state <= initwait2a;
						w0_index := w0_index + 1;
					end if;
				when dispon =>
					data_byte <= x"29";
					enable <= '1';
					rs <= '0';
					if (sended = '1') then
						state <= initwait3;
					else
						state <= dispon;
					end if;
				when initwait3 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= initwait3a;
						w0_index := 0;
						enable <= '0';
						rs <= '1';
					else
						state <= initwait3;
						w0_index := w0_index + 1;
					end if;
				when initwait3a =>
					if (w0_index = C_CLOCK_COUNTER_100 - 1) then
						state <= csup;
						w0_index := 0;
					else
						state <= initwait3a;
						w0_index := w0_index + 1;
					end if;
				when csup =>
					state <= bsinitwait ;
					enable <= '0';
					cs <= '1';
				-----------------------------------------------
				when bsinitwait =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= bsstart;
						w0_index := 0;
					else
						state <= bsinitwait ;
						w0_index := w0_index + 1;
					end if;
				when bsstart =>
					data_byte <= data_rom_blackscreen(data_index);
					enable <= '1';
					if (data_rom_blackscreen(data_index + 1) = x"01") then
						rs <= '0';
					elsif (data_rom_blackscreen(data_index + 1) = x"00") then
						rs <= '1';
					end if;
					if (sended = '1') then
						state <= bs_check_index;
					else
						state <= bsstart;
					end if;
				when bs_check_index =>
					if (data_index = data_size_blackscreen - 2) then
						data_index <= 0;
						state <= bswaitdata0;
					else
						data_index <= data_index + 2;
						state <= bswait0;
					end if;
				when bswait0 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= bswait1;
						w0_index := 0;
						enable <= '0';
					else
						state <= bswait0;
						w0_index := w0_index + 1;
					end if;
				when bswait1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= bsstart;
						w0_index := 0;
					else
						state <= bswait1;
						w0_index := w0_index + 1;
					end if;
				when bswaitdata0 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= bswaitdata0a;
						w0_index := 0;
						enable <= '0';
					else
						state <= bswaitdata0;
						w0_index := w0_index + 1;
					end if;
				when bswaitdata0a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= bsfillbytel;
						w0_index := 0;
					else
						state <= bswaitdata0a;
						w0_index := w0_index + 1;
					end if;
				when bsfillbytel =>
					data_byte <= i_color(15 downto 8);
					enable <= '1';
					rs <= '1';
					if (sended = '1') then
						state <= bsfillbytelwait0;
					else
						state <= bsfillbytel;
					end if;
				when bsfillbytelwait0 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= bsfillbytelwait0a;
						w0_index := 0;
						enable <= '0';
					else
						state <= bsfillbytelwait0;
						w0_index := w0_index + 1;
					end if;
				when bsfillbytelwait0a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= bsfillbyteh;
						w0_index := 0;
					else
						state <= bsfillbytelwait0a;
						w0_index := w0_index + 1;
					end if;
				when bsfillbyteh =>
					data_byte <= i_color(7 downto 0);
					enable <= '1';
					rs <= '1';
					if (sended = '1') then
						state <= bsfillbytehwait0;
					else
						state <= bsfillbyteh;
					end if;
				when bsfillbytehwait0 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= bsfillbytehwait0a;
						w0_index := 0;
						enable <= '0';
					else
						state <= bsfillbytehwait0;
						w0_index := w0_index + 1;
					end if;
				when bsfillbytehwait0a =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= bsfill_check_index;
						w0_index := 0;
					else
						state <= bsfillbytehwait0a;
						w0_index := w0_index + 1;
					end if;
				when bsfill_check_index =>
					if (data_index = SCREEN_FILL - 1) then
						data_index <= 0;
						state <= bscsup;
						initialized <= '1';
						enable <= '0';
					else
						data_index <= data_index + 1;
						state <= bsfillwait0;
					end if;
				when bsfillwait0 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= bsfillwait1;
						w0_index := 0;
						enable <= '0';
					else
						state <= bsfillwait0;
						w0_index := w0_index + 1;
					end if;
				when bsfillwait1 =>
					if (w0_index = C_CLOCK_COUNTER - 1) then
						state <= bsfillbytel;
						w0_index := 0;
					else
						state <= bsfillwait1;
						w0_index := w0_index + 1;
					end if;
				when bscsup =>
					state <= idle ;
					cs <= '1';
			end case;
		end if;
	end process p0;

end Behavioral;

